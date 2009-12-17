
    .include "sysequ.inc"
    .include "etherpbi.inc"
    .include "w5300.inc"
    .include "cio.inc"

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
    .word CIO_OPEN-1    ;OPEN_VEC-1
    .word CIO_CLOSE-1   ;CLOSE_VEC-1
    .word CIO_READ-1    ;GETBYTE_VEC-1
    .word CIO_WRITE-1   ;PUTBYTE_VEC-1
    .word CIO_STATUS-1  ;STATUS_VEC-1
    .word CIO_SPECIAL-1 ;SPECIAL_VEC-1
    
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

    ; Load saved settings from flash.
    
    ; 

    ;; Step 1.  Set up host interface.
    ; Mode: Big-Endian, ignore PAUSE, disable PPPoE, etc.
    lda #0
    sta W5300_BANK_COMMON
    sta W5300_REG_MR0
    sta W5300_REG_MR1
    ; Disable interrupts
    sta W5300_REG_IMR0
    sta W5300_REG_IMR1
    
    ;; Step 2. Set up net info.
    ; SHAR, GAR, SUBR, SIPR


    
    ; RTR, RCR
    
    ;; Step 3. Allocate Rx/Tx RAM for sockets.
    ; MTYPER, TMSR, RMSR
    
    ;; Step 4. Close all sockets
    ldy #8
@next:
    dey
    sta W5300_BANK_SOCK,y
    sta W5300_REG_SOCK_CR
    bne @next

    ; Restore system IRQs, if they were enabled before.
    plp

    ; Lastly, register our PBI device.
    lda DEVMASK
    ora NDEVREQ
    sta DEVMASK
    ; Add our CIO devices to HATABS.
    ldx #'@'
@check_dev:
    lda CIO_MAP-'@',x
    bne @next_dev
    lda #<GENDEV
    ldy #>GENDEV
    jsr NEWDEV
@next_dev:
    inx
    cpx #'z'+1
    bne @check_dev
    rts
