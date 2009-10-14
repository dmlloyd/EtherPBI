
    ;; Dynamically allocated registers.

    ; Interface status.
    IFSTAT_DOWN = 0
    IFSTAT_PHY_NEGO = 1
    IFSTAT_PHY_UP = 1
    IFSTAT_MAC_UP = 2
    IFSTAT_IP_UP = 3

    .global IFSTATZ
    
    .global IPADDR1   ; 4 bytes
    .global NETMASK1  ; 1 byte
    .global MACADDR1  ; 6 bytes
    .global IPADDR2   ; 4 bytes
    .global NETMASK2  ; 1 byte
    .global MACADDR2  ; 6 bytes
    
    .global ARP_AGE
    .global ARP_LAST

    .global t1
    .global t2
    .global t3
    .global t4

    ;
    ; Counters
    ;
    
    ; Receiver FIFO overruns (8 packets received before the ISR could run).
    ; Indicates eight dropped packets.
    .global RECV_OVERRUNS   ; 2 bytes
    ; The number of invalid packets received.
    .global RECV_INVALID    ; 2 bytes
    ; Number of received packets.
    .global RECV_PKTS       ; 2 bytes
    ; Number of sent packets.
    .global SEND_PKTS       ; 2 bytes
    ; Number of outbound packets that were dropped due to the transmit queue
    ; being full.  The IRQ handler may drop a packet.  Other interfaces may
    ; instead block until the transmitter is available.
    .global SEND_DROPPED    ; 2 bytes

    ;
    ; Tables
    ;
    .global NETMASK_TABLE
    .global HOSTMASK_TABLE

    ;
    ; Parameters
    ;
    .global RECV_LOW_WATER
    .global RECV_HIGH_WATER
    .global RECV_OVERRUN

    ;
    ; Current user settings
    ;

    .global USER_INITIAL_STATE

    ; PHY preferences

    ; MAC preferences
    .global USER_MAC_ADDR
    .global USER_SYSTEM_MAC_ADDR

    ; IP preferences
    ; flags:
    .global USER_IP_FLAGS
    ; Gateway IP address in network order, 0 for none
    .global USER_IP_GATEWAY
    ; IP address in network order
    .global USER_IP_ADDR
    ; Netmask in bits (/0-/32)
    .global USER_IP_NETMASK

    ; ARP preferences
    ; flags:
    ; $80 = accept ARP
    ; $40 = announce ARP
    .global USER_ARP_FLAGS

    ; ICMP preferences
    ; flags:
    ; $80 = ignore ICMP echo
    ; $40 = ignore ICMP echo broadcasts
    .global USER_ICMP_FLAGS

    ; TCP preferences
    
    ; UDP preferences

    ; DNS preferences
    .global USER_DNS_IP_ADDR
