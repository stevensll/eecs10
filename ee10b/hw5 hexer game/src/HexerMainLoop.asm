;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                 HexerMainLoop                              ;
;                            Hexer Game - Main loop                          ;
;                              	  EE/CS 10b - HW5                            ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; This file contains the main loop code for the Hexer Game. It intializes all 
; utilities used for the Hexer Game (switches, display, audio, and SPI [not
; implemented]). It then calls the HexerPlayGame from the HexerGame.asm file
; which handles all user inputs and updates the game state.

; Revision History:
;	06/15/23  Steven Lei				created file
;   06/17/24  Steven Lei                finished main loop

; set the device
.device ATMEGA64

; get the definitions for the device
.include  "m64def.inc"

; local include files
.include "HexerHW.inc"              ; Hardware constants
.include "HexerGame.inc"            ; Gameplay and user input constants
.include "HexerDisplay.inc"         ; Display (LEDs and 7-Seg) constants
.include "HexerSwitches.inc"        ; Switch debouncing constants

; code segment
.cseg

; setup the vector area
.org	$0000

	JMP	Start						;reset vector
	JMP	PC							;external interrupt 0
	JMP	PC							;external interrupt 1
	JMP	PC							;external interrupt 2
	JMP	PC							;external interrupt 3
	JMP	PC							;external interrupt 4
	JMP	PC							;external interrupt 5
	JMP	PC							;external interrupt 6
	JMP	PC							;external interrupt 7
	JMP	PC							;timer 2 compare match
	JMP	PC							;timer 2 overflow
	JMP	PC							;timer 1 capture
	JMP	PC							;timer 1 compare match A
	JMP	PC							;timer 1 compare match B
	JMP	PC							;timer 1 overflow
	JMP	Timer0CompareHandler       	;timer 0 compare match
	JMP	PC		    				;timer 0 overflow
	JMP	PC							;SPI transfer complete
	JMP	PC							;UART 0 Rx complete
	JMP	PC							;UART 0 Tx empty
	JMP	PC							;UART 0 Tx complete
	JMP	PC							;ADC conversion complete
	JMP	PC							;EEPROM ready
	JMP	PC							;analog comparator
	JMP	PC							;timer 1 compare match C
	JMP	PC							;timer 3 capture
	JMP	PC     						;timer 3 compare match A
	JMP	PC							;timer 3 compare match B
	JMP	PC							;timer 3 compare match C
	JMP	PC							;timer 3 overflow
	JMP	PC							;UART 1 Rx complete
	JMP	PC							;UART 1 Tx empty
	JMP	PC							;UART 1 Tx complete
	JMP	PC							;Two-wire serial interface
	JMP	PC							;store program memory ready

; start of the actual program

Start:							;start the CPU after a reset
	LDI	R16, LOW(TopOfStack)		;initialize the stack pointer
	OUT	SPL, R16
	LDI	R16, HIGH(TopOfStack)
	OUT	SPH, R16

	RCALL	InitPorts				;initialize I/O ports 
	RCALL 	InitTimer0				;initialize Timer0 for compare matches
	RCALL	InitDisplay             ;initialize display variables
    RCALL   InitSwitches            ;initialize switch variables
	RCALL   InitHexerGame         	;initialize Hexer variables

    SEI								;ready to go, allow interrupts

    RCALL   HexerPlayGameLoop      	;play the HexerGame and loop infinitely
	
    RJMP	Start					;shouldn't return, but if it does, restart


; data segment
.dseg


; the stack - 128 bytes
                .BYTE   127
TopOfStack:     .BYTE   1       ;top of stack

; since don't have a linker, include all the .asm files
.include "HexerInit.asm"		; initialize timer and IO ports
.include "HexerGame.asm"        ; the Hexer Game.
.include "HexerIRQ.asm"			; handle interrupts 
.include "Display.asm"			; display procedures
.include "Switches.asm"			; switch procedures
.include "Segtable.asm"			; seg table for displays
.include "RotationTables.asm"   ; the rotation tables for the game leds
									; include this last so the PC can reach
									; other code
