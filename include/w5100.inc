
    ;;
    ;; Register set of the W5100
    ;;
    
    HW_BASE     = $D100
    
    ;; Common registers
    
    W5100_BANK_COMMON   = $00
    
    ;; Mode Register (MR)
    W5100_REG_MR        = HW_BASE + $00
    ;; Default gateway
    W5100_REG_GAR       = HW_BASE + $01
    W5100_REG_GAR0      = W5100_REG_GAR + $00
    W5100_REG_GAR1      = W5100_REG_GAR + $01
    W5100_REG_GAR2      = W5100_REG_GAR + $02
    W5100_REG_GAR3      = W5100_REG_GAR + $03
    ;; Subnet mask
    W5100_REG_SUBR      = HW_BASE + $05
    W5100_REG_SUBR0     = W5100_REG_SUBR + $00
    W5100_REG_SUBR1     = W5100_REG_SUBR + $01
    W5100_REG_SUBR2     = W5100_REG_SUBR + $02
    W5100_REG_SUBR3     = W5100_REG_SUBR + $03
    ;; Source HW (MAC) address
    W5100_REG_SHAR      = HW_BASE + $09
    W5100_REG_SHAR0     = W5100_REG_SHAR + $00
    W5100_REG_SHAR1     = W5100_REG_SHAR + $01
    W5100_REG_SHAR2     = W5100_REG_SHAR + $02
    W5100_REG_SHAR3     = W5100_REG_SHAR + $03
    W5100_REG_SHAR4     = W5100_REG_SHAR + $04
    W5100_REG_SHAR5     = W5100_REG_SHAR + $05
    ;; Source IP address
    W5100_REG_SIPR      = HW_BASE + $0F
    W5100_REG_SIPR0     = W5100_REG_SIPR + $00
    W5100_REG_SIPR1     = W5100_REG_SIPR + $01
    W5100_REG_SIPR2     = W5100_REG_SIPR + $02
    W5100_REG_SIPR3     = W5100_REG_SIPR + $03
    ;; Interrupt register
    W5100_REG_IR        = HW_BASE + $15
    ;; Interrupt mask register
    W5100_REG_IMR       = HW_BASE + $16
    ;; Retry time
    W5100_REG_RTR       = HW_BASE + $17
    W5100_REG_RTR0      = W5100_REG_RTR + $00
    W5100_REG_RTR1      = W5100_REG_RTR + $01
    ;; Retry counter
    W5100_REG_RCR       = HW_BASE + $19
    ;; Rx Memory Size Register
    W5100_REG_RMSR      = HW_BASE + $1A
    ;; Tx Memory Size Register
    W5100_REG_TMSR      = HW_BASE + $1B
    ;; PPPoE Authentication Type
    W5100_REG_PATR      = HW_BASE + $1C
    W5100_REG_PATR0     = W5100_REG_PATR + $00
    W5100_REG_PATR1     = W5100_REG_PATR + $01
    ;; PPP LCP Request Timer
    W5100_REG_PTIMER    = HW_BASE + $28
    ;; PPP LCP Magic Number
    W5100_REG_PMAGIC    = HW_BASE + $29
    ;; Unreachable IP address
    W5100_REG_UIPR      = HW_BASE + $2A
    W5100_REG_UIPR0     = W5100_REG_UIPR + $00
    W5100_REG_UIPR1     = W5100_REG_UIPR + $01
    W5100_REG_UIPR2     = W5100_REG_UIPR + $02
    W5100_REG_UIPR3     = W5100_REG_UIPR + $03
    ;; Unreachable port
    W5100_REG_UPORT     = HW_BASE + $2E
    W5100_REG_UPORT0    = W5100_REG_UPORT + $00
    W5100_REG_UPORT1    = W5100_REG_UPORT + $01

    ;; Socket Registers
    
    ; 4 banks starting with $04
    W5100_BANK_SOCKET       = $04
    ;; Socket mode
    W5100_REG_SOCK_MR       = HW_BASE + $00
    ;; Socket command
    W5100_REG_SOCK_CR       = HW_BASE + $01
    ;; Socket interrupt
    W5100_REG_SOCK_IR       = HW_BASE + $02
    ;; Socket status
    W5100_REG_SOCK_SR       = HW_BASE + $03
    ;; Socket source port
    W5100_REG_SOCK_PORT     = HW_BASE + $04
    W5100_REG_SOCK_PORT0    = W5100_REG_SOCK_PORT + $00
    W5100_REG_SOCK_PORT1    = W5100_REG_SOCK_PORT + $01
    ;; Socket dest. HW (MAC) address
    W5100_REG_SOCK_DHAR     = HW_BASE + $06
    W5100_REG_SOCK_DHAR0    = W5100_REG_SOCK_DHAR + $00
    W5100_REG_SOCK_DHAR1    = W5100_REG_SOCK_DHAR + $01
    W5100_REG_SOCK_DHAR2    = W5100_REG_SOCK_DHAR + $02
    W5100_REG_SOCK_DHAR3    = W5100_REG_SOCK_DHAR + $03
    W5100_REG_SOCK_DHAR4    = W5100_REG_SOCK_DHAR + $04
    W5100_REG_SOCK_DHAR5    = W5100_REG_SOCK_DHAR + $05
    ;; Socket dest IP address
    W5100_REG_SOCK_DIPR     = HW_BASE + $0C
    W5100_REG_SOCK_DIPR0    = W5100_REG_SOCK_DIPR + $00
    W5100_REG_SOCK_DIPR1    = W5100_REG_SOCK_DIPR + $01
    W5100_REG_SOCK_DIPR2    = W5100_REG_SOCK_DIPR + $02
    W5100_REG_SOCK_DIPR3    = W5100_REG_SOCK_DIPR + $03
    ;; Socket dest port
    W5100_REG_SOCK_DPORT    = HW_BASE + $10
    W5100_REG_SOCK_DPORT0   = W5100_REG_SOCK_DPORT + $00
    W5100_REG_SOCK_DPORT1   = W5100_REG_SOCK_DPORT + $01
    ;; Socket MSS
    W5100_REG_SOCK_MSSR     = HW_BASE + $12
    W5100_REG_SOCK_MSSR0    = W5100_REG_SOCK_MSSR + $00
    W5100_REG_SOCK_MSSR1    = W5100_REG_SOCK_MSSR + $01
    ;; Socket Protocol (Raw mode)
    W5100_REG_SOCK_PROTO    = HW_BASE + $14
    ;; Socket IP TOS
    W5100_REG_SOCK_TOS      = HW_BASE + $15
    ;; Socket IP TTL
    W5100_REG_SOCK_TTL      = HW_BASE + $16
    ;; Socket Tx Free Size
    W5100_REG_SOCK_TX_FSR   = HW_BASE + $20
    W5100_REG_SOCK_TX_FSR0  = W5100_REG_SOCK_TX_FSR + $00
    W5100_REG_SOCK_TX_FSR1  = W5100_REG_SOCK_TX_FSR + $01
    ;; Socket Tx Read Pointer
    W5100_REG_SOCK_TX_RD    = HW_BASE + $22
    W5100_REG_SOCK_TX_RD0   = W5100_REG_SOCK_TX_RD + $00
    W5100_REG_SOCK_TX_RD1   = W5100_REG_SOCK_TX_RD + $01
    ;; Socket Tx Write Pointer
    W5100_REG_SOCK_TX_WR    = HW_BASE + $24
    W5100_REG_SOCK_TX_WR0   = W5100_REG_SOCK_TX_WR + $00
    W5100_REG_SOCK_TX_WR1   = W5100_REG_SOCK_TX_WR + $01
    ;; Socket Rx Size
    W5100_REG_SOCK_RX_RSR   = HW_BASE + $26
    W5100_REG_SOCK_RX_RSR0  = W5100_REG_SOCK_RX_RSR + $00
    W5100_REG_SOCK_RX_RSR1  = W5100_REG_SOCK_RX_RSR + $01
    ;; Socket Rx Read Pointer
    W5100_REG_SOCK_RX_RD    = HW_BASE + $28
    W5100_REG_SOCK_RX_RD0   = W5100_REG_SOCK_RX_RD + $00
    W5100_REG_SOCK_RX_RD1   = W5100_REG_SOCK_RX_RD + $01

    ;; Socket commands
    
    W5100_CMD_OPEN          = $01
    W5100_CMD_LISTEN        = $02
    W5100_CMD_CONNECT       = $04
    W5100_CMD_DISCON        = $08
    W5100_CMD_CLOSE         = $10
    W5100_CMD_SEND          = $20
    W5100_CMD_SEND_MAC      = $21
    W5100_CMD_SEND_KEEP     = $22
    W5100_CMD_RECV          = $40

    ;; Socket statuses
    
    W5100_ST_CLOSED         = $00
    W5100_ST_ARP_TCP        = $11   ;; Maybe not TCP ARP?
    W5100_ST_INIT           = $13
    W5100_ST_LISTEN         = $14
    W5100_ST_SYN_SENT       = $15
    W5100_ST_SYN_RECV       = $16
    W5100_ST_ESTABLISHED    = $17
    W5100_ST_FIN_WAIT       = $18
    W5100_ST_CLOSING        = $1A
    W5100_ST_TIME_WAIT      = $1B
    W5100_ST_CLOSE_WAIT     = $1C
    W5100_ST_LAST_ACK       = $1D
    W5100_ST_ARP_UDP        = $21
    W5100_ST_UDP            = $22
    W5100_ST_ARP_ICMP       = $31
    W5100_ST_IPRAW          = $32
    W5100_ST_MACRAW         = $42
    W5100_ST_PPPOE          = $5F
