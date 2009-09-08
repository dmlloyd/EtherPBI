
                        .ifndef NETEQU_INC
                        .define NETEQU_INC
                        
                        ; Both high bytes are $08, so generally I'll just check for that directly
                        ETHERTYPE_ARP   =   $0806
                        ETHERTYPE_IP    =   $0800
                        
                        IP_HEADER_LEN   =   20
                        UDP_HEADER_LEN  =   8
                        TCP_HEADER_LEN  =   20
                        
                        IP_PROTO_ICMP   =   $01
                        IP_PROTO_TCP    =   $06
                        IP_PROTO_UDP    =   $11
                        
                        .endif
