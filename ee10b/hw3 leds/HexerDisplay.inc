;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                               HexerDisplay.INC                             ;
;                               Display Functions                            ;
;                           Hexer Game (AVR version)                         ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the definitions for the display functions for the
; Hexer Game.
;
; Revision History:
;    11/3/93   Glen George      initial revision
;    10/30/95  Glen George      updated comments
;    10/11/98  Glen George      added LED_BLANK constant
;                               updated comments
;    12/26/99  Glen George      updated comments
;     1/30/03  Glen George      changed NO_LED_DIGITS to NUM_LED_DIGITS and
;                                  NO_SEGS to NUM_SEGS
;     7/12/10  Glen George      changed name to CLKDISP2.INC and added
;                                  constants for AM/PM indicators
;                               removed LEDDisplay constant, it is now in
;                                  CPU80188.INC
;     9/04/10  Glen George      fixed LED definitions, the indicators are
;                                  actually at the first location
;    10/25/12  Glen George      added more constants for AM/PM indicators
;                               changed PM, Alarm, and colon indicator
;                                  locations to match new PCB
;     9/29/13  Glen George      fixed definitions for PM and Alarm indicators
;                               added PM_DIGIT constant
;     4/30/18  Glen George      converted to AVR version of the clock
;     5/08/18  Glen George      added INIT_SEG_PATT constant
;     8/25/18  Glen George      updated comments
;    06/09/23  Steven Lei       retrieved file from website



; Display Definitions


; General Hardware Definitions

.EQU    NUM_LED_DIGITS = 4              ;number of LED digits
.EQU    NUM_SEGS = 8                    ;number of segments (includes indicators)


; Specific Digit/LED Definitions

.EQU    LED_BLANK     = 0b00000000      ;a blank LED

.EQU    INIT_SEG_PATT = 0b00000001      ;initial segment drive pattern

.EQU    BUFFER_SIZE   = 7               ;size of buffer in bytes


.EQU    COLON_SEG     = 7               ;colons are the last segment
.EQU    COLON_DIGITS  = 0b00000110      ;colons are in digits 1 and 2

.EQU    PM_SEG        = 7               ;PM LED is on the last segment
.EQU    PM_DIGIT      = 3               ;PM LED is in digit 3
.EQU    PM_DIG_BIT    = 0b00001000      ;bit pattern for PM LED in digit 3

.EQU    ALARM_SEG     = 7               ;Alarm LED is on the last segment
.EQU    ALARM_DIG_BIT = 0b00000001      ;Alarm LED is in digit 0


; Masks for checking time values

.EQU    AMPM_MASK    = 0b11000000       ;mask to check for an AM or PM indicator
.EQU    AM_MASK      = 0b11000000       ;mask for the AM indicator.
.EQU    PM_MASK      = 0b11100000       ;mask for the PM indicator.
.EQU    PM_TIME_MASK = 0b00100000       ;mask to differentiate AM and PM
.EQU    PM_TIME_BIT  = 5                ;bit to differentiate AM and PM


; Port Definitions

.EQU    DIGIT_PORT = PORTA          ;LED digits are on port A
.EQU    SEGMENT_PORT = PORTC        ;LED segments are on port C