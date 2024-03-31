;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                    CLKDISP                                 ;
;                               Display Routines                             ;
;                    Microprocessor-Based Clock (AVR version)                ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions for displaying time on the 7-segment
; displays.  The public functions included are:
;    InitDisplay        - initialize the display and its variables
;    DisplayTime        - display the passed time
;    DisplayAlarm       - display the passed alarm status
;    DisplayColonOn     - turn on the colon on the display
;    DisplayColonOff    - turn off the colon on the display
;    DisplayColonToggle - toggle the colon status on the display
;    LEDMux             - multiplex the LED display
;
; The local functions included are:
;    InitLEDMux         - initialize variables for LED multiplexing
;
; Revision History:
;    11/3/93   Glen George              initial revision
;    11/7/94   Glen George              updated comments
;                                       added Revision History section
;                                       simplified code for BlinkColon and
;                                          UpdateAlarm
;    10/30/95  Glen George              removed call to DisplayAlarm in the
;                                          DisplayTime function - it's not
;                                          needed since DisplayTime does not
;                                          affect the Alarm LED bits in
;                                          CurrentSegs
;                                       modified the code slightly in AlarmLED
;                                          for readability
;                                       updated comments
;    10/28/96  Glen George              updated comments (mostly Stack Depth
;                                          entries)
;                                       defined size of CurrentSegs with an
;                                          EQU constant (NO_SEGS)
;     9/14/97  Glen George              updated comments and changed "Local
;                                          Variables" to "Shared Variables"
;    10/11/98  Glen George              added InitDisplay, DisplayColonOn, and
;                                          DisplayColonOff
;                                       removed AlarmLED function
;                                       changed name of BlinkColon function to
;                                          DisplayColonToggle
;                                       changed variable capitalization
;                                       removed AlarmStatus variable, no
;                                          longer needed
;                                       added $INCLUDE of GENERAL.INC to get
;                                          definitions of TRUE and FALSE
;                                       updated comments
;    12/26/99  Glen George              updated comments
;     1/26/00  Glen George              updated comments
;    12/25/00  Glen George              explicitly clear the direction flag to
;                                          to auto-increment (instead of
;                                          assuming it is cleared)
;     2/04/03  Glen George              changed NO_SEGS to NUM_SEGS and
;                                          NO_LED_DIGITS to NUM_LED_DIGITS
;                                       cleaned up some code
;                                       updated comments
;     2/10/03  Glen George              fixed bug in DisplayTime
;    12/24/03  Glen George              fixed colon polarity errors in
;                                          DisplayColonOn and DisplayColonOff
;                                       updated comments
;     7/12/10  Glen George              changed names of include files
;     7/14/10  Glen George              modified code to not use 80188
;                                          instructions - not actually
;                                          necessary since the target for this
;                                          code is an 80188, but it is only
;                                          one instruction (ROR DX, 4) and it
;                                          means all code is 8088 compatible.
;                                       changed DisplayAlarm to use ZF for its
;                                          argument, not AL
;     9/04/10  Glen George              fixed bugs in SegTable, the indicators
;                                          are in the low bit, not the high
;                                          bit and pattern for '1' was wrong
;     9/04/10  Glen George              don't assume that ES points at data
;                                          segment in InitDisplay
;     9/30/10  Glen George              fixed DisplayTime to not trash the
;                                          colon and alarm LEDs
;     9/29/13  Glen George              updated DisplayTime function to match
;                                          the new placement of the AM/PM LED
;                                          in hardware and rewrote the code to
;                                          not affect the indicators (except
;                                          AM/PM)
;                                       updated segment table to not assume
;                                          the PM indicator is in the tens of
;                                          hours digit
;     4/30/18  Glen George              changed to AVR code
;     5/08/18  Glen George              fixed some syntax errors
;     8/25/18  Glen George              fixed bug in DisplayTime



; chip definitions
;.include  "4414def.inc"

; local include files
;.include  "clkgen.inc"
;.include  "clkdisp.inc"




.cseg




; InitDisplay
;
; Description:       This function initializes the display (colon off, digits
;                    blanked, alarm as set) and display multiplexing
;                    variables.
;
; Operation:         This function turns off the colon, blanks the digits, and
;                    sets the alarm LED appropriately.  It also initializes
;                    the display muxing variables.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   R16 - segment counter.
;                    Y   - pointer to display buffer.
; Shared Variables:  currentSegs - buffer is filled with LED_BLANK.
; Global Variables:  None.
;
; Input:             None.
; Output:            The LED display is blanked and the alarm LED is turned
;                    on or off (depending on the alarm setting).
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16, R17, Y (YH | YL)
; Stack Depth:       2 bytes
;
; Author:            Glen George
; Last Modified:     April 29, 2018

InitDisplay:


StartInitDisplay:                       ;start clearing the display
        LDI     R16, NUM_SEGS           ;number of segments to clear
        LDI	YL, LOW(currentSegs)	;point to the segments
        LDI	YH, HIGH(currentSegs)
        LDI     R17, LED_BLANK          ;get the blank segment pattern

InitBuffLoop:				;loop clearing the segments
        ST	Y+, R17			;clear the segments
	DEC	R16			;update loop counter
	BRNE	InitBuffLoop		;and loop until done
        ;BREQ   InitColonAlarm          ;then initialize the colon and alarm


InitColonAlarm:                         ;turn off colon and set alarm
        RCALL   DisplayColonOff

        RCALL   AlarmSet                ;next keep the alarm setting right
        RCALL   DisplayAlarm

        RCALL   InitLEDMux              ;finally, initialize muxing

        ;RJMP   EndInitDisplay          ;all done now


EndInitDisplay:                         ;done initializing the display - return
        RET




; DisplayTime
;
; Description:       This function displays the passed time on the 7-segment
;                    LED displays.  The colon and the alarm LED settings keep
;                    their current values.  The function does no actual
;                    output, it only updates the segment buffer which is then
;                    output periodically by the LEDMux routine.
;
; Operation:         The function gets the digits from the passed time and
;                    converts them to 7-segment patterns and stores them in
;                    the display buffer.  Since the display is multiplexed by
;                    segment, the buffer has to be filled bit-wise (the
;                    segment pattern is written one bit at a time).  The alarm
;                    and colon LEDs are not changed.
;
; Arguments:         R16 - minutes to be displayed in packed BCD.
;                    R17 - hours to be displayed in packed BCD.
; Return Value:      None.
;
; Local Variables:   R18 - digit counter.
;                    R19 - digit mask.
;                    R20 - 0 for propagating carries.
;                    R21 - digit to output in binary.
;                    R22 - segment counter.
;                    R23 - segment pattern from buffer.
;                    Y   - pointer to segment (display) buffer.
;                    Z   - pointer to segment pattern table.
; Shared Variables:  currentSegs - set to segment pattern for passed time.
; Global Variables:  None.
;
; Input:             None.
; Output:            The passed time is output to the LED display (indirectly
;                    via LEDMux).
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R0, R16, R17, R18, R19, R20, R21, R22, R23,
;                    Y (YH | YL), Z (ZH | ZL)
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     August 25, 2018

DisplayTime:


StartDisplayTime:                       ;start displaying the time
        LDI     R18, NUM_LED_DIGITS     ;number of digits to display
        LDI     R19, 0b00000001         ;start with right-most digit
	LDI	R20, 0			;for propagating carries
        ;RJMP   DisplayDigitLoop        ;now display the digits


DisplayDigitLoop:                       ;loop displaying the digits
        MOV     R21, R16                ;get the digit to display
        ANDI    R21, 0b00001111         ;digit is in the low nibble
        LDI     ZL, LOW(2 * SegTable)   ;get start of segment table
        LDI     ZH, HIGH(2 * SegTable)  ;   times 2 to do byte addressing
	ADD	ZL, R21			;get offset in segment table
	ADC	ZH, R20
        LPM                             ;lookup the segment pattern
        ;RJMP   DisplaySegments         ;store the segments


DisplaySegments:                        ;store the segments for this digit
        LDI     R22, NUM_SEGS - 1       ;number of segments to do (don't do indicators)
        LDI     YL, LOW(currentSegs)    ;setup for storing segments
        LDI     YH, HIGH(currentSegs)

DisplaySegmentLoop:                     ;loop storing the individual segments
	LD	R23, Y			;get current pattern for this segment
        SBRC    R0, 0                   ;check low bit of the segment pattern
        RJMP    SegmentOn               ;check if segment on for this digit
        ;RJMP   SegmentOff              ;   or off

SegmentOff:                             ;segment off for this digit
	COM	R19			;invert digit mask to clear bit
	AND	R23, R19		;clear bit in segment pattern
	COM	R19			;restore the digit mask
        RJMP    DisplayNextSegment      ;now go on to the next segment

SegmentOn:                              ;segment on for this character
        OR	R23, R19		;set bit in segment pattern
        ;RJMP   DisplayNextSegment      ;now go on to the next segment

DisplayNextSegment:                     ;go on to the next segment
	ST	Y+, R23			;store new segment pattern
        LSR     R0                      ;shift next segment bit into place
	DEC	R22			;update segment loop counter
	BRNE	DisplaySegmentLoop      ;do all the segments for this digit
        ;RJMP   EndDisplaySegmentLoop   ;done with this digit - go to next


EndDisplaySegmentLoop:                  ;done with segments for this digit
        LSR     R17                     ;move the next digit into place
        ROR     R16			;   each digit is 4 bits
        LSR     R17
        ROR     R16
        LSR     R17
        ROR     R16
        LSR     R17
        ROR     R16

        LSL     R19                     ;also update the bit mask for the digit

	DEC	R18			;update digit count
        BRNE    DisplayDigitLoop        ;loop until do all the digits
        ;RJMP   DisplayAMPM             ;now display the AM/PM indicator


DisplayAMPM:                            ;display the AM/PM indicator
	MOV	R17, R21		;copy the last digit pattern (in low nibble, not high)
        ANDI    R17, (AMPM_MASK >> 4)   ;is this a time with AM/PM (in low nibble of R21)
        BREQ    EndDisplayTime          ;no AM/PM indicator - all done
        ;BRNE   CheckForPM              ;else check if time is PM

CheckForPM:                             ;check if the time is in the PM
        LDS     R23, currentSegs + PM_SEG	;get the AM/PM indicator
        SBRS    R21, PM_TIME_BIT - 4    ;can just check the PM bit (in low nibble of R21)
        RJMP    DisplayAM               ;PM bit isn't set, so it is AM
        ;RJMP   DisplayPM               ;otherwise it is PM

DisplayPM:                              ;it is PM so turn on the PM indicator
        ORI     R23, 1 << PM_DIGIT
        RJMP    EndDisplayTime          ;now done with displaying time

DisplayAM:                              ;it is AM so turn off PM indicator
        ANDI    R23, ~(1 << PM_DIGIT)
        ;RJMP   EndDisplayTime          ;so done with displaying the time


EndDisplayTime:                         ;done displaying the time - return
        STS     currentSegs + PM_SEG, R23	;store the new colon bits
        RET					;and return




; DisplayAlarm
;
; Description:       This function displays the passed alarm status on the
;                    Alarm LED.  A non-zero (TRUE) value turns on the Alarm
;                    LED, a zero (FALSE) value turns it off.  The actual
;                    outputting of the Alarm LED is done by the LEDMux
;                    routine.
;
; Operation:         The ALARM_DIG_BIT in the ALARM_SEG is set or reset based
;                    on the passed value.
;
; Arguments:         ZF - alarm status to which to set the Alarm LED (set to
;                         turn it on, reset to turn it off).
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  currentSegs - ALARM_SEG element has a bit changed.
; Global Variables:  None.
;
; Input:             None.
; Output:            The Alarm LED is turned on or off (indirectly via LEDMux)
;                    as indicated by passed argument.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     April 29, 2018

DisplayAlarm:


	LDS	R16, currentSegs + ALARM_SEG	;get current LED state

AlarmTestStatus:                        ;check if Alarm is on or off
        BRNE    AlarmLEDOff             ;passed status is FALSE - Alarm LED is off
        ;BREQ   AlarmLEDOn              ;else the Alarm LED is on


AlarmLEDOn:                             ;turn on the Alarm LED
        ORI     R16, ALARM_DIG_BIT
        RJMP    EndDisplayAlarm         ;and done

AlarmLEDOff:                            ;turn off the Alarm LED
	ANDI	R16, ~ALARM_DIG_BIT
        ;RJMP   EndDisplayAlarm         ;and done


EndDisplayAlarm: 	                        ;done so return
	STS	currentSegs + ALARM_SEG, R16	;store new state and return
        RET




; DisplayColonOn
;
; Description:       This procedure turns on the colon on the display.
;
; Operation:         The colon bits in the stored segment patterns are set.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  currentSegs - bits in the COLON_SEG element are set.
; Global Variables:  None.
;
; Input:             None.
; Output:            The colon LEDs are turned on (indirectly via LEDMux).
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     April 29, 2018

DisplayColonOn:


        LDS     R16, currentSegs + COLON_SEG	;get the colon bits
        ORI     R16, COLON_DIGITS		;turn on the colon bits
        STS     currentSegs + COLON_SEG, R16	;store the new colon bits

        ;RJMP   EndDisplayColonOn       	;done turning on the colon


EndDisplayColonOn:                      	;done so return
        RET




; DisplayColonOff
;
; Description:       This procedure turns off the colon on the display.
;
; Operation:         The colon bits in the stored segment patterns are reset.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  currentSegs - bits in the COLON_SEG element are reset.
; Global Variables:  None.
;
; Input:             None.
; Output:            The colon LEDs are turned off (indirectly via LEDMux).
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     April 29, 2018

DisplayColonOff:


        LDS     R16, currentSegs + COLON_SEG	;get the colon bits
        ANDI    R16, ~COLON_DIGITS		;turn off the colon bits
        STS     currentSegs + COLON_SEG, R16	;store the new colon bits

        ;RJMP   EndDisplayColonOff      	;done turning off the colon


EndDisplayColonOff:                     	;done so return
        RET




; DisplayColonToggle
;
; Description:       This procedure toggles the displayed colon status.  That
;                    is, it just reverses the current state of the colon (as
;                    is reflected in the stored segment patterns -
;                    currentSegs).
;
; Operation:         The colon bits in the stored segment patterns are
;                    inverted.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  currentSegs - bits in the COLON_SEG element are changed.
; Global Variables:  None.
;
; Input:             None.
; Output:            The states of the colon LEDs are changed (indirectly via
;                    LEDMux).
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16, R17
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     April 29, 2018

DisplayColonToggle:


        LDS     R16, currentSegs + COLON_SEG	;get the colon bits
        LDI     R17, COLON_DIGITS
        EOR     R16, R17		        ;invert the colon bits
        STS     currentSegs + COLON_SEG, R16	;store the new colon bits

        ;RJMP   EndDisplayColonToggle   	;done toggling the colon


EndDisplayColonToggle:                  	;done so return
        RET




; LEDMux
;
; Description:       This procedure multiplexes the LED display under
;                    interrupt control.  It is meant to be called at a regular
;                    interval of about 1 ms.
;
; Operation:         This procedure outputs the next segment (from the
;                    currentSegs buffer) to the memory mapped LEDs each time
;                    it is called.  To do this it outputs the digits that
;                    should have the current segment on.  The segment to
;                    output is determined by curMuxSeg and curMuxSegPatt which
;                    are also updated by this function.  One segment is output
;                    each time the function is called.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   R18 - current segment number.
;                    R19 - current segment pattern.
;                    Z   - pointer to segment patterns to output.
; Shared Variables:  currentSegs   - an element of the buffer is written to
;                                    the LEDs and the buffer is not changed.
;                    curMuxSeg     - used to determine which buffer element to
;                                    output and updated to the next buffer
;                                    element.
;                    curMuxSegPatt - segment drive pattern to output and
;                                    and updated to the next drive pattern.
; Global Variables:  None.
;
; Input:             None.
; Output:            The next segment is output to the LED display.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R0, R18, R19, Z (ZH | ZL)
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     May 8, 2018

LEDMux:


StartLEDMux:                            ;first turn off the LEDs
	LDI	R18, LED_BLANK		;turn off the LED segment drives
	OUT	SEGMENT_PORT, R18

	CLR	R19			;zero constant for calculations
	LDS	R18, curMuxSeg		;get current segment to output

MuxLED:		     			;get the segment pattern for the digit
	LDI	ZL, LOW(currentSegs)	;get the start of the buffer
	LDI	ZH, HIGH(currentSegs)
	ADD	ZL, R18			;move to the current muxed digit
	ADC	ZH, R19

	LD	R0, Z			;get the segment pattern from buffer
	OUT	DIGIT_PORT, R0		;and output it to the display

	LDS	R19, curMuxSegPatt	;get the current drive pattern
	OUT	SEGMENT_PORT, R19	;and output it

	LSL	R19			;get the next segment pattern
        INC     R18                     ;and next segment number
	CPI	R18, NUM_SEGS		;check if have done all the segments
        BRLO    UpdateSegmentCnt        ;if not, update with the new values
	;BRSH	ResetSegmentCnt		;otherwise need to reset segments

ResetSegmentCnt:			;reset segment count and pattern
        CLR     R18                     ;on last segment, reset to first
	LDI	R19, INIT_SEG_PATT	;and the first pattern too
	;RJMP	UpdateSegmentCnt

UpdateSegmentCnt:			;store new segment count and pattern values
	STS	curMuxSeg, R18		;store the new segment count
	STS	curMuxSegPatt, R19	;store the new segment pattern
        ;RJMP   EndLEDMux               ;and all done


EndLEDMux:                              ;done multiplexing LEDs - return
        RET




; InitLEDMux
;
; Description:       This procedure initializes the variables used by the code
;                    that multiplexes the LED display.
;
; Operation:         The segment number to be multiplexed next is reset.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  curMuxSeg     - set to NUM_SEGS.
;                    curMuxSegPatt - set to INIT_SEG_PATT.
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
; Last Modified:     May 8, 2018

InitLEDMux:


	LDI	R16, 0                  ;initialize the segment to multiplex
        STS     curMuxSeg, R16

	LDI	R16, INIT_SEG_PATT      ;initialize segment drive pattern too
        STS     curMuxSegPatt, R16

        ;RJMP   EndInitLEDMux           ;only thing to do - done


EndInitLEDMux:                          ;done initializing multiplex operation
        RET                             ;   just return




; SegTable
;
; Description:      This is the segment pattern table.  It contains the
;                   segment patterns to be output to the display for all
;                   possible nibbles.  The segments are active high.
;
; Author:           Glen George
; Last Modified:    September 29, 2013

SegTable:

;                  gfedcba     gfedcba
        .DB	0b00111111, 0b00000110	;digits 0, 1
        .DB	0b01011011, 0b01001111	;digits 2, 3
        .DB	0b01100110, 0b01101101	;digits 4, 5
        .DB	0b01111100, 0b00000111	;digits 6, 7
        .DB	0b01111111, 0b01100111	;digits 8, 9
        .DB	0b00000000, 0b00000000	;digits 10, 11 (unused)
        .DB	0b00000000, 0b00000110	;digit 12  1:00 AM - 9:59 AM
					;digit 13 10:00 AM - 12:59 AM
        .DB	0b00000000, 0b00000110	;digit 14  1:00 PM - 9:59 PM
					;digit 15 10:00 PM - 12:59 PM




;the data segment

.dseg


currentSegs:    .BYTE	NUM_SEGS	;buffer holding currently displayed segment patterns

curMuxSeg:      .BYTE	1               ;current segment number being multiplexed
curMuxSegPatt:	.BYTE	1		;current segment output pattern
