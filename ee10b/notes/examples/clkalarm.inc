;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                 CLKALARM.INC                               ;
;                           Alarm Function Constants                         ;
;                   Microprocessor-Based Clock (AVR version)                 ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the assembly language definitions for the alarm functions
; for the Microprocessor-Based Clock.
;
; Revision History:
;     7/12/10  Glen George      initial revision
;     8/25/18  Glen George      changed to AVR assembler syntax




; Alarm Constants

.EQU	ALARMTIMEOUT = 4           ;maximum time alarm should sound + 1
                                   ;   (this is 3 minutes if TimeoutAlarm
                                   ;    is called every minute)



; Hardware Definitions


;alarm hardware constants for 8088 version of the clock

.EQU    ALARM_OFF = 0b00000000 	   ;value to turn off the alarm
.EQU	ALARM_ON  = 0b00000001	   ;value to turn on the alarm


;alarm hardware constants

.EQU	TIMER1A_OFF = 0b00000000	;turn off timer 1
					;  00------  no output on OC1A
					;  --00----  no output on OC1B
					;  ----00--  reserved
					;  ------00  no PWM output

.EQU	TIMER1B_OFF = 0b00001000	;turn off timer 1
					;  0-------  disable noise canceler
					;  -0------  capture on falling edge
					;  --00----  reserved
					;  ----1---  clear on compare match
					;  -----000  turn off the timer

.EQU	TIMER1A_ON  = 0b00010000	;setup timer 1 for tone output on OC1B
					;  00------  no output on OC1A
					;  --01----  toggle OC1B output
					;  ----00--  reserved
					;  ------00  no PWM output

.EQU	TIMER1B_ON  = 0b00001001	;setup timer 1 for tone output on OC1B
					;  0-------  disable noise canceler
					;  -0------  capture on falling edge
					;  --00----  reserved
					;  ----1---  clear on compare match
					;  -----001  run timer on clk


.EQU	ALARM_FREQ = 461                ;gives a 2 KHz output
                                        ;1.8432 MHz / 2 KHz / 2 (50/50 duty cycle)
