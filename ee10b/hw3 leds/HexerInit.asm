;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                 HexerInit                                  ;
;                          Initialization Functions                          ;
;                   		Hexer Game (AVR version)                 	     ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions for initializing the Hexer game clock and IO port
; hardware. The public functions included are:
;    InitPorts     - initialize the I/O ports
;    InitTimer0 - initialize timer 0 for interrupts
;
; Revision History:
;    05/18/23  Steven Lei      initial revision, 
;							   		code based on "clkinit.asm" in examples from website
;									revised: Port E set to all inputs
;											 timer set to 1 ms in Output Compare mode.
;
;    05/18/23  Steven Lei      updated comments

.cseg 

; InitPorts
;
; Description:       This procedure initializes the I/O ports for the system.
;
; Operation:         The direction bits are set appropriately for the ports
;                    and all outputs are turned off.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             None.
; Output:            The I/O ports are initialized and all outputs are turned
;                    off.
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

InitPorts:
                                        ;initialize I/O port directions
        LDI     R16, INDATA             ;Port E is all inputs
        OUT     DDRE, R16

EndInitPorts:                           ;done so return
        RET


; InitTimer0
;
; Description:       This function initializes timer 0 for approximately one
;                    millisecond interrupts assuming a 8 MHz clock.
;
; Operation:         This function sets up timer 0 for one millisecond
;                    interrupts. The Output Compare interrupt is turned on
;					 to achieve exactly 1 KHz.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             None.
; Output:            Timer 0 is initialized.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16
; Stack Depth:       0 bytes
;
; Author:            Steven Lei
; Last Modified:     5/18/2023



InitTimer0:
                                	;setup timer 0
	CLR		R16							;clear the count register
	OUT		TCNT0, R16					;   (not really necessary)
									;use CLK/8 as timer source, gives
	LDI		R16, TIMERCLK64				;   8 MHz / 64 / 125 interrupt
	OUT		TCCR0, R16					;   rate = 1KHz (1ms)
									;use compare interrupts
	LDI 	R16, 125					; set the rate to 125
	OUT 	OCR0, R16

	IN		R16, TIMSK					;get current timer interrupt masks
	ORI		R16, 1 << OCIE0				;turn on timer 0 compare interrupts
	OUT		TIMSK, R16

   	;RJMP   EndInitTimer0   		;done setting up the timer


EndInitTimer0:                  	;done initializing the timer - return
	RET