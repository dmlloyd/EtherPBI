
                        .include "sysequ.inc"

                        DEVICE_NAME     = 'N'


                        ;; Start at boot rom area at $D800
                        .segment "BOOT_ROM"
                        
                        ;; Checksum (NOT USED)
                        .byte 0, 0
                        
                        ;; Version number (NOT USED)
                        .byte $01
                        
                        ;; ID Number 1
                        .byte $80
                        
                        ;; Device type (NOT USED??)
                        .byte 0
                        
                        ;; I/O Vector
                        jmp PBI_SIO
                        
                        ;; Interrupt Vector, exist with (RTS?)
                        jmp PBI_IRQ
                        
                        ;; ID Number 2
                        .byte $91
                        
                        ;; Device Name (NOT USED)
                        .byte 0
                        
                        ;; CIO vectors
                        .word OPEN_VEC
                        .word CLOSE_VEC
                        .word GETBYTE_VEC
                        .word PUTBYTE_VEC
                        .word STATUS_VEC
                        .word SPECIAL_VEC
                        
                        jmp PBI_INIT
                        
                        ;; Unused byte
                        .byte 0
                        
PBI_SIO:
                        clc
                        rts

PBI_IRQ:
                        rts

PBI_INIT:
                        ;; Register our PBI device
                        lda DEVMASK
                        ora NDEVREQ
                        sta DEVMASK
                        ;; Add our device to HATABS
                        ldx #DEVICE_NAME
                        lda #<GENDEV
                        ldy #>GENDEV
                        jsr NEWDEV
                        bmi @exit
                        bcs @exit
@exit:                  rts

OPEN_VEC:
                        ;; do open
                        
                        lda #'N'
                        cmp ICHIDZ
                        beq @match
@nomatch:               clc         ; indicate no match
                        rts
@match:                 ldx ICDNOZ
                        beq @match2 ; device # not specified, so pick us
                        dex
                        beq @match2 ; we're not selected, it's the next card
                        stx ICDNOZ  ; store decremented device # so next card can have a chance
                        bne @nomatch
@match2:


                        sec
                        rts

                        .segment "TABLES"

                        ;
                        ; Netmask/Hostmask tables.
                        ;
                        ; Find a byte starting in the fourth row of either
                        ; table and read that byte plus the three bytes *above* it 
                        ; to get the mask bits.
                        ;
                        ; To get the netmask for each byte, put the netmask bits in X and do:
                        ; (for byte 0): lda NETMASK_TABLE+24,x
                        ; (for byte 1): lda NETMASK_TABLE+16,x
                        ; (for byte 2): lda NETMASK_TABLE+8,x
                        ; (for byte 3): lda NETMASK_TABLE+0,x
                        ;
                        ; To get the broadcast address, use ORA against HOSTMASK_TABLE.
                        ; To get the network address, use AND against NETMASK_TABLE.
                        ; To determine whether one IP/mask encompasses another,
                        ; 
                        ; Note: don't let this cross a page boundary else there will
                        ; be a one-cycle penalty...
NETMASK_TABLE:
                        .byte $00, $00, $00, $00, $00, $00, $00, $00
                        .byte $00, $00, $00, $00, $00, $00, $00, $00
                        .byte $00, $00, $00, $00, $00, $00, $00, $00
                        .byte $00, $80, $C0, $E0, $F0, $F8, $FC, $FE
                        ; These bytes are duplicated in the next table, so
                        ; just merge the tables...
                        ;.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
                        ;.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
                        ;.byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
                        ;.byte $FF
HOSTMASK_TABLE:
                        .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
                        .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
                        .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
                        .byte $FF, $7F, $3F, $1F, $0F, $07, $03, $01
                        .byte $00, $00, $00, $00, $00, $00, $00, $00
                        .byte $00, $00, $00, $00, $00, $00, $00, $00
                        .byte $00, $00, $00, $00, $00, $00, $00, $00
                        .byte $00

                        ;
                        ; Bit index table.
                        ;
                        ; If the bit index is in X, get the corresponding bit via:
                        ; lda BIT_TABLE+8,x ; for the low byte
                        ; lda BIT_TABLE,x   ; for the high byte
BIT_TABLE:
                        .byte $00, $00, $00, $00, $00, $00, $00, $00
                        .byte $01, $02, $04, $08, $10, $20, $40, $80
                        .byte $00, $00, $00, $00, $00, $00, $00, $00

                        ;
                        ; Bit count table.
                        ;
                        ; Each entry corresponds to the number of 1 bits
                        ; present in the offset of that value.
BITCOUNT_TABLE:
