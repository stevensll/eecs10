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
;     4/24/18  Glen George      initial revision
;     4/02/19  Glen George      fixed "Display" switch definitions
;    05/18/23  Steven Lei		retrieved file from website 
;    05/19/23  Steven Lei 		changed port definition and added mask definition

; Switch definitions

;Timing parameters (assumes 1 ms interrupt)

.EQU	DEBOUNCE_TIME = 10              ;debouncing time (10ms)
.EQU	REPEAT_TIME   = 5000            ;time until start fast repeating (5s)
.EQU	SLOW_RATE     = 2000            ;slow repeat rate (1/2 Hz)
.EQU	FAST_RATE     = 500             ;fast repeat rate (2 Hz)

; Port used is E

.EQU      SWITCH_PORT = PINE            ;switches are on port E

; Switch mask used to set bits 7 and 0, since only 6 buttons exist

.EQU    SWITCH_MASK = 0b10000001