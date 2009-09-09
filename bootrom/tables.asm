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
                        .byte $00
                        ; These bytes are duplicated in the next table, so
                        ; just merge the tables...
                        ;.byte $00, $00, $00, $00, $00, $00, $00, $00
                        ;.byte $00, $00, $00, $00, $00, $00, $00, $00
                        ;.byte $00, $00, $00, $00, $00, $00, $00, $00

                        ;
                        ; Bit index table.
                        ;
                        ; If the bit index is in X, get the corresponding bit via:
                        ; lda BIT_TABLE,x       ; for byte 0
                        ; lda BIT_TABLE-8,x     ; for byte 1
                        ; lda BIT_TABLE-16,x    ; for byte 2
                        ; lda BIT_TABLE-24,x    ; for byte 3

                        .byte $00, $00, $00, $00, $00, $00, $00, $00
                        .byte $00, $00, $00, $00, $00, $00, $00, $00
                        .byte $00, $00, $00, $00, $00, $00, $00, $00
BIT_TABLE:
                        .byte $01, $02, $04, $08, $10, $20, $40, $80
                        .byte $00, $00, $00, $00, $00, $00, $00, $00
                        .byte $00, $00, $00, $00, $00, $00, $00, $00
                        .byte $00, $00, $00, $00, $00, $00, $00, $00

                        ;
                        ; Bit count table.
                        ;
                        ; Each entry corresponds to the number of 1 bits
                        ; present in the offset of that value.
                        ;
BITCOUNT_TABLE:
                        .byte $00, $01, $01, $02, $01, $02, $02, $03
                        .byte $01, $02, $02, $03, $02, $03, $03, $04
                        .byte $01, $02, $02, $03, $02, $03, $03, $04
                        .byte $02, $03, $03, $04, $03, $04, $04, $05
                        .byte $01, $02, $02, $03, $02, $03, $03, $04
                        .byte $02, $03, $03, $04, $03, $04, $04, $05
                        .byte $02, $03, $03, $04, $03, $04, $04, $05
                        .byte $03, $04, $04, $05, $04, $05, $05, $06
                        .byte $01, $02, $02, $03, $02, $03, $03, $04
                        .byte $02, $03, $03, $04, $03, $04, $04, $05
                        .byte $02, $03, $03, $04, $03, $04, $04, $05
                        .byte $03, $04, $04, $05, $04, $05, $05, $06
                        .byte $02, $03, $03, $04, $03, $04, $04, $05
                        .byte $03, $04, $04, $05, $04, $05, $05, $06
                        .byte $03, $04, $04, $05, $04, $05, $05, $06
                        .byte $04, $05, $05, $06, $05, $06, $06, $07
                        .byte $01, $02, $02, $03, $02, $03, $03, $04
                        .byte $02, $03, $03, $04, $03, $04, $04, $05
                        .byte $02, $03, $03, $04, $03, $04, $04, $05
                        .byte $03, $04, $04, $05, $04, $05, $05, $06
                        .byte $02, $03, $03, $04, $03, $04, $04, $05
                        .byte $03, $04, $04, $05, $04, $05, $05, $06
                        .byte $03, $04, $04, $05, $04, $05, $05, $06
                        .byte $04, $05, $05, $06, $05, $06, $06, $07
                        .byte $02, $03, $03, $04, $03, $04, $04, $05
                        .byte $03, $04, $04, $05, $04, $05, $05, $06
                        .byte $03, $04, $04, $05, $04, $05, $05, $06
                        .byte $04, $05, $05, $06, $05, $06, $06, $07
                        .byte $03, $04, $04, $05, $04, $05, $05, $06
                        .byte $04, $05, $05, $06, $05, $06, $06, $07
                        .byte $04, $05, $05, $06, $05, $06, $06, $07
                        .byte $05, $06, $06, $07, $06, $07, $07, $08
