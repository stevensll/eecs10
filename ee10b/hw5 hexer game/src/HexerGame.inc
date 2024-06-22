;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                 Hexer.INC                                  ;
;                           Game Functions Constants                         ;
;                           Hexer Game (AVR version)                         ;
;                                 Include File                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the definitions for the game functions for the Hexer Game
;
; Revision History:
;    06/15/24  Steven Lei       added switch pattern and LEDs definitions
;    06/18/24  Steven Lei       added table definitions
;    06/21/24  Steven Lei       added state variables and game messages


; Game condition definitions

.EQU    GAME_INIT_MOVE_COUNT = 0x50     ; Initial amount of moves to start with
.EQU    GAME_OVER_LED_PATT   = 0b1111111111111111 ; Game over when all LEDs on      
.EQU    GAME_OVER_MOVE_COUNT = 0       ; Game over when 0 moves left
.EQU    GAME_LOSE_MESSAGE    = 0x105E  ; "LOSE" 
.EQU    GAME_WIN_MESSAGE     = 0x00A1  ; Can't display win, try "A-ONE"

; Table definitions
.EQU    SW_HAN_TABLE_ROW_OFFSET = 7    ; Offset between rows in table
.EQU    SW_HAN_TABLE_LAST =   WHITE_SW_PATT ; first entry in last row of table
.EQU    ROT_TABLE_ROW_OFFSET    = 2       ; Offset between rows in table


; Switch pattern definitions
.EQU 		BLACK_SW_PATT 			=  	0b11011111  ; Black switch press
.EQU 		RED_SW_PATT 			=   0b11101111  ; Red switch press
.EQU 		WHITE_SW_PATT 			= 	0b11110111  ; White switch press
.EQU 		GREEN_SW_PATT 			= 	0b11111011  ; Green switch press
.EQU 		BLUE_SW_PATT 			= 	0b11111101  ; Blue switch press
.EQU        START_RANDOM_RESET      =   0b10011111  ; Start + random reset 
.EQU        START_MANUAL_RESET0     =   0b10111101  ; Start + manual reset0 
.EQU        START_MANUAL_RESET1     =   0b10111110  ; Start + manual reset1

; Game LED masks definitions
.EQU        BLUE_LEDS_MASK 	    = 0b0000001101100101    ; Blue hexagon LEDs	 
.EQU        RED_LEDS_MASK 		= 0b1100011011001110 	; Red triangle LEDs 
.EQU        WHITE_LEDS_MASK 	= 0b1000011010000110 	; White hexagon LEDs 
.EQU        GREEN_LEDS_MASK 	= 0b1010011110010110    ; Green triangle LEDs
.EQU        BLACK_LEDS_MASK 	= 0b0010110010101000 	; Black hexagon LEDs 


; Game state machine states
.EQU        GAME_OVER_STATE         = 0 ; game is over and waiting for reset
.EQU        GAME_MANUAL_RESET_STATE = 1 ; manually resetting each button
.EQU        GAME_PLAY_STATE         = 2 ; playing the game             


.EQU        GAME_LEDS_EASY  =   0b0111100101111001  ; a 1 button solve pattern
.EQU        GAME_LEDS_HARD  =   0b0000000000001000  ; only 1 LED on pattern
.EQU        DEFAULT_RESET_GAME_LEDS_PATT = GAME_LEDS_EASY
