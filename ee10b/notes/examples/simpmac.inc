;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                 simpmac.inc                                ;
;                            Simple Macro Examples                           ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains generally useful macros for the AVR.  The macros included
; are:
;    CRITICAL_END   - end of critical code section
;    CRITICAL_START - start of critical code section
;    DISABLEIRQ     - disable interrupts
;    ENABLEIRQ      - enable interrupts
;    JF             - jump if register value is false
;    JT             - jump if register value is true
;    LDI16          - load a 16-bit immediate into an address register
;    MULBY2         - multiply argument by 2
;    SCBW           - convert a signed byte to a signed word
;    UCBW           - convert an unsigned byte to an unsigned word
;
;
; Revision History
;     5/27/22  Glen George         initial revision




; local include files
;   none




; ENABLEIRQ
;
; Description:       This macro generates code to enable interrupts.
;
; Operation:         The interrupt flag is set.
;
; Arguments:         None.
;
; Registers Changed: IF
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     May 26, 2022

.MACRO  ENABLEIRQ
        SEI                     ;set the interrupt flag, enabling interrupts
.ENDMACRO




; DISABLEIRQ
;
; Description:       This macro generates code to disable interrupts.
;
; Operation:         The interrupt flag is cleared.
;
; Arguments:         None.
;
; Registers Changed: IF
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     May 26, 2022

.MACRO  DISABLEIRQ
        CLI                     ;clear interrupt flag, disabling interrupts
.ENDM




; SCBW
;
; Description:       This macro generates code to convert the signed byte
;                    value in second register argument to a signed word value
;                    in the specified register pair.
;
; Operation:         The first register (high byte) is filled with the sign
;                    bit of the second register (low byte).
;
; Arguments:         regH (@0) - high byte of the resulting unsigned word.
;                    regL (@1) - low byte of the resulting unsigned word and
;                                byte value to convert to a word.
;
; Registers Changed: flags, regH
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     May 26, 2022

.MACRO  SCBW
        MOV     @0, @1          ;get copy of low byte
        LSL     @0              ;shift high bit into carry
        SBC     @0, @0          ;fill high byte with carry bit
.ENDM




; UCBW
;
; Description:       This macro generates code to convert the unsigned byte
;                    value in second register to an unsigned word value in
;                    register pair in the arguments.
;
; Operation:         The first register is cleared since there is no sign to
;                    extend into it and it is the high byte.
;
; Arguments:         regH (@0) - high byte of the resulting unsigned word.
;                    regL (@1) - low byte of the resulting unsigned word and
;                                byte value to convert to a word.
;
; Registers Changed: flags, regH
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     May 26, 2022

.MACRO  UCBW
        CLR     @0      ;clear the upper byte, there is no sign to extend
.ENDM




; MULBY2
;
; Description:       This macro generates code to multiply its argument by 2.
;
; Operation:         The argument is shifted left by 1.
;
; Arguments:         reg (@0) - register to multiply by 2.
;
; Registers Changed: flags
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     May 26, 2022

.MACRO  MULBY2
        LSL     @0              ;shift left to multiply by 2
.ENDM




; JF
;
; Description:       This macro jumps to the specified address if the given
;                    register is false (zero).
;
; Operation:         The register is TESTed for zero and the passed label is
;                    jumped to if it is.
;
; Arguments:         reg (@0)  - register to test for true/false.
;                    dest (@1) - destination to jump to if reg is false.
;
; Registers Changed: flags
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     May 26, 2022

.MACRO  JF
        TST     @0              ;test the register for zero/non-zero
        BREQ    @1              ;jump to destination if false (zero)
.ENDM




; JT
;
; Description:       This macro jumps to the specified address if the given
;                    register is true (non-zero).
;
; Operation:         The register is TESTed for non-zero and the passed label
;                    is jumped to if it is.
;
; Arguments:         reg (@0)  - register to test for true/false.
;                    dest (@1) - destination to jump to if reg is true.
;
; Registers Changed: flags
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     May 26, 2022

.MACRO  JT
        TST     @0              ;test the register for zero/non-zero
        BRNE    @1              ;jump to destination if true (non-zero)
.ENDM




; CRITICAL_START
;
; Description:       This macro generates the necessary code to begin a
;                    critical section of code.  Critical code must disable
;                    interrupts, so this macro saves the current interrupt
;                    status and then turns off interrupts.  This macro MUST
;                    be paired with the CRITICAL_END macro using the same
;                    register.
;
; Operation:         The flags are saved in the specificed register and
;                    interrupts are disabled.
;
; Arguments:         reg (@0) - register in which to save the flags.
;
; Registers Changed: IF, reg
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     May 26, 2022

.MACRO  CRITICAL_START
        IN      @0, SREG        ;save flags
        CLI                     ;disable the interrupts
.ENDMACRO




; CRITICAL_END
;
; Description:       This macro generates the necessary code to end a critical
;                    section of code.  Critical code must disable interrupts
;                    while it is executing, so this macro restores the
;                    previously saved interrupt status, possibly reenabling
;                    the interrupts.  This macro MUST be paired with the
;                    CRITICAL_START macro using the same register.
;
; Operation:         The flags previously saved in the specified register are
;                    restored.
;
; Arguments:         reg (@0) - register from which to restore the flags.
;
; Registers Changed: flags
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     May 26, 2022

.MACRO  CRITICAL_END
        OUT     SREG, @0        ;restore flags (interrupt flag in particular)
.ENDMACRO




; LDI16
;
; Description:       This macro generates code to load a 16-bit address
;                    register with a 16-bit immediate value.  The address
;                    register argument must be X, Y, or Z.
;
; Operation:         The low and high bytes of the address register are loaded
;                    individually.
;
; Arguments:         reg16 (@0) - 16-bit address register to be loaded (must
;                                 be X, Y, or Z).
;                    value (@1) - 16-bit value to load into the specified
;                                 address register.
;
; Registers Changed: none
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     May 26, 2022

.MACRO  LDI16
        LDI     @0H, HIGH(@1)
        LDI     @0L, LOW(@1)
.ENDM
