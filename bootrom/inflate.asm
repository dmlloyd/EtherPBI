                        .segment "BOOT_ROM"

                        .include "ether.inc"
                        .include "inflate.inc"
.proc INFLATE
                        ;
                        ; 6502 inflate routine.  Original author: Piotr Fusik <fox@scene.pl>
                        ; Modified to pull from flash instead of a memory image, and other
                        ; minor changes.
                        ;
                        ; In:   t2:t1 is the write address.
                        ;       ETH_FLASHAUTORD is the data source.
                        ; Out:  Decompressed data.
                        ;

                        ; Equates.
                        inflate_zp                          = $80
                        outputPointer                       = inflate_zp
                        getBit_buffer                       = inflate_zp+2
                        getBits_base                        = inflate_zp+3
                        inflateStoredBlock_pageCounter      = inflate_zp+3
                        inflateCodes_sourcePointer          = inflate_zp+4
                        inflateDynamicBlock_lengthIndex     = inflate_zp+4
                        inflateDynamicBlock_lastLength      = inflate_zp+5
                        inflateDynamicBlock_tempCodes       = inflate_zp+5
                        inflateCodes_lengthMinus2           = inflate_zp+6
                        inflateDynamicBlock_allCodes        = inflate_zp+6
                        inflateCodes_primaryCodes           = inflate_zp+7

                        ; Argument values for GET_BITS
                        GET_1_BIT       = $81
                        GET_2_BITS      = $82
                        GET_3_BITS      = $84
                        GET_4_BITS      = $88
                        GET_5_BITS      = $90
                        GET_6_BITS      = $a0
                        GET_7_BITS      = $c0

                        ; Maximum length of a Huffman code
                        MAX_CODE_LENGTH = 15
                        
                        ; Huffman trees
                        TREE_SIZE       = MAX_CODE_LENGTH+1
                        PRIMARY_TREE    = 0
                        DISTANCE_TREE   = TREE_SIZE
                        
                        ; Alphabet
                        LENGTH_SYMBOLS      = 1+29+2
                        DISTANCE_SYMBOLS    = 30
                        CONTROL_SYMBOLS     = LENGTH_SYMBOLS+DISTANCE_SYMBOLS
                        TOTAL_SYMBOLS       = 256+CONTROL_SYMBOLS

                        ; Start
                        ldy #0
                        sty getBit_buffer
inflate_blockLoop:
                        ; Get a bit of EOF and two bits of block type
                        ;ldy #0
                        sty getBits_base
                        lda #GET_3_BITS
                        jsr getBits
                        lsr
                        php
                        tax
                        bne inflateCompressedBlock

                        ; Copy uncompressed block
                        ; ldy #0
                        sty getBit_buffer
                        jsr getWord
                        jsr getWord
                        sta inflateStoredBlock_pageCounter
                        ;jmp inflateStoredBlock_firstByte
                        bcs inflateStoredBlock_firstByte
inflateStoredBlock_copyByte:
                        jsr getByte
inflateStoreByte:
                        jsr storeByte
                        bcc inflateCodes_loop
inflateStoredBlock_firstByte:
                        inx
                        bne inflateStoredBlock_copyByte
                        inc inflateStoredBlock_pageCounter
                        bne inflateStoredBlock_copyByte

inflate_nextBlock:
                        plp
                        bcc inflate_blockLoop
                        rts

inflateCompressedBlock:
                        ; Decompress a block with fixed Huffman trees:
                        ; :144 dta 8
                        ; :112 dta 9
                        ; :24  dta 7
                        ; :6   dta 8
                        ; :2   dta 8 ; codes with no meaning
                        ; :30  dta 5+DISTANCE_TREE
inflateFixedBlock_setCodeLengths:
                        ;ldy #0
                        lda #4
                        cpy #144
                        rol
                        sta literalSymbolCodeLength,y
                        cpy #CONTROL_SYMBOLS
                        bcs inflateFixedBlock_noControlSymbol
                        lda #5+DISTANCE_TREE
                        cpy #LENGTH_SYMBOLS
                        bcs inflateFixedBlock_setControlCodeLength
                        cpy #24
                        adc #2-DISTANCE_TREE

inflateFixedBlock_setControlCodeLength:
                        sta controlSymbolCodeLength,y
inflateFixedBlock_noControlSymbol:
                        iny
                        bne inflateFixedBlock_setCodeLengths
                        lda #LENGTH_SYMBOLS
                        sta inflateCodes_primaryCodes
                        dex
                        beq inflateCodes
                        ; Decompress a block reading Huffman trees first

                        ; Build the tree for temporary codes
                        jsr buildTempHuffmanTree

                        ; Use temporary codes to get lengths of literal/length and distance codes
                        ldx #0
                        ;sec
inflateDynamicBlock_decodeLength:
                        php
                        stx inflateDynamicBlock_lengthIndex
                        ; Fetch a temporary code
                        jsr fetchPrimaryCode
                        ; Temporary code 0..15: put this length
                        tax
                        bpl inflateDynamicBlock_verbatimLength
                        ; Temporary code 16: repeat last length 3 + getBits(2) times
                        ; Temporary code 17: put zero length 3 + getBits(3) times
                        ; Temporary code 18: put zero length 11 + getBits(7) times
                        jsr getBits
                        ; sec
                        adc #1
                        cpx #GET_7_BITS
                        bcc @s1
                        adc #7
@s1:                    tay
                        lda #0
                        cpx #GET_3_BITS
                        bcs @s2
                        lda inflateDynamicBlock_lastLength
@s2:
inflateDynamicBlock_verbatimLength:
                        iny
                        ldx inflateDynamicBlock_lengthIndex
                        plp
inflateDynamicBlock_storeLength:
                        bcc inflateDynamicBlock_controlSymbolCodeLength
                        sta literalSymbolCodeLength,x
                        inx
                        cpx #1
inflateDynamicBlock_storeNext:
                        dey
                        bne inflateDynamicBlock_storeLength
                        sta inflateDynamicBlock_lastLength
                        ;jmp inflateDynamicBlock_decodeLength
                        beq inflateDynamicBlock_decodeLength
inflateDynamicBlock_controlSymbolCodeLength:
                        cpx inflateCodes_primaryCodes
                        bcc @s1
                        ora #DISTANCE_TREE
@s1:                    sta controlSymbolCodeLength,x
                        inx
                        cpx inflateDynamicBlock_allCodes
                        bcc inflateDynamicBlock_storeNext
                        dey
                        ;ldy #0
                        ;jmp inflateCodes

                        ; Decompress a block
inflateCodes:
                        jsr buildHuffmanTree
inflateCodes_loop:
                        jsr fetchPrimaryCode
                        bcc inflateStoreByte
                        tax
                        beq inflate_nextBlock
                        ; Copy sequence from look-behind buffer
                        ; ldy #0
                        sty getBits_base
                        cmp #9
                        bcc inflateCodes_setSequenceLength
                        tya
                        ; lda #0
                        cpx #1+28
                        bcs inflateCodes_setSequenceLength
                        dex
                        txa
                        lsr
                        ror getBits_base
                        inc getBits_base
                        lsr
                        rol getBits_base
                        jsr getAMinus1BitsMax8
                        ; sec
                        adc #0
inflateCodes_setSequenceLength:
                        sta inflateCodes_lengthMinus2
                        ldx #DISTANCE_TREE
                        jsr fetchCode
                        ; sec
                        sbc inflateCodes_primaryCodes
                        tax
                        cmp #4
                        bcc inflateCodes_setOffsetLowByte
                        inc getBits_base
                        lsr
                        jsr getAMinus1BitsMax8
inflateCodes_setOffsetLowByte:
                        eor #$ff
                        sta inflateCodes_sourcePointer
                        lda getBits_base
                        cpx #10
                        bcc inflateCodes_setOffsetHighByte
                        lda getNPlus1Bits_mask-10,x
                        jsr getBits
                        clc
inflateCodes_setOffsetHighByte:
                        eor #$ff
                        ; clc
                        adc outputPointer+1
                        sta inflateCodes_sourcePointer+1
                        jsr copyByte
                        jsr copyByte
inflateCodes_copyByte:
                        jsr copyByte
                        dec inflateCodes_lengthMinus2
                        bne inflateCodes_copyByte
                        ; jmp inflateCodes_loop
                        beq inflateCodes_loop

buildTempHuffmanTree:
                        ; ldy #0
                        tya
inflateDynamicBlock_clearCodeLengths:
                        sta literalSymbolCodeLength,y
                        sta literalSymbolCodeLength+TOTAL_SYMBOLS-256,y
                        iny
                        bne inflateDynamicBlock_clearCodeLengths
                        ; numberOfPrimaryCodes = 257 + getBits(5)
                        ; numberOfDistanceCodes = 1 + getBits(5)
                        ; numberOfTemporaryCodes = 4 + getBits(4)
                        ldx #3
inflateDynamicBlock_getHeader:
                        lda inflateDynamicBlock_headerBits-1,x
                        jsr getBits
                        ; sec
                        adc inflateDynamicBlock_headerBase-1,x
                        sta inflateDynamicBlock_tempCodes-1,x
                        sta inflateDynamicBlock_headerBase+1
                        dex
                        bne inflateDynamicBlock_getHeader

                        ; Get lengths of temporary codes in the order stored in tempCodeLengthOrder
inflateDynamicBlock_getTempCodeLengths:
                        ; ldx #0
                        lda #GET_3_BITS
                        jsr getBits
                        ldy tempCodeLengthOrder,x
                        sta literalSymbolCodeLength,y
                        ldy #0
                        inx
                        cpx inflateDynamicBlock_tempCodes
                        bcc inflateDynamicBlock_getTempCodeLengths

                        ; Build Huffman trees basing on code lengths (in bits)
                        ; stored in the *SymbolCodeLength arrays
buildHuffmanTree:
                        ; Clear nBitCode_totalCount, nBitCode_literalCount, nBitCode_controlCount
                        tya
                        ; lda #0
@s1:                    sta nBitCode_clearFrom,y
                        iny
                        bne @s1
                        ; Count number of codes of each length
                        ; ldy #0
buildHuffmanTree_countCodeLengths:
                        ldx literalSymbolCodeLength,y
                        inc nBitCode_literalCount,x
                        inc nBitCode_totalCount,x
                        cpy #CONTROL_SYMBOLS
                        bcs buildHuffmanTree_noControlSymbol
                        ldx controlSymbolCodeLength,y
                        inc nBitCode_controlCount,x
                        inc nBitCode_totalCount,x
buildHuffmanTree_noControlSymbol:
                        iny
                        bne buildHuffmanTree_countCodeLengths
                        ; Calculate offsets of symbols sorted by code length
                        ; lda #0
                        ldx #-3*TREE_SIZE
buildHuffmanTree_calculateOffsets:
                        sta nBitCode_literalOffset+3*TREE_SIZE-$100,x
                        clc
                        adc nBitCode_literalCount+3*TREE_SIZE-$100,x
                        inx
                        bne buildHuffmanTree_calculateOffsets
                        ; Put symbols in their place in the sorted array
                        ; ldy #0
buildHuffmanTree_assignCode:
                        tya
                        ldx literalSymbolCodeLength,y
                        ldy nBitCode_literalOffset,x
                        inc nBitCode_literalOffset,x
                        sta codeToLiteralSymbol,y
                        tay
                        cpy #CONTROL_SYMBOLS
                        bcs buildHuffmanTree_noControlSymbol2
                        ldx controlSymbolCodeLength,y
                        ldy nBitCode_controlOffset,x
                        inc nBitCode_controlOffset,x
                        sta codeToControlSymbol,y
                        tay
buildHuffmanTree_noControlSymbol2:
                        iny
                        bne buildHuffmanTree_assignCode
                        rts

                        ; Read Huffman code using the primary tree
fetchPrimaryCode:
                        ldx #PRIMARY_TREE
                        ; Read a code from input basing on the tree specified in X,
                        ; return low byte of this code in A,
                        ; return C flag reset for literal code, set for length code
fetchCode:
                        ; ldy #0
                        tya
fetchCode_nextBit:
                        jsr getBit
                        rol
                        inx
                        sec
                        sbc nBitCode_totalCount,x
                        bcs fetchCode_nextBit
                        ; clc
                        adc nBitCode_controlCount,x
                        bcs fetchCode_control
                        ; clc
                        adc nBitCode_literalOffset,x
                        tax
                        lda codeToLiteralSymbol,x
                        clc
                        rts
fetchCode_control:
                        clc
                        adc nBitCode_controlOffset-1,x
                        tax
                        lda codeToControlSymbol,x
                        sec
                        rts

                        ; Read A minus 1 bits, but no more than 8
getAMinus1BitsMax8:
                        rol getBits_base
                        tax
                        cmp #9
                        bcs getByte
                        lda getNPlus1Bits_mask-2,x
getBits:
                        jsr getBits_loop
getBits_normalizeLoop:
                        lsr getBits_base
                        ror
                        bcc getBits_normalizeLoop
                        rts

                        ; Read 16 bits
getWord:
                        jsr getByte
                        tax
                        ; Read 8 bits
getByte:
                        lda #$80
getBits_loop:
                        jsr getBit
                        ror
                        bcc getBits_loop
                        rts

                        ; Read one bit, return in the C flag
getBit:
                        lsr getBit_buffer
                        bne getBit_return
                        pha
                        lda ETH_FLASHAUTORD
                        sec
                        ror
                        sta getBit_buffer
                        pla
getBit_return:
                        rts

                        ; Copy a previously written byte
copyByte:
                        ldy outputPointer
                        lda (inflateCodes_sourcePointer),y
                        ldy #0
                        ; Write a byte
storeByte:
                        sta (outputPointer),y
                        inc outputPointer
                        bne storeByte_return
                        inc outputPointer+1
                        inc inflateCodes_sourcePointer+1
storeByte_return:
                        rts

getNPlus1Bits_mask:
                        .byte GET_1_BIT,GET_2_BITS,GET_3_BITS,GET_4_BITS,GET_5_BITS,GET_6_BITS,GET_7_BITS

tempCodeLengthOrder:
                        .byte GET_2_BITS,GET_3_BITS,GET_7_BITS,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15

inflateDynamicBlock_headerBits:
                        .byte GET_4_BITS,GET_5_BITS,GET_5_BITS
inflateDynamicBlock_headerBase:
                        .byte 3,0,0  ; second byte is modified at runtime! XXX move to RW segment!

                        .segment "INFLATE_DATA"
                        
inflate_data:

; Data for building trees

literalSymbolCodeLength:    .res 256
controlSymbolCodeLength:    .res CONTROL_SYMBOLS

; Huffman trees

nBitCode_clearFrom:
nBitCode_totalCount:        .res 2*TREE_SIZE
nBitCode_literalCount:      .res TREE_SIZE
nBitCode_controlCount:      .res 2*TREE_SIZE
nBitCode_literalOffset:     .res TREE_SIZE
nBitCode_controlOffset:     .res 2*TREE_SIZE
codeToLiteralSymbol:        .res 256
codeToControlSymbol:        .res CONTROL_SYMBOLS

.endproc
