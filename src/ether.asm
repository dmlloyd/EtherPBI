

;; Ethernet interface module

    .include "net.inc"
    .include "regs.inc"
    .include "sysequ.inc"
    .include "cp2200.inc"

ETHER_PHY_START:
;; Disable interrupts.
    php
    sei
    lda IFSTATZ
    beq @exit
    
;; Step 5: Initialize the physical layer. (15.7)
;; Step 5.1: If auto-negotiation is used, kick off the synch procedure
;; Step 5.2: Disable the PHY layer
    lda #0
    sta ETH_PHYCN
;; Step 5.3: Configure desired options
;; Step 5.3.1: Specify duplex or auto-negotiate
;; Step 5.3.2: Enable loopback mode if desired (it's not :)
;; Step 5.3.3: Enable special features:
;; Step 5.3.3.1: Receiver smart squelch
;; Step 5.3.3.2: Automatic polarity correction
;; Step 5.3.3.3: Link integrity
;; Step 5.3.3.4: Jabber protection
;; Step 5.3.3.5: PAUSE packet capability
;; Step 5.3.4: Enable physical layer
;; Step 5.3.4.1: Set the enable bit
    lda #%10000000  ; PHYEN
    sta ETH_PHYCN
;; Step 5.3.4.2: Wait for phy to power up (>1 ms)
    ldx #17 ;; TODO: Does this work for PAL as well?
@delay:
    sta WSYNC
    dex
    bne @delay
;; Step 5.3.4.3: Enable transmitter and receiver
    lda #%11100000  ; PHYEN+TXEN+RXEN
    sta ETH_PHYCN
;; Step 5.3.5: Wait for auto-negotiate to complete

;; Step 6: Enable the appropriate LEDs.

;; Restore interrupt status.
@exit:
    plp
    rts

ETHER_MAC_START:
    php
    sei
    jsr ETHER_PHY_START

;; Step 7: Initialize the MAC (14.1)

;; Step 8: Configure the receive filter. (12.4)

    plp
    rts

