;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                  CLKSW.INC                                 ;
;                               Switch Functions                             ;
;                   Microprocessor-Based Clock (AVR version)                 ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the definitions for the switch functions for the
; Microprocessor-Based Clock.
;
; Revision History:
;     4/24/18  Glen George      initial revision
;     4/02/19  Glen George      fixed "Display" switch definitions



;Switch definitions

;Timing parameters (assumes 1 ms interrupt)

.EQU	DEBOUNCE_TIME = 10              ;debouncing time (10ms)
.EQU	REPEAT_TIME   = 5000            ;time until start fast repeating (5s)
.EQU	SLOW_RATE     = 2000            ;slow repeat rate (1/2 Hz)
.EQU	FAST_RATE     = 500             ;fast repeat rate (2 Hz)


;Hardware definitions

.EQU	  SET_HR_SW_BIT   = 0b00010000  ;"Hour Set" switch
.EQU	  SET_MIN_SW_BIT  = 0b00000100  ;"Minute Set" switch
.EQU	  ALARM_SW_BIT    = 0b00001000  ;"Alarm On/Off" switch
.EQU	  SNOOZE_SW_BIT   = 0b00000010  ;"Snooze" switch
.EQU	  SET_SW_BIT      = 0b00000001  ;"Set" switch
.EQU	  DISPLAY_SW_MASK = 0b11100000  ;"Display" switch
.EQU	  DISPLAY_TIME    = 0b01100000  ;"Display" switch in "Time" position
.EQU	  DISPLAY_ALARM   = 0b11000000  ;"Display" switch in "Alarm" position
.EQU	  DISPLAY_SNOOZE  = 0b10100000  ;"Display" switch in "Snooze" position

.EQU      SWITCH_PORT = PIND            ;switches are on port D
