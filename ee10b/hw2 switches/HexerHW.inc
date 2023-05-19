;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                HexerHW.inc                                 ;
;                            Hardware Include File                           ;
;                   Microprocessor-Based Clock (AVR version)                 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the hardware definitions for the clock, IO ports, and 
; switch routines.
;
; Revision History:
;    12/09/12  Glen George      initial revision
;     9/21/13  Glen George      changed fractional part from .1085 to .10852
;     9/21/13  Glen George      updated comments
;     4/20/18  Glen George      updated to match new hardware
;     5/02/18  Glen George      created from original clock.inc file
;     8/25/18  Glen George      added Timer 0 values
;     4/02/19  Glen George      removed PORTD_DIR, not needed in new hardware
;	 05/18/23  Steven Lei		updated TIMERCLK32,64,256,1024 definitions
;    05/19/23  Steven Lei       added switch routine definitions.



;setup values for Timer 0

.EQU    TIMERCLKSTOP = 0b00000000	;stop the timer clock
.EQU    TIMERCLK1    = 0b00000001	;timer runs at CLK
.EQU    TIMERCLK8    = 0b00000010	;timer runs at CLK/8
.EQU 	TIMERCLK32	 = 0b00000011	;timer runs at CLK/32
.EQU    TIMERCLK64   = 0b00000100	;timer runs at CLK/64
.EQU    TIMERCLK256  = 0b00000110	;timer runs at CLK/256
.EQU    TIMERCLK1024 = 0b00000111	;timer runs at CLK/1024
.EQU    TIMERCLKEXTF = 0b00000110	;timer clocks on falling edge of T0/T1
.EQU    TIMERCLKEXTR = 0b00000111	;timer clocks on rising edge of T0/T1

; I/O port definitions

.EQU	OUTDATA    = 0b11111111		;data direction 1 is output
.EQU    INDATA     = 0b00000000		;data direction 0 is input

; Switch definitions

;Timing parameters (assumes 1 ms interrupt)

.EQU	DEBOUNCE_TIME = 10              ;debouncing time (10ms)
.EQU	REPEAT_TIME   = 5000            ;time until start fast repeating (5s)
.EQU	SLOW_RATE     = 2000            ;slow repeat rate (1/2 Hz)
.EQU	FAST_RATE     = 500             ;fast repeat rate (2 Hz)

; Port used is E

.EQU      SWITCH_PORT = PINE            ;switches are on port D

; Switch mask used to set bits 7 and 0, since only 6 buttons exist

.EQU    SWITCH_MASK = 0b10000001