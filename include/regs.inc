
    ;; Dynamically allocated registers.

    .global IPADDR1 ; 4 bytes, big-endian
    .global PORT1   ; 2 bytes, big-endian

    ; PRNG seed
    .global SEED    ; 1 byte

    ; Temp regs
    .global t1
    .global t2
    .global t3
    .global t4

    ;
    ; Tables
    ;
    .global NETMASK_TABLE
    .global HOSTMASK_TABLE
