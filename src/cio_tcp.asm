    .include "sysequ.inc"
    .include "etherpbi.inc"
    .include "cio.inc"
    .include "w5300.inc"

    .segment "CIO_TCP"
    
    .org $DC00
    
    jmp TCP_OPEN
    jmp TCP_CLOSE
    jmp TCP_READ
    jmp TCP_WRITE
    jmp TCP_STATUS

    ;
    ; TCP_SPECIAL - Perform special XIO operation
    ;
    ; In:   ZIOCB populated
    ; Out:  Carry = 1, Y reg. = status (1 = ok), N flag = 1 for error
    ;
TCP_SPECIAL:
    ; Get the command
    lda ICCOMZ
    
    
    ldy #129
    sec
    rts

    ;
    ; TCP_OPEN - Open a TCP channel
    ;
    ; In:   ZIOCB populated
    ; Out:  Carry = 1, Y reg. = status (1 = ok), N flag = 1 for error
    ;
TCP_OPEN:
    lda ICAX1
    and #%11111001  ; check for unsupported flags
    beq @no_unsup
@badmode:
    ldy #EBADMOD    ; not supported yet
    sec
    rts
@no_unsup:
    lda ICAX1
    and #%00000110  ; READ & WRITE - not valid to open TCP otherwise
    cmp #%00000110
    bne @badmode
    
    ; Find an unused socket
    ldy #0

@try:
    sta W5300_BANK_SOCK,y
    lda W5300_REG_SOCK_SSR
    beq @found
    iny
    cpy #8
    bne @try
    ldy #ENFILE
    sec
    rts

@found:
    
    rts

TCP_STATUS:

TCP_WRITE:

TCP_READ:

TCP_CLOSE:
