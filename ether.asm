

            ;; Ethernet interface module
            
            .include "ether.inc"
            .include "regs.inc"
            
ETHER_RESET:
            ;; Disable IRQs.
                        php
                        sei
            ;; From CP2200/1 data sheet 6.2. Reset Initialization...
            ;; Step 1: Wait for reset pin to rise (duh)
            ;; Step 2: Wait for oscillator initialization to complete.
            ;; (we will poll the interrupt status register)
            
@retry0:                lda ETH_INT0
                        and #%00001000 ; Oscillator stabilized
                        beq @retry0
                        
            ;; Step 3: Wait for Self Initialization to complete.
            ;; The INT0 interrupt status register on page 31 should be
            ;; checked to determine when Self Initialization completes.

@retry1:                lda ETH_INT0
                        and #%00000100 ; Self-init complete
                        beq @retry1

            ;; Step 4: Disable interrupts (using INT0EN and INT1EN) for events that will not be
            ;; monitored or handled by the host processor. By default, all interrupts are enabled after every reset.

                        lda #0 ; TODO - set masks properly
                        sta ETH_INT0EN
                        sta ETH_INT1EN

            ;; Restore system IRQs.
                        plp

            ;; Init our ZP region.
                        ldx #$7f
                        lda #0
@loop                   sta $80,x
                        dex
                        bpl @loop ; stop when X hits $FF


            ;; XXX at this point, we should load settings from flash.



            ;; If auto MAC init is enabled, init it.
                        jsr ETHER_MAC_START
                        rts

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
                        lda #ETH_PHYCN_PHYEN
                        sta ETH_PHYCN
            ;; Step 5.3.4.2: Wait for phy to power up (>1 ms)
                        ldx #17 ;; TODO: Does this work for PAL as well?
@delay:                 sta WSYNC
                        dex
                        bne @delay
            ;; Step 5.3.4.3: Enable transmitter and receiver
                        lda #ETH_PHYCN_PHYEN+ETH_PHYCN_TXEN+ETH_PHYCN_RXEN
                        sta ETH_PHYCN
            ;; Step 5.3.5: Wait for auto-negotiate to complete

            ;; Step 6: Enable the appropriate LEDs.
            
            ;; Restore interrupt status.
@exit:                  plp
                        rts

ETHER_MAC_START:
                        php
                        sei
                        jsr ETHER_PHY_START

            ;; Step 7: Initialize the MAC (14.1)

            ;; Step 8: Configure the receive filter. (12.4)
            
                        plp
                        rts

