;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                  CLKTIMER                                  ;
;                               Timing Routines                              ;
;                   Microprocessor-Based Clock (AVR version)                 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions for handling timing for the clock.  The
; included public functions are:
;    HaveNewMinute - determines if a minute has elapsed
;    HaveNewSecond - determines if a second has elapsed
;    InitTiming    - initialize timing variables
;    ResetSeconds  - reset the second counter
;    TimingHandler - timer event handler
;
; The included local functions are:
;    none
;
; Revision History:
;    12/09/12  Glen George      initial revision
;     9/21/13  Glen George      updated comments
;     4/20/18  Glen George      updated for new hardware design
;     5/02/18  Glen George      changed name from timing.asm to clktimer.asm
;     8/26/18  Glen George      add colon blinking to TimingHandler



; local include files
;.include  "clkgen.inc"




.cseg




; InitTiming
;
; Description:       This function initializes the timing functions.  The
;                    counters and flags are reset.
;
; Operation:         The function that resets the timer counters and flags is
;                    called.
;
; Arguments:         None.
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
; Registers Changed: R16
; Stack Depth:       2 bytes
;
; Author:            Glen George
; Last Modified:     July 25, 2012

InitTiming:


        RCALL   ResetSeconds            ;reset the counters


        RET                             ;all there is to do so return




; ResetSeconds
;
; Description:       This function resets the counters for timing seconds and
;                    minutes.  It also clears the update flags for these
;                    timers and resets the colon blink counter.
;
; Operation:         The time keeping counters are initialized and the time
;                    keeping flags are set to FALSE.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  colonBlinkCntr - written (set to COLON_RATE).
;                    cntToNextMin   - written (set to MINUTE_CNT).
;                    cntToNextSec   - written (set to SECOND_CNT).
;                    fracToNextSec  - written (set to SEC_CNT_DENOM).
;                    newMinute      - written (set to FALSE).
;                    newSecond      - written (set to FALSE).
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
; Registers Changed: R16
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     December 9, 2012

ResetSeconds:


        LDI     R16, LOW(SECOND_CNT)    ;initialize the seconds counter
        STS     cntToNextSec, R16
        LDI     R16, HIGH(SECOND_CNT)
        STS     cntToNextSec + 1, R16

        LDI     R16, LOW(SEC_CNT_DENOM) ;initialize the fractional seconds counter
        STS     fracToNextSec, R16
        LDI     R16, HIGH(SEC_CNT_DENOM)
        STS     fracToNextSec + 1, R16

        LDI     R16, FALSE              ;clear new second flag
        STS     newSecond, R16

        LDI     R16, MINUTE_CNT         ;initialize the minutes counter
        STS     cntToNextMin, R16

        LDI     R16, FALSE              ;clear new minute flag
        STS     newMinute, R16

	LDI	R16, LOW(COLON_RATE)	;reset the colon blink counter
	STS	colonBlinkCntr, R16
	LDI	R16, HIGH(COLON_RATE)
	STS	colonBlinkCntr + 1, R16


        RET                             ;done so return




; TimingHandler
;
; Description:       This procedure is the handler for the timing system.  It
;                    updates the timing information.
;
; Operation:         The second and minute counters are updated.  If a counter
;                    decrements to 0 the associated flag is set, indicating a
;                    second or minute has elapsed.  To maintain accuracy every
;                    second the fractional second counter is decreased by the
;                    numerator until it goes negative.  When this happens it
;                    means an additional count is needed for the next second.
;                    Also, the fractional second counter has the denominator
;                    added back to it.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  cntToNextSec  - read and written (updated and checked for
;                                    zero).
;                    fracToNextSec - read and written (updated and checked for
;                                    negative values).
;                    newSecond     - read and written (set to TRUE if
;                                    cntToNextSec reaches zero).
;                    cntToNextMin  - read and written (updated and checked for
;                                    zero).
;                    newMinute     - read and written (set to TRUE if
;                                    cntToNextMin reaches zero).
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
; Registers Changed: flags, R16, Z (ZH | ZL)
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     April 20, 2018

TimingHandler:


UpdateTheTime:                          ;start by updating the time
        LDS     ZL, cntToNextSec        ;update the second counter
        LDS     ZH, cntToNextSec + 1
        SBIW    Z, 1                    ;decrement the counter
        STS     cntToNextSec, ZL        ;write it back to memory
        STS     cntToNextSec + 1, ZH
        BRNE    EndUpdateTime           ;if not zero - done updating
        ;BREQ   HaveSecond              ;otherwise another second has elapsed

HaveSecond:                             ;a second has elapsed
        LDI     R16, TRUE               ;set the new second flag
        STS     newSecond, R16

        LDS     ZL, fracToNextSec       ;update the fractional second counter
        LDS     ZH, fracToNextSec + 1
        SUBI    ZL, LOW(SEC_CNT_NUM)    ;decrement the fraction by the numerator
        SBCI    ZH, HIGH(SEC_CNT_NUM)
        BRCC    NoFracCarry             ;if no carry, do normal update
        ;BRCS   HaveFracCarry           ;otherwise handle the fractional second

HaveFracCarry:                            ;have a fractional carry, handle it
        SUBI    ZL, LOW(-SEC_CNT_DENOM)   ;need to add denominator back in for
        SBCI    ZH, HIGH(-SEC_CNT_DENOM)  ;   next fractional countdown
        LDI     R16, LOW(SECOND_CNT + 1)  ;reinitialize the seconds counter
        STS     cntToNextSec, R16         ;   but we have an extra count this time
        LDI     R16, HIGH(SECOND_CNT + 1) ;   due to the fractional second
        STS     cntToNextSec + 1, R16
        RJMP    DoneCheckSeconds          ;and done checking the seconds

NoFracCarry:                            ;no fractional carry, just load normal count
        LDI     R16, LOW(SECOND_CNT)    ;reinitialize the seconds counter
        STS     cntToNextSec, R16
        LDI     R16, HIGH(SECOND_CNT)
        STS     cntToNextSec + 1, R16
        ;RJMP   DoneCheckSeconds        ;and done checking the seconds

DoneCheckSeconds:                       ;done checking the seconds
        STS     fracToNextSec, ZL       ;write new value for the fractional part back
        STS     fracToNextSec + 1, ZH   ;   to memory
        ;RJMP   UpdateMinute            ;now see if a minute has elapsed

UpdateMinute:                           ;update the time to the next minute
        LDS     R16, cntToNextMin       ;update the minute counter
        DEC     R16                     ;decrement the counter
        STS     cntToNextMin, R16       ;write it back to memory
        BRNE    EndUpdateTime           ;if not zero - done updating
        ;BREQ   HaveMinute              ;otherwise another minute has elapsed

HaveMinute:                             ;a minute has elapsed
        LDI     R16, MINUTE_CNT         ;reset the minutes counter
        STS     cntToNextMin, R16

        LDI     R16, TRUE               ;set new minute flag
        STS     newMinute, R16
        ;RJMP   EndUpdateTime           ;done updating time


EndUpdateTime:                          ;done updating time, take care of colon
        LDS     ZL, colonBlinkCntr      ;update the colon blink counter
        LDS     ZH, colonBlinkCntr + 1
        SBIW    Z, 1                    ;decrement the counter
        BRNE    EndColonBlink           ;if not zero - done updating colon
        ;BREQ   BlinkColon              ;otherwise time to blink the colon

BlinkColon:				;blink the colon
	RCALL	DisplayColonToggle	;toggle the colon
	LDI	ZL, LOW(COLON_RATE)	;and reset the counter
	LDI	ZH, HIGH(COLON_RATE)
	;RJMP	EndColonBlink		;and done with handling colon blink

EndColonBlink:				;done handling blinking the colon
        STS     colonBlinkCntr, ZL      ;write the new value back to memory
        STS     colonBlinkCntr + 1, ZH
        ;RJMP   EndTimingHandler        ;and done handling the timing system


EndTimingHandler:                       ;done taking care of timing
        RET                             ;return




; HaveNewSecond
;
; Description:       This procedure returns whether or not a second has
;                    elapsed since the last time it was called (newSecond flag
;                    is set).  newSecond is always reset by this function.
;
; Operation:         The newSecond flag is checked and then reset to FALSE.
;                    Interrupts are disabled during this procedure (critical
;                    code).
;
; Arguments:         None.
; Return Value:      Zero Flag - reset if a second has elapsed since the last
;                                call to this function.
;
; Local Variables:   None.
; Shared Variables:  newSecond - read and written (set to FALSE).
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
; Registers Changed: flags, R0, R16, R17
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     July 25, 2012

HaveNewSecond:


        IN      R0, SREG                ;save interrupt flag status
        CLI                             ;can't interrupt this code

        LDS     R16, newSecond          ;get the current flag setting
        LDI     R17, FALSE              ;always reset the flag
        STS     newSecond, R17

        OUT     SREG, R0                ;restore flags (possibly re-enabling interrupts)

        CPI     R16, TRUE               ;now set the zero flag appropriately


        RET                             ;done so return




; HaveNewMinute
;
; Description:       This procedure returns whether or not a minute has
;                    elapsed since the last time it was called (newMinute flag
;                    is set).  newMinute is always reset by this function.
;
; Operation:         The newMinute flag is checked and then reset to FALSE.
;                    Interrupts are disabled during this procedure (critical
;                    code).
;
; Arguments:         None.
; Return Value:      Zero Flag - reset if a minute has elapsed since the last
;                                call to this function.
;
; Local Variables:   None.
; Shared Variables:  newMinute - read and written (set the FALSE).
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
; Registers Changed: flags, R0, R16, R17
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     July 25, 2012

HaveNewMinute:


        IN      R0, SREG                ;save interrupt flag status
        CLI                             ;can't interrupt this code

        LDS     R16, newMinute          ;get the current flag status
        LDI     R17, FALSE              ;always reset the flag
        STS     newMinute, R17

        OUT     SREG, R0                ;restore flags (possibly re-enabling interrupts)

        CPI     R16, TRUE               ;now set the zero flag appropriately


        RET                             ;done so return




;the data segment


.dseg


cntToNextSec:   .BYTE   2               ;counter for timing seconds
fracToNextSec:  .BYTE   2               ;fractional part of counter for timing seconds
newSecond:      .BYTE   1               ;flag indicating a second has passed

cntToNextMin:   .BYTE   1               ;counter for timing minutes
newMinute:      .BYTE   1               ;flag indicating a minute has passed

colonBlinkCntr:	.BYTE	2		;counter for timing colon blinking
