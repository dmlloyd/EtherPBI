                        .ifndef ARP_INC
                        .define ARP_INC

                        .global ARP_UPDATE
                        .global ARP_WRITE_ENTRY
                        .global ARP_WRITE_MAC
                        .global ARP_UPDATE_FLAGS
                        .global ARP_DELETE
                        .global ARP_DELETE_ENTRY
                        .global ARP_LOOKUP
                        .global ARP_CLEAR
                        .global ARP_DELETE_AGE

                        .global ARP_TABLE
                        
                        ARP_OP_REQUEST  = 1
                        ARP_OP_REPLY    = 2
                        ARP_OP_RARP_REQ = 3
                        ARP_OP_RARP_REP = 4

                        ;
                        ; ARP table format.
                        ;
                        ; The ARP table is fully interleaved for fast access
                        ; and compact representation.  This means that indexed,x
                        ; can be used with single increment or decrement ops.
                        ;
                        ; 21 is selected so that no portion crosses a page boundary, though
                        ; other values could work as well by starting the table at the right
                        ; offset.
                        ;
                        ARP_TABLE_SIZE  = 21
                        
                        ARP_MAX_AGE     = 20 ; minutes

                        ; First, the entry age.
                        ARP_TAB_AGE     = ARP_TABLE + ARP_TABLE_SIZE * 0
                        
                        ; Second is the ARP table flags
                        ; bit 7: 1 = allocated; 0 = free
                        ; bit 6: 1 = complete; 0 = incomplete or free
                        ; bit 5: 1 = in use (protected); 0 = not in use or free
                        ; bit 4:
                        ; bit 3:
                        ; bit 2:
                        ; bit 1:
                        ; bit 0:
                        ARP_TAB_FLAGS   = ARP_TABLE + ARP_TABLE_SIZE * 1
                        
                        ; IP address (network order)
                        ARP_TAB_IPADDR0 = ARP_TABLE + ARP_TABLE_SIZE * 2
                        ARP_TAB_IPADDR1 = ARP_TABLE + ARP_TABLE_SIZE * 3
                        ARP_TAB_IPADDR2 = ARP_TABLE + ARP_TABLE_SIZE * 4
                        ARP_TAB_IPADDR3 = ARP_TABLE + ARP_TABLE_SIZE * 5

                        ; MAC address (network order)
                        ARP_TAB_MAC0    = ARP_TABLE + ARP_TABLE_SIZE * 6
                        ARP_TAB_MAC1    = ARP_TABLE + ARP_TABLE_SIZE * 7
                        ARP_TAB_MAC2    = ARP_TABLE + ARP_TABLE_SIZE * 8
                        ARP_TAB_MAC3    = ARP_TABLE + ARP_TABLE_SIZE * 9
                        ARP_TAB_MAC4    = ARP_TABLE + ARP_TABLE_SIZE * 10
                        ARP_TAB_MAC5    = ARP_TABLE + ARP_TABLE_SIZE * 11
                        
                        .endif
