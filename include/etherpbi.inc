    ;
    ; EtherPBI Hardware Description
    ;

    ;; Memory map:
    ;; D100-D1FF (256 bytes): I/O area
    ;;    D100-D13F: W5300 access area, 64 bytes
    ;;    D140-D17F: Program memory bank 1 select. 1K window, 64 banks.
    ;;    D180-D18F: W5300 uses 1K (10 bit) address space, mapped in 16 64-byte (6-bit) pieces.
    ;;        Read/write D180 to select bank 0, D181 to select bank 1 etc.
    ;;    D190-D1BF: unused (mirrors of 80-8F)
    ;;    D1C0-D1FE: RAM bank select.  256 byte window, up to 63 banks (16Kbytes total)
    ;;    D1FF: PBI select/interrupt register
    ;; RAM: 8kB SRAM
    ;;    D600-D6FF (256 bytes): Fixed RAM bank (phys bank $1F)
    ;;    D700-D7FF (256 bytes): Selectable RAM bank (banks $00-$1E)
    ;; FLASH memory: CAT28F512 or equivalent
    ;;    D800-DBFF (1024 bytes): PBP Program memory bank 0 (fixed)
    ;;    DC00-DFFF (1024 bytes): PBP Program memory bank 1 (selectable)

    ; W5300 register access area
    W5300_BASE      = $D100
    
    ; Program bank 1 select
    PROG_BANK       = $D140

    CIO_BANK        = PROG_BANK + 0
    CIO_TCP_BANK    = CIO_BANK + 0
    CIO_UDP_BANK    = CIO_BANK + 1
    CIO_RAWIP_BANK  = CIO_BANK + 2
    CIO_RS232_BANK  = CIO_BANK + 3
    CIO_CIOTCP_BANK = CIO_BANK + 4

    SIO_BANK        = PROG_BANK + 8
    SIO_SIOUDP_BANK = SIO_BANK + 0
    SIO_SIOMAP_BANK = SIO_BANK + 1

    ; W5300 bank select - 16 bytes
    W5300_BANK      = $D180

    ; FLASH program area
    FLASH_PGM       = $D1C0

    ; RAM bank select
    RAM_BANK        = $D1E0

    ; PBI Control/Interrupt
    PBI_REG         = $D1FF

    RAM_LO          = $D500
    RAM_HI          = $D600

    ROM_LO          = $D800
    ROM_HI          = $DC00
    
