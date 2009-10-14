
    ;; CIO routines
    
    CIO_BANK = $D640 + 0 ; TODO bank ID of CIO bank

    .global OPEN
    .global CLOSE
    .global READ
    .global WRITE
    .global STATUS
    .global SPECIAL

    ;; CIO data
    

    ;; CIO equates

    ; CIO operations
    ;   Directories:
    ;     ARP cache:
    ;       OPEN #1,6,0,"N:ARP"
    ;     Log:
    ;       OPEN #1,6,0,"N:LOG"
    ;     Status:
    ;       OPEN #1,6,0,"N:STA"
    ;   Open types:
    ;     TCP socket:
    ;       unbound:
    ;         OPEN #1,12,0,"N:"
    ;       bound, random IP and port, unconnected:
    ;         OPEN #1,12,0,"N:!"
    ;       bound & connected, random src IP and port:
    ;         OPEN #1,12,0,"N:WWW.FLURG.COM:80"
    ;       bound & connected, specified src port:
    ;         OPEN #1,12,0,"N::1234!WWW.FLURG.COM:80"
    ;       existing socket attach:
    ;         OPEN #1,4+8+16,ID,"N:"
    ;       server:
    ;         OPEN #1,32,0,"N:":REM CREATE LISTENER
    ;         XIO 48,#1,0,0,"N::80":REM BIND
    ;         OPEN #2,28,1,"N:":REM ACCEPT FROM #1
    ;         XIO 38,#2,208,ASC("?"),"N:":REM TRANSLATE
    ;         PRINT #2;"HTTP/1.0 200 OK"
    ;         PRINT #2;"Content-Type: text/html"
    ;         PRINT #2;""
    ;         PRINT #2;"<html><body>TEST!</body></html>"
    ;         CLOSE #2
    

    ; OPEN
    ;   ICAX1 values:
    ;     bit 0: Concurrent mode emulation
    ;     bit 1: Directory
    ;     bit 2: Read
    ;     bit 3: Write
    ;     bit 4: Socket attach (use with accept).
    ;       when a server socket is closed, its unattached sockets will be closed too!
    ;     bit 5: Listen
    ;   ICAX2 = IOCB of server socket to accept from
    

    ; XIO operations

    ; RS232 compat
    XIO_RS232_SPBL  = $20 ; RS232 send partial block

    XIO_RS232_CNTRL = $22 ; RTS,XMT,DTR
    ; ICAX1:
        ; bit 0: force XMT to SPACE (0) or MARK (1)
        ; bit 1: XMT control enable (1 = enabled)
        ; bit 2-3: unused
        ; bit 4: Force RTS value
        ; bit 5: RTS control (1 = force, 0 = default)
        ; bit 6: Force DTR value
        ; bit 7: DTR control (1 = force, 0 = default)
    ; in atari800, turning off DTR drops connection

    XIO_RS232_RATE  = $24 ; Baud rate, stop bits, word size
    ; ICAX1:
        ; bit 0-3: bit rate
        ;   0000 = 300
        ;   0001 = 57600 in emu, 45.5 in 850
        ;   0010 = 50
        ;   0011 = 115200 in emu, 56.875 in 850
        ;   0100 = 75
        ;   0101 = 110
        ;   0110 = 134.5
        ;   0111 = 150
        ;   1000 = 300
        ;   1001 = 600
        ;   1010 = 1200
        ;   1011 = 1800
        ;   1100 = 2400
        ;   1101 = 4800
        ;   1110 = 9600
        ;   1111 = 19200
        ; bit 4-5: word size
        ;   00 = 8 bits
        ;   01 = 7 bits
        ;   10 = 6 bits
        ;   11 = 5 bits
        ; bit 6: in emu, selects 230400 bps
        ; bit 7: stop bits
        ;   0 = 1 stop bit
        ;   1 = 2 stop bits
    ; ICAX2: set concurrent mode handshake line check for DSR/CTS/CD
        ; bit 0: CD
        ; bit 1: CTS
        ; bit 2: DSR
        ; XIO 40 returns ERROR-139 if the named lines are not set

    ; Set translation mode
    XIO_XLATION     = $26 ; Set translation mode
    ; ICAX1:
        ; bits 0-1: RS232 output parity spec (ignored)
        ;   00 = no change
        ;   01 = set to odd
        ;   10 = set to even
        ;   11 = set to one
        ; bits 2-3: RS232 input parity spec (ignored)
        ;   00 = no change
        ;   01 = set to odd
        ;   10 = set to even
        ;   11 = no parity
        ; bit 4: translation mode
        ;   0 = light translation (strip bit 8 and translate 13<->155)
        ;   1 = heavy translation (light + control chars are filtered)
        ; bit 5: translation enable
        ;   0 = enable translation
        ;   1 = disable translation
        ; bit 6: CRLF output mode
        ;   0 = no LF
        ;   1 = append LF after CR
        ; bit 7: LF input mode (unused on R:)
        ;   0 = pass thru
        ;   1 = consume LF after CR
    ; ICAX2:
        ; replacement char for translation

    XIO_CONCURRENT  = $28 ; RS232 concurrent mode start
    ; ICAX1-2: output buffer address $0000 = default
    ; ICAX3-4?: input buffer address $0000 = default

    XIO_BLOCKING    = $2A ; Set blocking mode.
    ; ICAX1:
    ;   bit 0: Input/accept blocking; 0 = block, 1 = nonblock
    ;       - Non-blocking input does not support READ RECORD
    ;   bit 1: Output blocking; 0 = block, 1 = nonblock
    ;

    ; Bind to the given IP address.
    ; Text arg format: [xxx.xxx.xxx.xxx[:port]]
    ; Buffer format:
    ;     bytes 0-3: IP address in network order, 0 for *
    ;     bytes 4-5: Port in network order, 0 to select
    XIO_SOCK_BIND   = $30

    ; Accept an incoming connection via GET single-byte op.
    ; Returns the attach ID to pass into OPEN.  Make sure
    ; the same device # is used for multi-eth systems.

    ; Connect an unconnected socket to a remote host.
    ; Socket is bound to *:0 if it is not already bound.
    XIO_SOCK_CONNECT= $31

    ; Add a static ARP cache entry.
    ; Text arg format: xxx.xxx.xxx.xxx[/nm] xx:xx:xx:xx:xx:xx
    ; (IP address and optional netmask followed by MAC address)
    ; Data buffer format (must be at least 11 bytes):
    ; bytes 0-3: IP address in network order
    ; byte 4: Netmask bits (0-31)
    ; bytes 5-11: MAC address in network order
    XIO_ARP_ADD     = $40

    ; Delete an ARP cache entry.  Only an exact match is removed.
    ; Text arg format: xxx.xxx.xxx.xxx[/nm] xx:xx:xx:xx:xx:xx
    ; (IP address and optional netmask followed by MAC address)
    ; Data buffer format (must be at least 11 bytes):
    ; bytes 0-3: IP address in network order
    ; byte 4: Netmask bits (0-31)
    ; bytes 5-11: MAC address in network order
    XIO_ARP_DELETE  = $41
    ; Delete entire ARP cache.
    XIO_ARP_CLEAR   = $42


    ; Execute an ARP announcement.
    XIO_ARP_ANN     = $43
    
    

    XIO_IP_SET_ADDR = $50
    XIO_IP_SET_GW   = $51
    
    ; AUX1 codes.
    ; Accept the argument from the filename field in text format rather than from the data buffer.
    ; Not supported for all operations.
    XIO_AX1_TEXT_IN     = $01
    ; Produce output in text format rather than binary.
    ; Not supported for all operations.  Default mode for directories.
    XIO_AX1_TEXT_OUT    = $02
