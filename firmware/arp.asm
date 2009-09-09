
                        .include "regs.inc"
                        .include "arp.inc"

                        .segment "ARP_FIRMWARE"

                        ;
                        ; Update or add an ARP table entry.  If the IP address is already in the table, that entry is
                        ; returned unchanged; otherwise a new entry is added, unless the table is full.  The
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
                        ;    If no slots are open and the table is full, fail.
                        jsr ARP_LOOKUP
                        bmi @no_match
                        ; Found an existing match!  Return it.
@rts:
                        rts
@no_match:
                        ; No matches found; see if there's an open slot we can take
                        ldx t1
                        bpl ARP_WRITE_ENTRY     ; Found a free slot; fill it.
                        ; No free slots; try to grow the table.
                        lda ARP_LAST
                        cmp #ARP_TABLE_SIZE-1
                        beq @rts ; table is full (X still holds $FF from the ldx t1 above)
                        ; Add the free slot, write it back
                        tax
                        inx
                        stx ARP_LAST
                        ;jmp ARP_WRITE_ENTRY

                        ;
                        ; Overwrite an ARP table entry and mark it as "valid" and "incomplete".
                        ;
                        ; In:   IPADDR1 = the IP address
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

                        ;
                        ; Update the flags of an ARP table entry, and update its
                        ; age as well.
                        ;
                        ; In:   A register = the flags to write
                        ;       X register = the entry index
                        ; Out:  X register = the entry index
                        ;
ARP_UPDATE_FLAGS:       sta ARP_TAB_FLAGS,x
                        lda ARP_AGE
                        sta ARP_TAB_AGE,x
ARP_RTS:                rts

                        ;
                        ; Delete an ARP table entry by IP address.
                        ;
                        ; In:   IPADDR1 = the IP address of the entry to remove.
                        ; Out:  X register = the entry index, or $FF if none matched.
                        ;       S flag = set if none matched.
                        ;
ARP_DELETE:             jsr ARP_LOOKUP
                        bmi ARP_RTS
                        ;jmp ARP_DELETE_ENTRY

                        ;
                        ; Delete an ARP table entry.
                        ;
                        ; In:   X register = the entry index
                        ; Out:  X register = the deleted entry, or if the table was compacted, the index of the
                        ;       new last entry, or $ff if the table was completely truncated.
                        ;
ARP_DELETE_ENTRY:       lda #0
                        sta ARP_TAB_FLAGS,x
                        ; If it's the last entry, compact the table
                        cpx ARP_LAST
                        bne @done
                        
@next:                  dex
                        bmi @update     ; if that's the end, the table is empty
                        lda ARP_TAB_FLAGS,x
                        beq @next
@update:                stx ARP_LAST
@done:                  rts

                        ;
                        ; Locate the ARP entry for an IP address.
                        ;
                        ; In:   IPADDR1 = the IP address to look up
                        ; Out:  X register = ARP table entry, or $FF if none matched.
                        ;       S flag = set if none matched.
                        ;       t1 = open slot, if none matched; $FF if none are open.
                        ;
ARP_LOOKUP:
                        ldx #$ff
                        stx t1
                        ldx ARP_LAST
                        bpl @done
                        lda ARP_TAB_FLAGS,x     ; check only valid entries
                        bne @valid
@empty:
                        stx t1
@try_next:
                        dex
                        bmi @done
                        lda ARP_TAB_FLAGS,x
                        beq @empty
@valid:
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
                        ; match! :D
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
