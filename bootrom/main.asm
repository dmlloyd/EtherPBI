
                        .include "sysequ.inc"
                        .include "ether.inc"
                        .include "inflate.inc"

                        DEVICE_NAME     = 'N'

                        ;; Start at boot rom area at $D800
                        .segment "HEADER"
                        
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
                        
                        ;; Interrupt Vector, exit with PLA/RTI
                        jmp PBI_IRQ
                        
                        ;; ID Number 2
                        .byte $91
                        
                        ;; Device Name (NOT USED)
                        .byte 0
                        
                        ;; Initial CIO vectors
                        .word 0 ;OPEN_VEC-1
                        .word 0 ;CLOSE_VEC-1
                        .word 0 ;GETBYTE_VEC-1
                        .word 0 ;PUTBYTE_VEC-1
                        .word 0 ;STATUS_VEC-1
                        .word 0 ;SPECIAL_VEC-1
                        
                        ;; Device initialization
                        jmp RESET
                        
                        
                        ;; Unused byte
                        .byte 0

                        .segment "BOOT_ROM"
PBI_SIO:
                        clc
                        rts

PBI_IRQ:
                        pla
                        rti

PBI_INIT:

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
                        ; Each bank is separately compressed.
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
                        lda #<$D100
                        sta $80 ; dest low byte
                        lda #>$D100
                        sta $81 ; dest high byte
                        jsr INFLATE
                        
                        dec $91
                        bne load_bank
done_uncompressing:
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
