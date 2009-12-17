    .include "sysequ.inc"
    .include "etherpbi.inc"
    .include "cio.inc"

    .segment "CIO"

    ;
    ; check_dev - Verify that the device is ours, else return error
    ;
    ; In:   ZIOCB populated
    ; Out:  Carry 1 = it's us, Y reg. = bank # of handler
    ;       Carry 0 = not ours
    ;
check_dev:
    pha
    ldy ICHIDZ
    lda CIO_MAP,y
    bmi @fail
    tya
    pla
    sec
    rts
@fail:
    pla
    clc
    rts

@not_ok:
    clc
RTSX:
    rts

CIO_OPEN:
    jsr check_dev
    bcc RTSX
    sta CIO_BANK,y
    jmp OPENV

CIO_CLOSE:
    jsr check_dev
    bcc RTSX
    sta CIO_BANK,y
    jmp CLOSEV

CIO_READ:
    jsr check_dev
    bcc RTSX
    sta CIO_BANK,y
    jmp READV
    
CIO_WRITE:
    jsr check_dev
    bcc RTSX
    sta CIO_BANK,y
    jmp WRITEV

CIO_STATUS:
    jsr check_dev
    bcc RTSX
    sta CIO_BANK,y
    jmp STATUSV

CIO_SPECIAL:
    jsr check_dev
    bcc RTSX
    sta CIO_BANK,y
    jmp SPECIALV
