;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                  CLKINIT                                   ;
;                          Initialization Functions                          ;
;                   Microprocessor-Based Clock (AVR version)                 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions for initializing the LED-based clock
; hardware.  The public functions included are:
;    InitPorts  - initialize the I/O ports
;    InitTimer0 - initialize timer 0 for interrupts
;
; Revision History:
;    12/08/12  Glen George      initial revision
;     9/21/13  Glen George      updated comments
;     4/20/18  Glen George      updated code for new hardware design
;     5/02/18  Glen George      changed name from init.asm to clkinit.asm
;     8/25/18  Glen George      changed to using timer 0 and corrected port
;                                  usage in InitPorts
;     4/02/19  Glen George      changed InitPorts to initialized Port D to all
;                                  inputs



; device definitions
;.include  "4414def.inc"

; local include files
;.include  "clkHW.inc"




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
; Registers Changed: flags, R16
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     April 2, 2019

InitPorts:
                                        ;initialize I/O port directions
        LDI     R16, OUTDATA            ;initialize Port A to all outputs
        OUT     DDRA, R16
        CLR     R16                     ;and all outputs are low (off)
        OUT     PORTA, R16

        LDI     R16, OUTDATA            ;initialize Port C to all outputs
        OUT     DDRC, R16
        CLR     R16                     ;and all outputs are low (off)
        OUT     PORTC, R16

        LDI     R16, INDATA             ;Port D is all inputs
        OUT     DDRD, R16

        LDI     R16, INDATA             ;port B is all inputs
        OUT     DDRB, R16


EndInitPorts:                           ;done so return
        RET




; InitTimer0
;
; Description:       This function initializes timer 0 for approximately one
;                    millisecond interrupts assuming a 1.8432 MHz clock.
;
; Operation:         This function sets up timer 0 for one millisecond
;                    interrupts (actully 1.111 ms).
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
; Author:            Glen George
; Last Modified:     August 25, 2018

InitTimer0:
                                        ;setup timer 0
	CLR	R16			;clear the count register
	OUT	TCNT0, R16		;   (not really necessary)
					;use CLK/8 as timer source, gives
	LDI	R16, TIMERCLK8		;   1.8432 MHz / 8 / 256 interrupt
	OUT	TCCR0, R16		;   rate = 900 Hz

	IN	R16, TIMSK		;get current timer interrupt masks
	ORI	R16, 1 << TOV0		;turn on timer 0 interrupts
	OUT	TIMSK, R16
        ;RJMP   EndInitTimer0           ;done setting up the timer


EndInitTimer0:                          ;done initializing the timer - return
        RET
