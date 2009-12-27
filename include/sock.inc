
    ; Socket API


    ;
    ; RANDOM_BYTE - get a random byte
    ;
    ; In:   SEED = old seed
    ;
    ; Out:  A = SEED = random number
    ;
    .global RANDOM_BYTE

    ;
    ; SOCK_SELECT_PORT - select a random, unused source port #
    ;
    ; In:   A = mode:   $01 = TCP
    ;                   $02 = UDP
    ;
    ; Out:  PORT1 = port #
    ;       t1 = mode << 4
    ;       SEED = updated
    ;
    .global SOCK_SELECT_PORT

    ;
    ; SOCK_OPEN - open a W5300 socket
    ;
    ; In:   A = mode:   $01 = TCP
    ;                   $02 = UDP
    ;                   $03 = Raw IP
    ;                   $04 = Raw MAC
    ;       PORT1 = port # (TCP/UDP only), 0 = select random port
    ;
    ; Out:  Y = Socket ID (0-7)
    ;       Socket bank selected
    ;       N flag clear
    ;
    ; Err:  Y = Error code ENFILE (no socket available)
    ;       N flag set
    ;
    .global SOCK_OPEN

    ;
    ; SOCK_OPEN_CURRENT - open currently selected socket
    ;
    ; In:   A = mode:   $01 = TCP
    ;                   $02 = UDP
    ;                   $03 = Raw IP
    ;                   $04 = Raw MAC
    ;       PORT1 = port # (TCP/UDP only)
    ;
    ; Out:  Y = 1
    ;       N flag clear
    ;
    ; Err:  Y = Error code EISOPEN
    ;       N flag set
    ;
    .global SOCK_OPEN_CURRENT

    ;
    ; SOCK_CLOSE - close a socket
    ;
    ; In:   Y = Socket ID (0-7)
    ;
    ; Out:  Socket bank selected
    ;       Socket closed
    ;
    .global SOCK_CLOSE

    ;
    ; Close the current socket.
    ;
    ; In:   Socket bank selected
    ;
    ; Out:  Socket bank selected
    ;       Socket closed
    ;
    .global SOCK_CLOSE_CURRENT

    ;
    ; Write bytes to the current socket, starting with even byte, padding to word boundary.
    ;
    ; In:   BUFRHI/BUFRLO = buffer address
    ;       BFENHI/BFENLO = buffer length
    ;       Current socket selected
    ;
    ; Out:  Data written, padded to 16 bits
    ;       BUFRHI/BUFRLO = buffer address (unchanged)
    ;       BFENHI/BFENLO = buffer length (unchanged)
    ;       A, X, Y = clobbered
    ;
    .global SOCK_WRITE

    ;
    ; Read bytes from the current socket, starting with the even byte, padding to word boundary.
    ;
    ; In:   BUFRHI/BUFRLO = buffer address
    ;       BFENHI/BFENLO = buffer length
    ;       Current socket selected
    ;
    ; Out:  Data read into buffer, padded to 16 bits
    ;       BUFRHI/BUFRLO = buffer address (unchanged)
    ;       BFENHI/BFENLO = buffer length (unchanged)
    ;       A, X, Y = clobbered
    ;       
    .global SOCK_READ
