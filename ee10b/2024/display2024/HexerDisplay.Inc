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

.EQU    NUM_BUFFER_DIGITS    = 7        ; number of digits (ROWS) in the buffer
.EQU    NUM_7SEG_DIGITS      = 4        ; number of 7-segment displays digits
.EQU    NUM_GAME_LED_DIGITS  = 2        ; number of game LED digits 

; Specific Digit/LED Definitions

.EQU    DIGIT_OFF     = 0b00000000      ; turn off LEDs in a digit (off is 0)
.EQU    INIT_DIG_PATT = 0b00000001      ; initial digit drive pattern
.EQU    GAME_LED_DIG  = 0               ; game LEDs start at digit 0
.EQU    7SEG_DIG      = 3               ; 7-segment LEDs start at digit 3
            
.EQU    LOW_NIBBLE_MASK = 0b00001111    ; mask to get low nibble of a byte 

.EQU    GAME_LED_HI_MASK  = 0b11101111  ; high byte of LED mask, bit 12 unused
.EQU    GAME_LED_LOW_MASK = 0b11111111  ; low byte of LED mask

; Port Definitions
    ; see LED layout table on website for bit/digits

.EQU    SEGMENT_PORT = PORTC            ; LED segments are on port C
.EQU    DIGIT_PORT   = PORTD            ; LED digits are on port D
