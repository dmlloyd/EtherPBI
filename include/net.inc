

    ;; =======================
    ;;  Ethernet
    ;; =======================

    ; Both high bytes are $08, so generally I'll just check for that directly
    ETHERTYPE_ARP   =   $0806
    ETHERTYPE_IP    =   $0800
    
    ;; =======================
    ;;  IP
    ;; =======================

    IP_HEADER_LEN   =   20

    IP_PROTO_ICMP   =   $01
    IP_PROTO_TCP    =   $06
    IP_PROTO_UDP    =   $11

    ;; =======================
    ;;  ARP
    ;; =======================

    .global ARP_UPDATE
    .global ARP_WRITE_ENTRY
    .global ARP_WRITE_MAC
    .global ARP_UPDATE_FLAGS
    .global ARP_DELETE
    .global ARP_DELETE_ENTRY
    .global ARP_LOOKUP
    .global ARP_CLEAR
    .global ARP_DELETE_AGE

    ARP_TABLE_SIZE  = 16

    .global ARP_TABLE
    
    ARP_OP_REQUEST  = 1
    ARP_OP_REPLY    = 2
    ARP_OP_RARP_REQ = 3
    ARP_OP_RARP_REP = 4

    ARP_MAX_AGE     = 20 ; minutes

    ; ARP table entry age
    .global ARP_TAB_AGE
    
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
    ; The IOCB (times 16) currently associated with this socket, or $FF for none (or DCB/SIO).
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
    
    
