

    ;; =======================
    ;;  General sockets
    ;; =======================

    ; Number of open sockets of any kind.  If 0 and receiver is ONDEMAND, turn it off
    .global SOCK_COUNT

    .global SOCK_OPEN
    .global SOCK_CLOSE

    ;; =======================
    ;;  PHY
    ;; =======================

    PHY_STATE_DOWN = 0
    PHY_STATE_NEGO = 1
    PHY_STATE_UP = 2

    .global PHY_STATE
    ; PHY mode.
    ; Bit 7: 1 = full-duplex, 0 = half-duplex
    .global PHY_MODE

    ; Bring up the PHY layer.
    .global PHY_UP
    ; Turn off the PHY layer.  Brings down the MAC if it is up.
    .global PHY_DOWN

    ;; =======================
    ;;  MAC
    ;; =======================

    MAC_STATE_DOWN = 0
    MAC_STATE_UP = 1

    ; Receiver state values
    RECV_STATE_OFF = 0          ; Disable receiver
    RECV_STATE_ON = 1           ; Enable receiver (as long as the receive buffer is below the high-water mark)
    RECV_STATE_ONDEMAND = 2     ; Enable receiver when a socket is open

    ; Receiver status flags values
    RECV_STATUS_HIGHWATER = 1

    ; State of the MAC layer.
    .global MAC_STATE

    ; Receiver status flags
    .global RECV_STATUS
    ; Receiver state
    .global RECV_STATE
    ; The receiver low-water mark
    .global RECV_LOW_WATER
    ; The receiver high-water mark
    .global RECV_HIGH_WATER

    ; MAC layer stats.  3 bytes each
    ; Receiver FIFO overruns (8 packets received before the ISR could run).
    .global MAC_STATS_RECV_OVERRUNS
    ; The number of invalid packets received.
    .global MAC_STATS_RECV_INVALID
    ; Number of received packets.
    .global MAC_STATS_RECV_CNT
    ; Number of sent packets.
    .global MAC_STATS_SEND_CNT
    ; Number of outbound packets that were dropped due to the transmit queue
    ; being full.  The IRQ handler may drop a packet.  Other interfaces may
    ; instead block until the transmitter is available.
    .global MAC_STATS_SEND_DROPPED

    ; MAC procedures
    ; Bring up the MAC layer.  Also brings up PHY if it is down.  Will perform validation first.
    .global MAC_UP
    ; Turn off the MAC layer.  Brings down IP if it is up.
    .global MAC_DOWN

    ; Receiver procedures
    ; Set the desired receiver state
    .global RECV_SET_STATE

    ; Both high bytes are $08, so generally I'll just check for that directly
    ETHERTYPE_ARP   =   $0806
    ETHERTYPE_IP    =   $0800
    
    .global MAC_ADDRESS0
    .global MAC_ADDRESS1
    .global MAC_ADDRESS2
    .global MAC_ADDRESS3
    .global MAC_ADDRESS4
    .global MAC_ADDRESS5

    .global MAC_ADDRESS_HW0
    .global MAC_ADDRESS_HW1
    .global MAC_ADDRESS_HW2
    .global MAC_ADDRESS_HW3
    .global MAC_ADDRESS_HW4
    .global MAC_ADDRESS_HW5
    .global MAC_ADDRESS_HW6

    ;; =======================
    ;;  ARP
    ;; =======================

    ARP_OP_REQUEST  = 1
    ARP_OP_REPLY    = 2
    ARP_OP_RARP_REQ = 3
    ARP_OP_RARP_REP = 4

    ARP_MAX_AGE     = 20 ; minutes

    ; ARP procedures
    .global ARP_UPDATE
    .global ARP_WRITE_ENTRY
    .global ARP_WRITE_MAC
    .global ARP_UPDATE_FLAGS
    .global ARP_DELETE
    .global ARP_DELETE_ENTRY
    .global ARP_LOOKUP
    .global ARP_CLEAR
    .global ARP_DELETE_AGE

    ; ARP global variables
    .global ARP_AGE
    .global ARP_LAST

    ; ARP preferences
    ; flags:
    ; $80 = accept ARP
    ; $40 = announce ARP
    .global ARP_FLAGS

    ; ARP table structure
    .global ARP_TABLE
    
    ARP_TABLE_SIZE  = 16

    ; ARP table flags
    ; bit 7: 1 = allocated; 0 = free
    ; bit 6: 1 = complete; 0 = incomplete or free
    ; bit 5: 1 = in use (protected); 0 = not in use or free
    ; bit 4:
    ; bit 3:
    ; bit 2:
    ; bit 1:
    ; bit 0:
    .global ARP_TAB_FLAGS
    
    ; ARP table entry age, if not protected
    .global ARP_TAB_AGE
    ; Number of references, if protected
    ; When the count reaches 0, the age is marked and protect flag is cleared
    .global ARP_TAB_REFCNT
    
    ; IP address (network order)
    .global ARP_TAB_IPADDR0
    .global ARP_TAB_IPADDR1
    .global ARP_TAB_IPADDR2
    .global ARP_TAB_IPADDR3

    ; MAC address (network order)
    .global ARP_TAB_MAC0
    .global ARP_TAB_MAC1
    .global ARP_TAB_MAC2
    .global ARP_TAB_MAC3
    .global ARP_TAB_MAC4
    .global ARP_TAB_MAC5

    ;; =======================
    ;;  IP
    ;; =======================

    IP_HEADER_LEN   =   20

    IP_PROTO_ICMP   =   $01
    IP_PROTO_TCP    =   $06
    IP_PROTO_UDP    =   $11

    IP_STATE_DOWN   =   0
    IP_STATE_UP     =   1
    ;IP_STATE_DHCP  =   2

    ; IP procedures
    .global IP_UP
    .global IP_DOWN

    ; IP preferences

    ; IP Configuration flags
    .global IP_FLAGS
    ; Gateway IP address in network order, 0 for none
    .global IP_GATEWAY0
    .global IP_GATEWAY1
    .global IP_GATEWAY2
    .global IP_GATEWAY3
    ; IP address in network order
    .global IP_ADDRESS0
    .global IP_ADDRESS1
    .global IP_ADDRESS2
    .global IP_ADDRESS3
    ; Netmask in bits (/0-/32)
    .global IP_NETMASK

    ;; =======================
    ;;  ICMP
    ;; =======================

    ; ICMP preferences
    ; flags:
    ; $80 = ignore ICMP echo
    ; $40 = ignore ICMP echo broadcasts
    .global USER_ICMP_FLAGS

    ;; =======================
    ;;  TCP
    ;; =======================

    TCP_HEADER_LEN  =   20

    ;; Possible TCP socket states.
    
    TCP_CLOSED              = 0
    TCP_SYN_RCVD            = 1
    TCP_SYN_SENT            = 2
    TCP_ESTABLISHED         = 3
    TCP_FIN_WAIT_1          = 4
    TCP_FIN_WAIT_2          = 5
    TCP_CLOSING             = 6
    TCP_TIME_WAIT           = 7
    TCP_LAST_ACK            = 8

    ;; TCP socket state
    .global TCP_SOCK
    ; The IOCB (times 16) currently associated with this socket, or $FF for none.
    .global TCP_IOCB
    ; The ARP table entry associated with this socket
    .global TCP_ARP
    ; The remote IP address of the connection (big-endian)
    .global TCP_SOCK_REMOTE_IPADDR0
    .global TCP_SOCK_REMOTE_IPADDR1
    .global TCP_SOCK_REMOTE_IPADDR2
    .global TCP_SOCK_REMOTE_IPADDR3
    ; The local bound TCP port of the connection (big-endian)
    .global TCP_SOCK_LOCAL_PORT0
    .global TCP_SOCK_LOCAL_PORT1
    ; The remote TCP port of the connection (big-endian)
    .global TCP_SOCK_REMOTE_PORT0
    .global TCP_SOCK_REMOTE_PORT1
    ; The expected next receive sequence number
    .global TCP_SOCK_RECV_NXT_SEQ0
    .global TCP_SOCK_RECV_NXT_SEQ1
    .global TCP_SOCK_RECV_NXT_SEQ2
    .global TCP_SOCK_RECV_NXT_SEQ3
    ; The sequence number that was last sent by us
    .global TCP_SOCK_SEND_NXT_SEQ0
    .global TCP_SOCK_SEND_NXT_SEQ1
    .global TCP_SOCK_SEND_NXT_SEQ2
    .global TCP_SOCK_SEND_NXT_SEQ3
    ; The number of bytes previously sent (big-endian)
    .global TCP_LEN0
    .global TCP_LEN1
    ; The connection maximum segment size (big-endian)
    .global TCP_MSS0
    .global TCP_MSS1
    ; The initial maximum segment size for the connection (big-endian)
    .global TCP_INIT_MSS0
    .global TCP_INIT_MSS1
    ; The retransmission timeout
    .global TCP_RETRANS_TIMEOUT
    ; The current TCP state
    .global TCP_STATE
    ; The retransmission timer
    .global TCP_RETRANS_TIMER
    ; The number of retransmissions for the last segment
    .global TCP_RETRANS_CNT

    ;; =======================
    ;;  UDP
    ;; =======================

    UDP_HEADER_LEN  =   8
    
    ;; UDP socket state
    .global UDP_SOCK
    ; The IOCB (times 16) currently associated with this socket, or $FF for none (or DCB/SIO/etc).
    .global UDP_IOCB
    ; The remote IP address of the connection (big-endian)
    .global UDP_SOCK_REMOTE_IPADDR0
    .global UDP_SOCK_REMOTE_IPADDR1
    .global UDP_SOCK_REMOTE_IPADDR2
    .global UDP_SOCK_REMOTE_IPADDR3
    ; The local bound UDP port of the connection (big-endian)
    .global UDP_SOCK_LOCAL_PORT0
    .global UDP_SOCK_LOCAL_PORT1
    ; The remote UDP port of the connection (big-endian)
    .global UDP_SOCK_REMOTE_PORT0
    .global UDP_SOCK_REMOTE_PORT1
    ; The default time-to-live
    .global UDP_SOCK_TTL
    
    ;; =======================
    ;;  DNS
    ;; =======================

    ; DNS preferences
    .global USER_DNS_IP_ADDR
    
    ; DNS procedures
    ; Resolve the DNS name given in the selected IOCB.  Translates a file name into the four-byte IP address.  Blocking operation.
    ; DNS lookups are NOT cached.
    .global DNS_RESOLVE
