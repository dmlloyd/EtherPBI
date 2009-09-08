                        .ifndef ETHER_INC
                        .define ETHER_INC
                        
                        ;; Memory map:
                        ;; D100-D1FF (256 bytes): I/O area
                        ;; D600-D7FF (512 bytes): PBP GP Area
                        ;; D800-DBFF (1024 bytes): PBP Program memory bank 0
                        ;; DC00-DFFF (1024 bytes): PBP Program memory bank 1
                        
                        ETH_BASE        = $D100
                        ;; Current Rx Packet Address (Big-Endian!)
                        ETH_CPADDRH     = ETH_BASE + $21
                        ETH_CPADDRL     = ETH_BASE + $22
                        ;; Current Rx Packet Info Address (Big-Endian!)
                        ETH_CPINFOH     = ETH_BASE + $1D
                        ETH_CPINFOL     = ETH_BASE + $1E
                        ;; Current Rx Packet Length (Big-Endian!)
                        ETH_CPLENH      = ETH_BASE + $1F
                        ETH_CPLENL      = ETH_BASE + $20
                        ;; Current Rx Packet TLB number
                        ETH_TLB         = ETH_BASE + $1A
                        ;; Flash address pointer (Little-Endian!)
                        ETH_FLASHADDRH  = ETH_BASE + $69
                        ETH_FLASHADDRL  = ETH_BASE + $68
                        ;; Flash auto-read with increment
                        ETH_FLASHAUTORD = ETH_BASE + $05
                        ;; Flash regular I/O
                        ETH_FLASHDATA   = ETH_BASE + $06
                        ;; Flash erase (!)
                        ETH_FLASHERASE  = ETH_BASE + $6A
                        ;; Flash lock & key
                        ETH_FLASHKEY    = ETH_BASE + $67
                        ;; Flash status
                        ETH_FLASHSTA    = ETH_BASE + $7B
                        ;; Interrupt status 0 (self-clearing)
                        ETH_INT0        = ETH_BASE + $63
                        ;; Interrupt enable register 0
                        ETH_INT0EN      = ETH_BASE + $64
                        ;; Interrupt status 0 (read-only, non-clearing)
                        ETH_INT0RD      = ETH_BASE + $76
                        ;; Interrupt status 1 (self-clearing)
                        ETH_INT1        = ETH_BASE + $7F
                        ;; Interrupt enable register 1
                        ETH_INT1EN      = ETH_BASE + $7D
                        ;; Interrupt status 1 (read-only, non-clearing)
                        ETH_INT1RD      = ETH_BASE + $7E
                        ;; Port I/O power
                        ETH_IOPWR       = ETH_BASE + $70
                        ;; MAC address poinrter
                        ETH_MACADDR     = ETH_BASE + $0A
                        ;; MAC data register (Big-Endian!)
                        ETH_MACDATAH    = ETH_BASE + $0B
                        ETH_MACDATAL    = ETH_BASE + $0C
                        ;; MAC R/W initiate
                        ETH_MACRW       = ETH_BASE + $0D
                        ;; Oscillator power
                        ETH_OSCPWR      = ETH_BASE + $7C
                        ;; Physical layer configuration
                        ETH_PHYCF       = ETH_BASE + $79
                        ;; Physical layer control
                        ETH_PHYCN       = ETH_BASE + $78
                        ;; Physical layer status
                        ETH_PHYSTA      = ETH_BASE + $80
                        ;; RAM address pointer (Big-Endian!)
                        ETH_RAMADDRH    = ETH_BASE + $08
                        ETH_RAMADDRL    = ETH_BASE + $09
                        ;; Rx FIFO RAM data register
                        ETH_RAMRXDATA   = ETH_BASE + $02
                        ;; Tx Buffer RAM data register
                        ETH_RAMTXDATA   = ETH_BASE + $04
                        ;; Reset enable register
                        ETH_RSTEN       = ETH_BASE + $72
                        ;; Reset source status register
                        ETH_RSTSTA      = ETH_BASE + $73
                        ;; Rx FIFO auto-read with increment
                        ETH_RXAUTOREAD  = ETH_BASE + $01
                        ;; Receive control
                        ETH_RXCN        = ETH_BASE + $11
                        ;; Receive buffer head pointer (Big-Endian!)
                        ETH_RXFIFOHEADH = ETH_BASE + $17
                        ETH_RXFIFOHEADL = ETH_BASE + $18
                        ;; Receive buffer status
                        ETH_RXFIFOSTA   = ETH_BASE + $5B
                        ;; Receive buffer tail pointer (Big-Endian!)
                        ETH_RXFIFOTAILH = ETH_BASE + $15
                        ETH_RXFIFOTAILL = ETH_BASE + $16
                        ;; Receive filter configuration
                        ETH_RXFILT      = ETH_BASE + $10
                        ;; Receive hash table (Big-endian!)
                        ETH_RXHASHH     = ETH_BASE + $0E
                        ETH_RXHASHL     = ETH_BASE + $0F
                        ;; Receive status
                        ETH_RXSTA       = ETH_BASE + $12
                        ;; Software reset
                        ETH_SWRST       = ETH_BASE + $75
                        ;; Each TLB entry is 6 bytes.
                        ETH_TLB_SIZE    = 6
                        ;; There are 8 TLB entries.
                        ETH_TLB_COUNT   = 8
                        ;; TLB0 information (Big-endian!)
                        ETH_TLB0INFOH   = ETH_BASE + $23
                        ETH_TLB0INFOL   = ETH_BASE + $24
                        ;; TLB0 length (Big endian!)
                        ETH_TLB0LENH    = ETH_BASE + $25
                        ETH_TLB0LENL    = ETH_BASE + $26
                        ;; TLB0 address (Big-endian!)
                        ETH_TLB0ADDRH   = ETH_BASE + $27
                        ETH_TLB0ADDRL   = ETH_BASE + $28
                        ;; Repeat 6 more times.
                        ;; TLB Valid indicators
                        ETH_TLBVALID    = ETH_BASE + $1C
                        ;; Transmit data autowrite
                        ETH_TXAUTOWR    = ETH_BASE + $03
                        ;; Transmit busy indicator
                        ETH_TXBUSY      = ETH_BASE + $54
                        ;; Transmit control
                        ETH_TXCN        = ETH_BASE + $53
                        ;; Transmit data ending address (Big-endian!)
                        ETH_TXENDH      = ETH_BASE + $57
                        ETH_TXENDL      = ETH_BASE + $58
                        ;; Transmit pause (Big-endian!)
                        ETH_TXPAUSEH    = ETH_BASE + $55
                        ETH_TXPAUSEL    = ETH_BASE + $56
                        ;; Transmitter power
                        ETH_TXPWR       = ETH_BASE + $7A
                        ;; Transmit status vector 0-6
                        ETH_TXSTA0      = ETH_BASE + $62
                        ETH_TXSTA1      = ETH_BASE + $61
                        ETH_TXSTA2      = ETH_BASE + $60
                        ETH_TXSTA3      = ETH_BASE + $5F
                        ETH_TXSTA4      = ETH_BASE + $5E
                        ETH_TXSTA5      = ETH_BASE + $5D
                        ETH_TXSTA6      = ETH_BASE + $5C
                        ;; Transmit data start address (Big-endian!)
                        ETH_TXSTARTH    = ETH_BASE + $59
                        ETH_TXSTARTL    = ETH_BASE + $5A
                        ;; VDD Monitor control register
                        ETH_VDMCN       = ETH_BASE + $13
                 
                        .endif
