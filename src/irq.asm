
    .include "net.inc"
    .include "sysequ.inc"

    .segment "IRQ"


    ;
    ; Handle IRQ.
    ;
    ; In:   IRQ context
    ;       A saved on stack
    ;       D flag = clear
    ;       I flag = set
    ; Out:  PLA + RTI
    ;
IRQ:
    txa
    pha
    tya
    pha



    pla
    tay
    pla
    tax
    pla
    rti

