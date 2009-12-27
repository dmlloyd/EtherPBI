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
    ; Store socket number in aux3
    ;sty ICAX3,x

    ; Connect?
    lda #0
    cmp ICBLLZ
    sbc ICBLHZ
    beq @just_open

    ldy #0
    lda (ICBALZ),y
    cmp #'!'
    bne @xlate_text
    lda ICBLHZ
    cmp #0
    beq @check_low
@bad_buf:
    ldy #EBADBUF
    sec
    rts
@check_low:
    lda ICBLLZ
    cmp #6
    bne @bad_buf
    ; OK we have six raw bytes: IP followed by port
    


@just_open:
    ; Open socket
    lda #0
    sta W5300_REG_SOCK_MR0
    ; TCP, no delayed ACK, MAC Filter
    lda #%01100001
    sta W5300_REG_SOCK_MR1
    ; Open socket
    lda #$01
    sta W5300_REG_SOCK_CR
    

    rts

TCP_STATUS:

TCP_WRITE:

TCP_READ:

TCP_CLOSE:
