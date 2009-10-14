
    .include "net.inc"
    .include "regs.inc"
    .include "sysequ.inc"
    .include "cp2200.inc"
    .include "via.inc"

    .segment "IRQ"


    ;
    ; Handle IRQ.
    ;
    ; In:   IRQ context
    ;       A saved on stack
    ;       D flag = clear
    ;       I flag = set
    ; Out:  PLA + RTI
    ;
IRQ:
    txa
    pha
    tya
    pha
crit_check:
    lda CRITIC
    beq pkt_check
    ; Critical section!  Disable the receiver.
    lda #%00001000  ; RXINH, shut down receiver
    sta ETH_RXCN
    bne done        ; always true

pkt_check:
    ; First check for an eth interrupt.
    lda ETH_INT0
    and #%00000001  ; RXINT
    ; Receive the packet, then recheck.
    beq check_timeout
    jsr RECEIVE
    jmp pkt_check
check_timeout:
    ; Next check for timeouts.
    lda VIA_INT
    and #%00100000
    bne done
    jsr TIMEOUT
    jmp pkt_check
done:
    lda #0
    sta ETH_RXCN    ; enable receiver
    pla
    tay
    pla
    tax
    pla
    rti

    ;
    ; Process timeout.
    ;
TIMEOUT:                rts

    ;
    ; Receive an incoming packet.
    ;
RECEIVE:
    ; The FIFO could fill up in as little as 358.7 microseconds.
    ; But this is rather unlikely.  Check against a high-water
    ; mark to make sure the receiver doesn't overrun.  If we're above
    ; the high-water mark, disable the receiver.  If we're below the
    ; low-water mark, enable the receiver.  It's OK to do this
    ; in receive since if the receiver is disabled, there is guaranteed
    ; to be outstanding packets.  But it does mean that any
    ; packet handler code has to be damned fast.
    ;
    ; The high water mark should be set to minimize the chance of an
    ; overrun - the packet receive time should be less than the amount
    ; of time it would take to go from the (high water mark minus 1) to
    ; an overflow condition, taking into account the duration of the ISR.
    
    ; Check to see if we overran.
    lda ETH_RXFIFOSTA
    and #%00000010
    beq DO_RECEIVE
    ; aw shit.  We overran.  Just dump em all and start over.
    lda #%00000001  ; RXCLEAR
    sta ETH_RXCN
    ; Increment the counters so that the operator can diagnose the issue.
    inc RECV_OVERRUN
    bne DONE
    inc RECV_OVERRUN+1
DONE:                  
    rts

    ; Check to see if we hit the high-water mark.
DO_RECEIVE:                    
    ldx ETH_TLBVALID
    ; Count the number of 1 bits using our big ol lookup table.
    lda BITCOUNT_TABLE,x
    cmp RECV_HIGH_WATER
    bcc @below_high_water
    ; X >= high-water mark...
    lda #%00001000  ; RXINH, shut down receiver until we clear some space
    sta ETH_RXCN
    bne @resume     ; always true
@below_high_water:      cmp RECV_LOW_WATER
    bcs @resume
    ; X < low-water mark
    lda #%00000000  ; !RXINH, resume receiving
    sta ETH_RXCN
@resume:                ; Check that the packet is valid.
    lda ETH_CPINFOH
    and #%11111000
    cmp #%10000000
    ; or maybe instead:
    ; ldx ETH_TLBVALID
    ; inx ; set Z if all the slots were full
    beq DO_VALID
DO_INVALID:
    inc RECV_INVALID
    bne DONE
    inc RECV_INVALID+1
DO_RXSKIP:              
    lda #%00000010  ; RXSKIP the invalid packet
    sta ETH_RXCN
    rts
DO_VALID:
    ; Check that the packet is OK
    lda ETH_CPINFOL
    bmi DO_INVALID
    ; Broadcast packets are not subject to the dest addr check.
    lda ETH_CPINFOH
    and #%00000010  ; BCAST
    beq @next_dmac_in   ; no? then check the MAC address
    ldy #6
@consume:               lda ETH_RXAUTOREAD
    dey
    bne @consume
    beq @next_mac_in

    ; Verify final byte of the dest MAC address
    ; There's a bug in the device where the receive filter only
    ; checks the first 5 bytes of the destination MAC address.  Duh
    ldy #6
@next_dmac_in:          lda ETH_RXAUTOREAD
    dey
    bne @next_dmac_in
    cmp USER_MAC_ADDR+5
    ; no match? then skip the packet
    bne DO_RXSKIP

@next_mac_in:           ; Get the source MAC address
    ldy #256-6
    lda ETH_RXAUTOREAD
    sta MACADDR1-250,y
    iny
    bne @next_mac_in

    lda ETH_RXAUTOREAD
    cmp #$08
    ; not ICMP or IP? skip it
    bne DO_RXSKIP
    lda ETH_RXAUTOREAD
    cmp #<ETHERTYPE_IP
    beq RECEIVE_IP
    cmp #<ETHERTYPE_ARP
    bne DO_RXSKIP
    ;jmp RECEIVE_ARP

    
RECEIVE_ARP:            ; Read in the ARP packet data
    ; HTYPE must == $0001
    lda ETH_RXAUTOREAD
    cmp #<$0001
    lda ETH_RXAUTOREAD
    sbc #>$0001
    ; PTYPE must == $0800
    lda ETH_RXAUTOREAD
    sbc #<$8000
    lda ETH_RXAUTOREAD
    sbc #>$8000
    ; HLEN must == $06
    lda ETH_RXAUTOREAD
    sbc #6
    ; PLEN must == $04
    lda ETH_RXAUTOREAD
    sbc #4
    bne DO_RXSKIP   ; if any of that stuff didn't match
    ; Next is OPER
    ldx ETH_RXAUTOREAD
    dex
    beq RECEIVE_ARP_REQUEST
    dex
    bne DO_RXSKIP   ; unsupported op
    ;jmp RECEIVE_ARP_REPLY

    ; Receive an ARP reply
RECEIVE_ARP_REPLY:      
    ; An ARP reply should only update our ARP table
    ; if the destination IP is us.  Otherwise we may
    ; get a big table of entries we never use.

    ; Read sender address
    ldy #256-6
@loop_sha:              lda ETH_RXAUTOREAD
    sta MACADDR1-250,y
    iny
    bne @loop_sha
    ; Read sender proto address
    ldy #256-4
@loop_spa:              lda ETH_RXAUTOREAD
    sta IPADDR1-252,y
    iny
    bne @loop_spa
    ; Read target hardware address
    ldy #256-6
@loop_tha:              lda ETH_RXAUTOREAD
    sta MACADDR2-250,y
    iny
    bne @loop_tha
    ; Read target protocol address
    ldy #256-4
@loop_tpa:              lda ETH_RXAUTOREAD
    sta IPADDR2-252,y
    iny
    bne @loop_tpa
    
    ; Update our ARP cache.
    ; TODO - double-check API
    ; SECTION CHECK!
    jsr ARP_UPDATE
    jmp ARP_WRITE_MAC
    
    ; Receive an ARP request
RECEIVE_ARP_REQUEST:    
    ; Verify that the request is for our IP address.  We could use
    ; the info to populate our table either way, but it's better to keep the
    ; table as small as possible.
    ;
    ; If the request is not for our IP address, check to see whether the associated
    ; IP address appears in our ARP cache.  If so, update the entry just to be safe
    ; since some hosts will send a gratuitous ARP when their IP address changes.
    

    ; Update our table with the requestor information from
    ; the ARP request, because there is a strong likelihood that
    ; we will communicate more with this peer.

    ; Formulate a reply and send it off to the peer.




RECEIVE_IP:


    .include "bitcount_table.inc"
