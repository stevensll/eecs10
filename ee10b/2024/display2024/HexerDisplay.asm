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
; Output:            The LED display is blank.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Limitations:		 None.
; Special Notes:	 None.
;
; Registers changed: R16, R17, Y (YL | YH)
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
;					 The currBuffIndex and currDigPattern variables used in 
;					 MuxLEDs are initialized.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
;                    
; Shared Variables:  currBuffIndex: 		The current index (digit or row #)
;											used to access the display buffer
;											is WRITTEN as the first digit (0)
;					 dispDigPattern:		The current digit pattern to output
;											to the display is WRITTEN as the 
;											initial digit pattern.
;					 displayBuffer:			The display buffer is WRITTEN 
;											with each row as DIG_OFF to turn off
;											LEDs. (from ClearDisplay)
; Global Variables:  None.
;
; Input:             None.
; Output:            The LED display is blank.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Registers changed: R16, R17, Y (YL | YH)
; Stack depth:		 0 bytes.
;
; Author:            Steven Lei
; Last Modified:     03/30/2024
;

InitDisplay:

StartInitDisplay:					; first clear the display
	RCALL CLearDisplay
	;RJMP InitMuxLEDs				; now initialize variables used in MuxLEDs

InitMuxLEDs:						; initialize the index and digit pattern
	CLR		R16							; starting buffer index value is 0
	STS		currBuffIndex, R16
	LDI		R16, INIT_DIG_PATT		; reset digit pattern to the inital one
	STS		dispDigPattern, R16
	;RJMP 	EndInitDisplay			; done initializing variables

EndInitDisplay:						; done so return
	RET


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
; Operation:         The mask (m) is applied by setting the high and low byte 
;					 of (m) with the first and second byte of the displayBuffer.
;					 The game LEDs are displayed upon 1 ms interrupt using the
;				   	 MuxLEDs function.
;	
; Arguments:         R17 | R16 - the 16 bit mask (m) 
; Return Value:      None.
;
; Local Variables:   currBuffIndex: 	the current index of the display buffer
;
; Shared Variables:  displayBuffer:		the first two bytes of the display 
;										buffer, which correspond to game LEDs, 
;										are WRITTEN by masking with argument (m)
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
; Registers changed: Y (YL | YH)
; Stack depth:		 0 bytes.        
;         
; Author:            Steven Lei
; Last Modified:     03/30/24
;
; PseudoCode:

DisplayGameLEDs:

UpdateBuffer:						; set the game led rows in buffer to (m)
	LDI		YL, LOW(displayBuffer)		; load the address of the buffer
	LDI		YH,	HIGH(displayBuffer)			
	ADIW	Y,  GAME_LED_START_DIGIT	; offset address by start of game LEDs
	ST		Y+, R17						; store the high byte of the mask
	ST		Y, 	R16						; store the low byte of the mask

EndDisplayGameLEDs:						; done so return
	RET

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
; Local Variables:   R18: 				the current index (row) of the buffer
;					 R19:				the low byte of the argument (n)
;					 R20:				the hex value from the low nibble of (n)
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
; Registers Changed: 
; Stack depth:		 0 bytes.
;	                    
; Author:            Steven Lei
; Last Modified:     03/30/24
;
DisplayHex:

	LDI		R18, NUM_7SEG_DIGITS			;
	LDI		YL, LOW(displayBuffer)
	LDI		YH, HIGH(displayBuffer)
	ADIW	Y, 7SEG_START_DIGIT

	MOV		R19, R16
	ANDI	R19, LOW_NIBBLE_MASK
	LDI		ZL, LOW(2 * DigitSegTable)
	LDI		ZH, HIGH(2 * DigitSegTable)
	ADD		ZL, R19
	ADC 	ZH, 0
	LPM
	ST		Y+, R0

ShiftArgumentBits:				; shift the next nibble of the argument into R16
	LSR R17                         ; shift right and put shifted bit into carry
    ROR R16                         ; shift right and put carry into high bit
    LSR R17                         ; repeat 4 times since a nibble
    ROR R16
    LSR R17 
    ROR R16
    LSR R17
    ROR R16

CheckIndex:								; check if the buffer index is 0
	DEC		R18							
	BRNE	DisplayHexLoop				; if not 0, still more rows to update 
	;BREQ	EndDisplayHex				; else done looping and updating buffer
EndDisplayHex:							; done so return
	RET
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
; Registers changed: R16, R0, Z (ZL | ZH)
; Stack Depth:		 None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Author:            Steven Lei
; Last Modified:     03/30/24

MuxLEDs:

TurnOffDigitPort:                   ; turn off digits so no wrong LEDs displayed
    LDI     R16, DIGIT_OFF              ; turn off the digit port so all LEDs 
    OUT     DIGIT_PORT, R16                 ; are off
	;RJMP	OutputSegmentPattern	; ready to output segment pattern

OutputSegmentPattern:               ; output segment pattern at current digit
    LDI     ZL, LOW(displayBuffer)      ; load the address of the display buffer
    LDI     ZH, HIGH(displayBuffer)
    LDS     R16, currBuffIndex          ; load current index (digit) of display
    ADD     ZL, R16                     ; offset address by the buffer index
    ADC     ZH, 0                       ; use 0 for carry propagation
    LD      R0, Z                       ; get the segment pattern from buffer
    OUT     SEGMENT_PORT, R0            ; and output it to the segment port
	;RJMP 	OutputDigitPattern			; ready to output digit pattern

OutputDigitPattern:                 ; output digit pattern at current digit
    LDS     R16, dispDigPattern			; load the current digit pattern
	OUT		DIGIT_PORT					; and output to the digit port  
	;RJMP	CheckBufferIndex			; check if buffer value needs to wrap

CheckBufferIndex:					; compute the next buffer value
	LDS 	R16, currBuffIndex			; load the buffer index 
	SUBI	R16, NUM_DIGITS				; subtract it from the max index value
	BRLO	IncrementBuffIndex			; index is not max value yet, increment
	;BRGE	ResetBuffIndex				; index is max value reset

ResetBufferIndex:					; reset the buffer index to 0 for wrapping
	CLR		R16							; clear register to 0
	STS		currBuffIndex, R16			
	;RJMP	ResetDigitPattern			; also need to reset next digit pattern

ResetDigitPattern:					; reset next digit pattern sent to display
	LDS		R16, INIT_DIG_PATT			; reset digit to the initial pattern 		
	STS		dispDigPattern, R16
	RJMP	DoneMuxLEDs					; done updating digit pattern

IncrementBuffIndex:					; increment the buffer index
	LDS 	R16, currBuffIndex			
	INC		R16								
	STS		currBuffIndex, R16				
	;RJMP   UpdateDigitPattern			; also need to update the digit pattern

UpdateDigitPattern:					; update the digit pattern sent to display
	LDS		R16, dispDigPattern
	LSL		R16							; just need to shift the high bit left
	;RJMP	DoneMuxLEDs					; done updating digit pattern

DoneMuxLEDs:                         ; done multiplexing LEDs, so return
    RET


;the data segment

.dseg

displayBuffer:  .BYTE   NUM_DIGITS  ; the 7 byte display buffer for controlling
                                        ; the game LEDs and 7 seg display
dispDigPattern:	.BYTE	1			; the digit pattern to output to the display
currBuffIndex:  .BYTE	1			; current index used to access the buffer