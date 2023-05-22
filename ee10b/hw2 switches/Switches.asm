;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   SWITCHES                                 ;
;                                Switch Routines                             ;
;                 Microprocessor-Based Hexer Game (AVR version)              ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the 



; Revision history:
;	05/18/23	Steven Lei		Initial revision
;	05/19/23    Steven Lei      Successful implementation with  snon variable repeat rate 
;   05/19/23	Steven Lei		Updated comments    
;   05/21/23	Steven Lei		Fixed DebounceSwitches by adding switch up condition and
;						        correct instruction calls

.cseg

; InitSwitches
;
; Description:       Initializes the variables for the DebounceSwitches
;					 procedure.
;					  
; Operation:         Resets the debounce counter to the debounce time and the
;					 debounce flag to 0x00. The old and new switch pattern
;					 variables are also reset to 0xFF.
;                    
; Arguments:         None.
; Return Value:      None
;
; Local Variables:   None.
; Shared Variables:  debounceCntr  (W): Counter used for debouncing, reset to the
;									    debounce time (10 ms).
;					 debounceFlag  (W): Debounce flag, reset to 0x00
;					 switchOldPatt (W): Previous switch pattern, reset to 0xFF
;					 switchDebPatt (W): Debounced switch pattern, reset to 0xFF 
;
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
; Author:            Steven Lei
; Last Modified:	 5/18/23

InitSwitches:

ResetDebCounter:					    ; reset the debounce counter to the debounce time (10ms)
	LDI 	R16, LOW(DEBOUNCE_TIME)			; load low and high bit of debounce time to counter
	STS 	debounceCntr, R16				; store
	LDI 	R16, HIGH(DEBOUNCE_TIME)			
	STS 	debounceCntr+1, R16 		

ResetDebounceFlag:						; reset the debounce flag to 0x00
	LDI 	R16, 0x00						
	STS 	debounceFlag, R16					

ResetSwitchPatt:						; reset the old and new switch pattern to switch up (no press)
	LDI		R16, SWITCH_UP						 
	STS		switchOldPatt, R16				 	
	STS 	switchDebPatt, R16	


; DebounceSwitches
;
; Description:       Checks for a new switch pattern being pressed if none is
;					 currently being pressed, or debounces the currently pressed
;					 switches. This procedure is expected to be called by the 
;					 event handler ever 1 ms.
;					  
; Operation:         Upon every call, the new switch pattern pressed (input from pin E)
;					 is compared with the old switch pattern (switchOldPatt). If the
;					 pattern is the same AND is not all up (no switches pressed), the counter 
; 					 (debounceCntr) decrements, else it resets to the debounce time (10ms). 
; 					 When the counter reaches zero, the debounceFlag flag is set, indicating 
;					 that the switch is successfully debounced. The counter is then set to the
;					 repeat rate (5000 ms). 
;                    
; Arguments:         None.
; Return Value:      None
;
; Local Variables:   None.
; Shared Variables:  switchOldPatt (R,W): the previous switch pattern, 
;										  READ to check if equal to input pattern and WRITTEN 
;										  to update to input pattern					 
;					 debounceFlag  (W):   the debounce flag, set if debounce counter
;										  hits 0
;					 switchDebPatt (W):   the debounced pattern, set to input pattern
;										  when debounce counter hits 0
;					 debounceCntr  (R,W): the debounce counter, READ to check if
;										  0, set to DEBOUNCE_TIME if new pattern is
;										  all switches up or if new pattern 
;										  != old pattern, else set to repeat rate
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
; Registers Changed: R16, R17, Z
; Stack Depth:       0
;
; Author:            Steven Lei
; Last Modified:	 5/18/23

DebounceSwitches:

GetInput:								; get new input switch pattern
	IN		R17, SWITCH_PORT				; load it
	ORI		R17, SWITCH_MASK				; mask bits 0 and 7

CompareNewOldPatts:						; check if current switch pattern is same as previous
	LDS 	R16, switchOldPatt				; load the previous pattern	
	STS		switchOldPatt, R17				; update the old pattern 
	CPI     R17, SWITCH_UP					; if new pattern is up, don't debounce
	BREQ	ResetDebounceCounter			; 		and reset debounce counter
	CP 		R16, R17						; else check if old = new pattern
	BREQ	DecDebounceCounter				; 		if old = new, decrement the debounce counter time			
	;BRNE	ResetDebounceCounter			; 		else reset the debounce counter time

ResetDebounceCounter:					; reset the debounce counter to the debounce time (10ms)
	LDI 	R16, LOW(DEBOUNCE_TIME)			; load low and high bit of debounce time to counter
	STS 	debounceCntr, R16				; store
	LDI 	R16, HIGH(DEBOUNCE_TIME)			
	STS 	debounceCntr+1, R16 			

DecDebounceCounter:						; decrement the debounce counter and check if 0
	LDS		ZL, debounceCntr				; use the 16 bit register
	LDS 	ZH, debounceCntr+1		
	SBIW	Z, 1							; dec 
	STS 	debounceCntr, ZL				; store it back 
	STS 	debounceCntr+1, ZH			
	;BREQ	UpdateFlagPatt					; if counter is 0, update flag and pattern
	BRNE	DebounceSwitchesDone			; else, return

UpdateFlagPatt:							; set debounce flag and update switch pattern
	STS		switchDebPatt, R17				; store the new pattern as debounce pattern
	LDI 	R16, 0xFF						; set the flag to FF
	STS		debounceFlag, R16				; 
	LDI 	R16, LOW(REPEAT_TIME)			; set the debounce counter to the repeat rate
	STS		debounceCntr, R16				
	LDI		R16, HIGH(REPEAT_TIME)
	STS 	debounceCntr+1, R16

DebounceSwitchesDone:					; done handling debouncing
	RET										; and return


; GetSwitches
;
; Description:       Returns the debounced switch pattern in R16 after a switch
;					 was pressed and debounced. This procedure is a blocking function
;					 since it does not return until a switch has been pressed and debounced
;					 (but not necessarily needs to be released).
;
; Operation:         Blocking loop until a debounced switch pattern is available 
;					 (from calling SwitchAvailable). Note that this is critical code
;					 because the debounced switch pattern can't be changed when the procedure
;					 is returning it to R16.
;					 Returns the debounced pattern into R16, 
;                    
; Arguments:         None.
; Return Value:      switchDebPatt: (debounced switch pattern) in R16,
;					 with each bit representing a switch in a one hot scheme:
;					 7 - None
;					 6 - Yellow (start)
;					 5 - Black (random reset)
;					 4 - Red
;					 3 - White
;					 2 - Green (manual reset 0)
;					 1 - Blue (manual reset 1)
;					 0 - None
;
; Local Variables:   None.
; Shared Variables:  switchDebPatt (R,W): The debounced switch pattern,
;										  returned to R16 
;					 debounceFlag   (W) : The debounce flag, reset to 0x00 if a debounced switch
;										  pattern is retrieved.
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
; Registers Changed: R0, R16, R17
; Stack Depth:       2 Bytes
;
; Author:            Steven Lei
; Last Modified:	 5/18/23

GetSwitches:			

CheckDebounce:						; check if there is a debounced switch pattern 
	RCALL	SwitchAvailable				; zero flag reset if debounced pattern exists
	BREQ 	CheckDebounce				; loop back (blocking) if zero flag set
	;BRNE	LoadDebounce				; else zero flag reset, so get pattern

LoadDebounce:						; load the switch pattern and reset the debounce flag
	IN		R0, SREG					; save interrupt flag status
	CLI									; can't interrupt this code

	LDS 	R16, switchDebPatt			; return the debounced switch pattern in R16			 
	LDI		R17, 0x00					; reset the debounce flag
	STS		debounceFlag, R17		
	
	OUT 	SREG, R0				; restore flags (possibly re-enabling interrupts)

DoneGetSwitches:					; done so return
	RET


; SwitchAvailable
;
; Description:       Determines if a debounced switch pattern is available and
;					 returns the zero flag reset (available) and set (not available).
;
; Operation:         Resets the zero flag if there is a debounced switch pattern
;					 and sets the zero flag if there is not a debounced switch pattern
;					 by checking if the debounceFlag flag is set.
;
;                    
; Arguments:         None.
; Return Value:      Zero flag reset/set if debounce flag set/reset respectively.
;
; Local Variables:   None.
; Shared Variables:  Zero Flag:		(W only): Reset if debounceFlag flag is set. Set otheriwse 
;					 debounceFlag: 	(R only): Loaded into R16 and READ to set/reset zero flag
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
; Stack Depth:       0
;
; Author:            Steven Lei
; Last Modified:	 5/18/23

SwitchAvailable:			; load and check if debounceFlag flag is set
	LDS		R16, debounceFlag	; load the flag
	CPI 	R16, 0x00			; zero flag set if debounceFlag = 00
								; else zero flag reset 

	RET 						; done so return


.dseg

debounceFlag:		.BYTE	1		; The switch debounce flag
debounceCntr:		.BYTE	2		; The switch debouncing counter

switchDebPatt:		.BYTE	1		; The new debounced switch pattern
switchOldPatt:		.BYTE	1		; The previous switch pattern
