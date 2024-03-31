;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                    macdemo                                 ;
;                            Macro Demonstration Code                        ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains macro calls to demonstrate macro expansion.
;
;
; Revision History
;     5/27/22  Glen George       initial revision



; local include files
.include  "simpmac.inc"
.include  "macroif.inc"



        .cseg



        ;look at interrupt enable and disable macros

        ENABLEIRQ
        DISABLEIRQ


        ;try MULBY2 macro

        MULBY2  R0
        MULBY2  R17


        ;check out the conversion macros

        SCBW    R7, R6
        UCBW    R21, R20


        ;check the CRITICAL_START and CRITICAL_END macros

        CRITICAL_START  R5
        NOP
        CRITICAL_END    R5


        ;test the JF/JT macros

        JT      R6, TrueLabel
        JF      R17, FalseLabel
TrueLabel:                      ;just some labels for testing
FalseLabel:


        ;check the LDI16 macro

        LDI16   Y, 0x1234
        LDI16   Z, TrueLabel
        LDI16   X, 3000


        ;test shift right macro

        SHR     R16, 0
        SHR     R16, 1
        SHR     R16, 2
        SHR     R16, 3
        SHR     R16, 4
        SHR     R16, 5
        SHR     R16, 6
        SHR     R16, 7
        SHR     R16, 8
        SHR     R16, 20


        ;test table entry macro
MainMenu:
        TABLE_ENTRY     MoveForward, 0, MainMenu, "FowArd  "
        TABLE_ENTRY     MoveReverse, 0, MainMenu, "rEvErSE "
        TABLE_ENTRY     MoveReverse, 0, MainMenu, "errors"

        ;labels for testing
MoveForward:
MoveReverse:


        ;test fixed string table

        .SET    ENTRY_LEN = 0
        FIXED_STRTAB_ENTRY      "Len11String"
        FIXED_STRTAB_ENTRY      "abcdefghijk"
        FIXED_STRTAB_ENTRY      "lmnopqrstuvwxy"
