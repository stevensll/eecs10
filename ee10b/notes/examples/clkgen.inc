;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                  clkgen.inc                                ;
;                              General Constants                             ;
;                   Microprocessor-Based Clock (AVR version)                 ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the general assembly language definitions for the
; Microprocessor-Based Clock.
;
; Revision History:
;     7/12/10  Glen George      initial revision
;     9/30/10  Glen George      added some snooze constants and updated values
;                                  to not display hours
;     9/29/13  Glen George      changed the hours on the snooze constants to
;                                  make them correctly not display hours
;     4/24/18  Glen George      changed to AVR assembly
;     5/08/18  Glen George      fixed some syntax errors
;     8/25/18  Glen George      updated constant values




; General Constants

.EQU    TRUE = 0xFF			;a true boolean value
.EQU	FALSE = 0			;a false boolean value



; Time Constants

.EQU	MIDNITE     = 0xD200            ;midnite in 12-hour format

.EQU	SNOOZE_ZERO = 0xCC00            ;a zero value for the snooze time
.EQU	INIT_SNOOZE = 0xCC05            ;snooze time is initially 5 minutes
.EQU	MIN_SNOOZE  = 0xCC03            ;minimum snooze time is 3 minutes
.EQU	MAX_SNOOZE  = 0xCC59            ;maximum snooze time is 59 minutes
                                        ;note: high bye is CC to turn off
                                        ;      AM/PM indicator and hours

.EQU    SECOND_CNT    = 900             ;number of interrupts per second
.EQU	SEC_CNT_NUM   = 0		;   (is exactly 900 Hz so don't need
.EQU	SEC_CNT_DENOM = 50000		;   fractional part)

.EQU    MINUTE_CNT    = 60              ;number of seconds in a minute

.EQU    COLON_RATE    = 450             ;colon blink rate (about 1 Hz)
