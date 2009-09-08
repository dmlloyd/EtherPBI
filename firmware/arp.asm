

                        .include "regs.inc"
                        .include "arp.inc"

                        .segment "ARP_FIRMWARE"

                        ;
                        ; Update or add an ARP table entry.  If the IP address is already in the table, that entry is
                        ; returned; otherwise it is added unless the table is full.  The
                        ; new entry is marked as "incomplete"; to complete it, call ARP_WRITE_MAC after this method.
                        ;
                        ; In:   IPADDR1 = the IP address
                        ; Out:  X register = the entry index, $FF if the table is full
                        ;       S flag = 1 on failure
                        ;
ARP_UPDATE:
                        ; Matching rules:
                        ;    If the IP matches, replace the entry and update the age.
                        ;    If no match, add an entry.
                        ;    If there are no open slots, replace the oldest entry.
                        lda #$ff
                        sta t1          ; the first free slot we find
                        ldx ARP_LAST
@check_slot:
                        lda ARP_TAB_FLAGS,x
                        bpl @is_blank

@try_match:             ; Now, compare the full IP address, checking the least likely to match first.
                        lda IPADDR1+0
                        cmp ARP_TAB_IPADDR0,x
                        bne @try_next
                        lda IPADDR1+1
                        sbc ARP_TAB_IPADDR1,x
                        lda IPADDR1+2
                        sbc ARP_TAB_IPADDR2,x
                        lda IPADDR1+3
                        sbc ARP_TAB_IPADDR3,x
                        beq ARP_WRITE_MAC
                        bne @try_next   ; TODO update ages in t2 and t3...

                        ; the entry was blank; remember it just in case
@is_blank:              stx t1
@try_next:              dex
                        bpl @check_slot
                        ; not found; try to add it
                        ldx t1
                        bpl ARP_WRITE_ENTRY
                        ; no free entries; extend the table
                        ldx ARP_LAST
                        inx
                        cpx #ARP_TABLE_SIZE
                        bne @extend
                        ; table is maxed out; fail
@full:                  ldx #$ff
                        rts
@extend:                stx ARP_LAST
                        ;jmp ARP_WRITE_ENTRY

                        ;
                        ; Overwrite an ARP table entry.
                        ;
                        ; In:   IPADDR1 = the IP address
                        ;       MACADDR1 = the MAC address
                        ;       X register = the entry index
                        ; Out:  X register = the entry index
                        ;
ARP_WRITE_ENTRY:
                        lda IPADDR1+0
                        sta ARP_TAB_IPADDR0,x
                        lda IPADDR1+1
                        sta ARP_TAB_IPADDR1,x
                        lda IPADDR1+2
                        sta ARP_TAB_IPADDR2,x
                        lda IPADDR1+3
                        sta ARP_TAB_IPADDR3,x
                        lda #%10000000
                        bne ARP_UPDATE_FLAGS    ; always true

                        ;
                        ; Overwrite the MAC address of an ARP table entry
                        ; and mark it "complete".
                        ;
                        ; In:   MACADDR1 = the new MAC address
                        ;       X register = the entry index
                        ; Out:  X register = the entry index
                        ;
                        ; update age and MAC address.
ARP_WRITE_MAC:          lda MAC1+0
                        sta ARP_TAB_MAC0,x
                        lda MAC1+1
                        sta ARP_TAB_MAC1,x
                        lda MAC1+2
                        sta ARP_TAB_MAC2,x
                        lda MAC1+3
                        sta ARP_TAB_MAC3,x
                        lda MAC1+4
                        sta ARP_TAB_MAC4,x
                        lda MAC1+5
                        sta ARP_TAB_MAC5,x
                        lda ARP_TAB_FLAGS,x
                        ora #%11000000  ; mark entry as "complete"
ARP_UPDATE_FLAGS:       sta ARP_TAB_FLAGS,x
                        lda ARP_AGE
                        sta ARP_TAB_AGE,x
                        rts

                        ;
                        ; Delete an ARP table entry by IP address.
                        ;
                        ; In:   IPADDR1 = the IP address of the entry to remove.
                        ; Out:  X register = the entry index, or $FF if none matched.
                        ;       S flag = set if none matched.
                        ;
ARP_DELETE:             jsr ARP_LOOKUP
                        bmi ARP_DELETE_RTS
                        ;jmp ARP_DELETE_ENTRY

                        ;
                        ; Delete an ARP table entry.
                        ;
                        ; In:   X register = the entry index
                        ; Out:  X register = the entry index
                        ;
ARP_DELETE_ENTRY:       lda #0
                        sta ARP_TAB_FLAGS,x
                        ; If it's the last entry, compact the table
                        cpx ARP_LAST
                        bne ARP_DELETE_RTS
                        txa
                        tay
                        ; Remove all trailing empty entries
@next:                  dey
                        bmi @done   ; <0 means the table is empty
                        lda ARP_TAB_FLAGS,y
                        bne @done   ; this entry is occupied
                        beq @next
@done:                  sty ARP_LAST
ARP_DELETE_RTS:         rts

                        ;
                        ; Locate the ARP entry for an IP address.
                        ;
                        ; In:   IPADDR1 = the IP address to look up
                        ; Out:  X register = ARP table entry, or $FF if none matched.
                        ;       S flag = set if none matched.
                        ;       t1 = an open slot, or $FF if there are none.
                        ;       t3 = the oldest slot, or $FF if there were no slots.
                        ;
ARP_LOOKUP:
                        ldx ARP_LENGTH
@try_next:              dex
                        bpl @done
                        lda ARP_TAB_FLAGS,x     ; check only complete entries
                        and #%01000000
                        beq @try_next
                        lda IPADDR1+3
                        cmp ARP_TAB_IPADDR3,x
                        bne @try_next
                        lda IPADDR1+0
                        sbc ARP_TAB_IPADDR0,x
                        lda IPADDR1+1
                        sbc ARP_TAB_IPADDR1,x
                        lda IPADDR1+2
                        sbc ARP_TAB_IPADDR2,x
                        bne @try_next
@done:                  rts

                        ;
                        ; Truncate the ARP table.
                        ;
                        ; In:   -
                        ; Out:  -
                        ;
ARP_CLEAR:
                        lda #-1
                        sta ARP_LAST
                        rts
