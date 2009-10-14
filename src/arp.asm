
    .include "net.inc"
    .include "regs.inc"

    .segment "ARP"

    ; ARP_UPDATE - Update or add an ARP table entry.  If the IP address is already in the table, that entry is
    ; returned unchanged; otherwise a new entry is added, unless the table is full.  The
    ; new entry is marked as "incomplete"; to complete it, call ARP_WRITE_MAC after this method.
    ;
    ; In:   IPADDR1 = the IP address
    ; Out:  X register = the entry index, $FF if the table is full
    ;       S flag = 1 on failure
    ;
    ; Matching rules:
    ;    If the IP matches, replace the entry and update the age.
    ;    If no match, add an entry.
    ;    If no slots are open and the table is full, fail.
ARP_UPDATE:
    jsr ARP_LOOKUP
    bmi @no_match
    ; Found an existing match!  Return it.
@return:
    rts
@no_match:
    ; No matches found; see if there's an open slot we can take
    ldx t1
    bpl ARP_WRITE_ENTRY     ; Found a free slot; fill it.
    ; No free slots; try to grow the table.
    lda ARP_LAST
    cmp #ARP_TABLE_SIZE-1
    beq @return ; table is full (X still holds $FF from the ldx t1 above)
    ; Add the free slot, write it back
    tax
    inx
    stx ARP_LAST
    ;jmp ARP_WRITE_ENTRY

    ;
    ; ARP_WRITE_ENTRY - Overwrite an ARP table entry and mark it as "valid" and "incomplete".
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
    ; not reached


    ;
    ; ARP_WRITE_MAC - Overwrite the MAC address of an ARP table entry
    ; and mark it "complete".
    ;
    ; In:   MACADDR1 = the new MAC address
    ;       X register = the entry index
    ; Out:  X register = the entry index
    ;
    ; update age and MAC address.
ARP_WRITE_MAC:
    lda MACADDR1+0
    sta ARP_TAB_MAC0,x
    lda MACADDR1+1
    sta ARP_TAB_MAC1,x
    lda MACADDR1+2
    sta ARP_TAB_MAC2,x
    lda MACADDR1+3
    sta ARP_TAB_MAC3,x
    lda MACADDR1+4
    sta ARP_TAB_MAC4,x
    lda MACADDR1+5
    sta ARP_TAB_MAC5,x
    lda ARP_TAB_FLAGS,x
    ora #%11000000  ; mark entry as "complete"
    ;jmp ARP_UPDATE_FLAGS


    ;
    ; ARP_UPDATE_FLAGS - Update the flags of an ARP table entry, and update its
    ; age as well.
    ;
    ; In:   A register = the flags to write
    ;       X register = the entry index
    ; Out:  X register = the entry index
    ;
ARP_UPDATE_FLAGS:
    sta ARP_TAB_FLAGS,x
    lda ARP_AGE
    sta ARP_TAB_AGE,x
ARP_RETURN:
    rts

    ;
    ; ARP_DELETE - Delete an ARP table entry by IP address.
    ;
    ; In:   IPADDR1 = the IP address of the entry to remove.
    ; Out:  X register = the entry index, or $FF if none matched.
    ;       S flag = set if none matched.
    ;
ARP_DELETE:
    jsr ARP_LOOKUP
    bmi ARP_RETURN    ; nearest convenient rts
    ;jmp ARP_DELETE_ENTRY

    ;
    ; ARP_DELETE_ENTRY - Delete an ARP table entry.
    ;
    ; In:   X register = the entry index
    ; Out:  X register = the deleted entry, or if the table was compacted, the index of the
    ;       new last entry, or $ff if the table was completely truncated.
    ;
ARP_DELETE_ENTRY:
    lda #0
    sta ARP_TAB_FLAGS,x
    ; If it's the last entry, compact the table
    cpx ARP_LAST
    bne @done
@next:
    dex
    bmi @update      ; if that's the end, the table is empty
    lda ARP_TAB_FLAGS,x
    beq @next
@update:                
    stx ARP_LAST
@done:
    rts

    ;
    ; ARP_LOOKUP - Locate the ARP entry for an IP address.
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
@done:                  
    rts

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

    ;
    ; ARP_DELETE_AGE - Delete all entries older than the given age.
    ;
    ; In:   A register = the age at which entries should be deleted
    ; Out:  -
    ;
ARP_DELETE_AGE:
    sec
    sbc ARP_AGE         ; Target age - ARP clock -> A
    tay
    ldx ARP_LAST
    bmi @done
@check:                  
    lda ARP_TAB_FLAGS,x
    beq @next
    and #%00100000      ; Make sure entry isn't "protected"
    beq @found
@next:
    dex
    bpl @check
@done:
    rts
@found:
    tya
    cmp ARP_TAB_AGE,x   ; Target age - ARP clock - Entry timestamp -> P
    beq @expired         ; <= 0 means expired, >0 means OK; can't use carry because we might have wrapped
    bpl @next
@expired:
    jsr ARP_DELETE_ENTRY
    bpl @check           ; If the table was compacted, check the new entry.  Otherwise,
                        ; an entry is rechecked.  Oh well.
    rts                 ; Else, the table is now empty so short-circuit the whole deal.
