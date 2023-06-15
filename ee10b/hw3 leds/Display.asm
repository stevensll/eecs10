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
; Description:       This function initializes the display by turning all LEDs 
;                    off and initializing the display multiplex variables.
;
; Operation:         Calls ClearDisplay() to turn of all LEDs. Variables
;                    used in MultiplexLEDs() are initialized.
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
; Output:            The LED display is blanked.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: R16, R17, Y (YH | YL)
;
; Author:            Steven Lei
; Last Modified:     June 9, 2023

InitDisplay:

StartInitDisplay:          ;start clearing the display
    RCALL ClearDisplay          

InitLEDMux:                ;init variables for MultiplexLEDs
    LDI     R16, 0              ; reset digit number
    STS     currBuffDig, R16    
    LDI     R16, INIT_DIG_PATT  ; reset digit drive pattern
    STS     currDrivePatt, R16  

EndInitDisplay:            ;done initializing the display - return
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
; Local Variables:   R16 - the value of each LEDbuffer byte (0) 
;                    R17 - counter for iterating through entire LEDbuffer
;                    Y   - the LEDbuffer address

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

StartClear:                      ; setup the buffer counter and the Y pointer 
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

; Shared Variables:  LEDbuffer - (W) the LEDbuffer is masked to the new bytes to 
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
; Registers Changed: R16, R17
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
    RET                             ; and return

; DisplayHex()
;
; Description:       This function is passed a 16 bit unsigned value (n) to 
;                    output in hexadecimal (at most 4 digits) to the 7 segment
;                    display. (n) is passed in by R17 | R16.
;
; Operation:         Since 4 bits represent a hexadecimal digit, each nibble
;                    of the passed bytes are interpreted through masking and
;                    are looked up in the DigitSegTable to correctly display
;                    the value in the 7 segment display.
;                  
; Arguments:         R17 | R16 - the 16 bit unsigned value to output in hex
; Return Value:      None.
;
; Local Variables:   R18 - counter for iterating through 7 seg display
;                    R19 - the low nibble of interest representing the digit
;                    R20 - for carry propogation
;                    Y   - LEDbuffer address
;                    Z   - DigitSegTable address 
; Shared Variables:  LEDbuffer - (W) the segment pattern at each digit
;                                for the 7 segment displays are updated 
;                                to match the digit pattern provided by
;                                the input digits
;                           
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: R16, R17, R18, R19, R20, Y (YH | YL), Z (ZH | ZL)
;                    
; Author:            Steven Lei
; Last Modified:     June 14, 2023

DisplayHex:

StartDisplayHex:                ; setup the LEDbuffer address and counter
    LDI     YL, LOW (LEDbuffer)    ; load the LEDbuffer address
    LDI     YH, HIGH(LEDbuffer)
    ADIW    Y, SEG_DIG             ; offset address to start at 7 segs
    LDI     R18, NUM_SEG_DIGITS    ; counter to loop through amt of 7 segs
    CLR     R20                    ; for carry


DisplayHexLoop:                 ; get digit pattern
    MOV     R19, R16                    ; copy the low byte
    ANDI    R19, LOW_NIBBLE_MASK        ; mask to get the low nibble
    LDI     ZL, LOW(2 * DigitSegTable)  ; get the start of the segment table
    LDI     ZH, HIGH(2 * DigitSegTable)     ; times 2 to do byte addressing
    ADD     ZL, R19                     ; offset in the seg table
    ADC     ZH, R20
    LPM                                 ; lookup the pattern and put in R0
    ST      Y+, R0                      ; store pattern at buffer address

ShiftBits:                      ; shift the next nibble into R16
    LSR R17                         ; shift right and put shifted bit into carry
    ROR R16                         ; shift right and put carry into high bit
    LSR R17                         ; repeat 4 times
    ROR R16
    LSR R17 
    ROR R16
    LSR R17
    ROR R16

CheckIndexCount:               ; check if done iterating through 7-segs
    DEC R18                         ; update loop counter
    BRNE DisplayHexLoop             ; if not done keep looping
   ;BRNE EndDisplayHex              ; else done

EndDisplayHex:                    ; done
    RET                             ; and return

; MultiplexLEDs
;
; Description:       This procedure multiplexes the LED display under
;                    interrupt control.  It is meant to be called at a regular
;                    interval of about 1 ms.
;
; Operation:         This procedure outputs the next digit (from the
;                    LEDbuffer) to the memory mapped LEDs each time
;                    it is called.  To do this it outputs the bits that
;                    should have the current digit on. The digit to
;                    output is determined by currBuffDig and curBuffPatt which
;                    are also updated by this function. One digit is output
;                    each time the function is called.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   R18 - current digit number.
;                    R19 - current digit drive pattern.
;                    Z   - pointer to digit patterns to output.
; Shared Variables:  LEDbuffer     - (R) an element of the buffer is written to
;                                    the LEDs and the buffer is not changed.
;                    currBuffDig   - (R,W) used to determine which buffer 
;                                    row to output and updated to the next 
;                                    buffer row
; 
;                    currDrivePatt  - (R,W) digit drive pattern to output and
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

StartLEDMux:                    ; first turn off the LEDs
	LDI	    R18, LED_BLANK		    ; turn off the LED digit drives
	OUT	    DIGIT_PORT, R18

	CLR	    R19			            ; zero constant for calculations
	LDS	    R18, curBuffDig		    ; get current digit number

MuxLED:		     			    ;get the pattern for the digit
	LDI	    ZL, LOW(LEDbuffer)	    ; get the start of the buffer
	LDI	    ZH, HIGH(LEDbuffer)
	ADD	    ZL, R18			        ; move to the current digit number
	ADC	    ZH, R19

	LD	    R0, Z			        ; get the pattern from buffer 
	OUT	    BIT_PORT, R0		        ; and output it to the display 

	LDS	    R19, currDrivePatt	    ; get the current drive pattern
	OUT	    DIGIT_PORT, R19	            ; and output it 

	LSL	    R19			            ; get the next digit drive pattern
    INC     R18                     ; and next digit number
	CPI	    R18, NUM_DIGITS		    ;check if have done all the digits
    BRLO    UpdateDigitCnt          ;if not, update with the new values
	;BRSH	ResetDigitCnt		    ;otherwise need to reset digit

ResetDigitCnt:			        ;reset digit count and drive pattern
    CLR     R18                     ;on last digit, reset to first
	LDI	    R19, INIT_SEG_PATT	    ;and the first drive pattern 
	;RJMP	UpdateDigitCnt

UpdateDigitCnt:			        ;store new digit count and drive pattern values
	STS	    curBuffDig, R18		    ;store the new digit number
	STS	    currDrivePatt, R19	    ;store the new drive pattern
    ;RJMP   EndLEDMux               ;and all done

EndLEDMux:                  ;done multiplexing LEDs - return
    RET

;the data segment

.dseg


LEDbuffer:      .BYTE   NUM_DIGITS  ; the 7 byte LED buffer containing
                                        ; game LEDs and 7 seg displays
currBuffDig:    .BYTE   1           ; current digit number of the buffer
currDrivePatt:  .BYTE   1           ; current digit drive pattern to output 
