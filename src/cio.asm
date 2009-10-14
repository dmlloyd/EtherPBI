    .include "sysequ.inc"
    .include "cio.inc"
    
    .segment "CIO_REGS"

CIO_REGS:
    .res 32

    IOCB_TYPE = CIO_REGS + 0
    
    ; Socket IOCB types
    SOCKET_ID = CIO_REGS + 1

    ; Directory IOCB types
    ;   Log:
    LOG_POS = CIO_REGS + 1      ; Position in log
    LOG_MSG_POS = CIO_REGS + 2  ; Position in expanded log message
    ;   ARP table:
    ARP_POS = CIO_REGS + 1      ; Position in ARP table
    ARP_MSG_POS = CIO_REGS + 2  ; Position in expanded ARP message
    ARP_MSG_LEN = CIO_REGS + 3  ; Length of ARP message


    .segment "CIO"
    

    ;
    ; OPEN - Open a IOCB for one of our devices ("N", "R", or "H").
    ;
    ; In:   ZIOCB populated
    ; Out:  Carry 1 = we handled it
    ;       Carry 0 = it is not a known device of ours
    ;
OPEN:
    lda ICHIDZ
    ; See if it's a net device request
    cmp #'N'
    beq do_net_open
    ; See if it's a request for an emulated RS232 device
    cmp #'R'
    beq do_rs232_open
    ; See if it's a request for our NETCIO device
    cmp #'H'
    beq do_netcio_open
    ; not ours, return
    clc
    rts
do_net_open:
    jmp NET_OPEN
do_rs232_open:
    jmp RS232_OPEN
do_netcio_open:
    jmp NETCIO_OPEN

    ; Handle open of virtual R: device.
rs232_open:
    lda ICDNOZ  ; device #
    bne @nonzero
    inc ICDNOZ
    lda ICDNOZ
@nonzero:
    ; Look to see if a connection has been registered for this handler

    ; No, report an error
    ldy #EDNACK
    sec
    rts

ok:
    ldy #1
    sec
    rts

