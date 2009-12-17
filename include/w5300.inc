
    ;;
    ;; W5300 definitions
    ;;
    ;; Include etherpbi.inc *first*
    ;;

    ; Bank 0: Init, common regs
    W5300_BANK_COMMON   = W5300_BANK + $0

    ; Mode Register
    W5300_REG_MR0       = W5300_BASE + $00
    W5300_REG_MR1       = W5300_BASE + $01

    ; Interrupt Register
    W5300_REG_IR0       = W5300_BASE + $02
    W5300_REG_IR1       = W5300_BASE + $03

    ; Interrupt Mask Register
    W5300_REG_IMR0      = W5300_BASE + $04
    W5300_REG_IMR1      = W5300_BASE + $05
    
    ; Source Hardware Address Register
    W5300_REG_SHAR      = W5300_BASE + $08
    W5300_REG_SHAR0     = W5300_REG_SHAR + 0
    W5300_REG_SHAR1     = W5300_REG_SHAR + 1
    W5300_REG_SHAR2     = W5300_REG_SHAR + 2
    W5300_REG_SHAR3     = W5300_REG_SHAR + 3
    W5300_REG_SHAR4     = W5300_REG_SHAR + 4
    W5300_REG_SHAR5     = W5300_REG_SHAR + 5

    ; Gateway Address Register
    W5300_REG_GAR       = W5300_BASE + $10
    W5300_REG_GAR0      = W5300_REG_GAR + 0
    W5300_REG_GAR1      = W5300_REG_GAR + 1
    W5300_REG_GAR2      = W5300_REG_GAR + 2
    W5300_REG_GAR3      = W5300_REG_GAR + 3

    ; Subnet Mask Register
    W5300_REG_SUBR      = W5300_BASE + $14
    W5300_REG_SUBR0     = W5300_REG_SUBR + 0
    W5300_REG_SUBR1     = W5300_REG_SUBR + 1
    W5300_REG_SUBR2     = W5300_REG_SUBR + 2
    W5300_REG_SUBR3     = W5300_REG_SUBR + 3

    ; Source IP Address Register
    W5300_REG_SIPR      = W5300_BASE + $18
    W5300_REG_SIPR0     = W5300_REG_SIPR + 0
    W5300_REG_SIPR1     = W5300_REG_SIPR + 1
    W5300_REG_SIPR2     = W5300_REG_SIPR + 2
    W5300_REG_SIPR3     = W5300_REG_SIPR + 3

    ; Retransmission Timeout Register
    W5300_REG_RTR       = W5300_BASE + $1C
    W5300_REG_RTR0      = W5300_REG_RTR + 0
    W5300_REG_RTR1      = W5300_REG_RTR + 1

    ; Retransmission Retry-count Register
    W5300_REG_RCR       = W5300_BASE + $1F
    
    ; Transmit memory size register, socket 0-7
    W5300_REG_TMSR      = W5300_BASE + $20
    W5300_REG_TMSR0     = W5300_REG_TMSR + 0
    W5300_REG_TMSR1     = W5300_REG_TMSR + 1
    W5300_REG_TMSR2     = W5300_REG_TMSR + 2
    W5300_REG_TMSR3     = W5300_REG_TMSR + 3
    W5300_REG_TMSR4     = W5300_REG_TMSR + 4
    W5300_REG_TMSR5     = W5300_REG_TMSR + 5
    W5300_REG_TMSR6     = W5300_REG_TMSR + 6
    W5300_REG_TMSR7     = W5300_REG_TMSR + 7

    ; Receive Memory Size Register, socket 0-7
    W5300_REG_RMSR      = W5300_BASE + $28
    W5300_REG_RMSR0     = W5300_REG_RMSR + 0
    W5300_REG_RMSR1     = W5300_REG_RMSR + 1
    W5300_REG_RMSR2     = W5300_REG_RMSR + 2
    W5300_REG_RMSR3     = W5300_REG_RMSR + 3
    W5300_REG_RMSR4     = W5300_REG_RMSR + 4
    W5300_REG_RMSR5     = W5300_REG_RMSR + 5
    W5300_REG_RMSR6     = W5300_REG_RMSR + 6
    W5300_REG_RMSR7     = W5300_REG_RMSR + 7

    ; Memory Block Type Register
    W5300_REG_MTYPER    = W5300_BASE + $30
    W5300_REG_MTYPER0   = W5300_REG_MTYPER + 0
    W5300_REG_MTYPER1   = W5300_REG_MTYPER + 1
    
    ; PPPoE Authentication Register
    W5300_REG_PATR      = W5300_BASE + $32
    W5300_REG_PATR0     = W5300_REG_PATR + 0
    W5300_REG_PATR1     = W5300_REG_PATR + 1

    ; PPP LCP Request Time Register
    W5300_REG_PTIMER    = W5300_BASE + $37
    
    ; PPP LCP Magic Number Register
    W5300_REG_PMAGICR   = W5300_BASE + $39
    
    ; PPP Session ID Register
    W5300_REG_PSIDR     = W5300_BASE + $3C
    W5300_REG_PSIDR0    = W5300_REG_PSIDR + 0
    W5300_REG_PSIDR1    = W5300_REG_PSIDR + 1

    ; START OF BANK 1
    W5300_BANK_PPP      = W5300_BANK + 1

    ; PPP Destination Hardware Address Register
    W5300_REG_PDHAR     = W5300_BASE + $00
    W5300_REG_PDHAR0    = W5300_REG_PDHAR + 0
    W5300_REG_PDHAR1    = W5300_REG_PDHAR + 1
    W5300_REG_PDHAR2    = W5300_REG_PDHAR + 2
    W5300_REG_PDHAR3    = W5300_REG_PDHAR + 3
    W5300_REG_PDHAR4    = W5300_REG_PDHAR + 4
    W5300_REG_PDHAR5    = W5300_REG_PDHAR + 5

    ; Unreachable IP Address Register
    W5300_REG_UIPR      = W5300_BASE + $08
    W5300_REG_UIPR0     = W5300_REG_UIPR + 0
    W5300_REG_UIPR1     = W5300_REG_UIPR + 1
    W5300_REG_UIPR2     = W5300_REG_UIPR + 2
    W5300_REG_UIPR3     = W5300_REG_UIPR + 3

    ; Unreachable Port Number Register
    W5300_REG_UPORTR    = W5300_BASE + $0C
    W5300_REG_UPORTR0   = W5300_REG_UPORTR + 0
    W5300_REG_UPORTR1   = W5300_REG_UPORTR + 1
    
    ; Fragment MTU Register
    W5300_REG_FMTUR     = W5300_BASE + $0E
    W5300_REG_FMTUR0    = W5300_REG_FMTUR + 0
    W5300_REG_FMTUR1    = W5300_REG_FMTUR + 1

    ; BRDY Configure/Depth Registers (n/a)

    ; START OF BANKS 4-12
    W5300_BANK_SOCK     = W5300_BANK + $04

    ; Socket Mode Register
    W5300_REG_SOCK_MR   = W5300_BASE + $00
    W5300_REG_SOCK_MR0  = W5300_REG_SOCK_MR + 0
    W5300_REG_SOCK_MR1  = W5300_REG_SOCK_MR + 1
    
    ; Socket Command Register
    W5300_REG_SOCK_CR   = W5300_BASE + $03

    ; Socket Interrupt Mask Register
    W5300_REG_SOCK_IMR  = W5300_BASE + $05
    
    ; Socket Interrupt Register
    W5300_REG_SOCK_IR   = W5300_BASE + $07
    
    ; Socket Status Register
    W5300_REG_SOCK_SSR  = W5300_BASE + $09
    
    ; Socket Source Port Register
    W5300_REG_SOCK_PORTR    = W5300_BASE + $0A
    W5300_REG_SOCK_PORTR0   = W5300_REG_SOCK_PORTR + 0
    W5300_REG_SOCK_PORTR1   = W5300_REG_SOCK_PORTR + 1
    
    ; Socket Destination Hardware Address Register
    W5300_REG_SOCK_DHAR     = W5300_BASE + $0C
    W5300_REG_SOCK_DHAR0    = W5300_REG_SOCK_DHAR + 0
    W5300_REG_SOCK_DHAR1    = W5300_REG_SOCK_DHAR + 1
    W5300_REG_SOCK_DHAR2    = W5300_REG_SOCK_DHAR + 2
    W5300_REG_SOCK_DHAR3    = W5300_REG_SOCK_DHAR + 3
    W5300_REG_SOCK_DHAR4    = W5300_REG_SOCK_DHAR + 4
    W5300_REG_SOCK_DHAR5    = W5300_REG_SOCK_DHAR + 5
    
    ; Socket Destination Port Register
    W5300_REG_SOCK_DPORTR   = W5300_BASE + $12
    W5300_REG_SOCK_DPORTR0  = W5300_REG_SOCK_DPORTR + 0
    W5300_REG_SOCK_DPORTR1  = W5300_REG_SOCK_DPORTR + 1

    ; Socket Destination IP Register
    W5300_REG_SOCK_DIPR     = W5300_BASE + $14
    W5300_REG_SOCK_DIPR0    = W5300_REG_SOCK_DIPR + 0
    W5300_REG_SOCK_DIPR1    = W5300_REG_SOCK_DIPR + 1
    W5300_REG_SOCK_DIPR2    = W5300_REG_SOCK_DIPR + 2
    W5300_REG_SOCK_DIPR3    = W5300_REG_SOCK_DIPR + 3
    
    ; Socket MSS Register
    W5300_REG_SOCK_MSSR     = W5300_BASE + $18
    W5300_REG_SOCK_MSSR0    = W5300_REG_SOCK_MSSR + 0
    W5300_REG_SOCK_MSSR1    = W5300_REG_SOCK_MSSR + 1
    
    ; Socket Keep-Alive Time Register
    W5300_REG_SOCK_KPALVTR  = W5300_BASE + $1A
    
    ; Socket Protocol Number Register
    W5300_REG_SOCK_PROTOR   = W5300_BASE + $1B

    ; Socket TOS Register
    W5300_REG_SOCK_TOS      = W5300_BASE + $1D
    
    ; Socket TTL Register
    W5300_REG_SOCK_TTL      = W5300_BASE + $1F

    ; Socket Tx Write Size Register
    W5300_REG_SOCK_WRSR     = W5300_BASE + $21
    W5300_REG_SOCK_WRSR0    = W5300_REG_SOCK_WRSR + 0
    W5300_REG_SOCK_WRSR1    = W5300_REG_SOCK_WRSR + 1
    W5300_REG_SOCK_WRSR2    = W5300_REG_SOCK_WRSR + 2

    ; Socket Tx Free Size Register
    W5300_REG_SOCK_FSR      = W5300_BASE + $25
    W5300_REG_SOCK_FSR0     = W5300_REG_SOCK_FSR + 0
    W5300_REG_SOCK_FSR1     = W5300_REG_SOCK_FSR + 1
    W5300_REG_SOCK_FSR2     = W5300_REG_SOCK_FSR + 2

    ; Socket Rx Read Size Register
    W5300_REG_SOCK_RSR      = W5300_BASE + $29
    W5300_REG_SOCK_RSR0     = W5300_REG_SOCK_RSR + 0
    W5300_REG_SOCK_RSR1     = W5300_REG_SOCK_RSR + 1
    W5300_REG_SOCK_RSR2     = W5300_REG_SOCK_RSR + 2

    ; Socket Fragment Register
    W5300_REG_SOCK_FRAGR    = W5300_BASE + $2D
    
    ; Socket Tx FIFO Register
    W5300_REG_SOCK_TX_FIFOR = W5300_BASE + $2E
    W5300_REG_SOCK_TX_FIFOR0= W5300_REG_SOCK_TX_FIFOR + 0
    W5300_REG_SOCK_TX_FIFOR1= W5300_REG_SOCK_TX_FIFOR + 1
    
    ; Socket Rx FIFO Register
    W5300_REG_SOCK_RX_FIFOR = W5300_BASE + $2E
    W5300_REG_SOCK_RX_FIFOR0= W5300_REG_SOCK_RX_FIFOR + 0
    W5300_REG_SOCK_RX_FIFOR1= W5300_REG_SOCK_RX_FIFOR + 1

