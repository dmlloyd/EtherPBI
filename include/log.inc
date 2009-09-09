                        .ifndef LOG_INC
                        .define LOG_INC
                        
                        ; Log message types
                        LOG_END                 = $0
                        LOG_INITIALIZED         = $1
                        LOG_PHY_UP              = $2
                        LOG_PHY_DOWN            = $3
                        LOG_MAC_UP              = $4
                        LOG_MAC_DOWN            = $5
                        LOG_IP_UP               = $6
                        LOG_IP_DOWN             = $7
                        
                        
                        .endif ; LOG_INC
