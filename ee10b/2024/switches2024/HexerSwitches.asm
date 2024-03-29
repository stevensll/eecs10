;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                 HexerSwitches                              ;
;                                Switch Routines                             ;
;                 Microprocessor-Based Hexer Game (AVR version)              ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the procedures for debouncing switches for the Hexer Game.
; included public functions are:
;	DebounceSwitches:	debounces the switch pattern pressed using variable
;					   	auto repeat
;	InitSwitches:		initializes variables used for debouncing
; 	SwitchAvailable:	checks if a debounced switch is available
;   GetSwitches:		waits until a debounced switch is available and returns 
;					   	it

; included local functions are:
; 	none

; Revision history:
;	05/18/23	Steven Lei		Initial revision
;	05/19/23    Steven Lei      Successful implementation with non variable 
;								repeat rate 
;   05/19/23	Steven Lei		Updated comments    
;   05/21/23	Steven Lei		Fixed DebounceSwitches by adding switch up 
;						        condition and correct instruction calls
;	03/29/24	Steven Lei		Change oldSwitchPatt and debSwitchPatt to
;								prevSwitchPatt and newSwitchPatt for clarity.
;								Added variable repeat rate in Debounce Switches.
;								Added ResestCountersAndRate procedure to make
;								InitSwitches and DebounceSwitches procedures 
;								less redundant when resetting counters and rate.	

; ResetCountersAndRate
;
; Description:       Resets the debounce counter, repeat counter, and repeat 
;					 rate used for timing switch debounces.
;					  
; Operation:         Resets the debounce counter to the debounce time (10ms),
;					 the repeat counter to the repeat time until fast rate, and
;					 the repeat rate to the slow rate. 
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  debounceCounter:	Counter used for debouncing and WRITTEN 
;									    as the debounce time (10 ms).
;					 repeatCounter:		Counter used for counting until the 
;										repeat rate is switched to fast, WRITTEN
;										as the fast repeat time (5s)
;					 repeatRate:		The rate in which a repeated switch 
;										pattern is debounced, first slow (2s)
;										then fast (500ms).
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
; Limitations:		 None.
; Special notes:	 None.
;
; Author:            Steven Lei
; Last Modified:	 03/29/2024


ResetCountersAndRate:				; reset the counters and the repeat rate

ResetDebounceCounter:					; reset the debounce counter
	LDI		R16, LOW(DEBOUNCE_TIME)		
	STS		debounceCounter, R16
	LDI		R16, HIGH(DEBOUNCE_TIME)	
	STS		debounceCounter+1, R16

ResetRepeatCounter:						; reset the repeat counter
	LDI		R16, LOW(FAST_REPEAT_TIME)	
	STS		repeatCounter, R16
	LDI		R16, HIGH(FAST_REPEAT_TIME)	
	STS		repeatCounter+1, R16

ResetRepeatRate:						; reset the repeat rate to slow
	LDI		R16, LOW(SLOW_RATE)			; reset the repeat rate to slow
	STS 	repeatRate, R16		
	LDI		R16, HIGH(SLOW_RATE)			
	STS 	repeatRate+1, R16	

DoneResetCountersAndRate:				; done resetting everything so return
	RET


; InitSwitches
;
; Description:       Initializes the variables for the DebounceSwitches
;					 procedure.
;					  
; Operation:         Resets the debounce counter, the repeat counter, and the 
;					 repeat rate. The debounce flag is also reset to FALSE.
;					 The old and new switch pattern variables are reset to
;					 SWITCH_UP (all bits are high when switch is not pressed).
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  debounceCounter:	Counter used for debouncing and WRITTEN 
;									    as the debounce time (10 ms).
;					 repeatCounter:		Counter used for counting until the 
;										repeat rate is switched to fast, WRITTEN
;										as the fast repeat time (5s)
;					 repeatRate:		The rate in which a repeated switch 
;										pattern is debounced, WRITTEN as 
;										the slow rate (500ms)
;					 debounceFlag: 		Flag indicating if a switch is 
;										debounced, WRITTEN to false.
;					 prevSwitchPatt:	Previous switch pattern, WRITTEN to 
;										SWITCH_UP
;					 newSwitchPatt: 	New debounced switch pattern, WRITTEN to 
;										SWITCH_UP 
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
; Limitations:		 None.
; Special notes:	 None.
;
; Author:            Steven Lei
; Last Modified:	 03/29/2024

InitSwitches:

ResetCountersRepeatRate:		; reset the counters and the repeat rate
	RCALL 	ResetCountersAndRate

ResetDebounceFlag:				; reset the debounce flag
	LDS		R16, FALSE						
	STS		debounceFlag, R16

ResetSwitchPatterns:			; set the prev and new switch patt bits to high
	LDS		R16, SWITCH_UP			; (none pressed)
	STS		newSwitchPatt, R16
	STS		prevSwitchPatt, R16

; DebounceSwitches
;
; Description:       Checks for a new switch pattern being pressed if none is
;					 currently being pressed, or debounces the currently pressed
;					 switches. This procedure is expected to be called by the 
;					 timer interrupt event handler every 1 ms. It uses variable
;					 auto repeat if a switch pattern is held down for a period
;					 of time (5s).
;					  
; Operation:         Upon every call, the new switch pattern pressed (input from 
;					 pin E) is compared with the old switch pattern. If the
;					 pattern is the same AND is not switch up (no switches 
;					 pressed), the debounce counter will decrement. It will then
;					 check if the debounce counter hits 0, meaning the switch
;					 pattern can be returned and the debounce flag will be set.
;					 It will also decrement the repeat counter until it hits 
;					 zero, in which the repeat rate will be changed. If the new 
;					 pattern does not satisfy these  conditions, all counters 
;					 and the repeat rate will be reset.
;                    
; Arguments:         None.
; Return Value:      None
;
; Local Variables:   None.
; Shared Variables:  prevSwitchPatt: 	the previously inputted switch pattern, 
;										READ to check if equal to input 
;										pattern, WRITTEN to update the old  
;										pattern to the input pattern			
;					 newSwitchPatt:		the fully debounced switch pattern, 
;									 	WRITTEN as the input pattern if the
;										debounce counter hits 0.
;					 debounceFlag:   	the debounce flag, WRITTEN as true 
;										if the debounce counter hits 0. 
; 					 debounceCounter:	Counter used for debouncing and WRITTEN 
;									    as the debounce time (10 ms).
;					 repeatCounter:		Counter used for counting until the 
;										repeat rate is switched to fast, WRITTEN
;										as the fast repeat time (5s)
;					 repeatRate:		The rate in which a repeated switch 
;										pattern is debounced, first slow (2s)
;										then fast (500ms).
; Global Variables:  None.
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
; Registers Changed: Flags, R16, R17, Z (ZL | ZH)
; Stack Depth:       0
;
; Limitations:		 None.
; Special notes:	 A pressed switch is represented by a low bit (0).
;
; Author:            Steven Lei
; Last Modified:	 03/27/24
;


DebounceSwitches:

GetSwitchPattern:					; first get the switch pattern pressed
	IN		R16, SWITCH_PORT			
	ORI		R16, SWITCH_MASK			; mask unused bits 7 and 0 to high 

CheckSwitchPatternUp:				; check if all switches are up
	CPI 	R16, SWITCH_UP				; up pattern means no switches pressed
	BREQ	ResetCountersAndRate		; no switches pressed, so reset counters
	;BRNE	CheckSwitchPatternSame		; else compare previous and new patterns

CheckSwitchPatternSame:				; compare the new and previous patterns
	LDS 	R17, prevSwitchPatt			; load the previous pattern
	STS		prevSwitchPatt, R16			; update the previous pattern in memory
	CP 		R16, R17					; if previous and new patterns are same
	BREQ	DecrementDebounceCounter		; decrement debounce counter
	;BRNE	ResetCountersAndRate		; else reset the counters and rate

ResetCountersRate:				; reset the counters and the repeat rate
	RCALL 	ResetCountersAndRate	
	RJMP	DebounceSwitchesDone		; done resetting counters and rate

DecrementDebounceCounter:		; decrement the debounce counter until 0
	LDS		ZL, debounceCounter		; load the counter value
	LDS		ZH, debounceCounter+1		
	SBIW	Z,	1					; decrement the counter by 1
	STS		debounceCounter, ZL		; write the updated counter value back			
	STS 	debounceCounter+1, ZH		
	BRNE	DecrementRepeatCounter 	; counter is not 0, so update repeat counter
	;BREQ	UpdateDebounceFlagAndPattern; else update debounce flag and pattern 

UpdateDebounceFlagAndPattern:	; update debounce flag and new switch pattern
	STS		newSwitchPatt, R16		; store the new switch pattern to memory
	LDS		R16, TRUE				; set the debounce flag
	STS		debounceFlag, R16 		

UpdateDebounceCounter:			; update the debounce counter to repeat rate	
	LDS		R16, repeatRate 		
	STS		debounceCounter, R16			
	LDS		R16, repeatRate+1
	STS		debounceCounter+1, R16	

DecrementRepeatCounter:			; decrement the repeat counter
	LDS		ZL, repeatCounter			; load the counter value
	LDS		ZH, repeatCounter+1		
	SBIW	Z,	1						; decrement the counter by 1
	STS		repeatCounter, ZL			; write the updated counter value back			
	STS 	repeatCounter+1, ZH	
	BRNE 	DebounceSwitchesDone		; counter not 0, so don't modify rate
	;BREQ 	UpdateRepeatRate			; else update repeat rate to fast

UpdateRepeatRate:						; update the repeat rate to fast rate
	LDS		R16, LOW(FAST_RATE)				
	STS		repeatRate, R16
	LDS		R16, HIGH(FAST_RATE)
	STS 	repeatRate+1, R16		

DebounceSwitchesDone:					; done debouncing switches so return
	RET		

; GetSwitches
;
; Description:      Returns the fully debounced code of the switch pattern that
;					was pressed by the user. This procedure is blocking since
;					it does not return until a switch has been pressed and 
;					debounced (but not necessarily released). The switch code 
;					is defined below.
;
; Operation:        Calls the SwitchAvailable() function with a blocking 
;					loop until the function returns true. Then returns the
;					debounced switch pattern in the register R16. Also resets
;					the debounce flag if a pattern is debounced. Note that
;					this is critical code because the debounced switch pattern
;					and debounce flag can't be changed while this procedure
;					is running. Thus, interrupts must be briefly disabled
;					and then re-enabled.
;					 
; Arguments:        None.
; Return Value:     newSwitchPatt: 8 bit debounced switch pattern in R16,
;					with each bit representing a switch in (reverse) one hot:
;						Bit code		Switch Pressed	Function
;						11011111		Black			Black hexagon rotator
;						11101111		Red				Red triangle rotator
;						11110111		White			White hexagon inverter
;						11111011		Green			Green triangle rotator
;						11111101		Blue			Blue hexagon rotator
;						10011111		Yellow + Black	Random reset
;						10111101		Yellow + Green	Manual reset 0
;						10111110		Yellow + Blue	Manual reset 1
;						Any other switch pattern does not do anything
;
; Local Variables:   None.
; Shared Variables:  newSwitchPatt:		The debounced switch pattern is READ to
;										R16.
;					 debounceFlag: 		WRITTEN to FALSE if a debounced switch
;										pattern is found.
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
; Special notes:	 A pressed switch is represented by a low bit (0).
;
; Registers Changed: R0, R16, R17
; Stack Depth:       0 bytes
;
; Author:            Steven Lei
; Last Modified:	 03/26/24

GetSwitches:

CheckSwitchAvailable:			; check if a there is a debounced pattern
	RCALL	SwitchAvailable			; update the Zero Flag for branching
	BREQ	CheckSwitchAvailable	; debounce pattern is not available
	;BRNE	LoadDebouncedPatt		; debounced pattern is avaialble

LoadDebouncedPatt:				; load the pattern and reset debounce flag
	IN		R0, SREG				; save interrupt flag status
	CLI								; can't interrupt this code

	LDS		R16, newSwitchPatt		; return the debounced pattern to R16
	LDI		R17, FALSE				; reset the debounce flag to FALSE
	STS		debounceFlag, R17			

	OUT		SREG, R0				; restore flags (could re-enable interrupts)

DoneGetSwitches:					; done so return
	RET

; SwitchAvailable
;
; Description:       Returns with the zero flag FALSE (reset) if a debounced  
;					 switch pattern is available and TRUE (set) otherwise. This 
;					 allows the blocking loop in GetSwitches() to terminate.
;
; Operation:         Resets the zero flag if there is a debounced switch pattern
;					 (debounceFlag is TRUE) and sets the zero flag otherwise
;					 (debounceFlag is FALSE). The debounceFlag is modified by
;					 the DebounceSwitches() funciton.
;                    
; Arguments:         None.
; Return Value:      Zero Flag RESET or Zero Flag SET in SREG.
;
; Local Variables:   None.
; Shared Variables:  Zero Flag:		WRITEN as FALSE if debounceFlag is TRUE, 
;									else TRUE if debounceFlag is FALSE. 
;					 debounceFlag: 	READ in R16 to set/reset Zero Flag. 
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
; Special notes:	 None.
;
; Registers Changed: R16
; Stack Depth:       0
;
; Author:            Steven Lei
; Last Modified:	 03/27/24


SwitchAvailable:				;check if the switch debounce flag is set
   	LDS		R16, debounceFlag		
	CPI		R16, FALSE				; zero flag will be TRUE if debounceFlag is  
									; FALSE, else zero flag will be FALSE
	RET								; done so return


.dseg

debounceFlag:			.BYTE	1	; The switch debounce flag
debounceCounter:		.BYTE	2	; The switch debounce counter.
repeatCounter: 			.BYTE	2	; The repeat counter to change to FAST_RATE
repeatRate:				.BYTE	2	; The repeat rate (fast or slow) that is 
										; used if the switch press is repeating
newSwitchPatt:			.BYTE	1	; The new debounced switch pattern
prevSwitchPatt:			.BYTE	1	; The previously inputted switch pattern

