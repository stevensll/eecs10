;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                     SQRT                                   ;
;                          Square Root Table Examples                        ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains functions for computing the square root of an integer
; argument.  Each function uses a different method for computing the square
; root.  The functions included are:
;    SqrtTable1 - compute the square root with table lookup
;    SqrtTable2 - compute the square root with table lookup
;
; Revision History:
;     2/23/05  Glen George              initial revision
;     5/25/22  Glen George              converted to AVR assembly



; local include files
;     none




        .cseg




; SqrtTable1
;
; Description:       This function returns the integer square root of the
;                    8-bit unsigned integer passed to the function.  The
;                    returned value is rounded to the nearest integer.
;
; Operation:         The passed integer is looked up in a table containing the
;                    square root of every integer (a 256 entry table).
;
; Arguments:         R16 - unsigned value for which to compute the square
;                          root.
; Return Value:      R0 - integer square root of the passed argument.
;
; Local Variables:   None.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        Table lookup.
; Data Structures:   A table of square roots.
;
; Registers Changed: flags, R0, Z (ZH | ZL)
; Stack Depth:       0 words.
;
; Author:            Glen George
; Last Modified:     May 25, 2022

SqrtTable1:

        LDI     ZL, LOW(2 * SquareRoots1)   ;get the start of the table
        LDI     ZH, HIGH(2 * SquareRoots1)
        EOR     R0, R0                      ;zero R0 for carry propagation
        ADD     ZL, R16                     ;add in the table offset
        ADC     ZH, R0

        LPM     R0, Z                       ;and get the square root


EndSqrtTable1:                              ;have the square root - return
        RET




; SquareRoots1
;
; Description:      This table contains the square roots of every integer from
;                   0 to 255.
;
; Author:           Glen George
; Last Modified:    May 25, 2022


SquareRoots1:

        .DB      0,  1,  1,  2,  2,  2,  2,  3,  3,  3,  3,  3,  3,  4,  4,  4
        .DB      4,  4,  4,  4,  4,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  6
        .DB      6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  7,  7,  7,  7,  7
        .DB      7,  7,  7,  7,  7,  7,  7,  7,  7,  8,  8,  8,  8,  8,  8,  8
        .DB      8,  8,  8,  8,  8,  8,  8,  8,  8,  9,  9,  9,  9,  9,  9,  9
        .DB      9,  9,  9,  9,  9,  9,  9,  9,  9,  9,  9, 10, 10, 10, 10, 10
        .DB     10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
        .DB     11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11
        .DB     11, 11, 11, 11, 11, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12
        .DB     12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 13, 13, 13
        .DB     13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13
        .DB     13, 13, 13, 13, 13, 13, 13, 14, 14, 14, 14, 14, 14, 14, 14, 14
        .DB     14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14
        .DB     14, 14, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
        .DB     15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
        .DB     15, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16




; SqrtTable2
;
; Description:       This function returns the integer square root of the
;                    8-bit unsigned integer passed to the function.  The
;                    returned value is rounded to the nearest integer.
;
; Operation:         The passed integer is looked up in a table whose entries
;                    are the values whose rounded integer square root matches
;                    the index.  The table is searched for the passed value
;                    and the index gives the square root.
;
; Arguments:         R16 - unsigned value for which to compute the square
;                          root.
; Return Value:      R0 - integer square root of the passed argument.
;
; Local Variables:   None.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        Table lookup.
; Data Structures:   A table of square roots.
;
; Registers Changed: flags, R0, R16, Z (ZH | ZL)
; Stack Depth:       0 words.
;
; Author:            Glen George
; Last Modified:     May 25, 2022

SqrtTable2:


SqrtTable2Init:                         ;get ready for the table lookup
        LDI     ZL, LOW(2 * SquareRoots2)   ;get the start of the table
        LDI     ZH, HIGH(2 * SquareRoots2)

SqrtLookupLoop:                         ;loop, looking for the passed value
        LPM     R0, Z+                  ;get next square root value from table
        CP      R0, R16                 ;compare passed value with table
        BRLO    SqrtLookupLoop          ;keep trying if haven't reached passed
        ;BRSH   FoundSqrt               ;   value yet, otherwise found it
                                        ;have to exit loop because last entry
                                        ;   is the max value for R16
FoundSqrt:                              ;found the square root, it's the table offset
        LDI     R16, LOW(2 * SquareRoots2) + 1   ;get start of table to find offset
        MOV     R0, R16                          ;   +1 because of post-inc in LPM
        SUB     R0, ZL                  ;compute the -offset (works even if
        NEG     R0                      ;   cross pages), so negate
        ;RJMP   EndSqrtTable2           ;and all done


EndSqrtTable2:                          ;have the square root - return
        RET




; SquareRoots2
;
; Description:      This table contains the integers at which the value of the
;                   rounded integer square root changes.  For example, the
;                   square root of 6 is 3 and the square root of 7 is 4, so 6
;                   is in the table.  The table needs to end with the maximum
;                   loopup value (255 in this case).  Note that there also
;                   must be an even number of bytes in any ROM table so the
;                   last entry is duplicated to make the number of bytes even.
;
; Author:           Glen George
; Last Modified:    May 25, 2022


SquareRoots2:

        .DB       0,   2,   6,  12,  20,  30,  42,  56
        .DB      72,  90, 110, 132, 156, 182, 210, 240, 255, 255
