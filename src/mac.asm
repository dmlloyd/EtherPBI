
;; Ethernet MAC interface module

    .include "net.inc"
    .include "regs.inc"
    .include "sysequ.inc"
    .include "cp2200.inc"

    .segment "MAC_VARS"

MAC_STATE:
    .res 1

RECV_STATUS:
    .res 1

RECV_STATE:
    .res 1

RECV_LOW_WATER:
    .res 1

RECV_HIGH_WATER:
    .res 1

MAC_STATS_RECV_OVERRUNS:
    .res 3

MAC_STATS_RECV_INVALID:
    .res 3

MAC_STATS_RECV_CNT:
    .res 3

MAC_STATS_SEND_CNT:
    .res 3

MAC_STATS_SEND_DROPPED:
    .res 3

MAC_ADDRESS0:
    .res 1
MAC_ADDRESS1:
    .res 1
MAC_ADDRESS2:
    .res 1
MAC_ADDRESS3:
    .res 1
MAC_ADDRESS4:
    .res 1
MAC_ADDRESS5:
    .res 1

MAC_ADDRESS_HW0:
    .res 1
MAC_ADDRESS_HW1:
    .res 1
MAC_ADDRESS_HW2:
    .res 1
MAC_ADDRESS_HW3:
    .res 1
MAC_ADDRESS_HW4:
    .res 1
MAC_ADDRESS_HW5:
    .res 1

    .segment "MAC"

    ; MAC indirect register names (14.3)
    MACCN = 0
    MACCF = 1
    IPGT = 2
    IPGR = 3
    CWMAXR = 4
    MAXLEN = 5
    MACAD0 = $10
    MACAD1 = $11
    MACAD2 = $12

    ; Macro to write a 16-bit value to one of the MAC INDIRECT registers.
    ; Supports immediate or absolute (big-endian) arguments.
    .macro write_mac_ind reg, value
        .if (.match (.left (1, {value}), #))
            ; immediate mode...
            lda #reg
            sta ETH_MACADDR
            lda #<(.right (.tcount ({value})-1, {value}))
            sta ETH_MACDATAH
            lda #>(.right (.tcount ({value})-1, {value}))
            sta ETH_MACDATAL
            sta ETH_MACRW
        .else
            ; absolute mode (BIG-ENDIAN!)
            lda #reg
            sta ETH_MACADDR
            lda value
            sta ETH_MACDATAH
            lda value+1
            sta ETH_MACDATAL
            sta ETH_MACRW
        .endif
    .endmacro

    ;
    ; MAC_UP - Bring up the ethernet MAC layer.
    ;
    ; In:   I flag = set
    ; Out:  Y register = status; 1 = success, $80-FF = error
MAC_UP:
    lda MAC_STATE
    cmp #MAC_STATE_DOWN
    beq @start
    ; already done; return
    ldy #1
    rts
@start:
    ; Validate.  Make sure we have a MAC address configured.
    lda MAC_ADDRESS0
    bne @mac_ok
    lda MAC_ADDRESS1
    bne @mac_ok
    lda MAC_ADDRESS2
    bne @mac_ok
    lda MAC_ADDRESS3
    bne @mac_ok
    lda MAC_ADDRESS4
    bne @mac_ok
    lda MAC_ADDRESS5
    bne @mac_ok
    ldy #EBADNAM    ; invalid MAC address configured
    rts

@mac_ok:
    ; Bring up PHY if it is not up
    lda PHY_STATE
    cmp #PHY_STATE_UP
    beq @phy_is_up
    jsr PHY_UP
    bpl @phy_is_up
    rts             ; error in Y

@phy_is_up:
    ;; Step 7: Initialize the MAC (14.1)
    lda PHY_MODE
    bpl @half_duplex
    write_mac_ind MACCF, #$40B3
    write_mac_ind IPGT, #$0015
    bne @written        ; always true
@half_duplex:
    write_mac_ind MACCF, #$4012
    write_mac_ind IPGT, #$0012
@written:
    write_mac_ind IPGR, #$0C12
    write_mac_ind MAXLEN, #$05EE
    write_mac_ind MACAD0, MAC_ADDRESS0
    write_mac_ind MACAD1, MAC_ADDRESS2
    write_mac_ind MACAD2, MAC_ADDRESS4
    write_mac_ind MACCN, #$0001

    ;; Step 8: Configure the receive filter. (12.4)
    lda #0              ; Disable multicast
    sta ETH_RXHASHH
    sta ETH_RXHASHL
    lda #%00001101      ; Disable Runt, FCS Error, and Multicast; enable Broadcast
    sta ETH_RXFILT
    
    lda #MAC_STATE_UP
    sta MAC_STATE

    ldy #1          ; Report status OK
    rts

    ;
    ; MAC_DOWN - Bring down the MAC layer.
    ;
    ; In:   I flag = set
    ; Out:  Y register = status; 1 = success, $80-FF = error
    ;
MAC_DOWN:
    lda MAC_STATE
    ;cmp #MAC_STATE_DOWN
    beq @done
@start:
    lda IP_STATE
    ;cmp #IP_STATE_DOWN
    beq @ip_is_down
    jsr IP_DOWN
    bmi @ret    ; error is in Y
@ip_is_down:
    write_mac_ind MACCN, #$0000
    lda #MAC_STATE_DOWN
    sta MAC_STATE
@done:
    ldy #1
@ret:
    rts
