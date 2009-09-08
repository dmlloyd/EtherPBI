                        .ifndef UIP_INC
                        .define UIP_INC
                        
                        .global UIP_GET_HOST_IP
                        .global UIP_SET_HOST_IP

                        .global UIP_GET_DEFAULT_GW
                        .global UIP_SET_DEFAULT_GW

                        .global UIP_GET_NETMASK
                        .global UIP_SET_NETMASK
                        
                        .global UIP_INIT
                        
                        .global UIP_SET_IP_ID

                        .global UIP_INPUT
                        .global UIP_PERIODIC

                        .global UIP_POLL_CONN
                        
                        .global UIP_UDP_PERIODIC
                        .global UIP_UDP_PERIODIC_CONN

                        .global HW_SEND

                        .global UIP_LISTEN
                        .global UIP_UNLISTEN
                        .global UIP_CONNECT
                        .global UIP_SEND
                        .global UIP_CLOSE
                        .global UIP_ABORT
                        .global UIP_STOP

                        .global UIP_RESTART
                        
                        ;; UIP structures
                        ;;
                        ;; UIP_CONNECTION
                        .global UIP_CONN_REMOTE_ID
                        .global UIP_CONN_LOCAL_PORT
                        .global UIP_CONN_REMOTE_PORT
                        .global UIP_CONN_RCV_NEXT_SEQ



                        .endif
