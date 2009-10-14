

;; Ethernet PHY interface module

    .include "net.inc"
    .include "regs.inc"
    .include "sysequ.inc"
    .include "cp2200.inc"

    .segment "PHY_VARS"

PHY_STATE:
    .res 1
PHY_MODE:
    .res 1

    .segment "PHY"

    ;
    ; PHY_UP - Bring up the ethernet PHY.
    ;
    ; In:   I flag = set
    ; Out:  Y register = status; 1 = success, $80-FF = error
    ;
PHY_UP:
    lda PHY_STATE
    ;cmp #PHY_STATE_DOWN
    bne @exit   ; PHY is already up!
    
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

    rts
