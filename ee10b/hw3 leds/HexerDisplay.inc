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
;    06/09/23  Steven Lei       initial revision
;    06/14/23  Steven Lei       update hardware definitions

; Display Definitions

; General Hardware Definitions

.EQU    NUM_DIGITS  = 7                 ; size of the LED buffer
.EQU    NUM_SEG_DIGITS  = 4             ; number of 7-segment displays
.EQU    NUM_LED_DIGITS = 2              ; number of game LED digits 

; Specific Digit/LED Definitions

.EQU    LED_BLANK     = 0b00000000      ; a blank LED
.EQU    INIT_SEG_PATT = 0b00000001      ; initial segment drive pattern
.EQU    LED_DIG = 0                     ; game LEDs start at digit 0
.EQU    SEG_DIG = 3                     ; 7-segment displays start at digit 3

.EQU    INIT_ON_TIME = 10               ; display on and off time
.EQU    INIT_OFF_TIME = 0               

.EQU    GAME_LED_HI_MASK = 0b11101111   ; high byte mask, bit 12 unused
.EQU    GAME_LED_LOW_MASK = 0b11111111  ; low byte mask

; Port Definitions
    ; see LED layout table on website for bit/digits

.EQU    BIT_PORT = PORTC                ;LED bits are on port C
.EQU    DIGIT_PORT = PORTD              ;LED digits are on port D
