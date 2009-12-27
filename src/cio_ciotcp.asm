
    ;
    ; Client->Server Protocol
    ;
    ; PROTO:
    ;       OPEN CMDS
    ;
    ; OPEN:
    ;       DeviceName(1) UnitNumber(1) AuxBytes(6) BufLen(2) Buf(n) ReceiveSpecialInfo(0)
    ;
    ; CMDS:
    ;       CMD CMDS
    ;     | Eof(end-of-input)
    ;
    ; CMD:
    ;       DeviceName(1) UnitNumber(1) AuxBytes(6) 
    ; ---
    ; Server->Client Messages:
    ;
    ; SPECIAL_INFO:
    ;       Count(1) SPECIAL_CMD_INFO(n)
    ;
    ; SPECIAL_CMD_INFO:
    ;       Command(1) Flags(1)
    ;
    ; ---
    ; DeviceName(1): the one-byte ATASCII device name
    ; UnitNumber(1): the one-byte unit # (1-9)
    ; AuxBytes(6): the six aux bytes
    ; BufLen(2): the length of incoming buffer data
    ; Buf(n): the buffer data
    ; ReceiveSpecialInfo(0): wait to receive SPECIAL_INFO from the server
    ; Eof: physical end-of-input from client
    ;
