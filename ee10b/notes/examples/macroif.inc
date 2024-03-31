;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                 macroif.inc                                ;
;                          Macros with Ifs Examples                          ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains generally useful macros for the AVR that include
; conditional assembly.  The macros included are:
;    FIXED_STRTAB_ENTRY - generate a fixed string table entry
;    SHR                - shift register right by n
;    TABLE_ENTRY        - generate a table entry
;
;
; Revision History
;     5/27/22  Glen George         initial revision




; local include files
;   none




; SHR
;
; Description:       This macro generates code to shift the specified register
;                    right by the specified amount.  It is a logical shift
;                    right so zeros are shifted into the high bits.  The macro
;                    optimizes the generated code by using LSL, ROR, SWAP, and
;                    ANDI instructions to generate the most efficient code.
;
; Operation:         The appropriate number of shift, rotate, and swap
;                    operations are done to shift the register by the desired
;                    amount.
;
; Arguments:         reg (@0) - register to shift right (must be R16 - R31).
;                    n (@1)   - number of bits to shift right by.
;
; Registers Changed: flags
; Stack Depth:       0 words
;
; Author:            Glen George
; Last Modified:     May 27, 2022

.MACRO  SHR

    .IF (@1 >= 8)
                CLR     @0              ;shifting right by 8+ - result is 0
    .ELSE
        .IF (@1 == 7)
                ROL     @0              ;faster to rotate lefts
                ROL     @0
                ANDI    @0, 0b00000001  ;but need to clear high bits too
        .ENDIF
        .IF ((@1 >= 4) && (@1 < 7))
                SWAP    @0              ;swap to shift right by 4
                ANDI    @0, 0b00001111  ;but need to clear high bits too
        .ENDIF
        .IF ((@1 >= 1) && (@1 < 4)) 
                LSR     @0              ;shifting right at least once, do shift
        .ENDIF
        .IF (((@1 >= 2) && (@1 < 4)) || ((@1 >= 5) && (@1 < 7)))
                LSR     @0              ;shifting right at least twice, do another shift
        .ENDIF
        .IF ((@1 == 3) || (@1 == 6))
                LSR     @0              ;shifting right at least 3 times, do another shift
        .ENDIF
    .ENDIF
.ENDM




; TABLE_ENTRY
;
; Description:       This macro generates an entry for the menu system table.
;
; Operation:         The arguments are made into a table entry using .DB and
;                    .DW pseudo-ops.  It also checks that the string is eight
;                    bytes long.
;
; Arguments:         addr (@0)      - address of menu action routine.
;                    arg (@1)       - 16-bit arugment for action routine.
;                    next_menu (@2) - next table to use.
;                    string (@3)    - string to display.
;
; Registers Changed: none
; Stack Depth:       0 words
;
; Author:            Glen George
; Last Modified:     May 27, 2022

.MACRO  TABLE_ENTRY

        .DW     @0, @1, @2
        .DB     @3

        .IF (STRLEN(@3) != 8)
            .WARNING  "String must be 8 bytes long"
        .ENDIF
.ENDM




; FIXED_STRTAB_ENTRY
;
; Description:       This macro generates an entry for the table of fixed
;                    length strings.  It automatically sets and checks the
;                    string length.
;
; Operation:         The arguments is made a table entry using the .DB
;                    pseudo-op.  If it is the first string the length is set
;                    to the length of this string.  Otherwise the string is
;                    checked to be sure it is the same length as previous
;                    strings.  The string is padded with <NULL> if it is an
;                    odd length (since code tables entries must be an even
;                    number of bytes.
;
; Arguments:         string (@3) - string for this table entry.
;                    
;
; Registers Changed: none
; Stack Depth:       0 words
;
; Author:            Glen George
; Last Modified:     May 27, 2022

.MACRO  FIXED_STRTAB_ENTRY

    .IF (ENTRY_LEN == 0)                ;if first entry, set the length
        .SET ENTRY_LEN = STRLEN(@0)
    .ENDIF

    .IF (ENTRY_LEN == STRLEN(@0))       ;now check the length
        .IF ((STRLEN(@0) % 2) != 0)     ;have a valid length, check if odd
            .DB     @0, 0               ;odd length, pad with 0 (<null>)
        .ELSE
            .DB     @0                  ;even length, no padding
        .ENDIF
    .ELSE                               ;must be an invalid length
        .WARNING  "Fixed length string does not match previous string lengths."
    .ENDIF

.ENDM
