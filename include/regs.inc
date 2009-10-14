
    ;; Dynamically allocated registers.

    .global IPADDR1   ; 4 bytes
    .global NETMASK1  ; 1 byte
    .global MACADDR1  ; 6 bytes
    .global IPADDR2   ; 4 bytes
    .global NETMASK2  ; 1 byte
    .global MACADDR2  ; 6 bytes
    
    .global t1
    .global t2
    .global t3
    .global t4

    ;
    ; Tables
    ;
    .global NETMASK_TABLE
    .global HOSTMASK_TABLE
