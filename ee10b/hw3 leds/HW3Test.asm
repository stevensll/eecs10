;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   HW3TEST                                  ;
;                            Homework #3 Test Code                           ;
;                                  EE/CS 10b                                 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the test code for Homework #3.  The function makes a
; number of calls to the display functions to test them.  The functions
; included are:
;    DisplayTest - test the homework display functions
;
; Revision History:
;    4/29/19  Glen George               initial revision
;    5/18/23  Glen George               updated for Hexer
;   06/15/23  Steven Lei                retrieved from website


;set the device
.device ATMEGA64

;get the definitions for the device
.include  "m64def.inc"

; local include files
.include "HexerDisplay.inc"
.include "HexerHW.inc"





.cseg

; setup the vector area
.org	$0000

	JMP	Start		;reset vector
	JMP	PC			;external interrupt 0
	JMP	PC			;external interrupt 1
	JMP	PC			;external interrupt 2
	JMP	PC			;external interrupt 3
	JMP	PC			;external interrupt 4
	JMP	PC			;external interrupt 5
	JMP	PC			;external interrupt 6
	JMP	PC			;external interrupt 7
	JMP	PC			;timer 2 compare match
	JMP	PC			;timer 2 overflow
	JMP	PC			;timer 1 capture
	JMP	PC			;timer 1 compare match A
	JMP	PC			;timer 1 compare match B
	JMP	PC			;timer 1 overflow
	JMP	Timer0CompareHandler          ;timer 0 compare match
	JMP	PC		    ;timer 0 overflow
	JMP	PC			;SPI transfer complete
	JMP	PC			;UART 0 Rx complete
	JMP	PC			;UART 0 Tx empty
	JMP	PC			;UART 0 Tx complete
	JMP	PC			;ADC conversion complete
	JMP	PC			;EEPROM ready
	JMP	PC			;analog comparator
	JMP	PC			;timer 1 compare match C
	JMP	PC			;timer 3 capture
	JMP	PC     		;timer 3 compare match A
	JMP	PC			;timer 3 compare match B
	JMP	PC			;timer 3 compare match C
	JMP	PC			;timer 3 overflow
	JMP	PC			;UART 1 Rx complete
	JMP	PC			;UART 1 Tx empty
	JMP	PC			;UART 1 Tx complete
	JMP	PC			;Two-wire serial interface
	JMP	PC			;store program memory ready

; start of the actual program

Start:							;start the CPU after a reset
	LDI	R16, LOW(TopOfStack)		;initialize the stack pointer
	OUT	SPL, R16
	LDI	R16, HIGH(TopOfStack)
	OUT	SPH, R16

	RCALL	InitPorts				;initialize I/O ports 
	RCALL 	InitTimer0				;initialize timer0
	RCALL	InitDisplay             ;initialize display variables

	SEI								;ready to go, allow interrupts

    RCALL   DisplayTest      		;do the display tests
	RJMP	Start					;shouldn't return, but if it does, restart



; DisplayTest
;
; Description:       This procedure tests the display functions.  It first
;                    loops displaying patterns on the game LEDs using the
;                    DisplayGameLEDs function.  FOllowing this it loops
;                    sending values to the DisplayHex function.  To validate
;                    the code the display must be checked for the appropriate
;                    patterns being displayed.  The function never returns,
;                    when the aforementioned patterns have finished, it
;                    repeats them.
;
; Operation:         The arguments to call each function with are stored in
;                    tables.  The function loops through the tables making the
;                    appropriate display code calls.  Delays are done after
;                    most calls so the display can be examined.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   R20         - test counter.
;                    Z (ZH | ZL) - test table pointer.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16, R17, R18, R19, R20, R21, Y (YH | YL),
;                    Z (ZH | ZL)
; Stack Depth:       unknown (at least 4 bytes)
;
; Author:            Glen George
; Last Modified:     May 18, 2023

DisplayTest:

        RCALL   ClearDisplay            ;first clear the display
        LDI     R16, 100                ;and delay a bit
        RCALL   Delay16


TestGameLEDs:                           ;do the DisplayGameLEDs tests
        LDI     ZL, LOW(2 * TestGTab)   ;start at the beginning of the
        LDI     ZH, HIGH(2 * TestGTab)  ;   DisplayGameLEDs test table

TestGameLEDsLoop:

        LPM     R16, Z+                 ;get the DisplayGameLEDs arguments
        LPM     R17, Z+                 ;   from the table

        PUSH    ZL                      ;save registers around function call
        PUSH    ZH
        RCALL   DisplayGameLEDs         ;call the function
        POP     ZH                      ;restore the registers
        POP     ZL

        LPM     R16, Z                  ;get the time delay from the table
        RCALL   Delay16                 ;and do the delay
        LPM     R16, Z+                 ;do twice the delay
        RCALL   Delay16

        ADIW    Z, 1                    ;skip the padding byte

        LDI     R20, HIGH(2 * EndTestGTab)      ;setup for end check
        CPI     ZL, LOW(2 * EndTestGTab)        ;check if at end of table
        CPC     ZH, R20
        BRNE    TestGameLEDsLoop        ;and keep looping if not done
        ;BREQ   TestDisplayHex          ;otherwise test DisplayHex function


TestDisplayHex:                         ;do the DisplayHex tests
        LDI     ZL, LOW(2 * TestHexTab) ;start at the beginning of the
        LDI     ZH, HIGH(2 * TestHexTab);   DisplayHex test table

TestDisplayHexLoop:

        LPM     R16, Z+                 ;get DisplayHex argument from the table
        LPM     R17, Z+

        PUSH    ZL                      ;save registers around DisplayHex call
        PUSH    ZH
        RCALL   DisplayHex              ;call the function
        POP     ZH
        POP     ZL

        LPM     R16, Z                  ;get the time delay from the table
        RCALL   Delay16                 ;and do the delay
        LPM     R16, Z+                 ;do twice the delay
        RCALL   Delay16

        ADIW    Z, 1                    ;skip the padding byte

        LDI     R20, HIGH(2 * EndTestHexTab)    ;setup for end check
        CPI     ZL, LOW(2 * EndTestHexTab)      ;check if at end of table
        CPC     ZH, R20
        BRNE    TestDisplayHexLoop      ;and keep looping if not done
        ;BREQ   DoneDisplayTests        ;otherwise done with display tests


DoneDisplayTests:                       ;have done all the tests
        RJMP    DisplayTest             ;start over and loop forever


        RET                             ;should never get here




; Delay16
;
; Description:       This procedure delays the number of clocks passed in R16
;                    times 80000.  Thus with a 8 MHz clock the passed delay is
;                    in 10 millisecond units.
;
; Operation:         The function just loops decrementing Y until it is 0.
;
; Arguments:         R16 - 1/80000 the number of CPU clocks to delay.
; Return Value:      None.
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
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16, Y (YH | YL)
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     May 6, 2018

Delay16:

Delay16Loop:                            ;outer loop runs R16 times
        LDI     YL, LOW(20000)          ;inner loop is 4 clocks
        LDI     YH, HIGH(20000)         ;so loop 20000 times to get 80000 clocks
Delay16InnerLoop:                       ;do the delay
        SBIW    Y, 1
        BRNE    Delay16InnerLoop

        DEC     R16                     ;count outer loop iterations
        BRNE    Delay16Loop


DoneDelay16:                            ;done with the delay loop - return
        RET




; Test Tables


; TestGTab
;
; Description:      This table contains the values of the arguments for
;                   testing the DisplayGameLEDs function.  Each entry consists
;                   of the two byte argument, the time delay to leave the
;                   pattern displayed, and a padding byte (to keep it word
;                   aligned).
;
; Author:           Glen George
; Last Modified:    May 18, 2023

TestGTab:
               ;Argument (low /high)    Delay (10 ms)   Padding
        .DB     0b11111111, 0b11111111, 100,            0       ;all on
        .DB     0b00000000, 0b00000000, 100,            0       ;all off
        .DB     0b01100101, 0b00000011, 100,            0
        .DB     0b01100000, 0b00000001,  20,            0
        .DB     0b00000101, 0b00000010,  20,            0
        .DB     0b01100000, 0b00000001,  20,            0
        .DB     0b00000101, 0b00000010,  20,            0
        .DB     0b11001110, 0b11000110, 100,            0
        .DB     0b10000110, 0b11000000,  20,            0
        .DB     0b01001000, 0b00000110,  20,            0
        .DB     0b10000110, 0b11000000,  20,            0
        .DB     0b01001000, 0b00000110,  20,            0
        .DB     0b10000110, 0b10000110, 100,            0
        .DB     0b00000100, 0b10000010,  20,            0
        .DB     0b10000010, 0b00000100,  20,            0
        .DB     0b00000100, 0b10000010,  20,            0
        .DB     0b10000010, 0b00000100,  20,            0
        .DB     0b10010110, 0b10100111, 100,            0
        .DB     0b00010010, 0b10000110,  20,            0
        .DB     0b10000100, 0b00100001,  20,            0
        .DB     0b00010010, 0b10000110,  20,            0
        .DB     0b10000100, 0b00100001,  20,            0
        .DB     0b10101000, 0b00101100, 100,            0
        .DB     0b10000000, 0b00001100,  20,            0
        .DB     0b00101000, 0b00100000,  20,            0
        .DB     0b10000000, 0b00001100,  20,            0
        .DB     0b00101000, 0b00100000,  20,            0
        .DB     0b00000000, 0b00000000,  50,            0
        .DB     0b00000000, 0b01000000,  20,            0
        .DB     0b00000000, 0b00000001,  20,            0
        .DB     0b00000000, 0b00000010,  20,            0
        .DB     0b00000000, 0b00000100,  20,            0
        .DB     0b00000000, 0b00100000,  20,            0
        .DB     0b00000001, 0b00000000,  20,            0
        .DB     0b00000010, 0b00000000,  20,            0
        .DB     0b00100000, 0b00000000,  20,            0
        .DB     0b00000000, 0b10000000,  20,            0
        .DB     0b00000000, 0b00001000,  20,            0
        .DB     0b01000000, 0b00000000,  20,            0
        .DB     0b00000100, 0b00000000,  20,            0
        .DB     0b10000000, 0b00000000,  20,            0
        .DB     0b00001000, 0b00000000,  20,            0
        .DB     0b00010000, 0b00000000,  20,            0
        .DB     0b00000000, 0b00000000,  10,            0

EndTestGTab:




; TestHexTab
;
; Description:      This table contains the argument values for testing the
;                   DisplayHex function.  Each entry consists of the value to
;                   display, and the time delay to leave the pattern
;                   displayed.  Since this accessed as a 8-bit value, the high
;                   byte of the delay must be skipped in the code.
;
; Author:           Glen George
; Last Modified:    April 29, 2019

TestHexTab:
               ;Argument    Delay (10 ms)
        .DW     0x8888,     150                 ;all segments on
        .DW     0x0000,     150
        .DW     0x1234,     150
        .DW     0x5678,     150
        .DW     0x9ABC,     150
        .DW     0xDEF0,     150
        .DW     0xFFFF,     150
        .DW     0x7734,     150
        .DW     0xDEAD,     150
        .DW     0xBEEF,     150

EndTestHexTab:

; data segment

.dseg
; the stack - 128 bytes
            .BYTE   127
TopOfStack: .BYTE   1       ;top of stack

; since don't have a linker, include all the .asm files
.include "Display.asm"
.include "HexerIRQ.asm"
.include "HexerInit.asm"
.include "Segtable.asm"
