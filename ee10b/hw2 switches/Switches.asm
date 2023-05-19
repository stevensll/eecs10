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
;	


.cseg

; GetSwitches()
;
; Description:       Returns the debounced switch pattern in R16 after a switch
;					 was pressed and debounced. This procedure is a blocking function
;					 since it does not return until a switch has been pressed and debounced.
;
; Operation:         Blocking loop until a debounced switch pattern is available 
;					 (from calling SwitchAvailable()). Returns the debounced pattern
;				     into R16, with each bit representing a switch in a one hot scheme:
;					 7 - None
;					 6 - Yellow (start)
;					 5 - Black (random reset)
;					 4 - Red
;					 3 - White
;					 2 - Green (manual reset 0)
;					 1 - Blue (manual reset 1)
;					 0 - None
;                    
; Arguments:         None.
; Return Value:      R16
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
; Registers Changed: R16
; Stack Depth:       
;
; Author:            Steven Lei
; Last Modified:	 5/18/23

GetSwitches:			

CheckDebounce:					; check if there is a debounced switch pattern 
	RCALL	SwitchAvailable			; zero flag reset if debounced pattern exists
	BREQ 	CheckDebounce			; loop back (blocking) if zero flag set
	;BRNE	LoadDebounce			;lbranch if zero flag reset

LoadDebounce:					; load the switch pattern and reset the debounce flag
	LDS 	R19, switchNewPatt		; load the switch pattern
	LDS 	R16, swDebounced		; reset debounce flag
	LDS		R17, 0x00					; 0 is reset
	STS		swDebounced, R17		

DoneGetSwitches:				; done so return
	RET



; SwitchAvailable()
;
; Description:       Determines if a debounced switch pattern is available and
;					 returns the zero flag reset (available) and set (not available).
;
; Operation:         Resets the zero flag if there is a debounced switch pattern
;					 and sets the zero flag if there is not a debounced witch pattern
;					 by checking if the swDebounced flag is set.
;
;                    
; Arguments:         None.
; Return Value:      
;
; Local Variables:   None.
; Shared Variables:  Zero Flag:		(W only): Reset if swDebounced flag is set. set otheriwse 
;					 swDebounced: 	(R only): Loaded into R16 and read to set/reset zero flag
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


SwitchAvailable:			; load and check if swDebounced flag is set
	LDS		R16, swDebounced		; load the flag
	CPI 	R16, 0x00				; zero flag set if equal (swDebounced is not set)
									; else reset 

	RET 						; done so return


; InitSwitches()
;
; Description:       Initializes the shared variables for the DebounceSwitches()
;					 procedure.
;					  
; Operation:         
;                    
; Arguments:         None.
; Return Value:      None
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
; Registers Changed: 
; Stack Depth:       
;
; Author:            Steven Lei
; Last Modified:	 5/18/23

; DebounceSwitches()
;
; Description:       Checks for a new switch pattern being pressed if none is
;					 currently being pressed, or debounces the currently pressed
;					 switches. This procedure is expected to be called by the 
;					 event handler ever 1 ms.
;					  
; Operation:         Upon every call, the new switch pattern pressed (input from pin E)
;					 is compared with the old switch pattern (switchOldPatt). If the
;					 pattern is the same, the counter (debounceCntr) decrements, 
;					 else it resets to the debounce time (10ms). When the counter 
;					 reaches zero, the swDebounced flag is set, indicating that the 
;					 switch is successfully debounced. The counter is then set to the
;					 repeat rate (5000 ms). 
;                    
; Arguments:         None.
; Return Value:      None
;
; Local Variables:   None.
; Shared Variables:  switchOldPatt (R,W): the previous switch pattern, 
;					 READ to check if equal to new pattern and WRITTEN 
;					 
;					 swDebounced   (W):
;					 switchNewPatt (W):
;					 debounceCntr  (R,W):
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
; Registers Changed: R16, R17, Z
; Stack Depth:       0
;
; Author:            Steven Lei
; Last Modified:	 5/18/23

DebounceSwitches:

GetInput:								; get input switch pattern
	IN		R17, SWITCH_PORT				; load it
	ORI		R17, SWITCH_MASK				; mask bits 0 and 7

CompareNewOldPatts:						; check if current switch pattern is same as previous
	LDS 	R16, switchOldPatt				; load the previous pattern
	CP 		R16, R17						; check if old  = new pattern
	STS		switchOldPatt, R17				; update the old pattern
	BREQ	DecDebounceCounter				; if equal, decrement debounce counter			
	;BRNE	ResetDebounceCounter			; else reset debounce counter

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
	BREQ	SetDebounceFlag					; if 0, set debounce flag and set debounce counter
	;BRNE									; else, return

UpdateFlag&Switch:						; set debounce flag and update switch pattern
	STS		switchNewPatt, R17				; store the new pattern
	LDS 	R16, 0xFF						; set the flag to FF
	STS		swDebounced, R16				; 
	LDS 	R16, LOW(REPEAT_RATE)			; set the debounce counter to the repeat rate
	STS		debounceCntr, R16				
	LDS		R16, HIGH(REPEAT_RATE)
	STS 	debounceCntr+1, R16

DebounceSwitchesDone					; done handling debouncing
	RET										; and return

.dseg

swDebounced:		.BYTE	1		;
debounceCntr:		.BYTE	2		;

switchNewPatt:		.BYTE	1		;
swithOldPatt:		.BYTE	1		;

