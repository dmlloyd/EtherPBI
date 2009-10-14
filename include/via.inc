    
    .global VIA_BASE ; $D1C0
    
    .global VIA_PORTB
    .global VIA_PORTA
    .global VIA_DDRB
    .global VIA_DDRA
    ; Read:  T1 counter low
    ; Write: T1 latches low
    .global VIA_T1CL
    ; Read:  T1 counter high
    ; Write: T1 counter high
    .global VIA_T1CH
    ; Read:  T1 latches low
    ; Write: T1 latches low
    .global VIA_T1LL
    ; Read:  T1 latches high
    ; Write: T1 latches high
    .global VIA_T1LH
    
    .global VIA_T2CL
    .global VIA_T2CH
    .global VIA_SHIFT
    .global VIA_AUXCTL
    .global VIA_PCR
    .global VIA_INT
    .global VIA_INTEN
    .global VIA_PORTAN
