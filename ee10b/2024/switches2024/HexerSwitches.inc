;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                               HexerSwitches.INC                            ;
;                               Switch Functions                             ;
;							Hexer Game (AVR version)					     ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the definitions for the switch functions for the
; Hexer Game. 
;
; Revision History:
;    05/19/23  Steven Lei       initial revision. Adapted from "clcksw.inc" in
;                               EXAMPLES from Glen's website.
;    05/19/23  Steven Lei 		added port definition and mask definition
; 	 05/21/23  Steven Lei		added switch up definition
;    03/27/24  Steven Lei       updated comments and formatting

; Switch definitions

; Timing parameters (assumes 1 ms interrupt)

.EQU	DEBOUNCE_TIME    = 10          ; debouncing time (10ms)
.EQU	FAST_REPEAT_TIME = 500         ; time until start fast repeat (500 ms)
.EQU	SLOW_RATE        = 200         ; slow repeat rate (200 ms)
.EQU	FAST_RATE        = 50          ; fast repeat rate (50 ms)

; Hardware definitions
.EQU    SWITCH_PORT = PINE              ; switches are on port E
.EQU    SWITCH_MASK = 0b10000001        ; mask bits 7 and 0 since only 6 buttons
.EQU	SWITCH_UP   = 0b11111111        ; switches are up when all bits are set

; General constants
.EQU    TRUE  = 0b11111111              ; boolean TRUE is all bits high 
.EQU    FALSE = 0b00000000              ; boolean FALSE is all bits low