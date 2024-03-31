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
;    DisplayHex         - displays the passed digit in hex
;    DisplayGameLEDs    - toggles the game LEDs in the LED buffer with mask (m)
;    LEDMux             - muxes LEDs on interrupt by writing buffer to LED ports
; The local functions included are:
;   None
; Revision History:
;   06/09/23    Steven Lei      Initial revision
;   06/14/23    Steven Lei      Finished ClearDisplay, DisplayHex
;   06/15/23    Steven Lei      Finished DisplayGameLEDs, InitDisplay, LEDMux

; local include files
;.include  "clkgen.inc"
;.include  "clkdisp.inc"

.cseg

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                        	Display Procedure Outlines                	 	 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Steven Lei
EECS10b HW3 Display Procedure Outlines
* Note: I handed this in last year, but re-did it just to keep documentation 
		consistent. Some changes I made are:
			Updated Pseudo code format for all functions (makes it clearer)
			Updated DebounceSwitches to contain variable repeat rate
			Included definition of CONSTANTS

; CONSTANTS used in Pseudo code:

NUM_BUFFER_DIGITS    = 7        ; number of digits (ROWS) in the buffer
NUM_7SEG_DIGITS      = 4        ; number of 7-segment displays digits
NUM_GAME_LED_DIGITS  = 2        ; number of game LED digits 

DIGIT_OFF       	  = 0b00000000      ; turn off LEDs in a digit (off is 0)
INIT_DIG_PATT 		  = 0b00000001      ; initial digit drive pattern
GAME_LED_START_DIGIT  = 0               ; game LEDs start at digit 0
7SEG_START_DIGIT      = 3               ; 7-segment LEDs start at digit 3
            
LOW_NIBBLE_MASK = 0b00001111    ; mask to get low nibble of a byte 

GAME_LED_HI_MASK  = 0b11101111  ; high byte of LED mask, bit 12 unused
GAME_LED_LOW_MASK = 0b11111111  ; low byte of LED mask

; Port Definitions
    ; see LED layout table on website for bit/digits

SEG_PORT   = PORTC              ; LED segments are on port C
DIGIT_PORT = PORTD              ; LED digits are on port D

; ClearDisplay
;
; Description:       This function clears the 7 segment and game LEDS buffer. 
;                    After it is called, all LEDs on the display should be off.
;
; Operation:         The display and game LEDs are cleared by resetting each
;                    byte of the displayBuffer to DIGIT_OFF (all LED bits low).
;					 This is done by looping through each byte of the buffer. 
;					 Upon the 1 ms interrupt, the MuxDisplay function writes
;					 one digit (row) of the displayBuffer to turn off the 
;					 corresponding LEDs.
;                  
; Arguments:         None
; Return Value:      None.
;
; Local Variables:   R17:		        the current digit (row) of the buffer
;                    
; Shared Variables:  displayBuffer:		Each bit of the buffer represents an LED
;										segment and each byte(row) of the buffer
;										represents a digit. Each byte of the
;										buffer is WRITTEN as DIGIT_OFF.
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
; Limitations:		 None.
; Special Notes:	 None.
;
; Registers changed: R16, R17, Y
; Stack depth:       0 bytes
;                 
; Author:            Steven Lei
; Last Modified:     03/30/24

ClearDisplay:

StartClearDisplay:              ; setup the buffer digit index and Y pointer
    LDI     R16, DIGIT_OFF          ; using DIGIT_OFF for clearing (all bits 0)
    LDI     R17, NUM_DIGITS         ; start at the highest buffer digit index
    LDI     YL, LOW(displayBuffer)  ; get the address of the buffer
    LDI     YH, HIGH(displayBuffer)

ClearDisplayLoop:               ; loop through buffer and clear rows (digits)
    ST      Y+, R16                 ; clear LED and increment buffer pointer
    DEC     R17                     ; decrement the current buffer digit    
    BRNE    ClearDisplayLoop        ; not done clearing all rows of the buffer
    ;BRNEQ  ClearDisplayDone:       ; done clearing all rows of the buffer

ClearDisplayDone:               ; done so return
    RET         


; InitDisplay
;
; Description:       This function initializes the display by turning all LEDs 
;                    off and initializing the display multiplex variables.
;
; Operation:         Calls ClearDisplay() to turn off all LEDs in the buffer.
;					 The currDispDig and currSegPatt variables used in 
;					 MuxLEDs are initialized.
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
; Special Notes:	 None.
; Limitations:		 None.
;
; Author:            Steven Lei
; Last Modified:     June 9, 2023
;
; Psuedo code:

	InitDisplay(){
		ClearDisplay()
		currDispDig = 0
		RETURN
	}

; DisplayGameLEDs(m)
;
; Description:      This function is passed a 16 bit mask that indicates the 
;                   game LEDs to turn off/on. If the bit in the mask is set, 
;                   the corresponding game LED is turned on and if it is reset, 
;                   the LED is turned off. The bits are defined as the follows:
;
;					MASK BIT 	CORRESPONDING GAME LED
;					15					L9
;					14					L1
;					13					L5
;					12				   NONE
;					11					L10
;					10					L4
;					09					L3
;					08					L2
;					07					L13
;					06					L11
;					05					L8
;					04					L15
;					03					L14
;					02					L12
;					01					L7
;					00					L6
;                    
; Operation:         The mask (m) is applied by masking the high and low byte 
;					 of (m) with the first and second byte of the LEDbuffer.
;					 The game LEDs are displayed upon 1 ms interrupt using the
;				   	 MuxLEDs function.
;	
; Arguments:         R17 | R16 - the 16 bit mask (m) 
; Return Value:      None.
;
; Local Variables:   currDigitIndex: 	the current digit of display buffer
;
; Shared Variables:  displayBuffer:		the first two bytes of the display 
;										buffer, which correspond to game LEDs, 
;										are WRITTEN by masking with argument (m)
;	
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Special notes:	 None.
; Limitations:		 None.           
;         
; Author:            Steven Lei
; Last Modified:     03/30/24
;
; PseudoCode:

DisplayGameLEDs:

MaskGameLEDHigh:
    ANDI    R17, 
MaskGameLEDLow:
	DisplayGameLEDs(m){
		FOR (currDigit = 0, currDigit + GAME_LED_START_DIGIT < 7SEG_START_DIGIT,
			 currDigit++){
				displayBuffer[currDigit+GAME_LED_START_DIGIT] &= m[currDigit]
			 }
		RETURN
	}

; DisplayHex()
;
; Description:       This function is passed a 16 bit unsigned value (n) to 
;                    output in hexadecimal (at most 4 digits) to the 7 segment
;                    display. (n) is passed in by R17 | R16. The value is then
;					 displayed on the 7 segment display.
;
; Operation:         Since 4 bits represent a hexadecimal digit, each nibble
;                    of the passed bytes are interpreted through bit masking
;					 and shifting. The nibble is then looked up in the 
;                    DigitSegTable to find the corresponding segments to set in
;					 the displayBuffer. The buffer is then written to the actual
;					 LEDs upon interrupt using MuxLEDs.
;
; Arguments:         R17 | R16 - the 16 bit unsigned value to output in hex
; Return Value:      None.
;
; Local Variables:   currDigit: 		the current digit (row) of the buffer
;					 lowByte:			the low byte of the argument (n)
;					 hex_value			the hex value from the low nibble of (n)
; Shared Variables:  displayBuffer:		Each bit of the buffer represents an LED
;										segment and each byte(row) of the buffer
;										represents a digit. Each segment of the
;										buffer is WRITTEN to display the correct
;										hex value.
;                           
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;	                    
; Author:            Steven Lei
; Last Modified:     03/30/24
;
; Pseudo code:

	DisplayHex(n){
		FOR(currDigit = 7SEG_START_DIGIT, currDigit < NUM_BUFFER_DIGITS, 
			currDigit++){
				low_byte = LOW(n)
				hex_value = low_byte & LOW_NIBBLE_MASK
				displayBuffer[currDigit] = DigitSegTable[hex_value]
				shiftNibbleRight(n)
			}
	}
	// note: shiftRight is just the bit right shift instruction
	shiftNibbleRight(n){
		shiftRight(n)
		shiftRight(n)
		shiftRight(n)
		shiftRight(n)
	}

; MuxLEDs
;
; Description:       This procedure multiplexes the LED display under
;                    interrupt control.  It is meant to be called at a regular
;                    interval of about 1 ms. It will display 1 digit of the
;					 LEDs every interrupt, but because the interrupt frequency 
;					 is 1 kHz, it looks like all digits are displayed at once.
;
; Operation:         Since not all digits of the display can be displayed at 
;					 once, upon interrupt, the segment pattern (currSegPatt)
;					 at the current display digit (currDispDig) is written from 
;					 from the display buffer to the corresponding LEDs. When
;					 writing from the buffer to the LEDs, the LEDS must be 
;					 turned off to avoid briefly turning on the wrong LEDs.
;					 After the digit and segments are written, the current
;					 display digit is updated and the next segment pattern is 
;					 stored. The display buffer is updated from the DisplayHex 
;					 or DisplayGameLEDs functions.
;					 
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.	
;                   
; Shared Variables:  displayBuffer:  a digit (row) of the buffer and the
;									 corresponding segment pattern is read to 
;									 the LED output ports
;                    currDispDig:	 the current digit (row) is READ to the  
;                                    row to output and WRITTEN (incremented,
;									 with wrapping) as the next buffer row index
;                    currSegPatt:	 the segment pattern at the current digit is
;									 READ to the output and WRITTEN (updated)
;                                    as the next buffer row's segment pattern.
; Global Variables:  None.
;
; Input:             None.
; Output:            DIGIT_PORT: 	The digit to display is WRITTEN from buffer 
;									to the port
;					 SEG_PORT:		The segments to display are WRITTEN from
;									buffer to the port.
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Author:            Steven Lei
; Last Modified:     03/30/24

MuxLEDs:

TurnOffDigits:                      ; turn off digits so no wrong LEDs displayed
    LDI     R16, DIGIT_OFF              ; turn off the digit port so all LEDs 
    OUT     DIGIT_PORT, R16                 ; are off

OutputSegmentPattern:               ; output segment pattern at current digit
    LDI     ZL, LOW(displayBuffer)      ; load the address of the display buffer
    LDI     ZH, HIGH(displayBuffer)
    LDS     R16, currDispDig            ; load current digit (row) of display
    ADD     ZL, R16                     ; offset address by the current digit
    ADC     ZH, 0                       ; use 0 for carry propagation
    LD      R0, Z                       ; get the segment pattern from buffer
    OUT     BIT_PORT, R0                    ; and output it to the port

OutputDigPattern:                   ; output digit pattern at current digit
    LDS       


	MuxLEDs(){
		DIGIT_PORT = DIGIT_OFF		   	  ; turn off the port controlling digits
		SEG_PORT = displayBuffer[currDispDig]     ; write the column/seg pattern
		DIGIT_PORT = currDispDig		; write the row/dig pattern
		currDispDig = (currDispDig + 1) MOD	NUM_DIGITS	; go to the next digit
		currSegPatt = displayBuffer[currDispDig]		; get the next segments
		RETURN
	}

EndMuxLEDs:                         ; done multiplexing LEDs, so return
    RET




;the data segment

.dseg

displayBuffer:  .BYTE   NUM_DIGITS  ; the 7 byte display buffer for controlling
                                        ; the game LEDs and 7 seg display
currDispDig:    .BYTE   1           ; current digit to output to the display
currSegPatt:    .BYTE   1           ; current segment pattern to output to 
                                    ; the display
