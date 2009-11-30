
    .include "sysequ.inc"
    .include "w5100.inc"
    .include "cio.inc"

    ;; Memory map:
    ;; D100-D1FF (256 bytes): I/O area
    ;;    D100-D17F: W5100 bank select bytes
    ;;    D180-D18F: PBP Program memory bank 1 select
    ;;    D190-D1EF: unused
    ;;    D1FF: PBI select/interrupt register
    ;; D600-D6FF (256 bytes): W5100 access area
    ;; D700-D7FF (256 bytes): Buffer RAM bank 
    ;; D800-DBFF (1024 bytes): PBP Program memory bank 0
    ;; DC00-DFFF (1024 bytes): PBP Program memory bank 1
    
    DEVICE_NAME     = 'N'

    ;; PBI area at $D800
    .segment "HEADER"
    ;;.org $D800
    
    ;; Checksum (NOT USED)
    .word 0
    
    ;; Version number (NOT USED)
    .byte $01
    
    ;; ID Number 1
    .byte $80
    
    ;; Device type (NOT USED??)
    .byte 0
    
    ;; I/O Vector
    jmp SIO
    
    ;; Interrupt Vector, exit with PLA/RTI
    jmp IRQ
    
    ;; ID Number 2
    .byte $91
    
    ;; Device Name (NOT USED)
    .byte 0
    
    ;; Initial CIO vectors
    .word OPENV-1    ;OPEN_VEC-1
    .word CLOSEV-1   ;CLOSE_VEC-1
    .word READV-1    ;GETBYTE_VEC-1
    .word WRITEV-1   ;PUTBYTE_VEC-1
    .word STATUSV-1  ;STATUS_VEC-1
    .word SPECIALV-1 ;SPECIAL_VEC-1
    
    ;; Device initialization
    jmp INIT

    ;; Unused byte
    .byte 0

    .segment "BOOT_ROM"
SIO:
    clc
    rts

IRQ:
    pla
    rti

INIT:
    jmp RESET
    
OPENV:
    sta CIO_BANK
    jmp OPEN

CLOSEV:
    sta CIO_BANK
    jmp CLOSE

READV:
    sta CIO_BANK
    jmp READ
    
WRITEV:
    sta CIO_BANK
    jmp WRITE

STATUSV:
    sta CIO_BANK
    jmp STATUS

SPECIALV:
    sta CIO_BANK
    jmp SPECIAL

RESET:
    ;
    ; Complete reset procedure.
    ;
    ; In:   -
    ; Out:  -
    ;

    ; Disable IRQs.
    php
    sei


    ; Restore system IRQs, if they were enabled before.
    plp

    ; Lastly, register our PBI device.
    lda DEVMASK
    ora NDEVREQ
    sta DEVMASK
    ; Add our device to HATABS.
    ldx #DEVICE_NAME
    lda #<GENDEV
    ldy #>GENDEV
    ; Exit via NEWDEV.
    jmp NEWDEV
    ; Ignore the result, because frankly, we don't much care.

