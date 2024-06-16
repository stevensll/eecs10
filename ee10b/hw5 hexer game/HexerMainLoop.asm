;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   HexerLoop                                ;
;                            Homework #5 Game Main loop                      ;
;                                  EE/CS 10b                                 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; This file contains the main loop code for homework #5.  The function makes a
; number of calls to the display functions to test them.  The functions
; included are:
;    DisplayTest - test the homework display functions
;
; Revision History:

;   06/15/23  Steven Lei                retrieved from website


;set the device
.device ATMEGA64

;get the definitions for the device
.include  "m64def.inc"

; local include files
.include "HexerHW.inc"              ; Hardware constants
.include "HexerGame.inc"            ; Game constants
.include "HexerDisplay.inc"         ; Procedures for displaying LEDS
.include "HexerSwitches.inc"        ; Procedures for debouncing switches


.cseg

; setup the vector area
.org	$0000

	JMP	Start		;reset vector
	JMP	PC			;external interrupt 0
	JMP	PC			;external interrupt 1
	JMP	PC			;external interrupt 2
	JMP	PC			;external interrupt 3
	JMP	PC			;external interrupt 4
	JMP	PC			;external interrupt 5
	JMP	PC			;external interrupt 6
	JMP	PC			;external interrupt 7
	JMP	PC			;timer 2 compare match
	JMP	PC			;timer 2 overflow
	JMP	PC			;timer 1 capture
	JMP	PC			;timer 1 compare match A
	JMP	PC			;timer 1 compare match B
	JMP	PC			;timer 1 overflow
	JMP	Timer0CompareHandler          ;timer 0 compare match
	JMP	PC		    ;timer 0 overflow
	JMP	PC			;SPI transfer complete
	JMP	PC			;UART 0 Rx complete
	JMP	PC			;UART 0 Tx empty
	JMP	PC			;UART 0 Tx complete
	JMP	PC			;ADC conversion complete
	JMP	PC			;EEPROM ready
	JMP	PC			;analog comparator
	JMP	PC			;timer 1 compare match C
	JMP	PC			;timer 3 capture
	JMP	PC     		;timer 3 compare match A
	JMP	PC			;timer 3 compare match B
	JMP	PC			;timer 3 compare match C
	JMP	PC			;timer 3 overflow
	JMP	PC			;UART 1 Rx complete
	JMP	PC			;UART 1 Tx empty
	JMP	PC			;UART 1 Tx complete
	JMP	PC			;Two-wire serial interface
	JMP	PC			;store program memory ready

; start of the actual program

Start:							;start the CPU after a reset
	LDI	R16, LOW(TopOfStack)		;initialize the stack pointer
	OUT	SPL, R16
	LDI	R16, HIGH(TopOfStack)
	OUT	SPH, R16

	CALL	InitPorts				;initialize I/O ports 
	CALL 	InitTimer0				;initialize timer0
	CALL	InitDisplay             ;initialize display variables
    CALL    InitSwitches            ;initialize switch variables
	CALL    InitMoveCounter         

    SEI								;ready to go, allow interrupts

    RCALL   HexerPlayLoop      		;play the hexer game
	
    RJMP	Start					;shouldn't return, but if it does, restart


.dseg
;
; the stack - 128 bytes
                .BYTE   127
TopOfStack:     .BYTE   1       ;top of stack

; since don't have a linker, include all the .asm files
.include "HexerInit.asm"		; initialize timer and IO ports
.include "HexerGame.asm"        ; the Hexer Game.
.include "Display.asm"			; display procedures
.include "Switches.asm"			; switch procedures
.include "HexerIRQ.asm"			; handle interrupts 
.include "Segtable.asm"			; seg table for displays
.include "RotationTables.asm"   ; the rotation tables for the game leds
