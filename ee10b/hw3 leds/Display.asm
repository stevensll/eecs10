;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                    DISPLAY                                 ;
;                               Display Routines                             ;
;                   Microprocessor-Based Hexer Game (AVR version)            ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions for displaying the game LEDs and the 7 segment
; display for the Hexer Game. The functions included are: 
;    InitDisplay        - initialize the display and its variables
;    ClearDisplay       - clears the LED buffer
;    DisplayHex         - 
;    DisplayGameLEDs    - toggles the game LEDs in the LED buffer with mask (m)

; The local functions included are:
;   None
; Revision History:
;   06/09/23    Steven Lei      Initial revision
;   06/14/23    Steven Lei      Finished ClearDisplay, DisplayHex, 
;                               DisplayGameLEDs

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
;
; Author:            Steven Lei
; Last Modified:     June 9, 2023

InitDisplay:


StartInitDisplay:                       ;start clearing the display
        LDI     R16, NUM_SEGS           ;number of segments to clear
        LDI YL, LOW(currentSegs)        ;point to the segments
        LDI YH, HIGH(currentSegs)
        LDI     R17, LED_BLANK          ;get the blank segment pattern

InitBuffLoop:               ;loop clearing the segments
        ST  Y+, R17         ;clear the segments
    DEC R16         ;update loop counter
    BRNE    InitBuffLoop        ;and loop until done
        ;BREQ   InitColonAlarm          ;then initialize the colon and alarm


InitColonAlarm:                         ;turn off colon and set alarm
        RCALL   DisplayColonOff

        RCALL   AlarmSet                ;next keep the alarm setting right
        RCALL   DisplayAlarm

        RCALL   InitLEDMux              ;finally, initialize muxing

        ;RJMP   EndInitDisplay          ;all done now


EndInitDisplay:                         ;done initializing the display - return
        RET




; ClearDisplay()
;
; Description:       This function clears the 7 segment and game LEDS buffer. 
;                    After it is called, all LEDs should be off.
;
; Operation:         The display and game LEDs are cleared by resetting each
;                    byte of the LEDbuffer. The LEDbuffer is then written to
;                    the LEDs by MultiplexLEDs to turn off each LED.
;                  
; Arguments:         None
; Return Value:      None.
;
; Local Variables:   None.

; Shared Variables:  
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
; Registers Changed: R16, R17, Y
;                    
; Author:            Steven Lei
; Last Modified:     June 14, 2023

ClearDisplay:

ClearInit:                      ; setup the buffer counter and the Y pointer 
    LDI     R16, LED_BLANK          ; blanks for clearing    
    LDI     R17, NUM_DIGITS        ; use R17 as a decrementing counter
    LDI     YL, LOW(LEDbuffer)      ; load the 16 bit buffer address
    LDI     YH, HIGH(LEDbuffer)

ClearLoop:                      ; loop through each byte of buffer and clear it   
    ST      Y+, R16                 ; store blank and increment pointer
    DEC     R17                     ; update counter
    BRNE    ClearLoop               ; loop until entire buffer is iterated
   ;BREQ    ClearDisplayDone

ClearDisplayDone:               ; done clearing
    RET                             ; and return

; DisplayGameLEDs(m)
;
; Description:       This function is passed a 16 bit mask that indicates the 
;                    game LEDs to turn off/on. If the bit in the mask is set, 
;                    the corresponding game LED is turned on and if it is reset, 
;                    the LED is turned off. The bits are defined as the follows:

;    MASK BITS: | 15 | 14 | 13 | 12 | 11 | 10 | 09 | 08 | 07 | 06 | 05 | 04 | 03 | 02 | 01 | 00 |
;    GAME LEDS: | L9 | L1 | L5 |NONE|L10 | L4 | L3 | L2 |L13 |L11 | L8 |L15 |L14 |L12 | L7 | L6 |
;                    
; Operation:         The mask (m) is applied by masking the high byte of (m) 
;                    with the high byte of the game LEDs in the LED buffer
;                    and masking the low byte of (m) with the low byte of the
;                    game LEDs in the LED buffer. 
;
; Arguments:         R17 | R16 - the 16 bit mask (m) 
; Return Value:      None.
;
; Local Variables:   None.

; Shared Variables:  LEDbuffer - the LEDbuffer is masked to the new bytes to 
;                                determine what LEDs will be turned/on off on 
;                                the next multiplexing interrupt.
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
; Registers Changed: R16, R17, R18
;                    
; Author:            Steven Lei
; Last Modified:     June 14, 2023

DisplayGameLEDs:

MaskHiGameLED:                     ; mask high byte of (m) in R17 to buffer
    ANDI    R17, GAME_LED_HI_MASK      ; mask bit 4 of (m) to low since unused
    STS     LEDbuffer+GAME_LED_HI, R17 

MaskLowGameLED:                    ; mask low byte of (m) in R16 to buffer
    ANDI    R16, GAME_LED_LOW_MASK      
    STS     LEDbuffer+GAME_LED_LO, R16

DisplayGameLEDsDone:                ; done
    RET                                     ; and return

; DisplayHex()
;
; Description:       This function is passed a 16 bit unsigned value (n) to 
;                    output in hexadecimal (at most 4 digits) to the 7 segment
;                    display. (n) is passed in by R17 | R16.
;
; Operation:         Since 4 bits represent a hexadecimal digit, each nibble
;                    of the passed bytes are interpreted to display the 4 digit
;                    value in the 7 segment.
;                  
; Arguments:         R17 | R16 - the 16 bit unsigned value to output in hex
; Return Value:      None.
;
; Local Variables:   
; Shared Variables:  LEDbuffer      - (W)
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: 
;                    
;
; Author:            Steven Lei
; Last Modified:     June 14, 2023

DisplayHex:



EndDisplayHex:                    ; done
    RET                             ; and return

; MultiplexLEDs
;
; Description:       This procedure multiplexes the LED display under
;                    interrupt control.  It is meant to be called at a regular
;                    interval of about 1 ms.
;
; Operation:         This procedure outputs the next segment (from the
;                    currentSegs buffer) to the memory mapped LEDs each time
;                    it is called.  To do this it outputs the bits that
;                    should have the current digit on.  The digit to
;                    output is determined by currBuffDig and curBuffPatt which
;                    are also updated by this function. One digit is output
;                    each time the function is called.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   R18 - current segment number.
;                    R19 - current segment pattern.
;                    Z   - pointer to segment patterns to output.
; Shared Variables:  LEDbuffer     - (R) an element of the buffer is written to
;                                    the LEDs and the buffer is not changed.
;                    currBuffDig   - (R,W) used to determine which buffer 
;                                    row to output and updated to the next 
;                                    buffer row
; 
;                    currBuffPatt  - (R,W) digit drive pattern to output and
;                                    and updated to the next drive pattern.
; Global Variables:  None.
;
; Input:             None.
; Output:            The next digit is output to the LED display.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R0, R18, R19, Z (ZH | ZL)
;
; Author:            Steven Lei, credit Glen George
; Last Modified:     June 14, 2023

MultiplexLEDs:

StartLEDMux:                ; first turn off the LEDs
	LDI	R18, LED_BLANK		    ; turn off the LED segment drives
	OUT	DIGIT_PORT, R18

	CLR	R19			            ; zero constant for calculations
	LDS	R18, curBuffDig		    ; get current digit to output

MuxLED:		     			;get the pattern for the digit
	LDI	ZL, LOW(LEDbuffer)	    ; get the start of the buffer
	LDI	ZH, HIGH(LEDbuffer)
	ADD	ZL, R18			        ; move to the current muxed digit
	ADC	ZH, R19

	LD	R0, Z			        ; get the digit from buffer 
	OUT	BIT_PORT, R0		        ; and output it to the display 

	LDS	R19, currBuffPatt	    ; get the current drive pattern
	OUT	DIGIT_PORT, R19	            ; and output it 

	LSL	R19			            ; get the next segment pattern
    INC R18                     ; and next segment number
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



SegTable:

;                  gfedcba     gfedcba
        .DB 0b00111111, 0b00000110  ;digits 0, 1
        .DB 0b01011011, 0b01001111  ;digits 2, 3
        .DB 0b01100110, 0b01101101  ;digits 4, 5
        .DB 0b01111100, 0b00000111  ;digits 6, 7
        .DB 0b01111111, 0b01100111  ;digits 8, 9
        .DB 0b00000000, 0b00000000  ;digits 10, 11 (unused)
        .DB 0b00000000, 0b00000110  ;digit 12  1:00 AM - 9:59 AM
                                    ;digit 13 10:00 AM - 12:59 AM
        .DB 0b00000000, 0b00000110  ;digit 14  1:00 PM - 9:59 PM
                                    ;digit 15 10:00 PM - 12:59 PM




;the data segment

.dseg


LEDbuffer:      .BYTE   NUM_DIGITS  ; the 7 byte LED buffer with the currently
                                        ; displayed game LEDs and 7-seg patterns

currBuffDig:    .BYTE   1           ; current index of the buffer
currBuffPatt:   .BYTE   1           ; current digit pattern to output 
