                        
                        
                        .ifndef VIA_INC
                        .define VIA_INC
                        
                        VIA_BASE    = $D1C0
                        
                        VIA_PORTB   = VIA_BASE + 0
                        VIA_PORTA   = VIA_BASE + 1
                        VIA_DDRB    = VIA_BASE + 2
                        VIA_DDRA    = VIA_BASE + 3
                        ; Read:  T1 counter low
                        ; Write: T1 latches low
                        VIA_T1CL    = VIA_BASE + 4
                        ; Read:  T1 counter high
                        ; Write: T1 counter high
                        VIA_T1CH    = VIA_BASE + 5
                        ; Read:  T1 latches low
                        ; Write: T1 latches low
                        VIA_T1LL    = VIA_BASE + 6
                        ; Read:  T1 latches high
                        ; Write: T1 latches high
                        VIA_T1LH    = VIA_BASE + 7
                        
                        VIA_T2CL    = VIA_BASE + 8
                        VIA_T2CH    = VIA_BASE + 9
                        VIA_SHIFT   = VIA_BASE + 10
                        VIA_AUXCTL  = VIA_BASE + 11
                        VIA_PCR     = VIA_BASE + 12
                        VIA_INT     = VIA_BASE + 13
                        VIA_INTEN   = VIA_BASE + 14
                        VIA_PORTAN  = VIA_BASE + 15

                        .endif
