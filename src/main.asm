
    .include "sysequ.inc"
    .include "cp2200.inc"
    .include "ether_cio.inc"

    ;; Memory map:
    ;; D100-D1FF (256 bytes): I/O area
    ;;    D100-D17F: CP2200
    ;;    D180-D18F: VIA
    ;;    D190-D1EF: unused
    ;;    D1FF: PBI select/interrupt register
    ;; D600-D63F (64 bytes): 
    ;; D640-D67F (64 bytes): PBP Program memory bank 1 select
    ;; D680-D6BF (64 bytes): Buffer RAM select - low
    ;; D6C0-D6FF (64 bytes): Buffer RAM select - high
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


OPEN:
    ;; do open
    
    lda #'N'
    cmp ICHIDZ
    beq @match
@nomatch:
    clc         ; indicate no match
    rts
@match:
    ldx ICDNOZ
    beq @match2 ; device # not specified, so pick us
    dex
    beq @match2 ; we're not selected, it's the next card
    stx ICDNOZ  ; store decremented device # so next card can have a chance
    bne @nomatch
@match2:


    sec
    rts

.proc RESET
    ;
    ; Complete reset procedure.
    ;
    ; In:   -
    ; Out:  -
    ;

    ; Disable IRQs.
    php
    sei
    ; From CP2200/1 data sheet 6.2. Reset Initialization...
    ; Step 1: Wait for reset pin to rise (duh)
    ; Step 2: Wait for oscillator initialization to complete.
    ; (we will poll the interrupt status register)

wait0:
    lda ETH_INT0
    and #%00001000  ; Oscillator stabilized?
    bne wait2       ; More quickly than expected!
wait1:
    sta WSYNC       ; Don't spam the register, plz
    lda ETH_INT0
    and #%00001000  ; Oscillator stabilized?
    beq wait1
wait2:
    ; Step 3: Wait for Self Initialization to complete.
    ; The INT0 interrupt status register on page 31 should be
    ; checked to determine when Self Initialization completes.
    lda ETH_INT0
    and #%00000100  ; Self-init complete?
    bne chip_ready  ; Chip is ready
wait3:
    sta WSYNC       ; Don't spam...
    lda ETH_INT0
    and #%00000100  ; Self-init complete?
    beq wait3

chip_ready:
    ; Step 4: Disable interrupts (using INT0EN and INT1EN).
    ; The proper interrupts will be enabled when the PHY/MAC are turned up.
    lda #0
    sta ETH_INT0EN
    sta ETH_INT1EN

    ; Init our ZP region.
    ldx #$7f
    lda #0
clear_byte:
    sta $80,x
    dex
    bpl clear_byte  ; stop when X hits $FF

    ; Load firmware image from flash.
    lda #0
    sta $90 ; this will be our placeholder for the bank #
    ; Start at the beginning...
    ;lda #0
    sta ETH_FLASHADDRL
    ;lda #0
    sta ETH_FLASHADDRH
    lda ETH_FLASHAUTORD
    bne commence
    ; no firmware, abort!
    plp
    rts
commence:
    sta $91 ; the number of banks to read
load_bank:
    ldx ETH_FLASHAUTORD ; low count
    ldy ETH_FLASHAUTORD ; high count
@l1:
    lda ETH_FLASHAUTORD
    sta $D100,x
    inx
    bne @l1
@l2:
    lda ETH_FLASHAUTORD
    sta $D200,x
    inx
    bne @l2
    



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
    jmp NEWDEV
    ; Ignore the result, because frankly, we don't much care.
.endproc

