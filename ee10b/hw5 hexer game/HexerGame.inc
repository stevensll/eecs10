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
;    06/15/24  Steven Lei       added definitions


; Game definitions

.EQU    GAME_MAX_MOVES = 0x50    ; Max moves that can be until game is over


; Switch definitions

.EQU 		BLACK_SW_PATT 			=  	0b11011111
.EQU 		RED_SW_PATT 			=   0b11101111
.EQU 		WHITE_SW_PATT 			= 	0b11110111
.EQU 		GREEN_SW_PATT 			= 	0b11111011
.EQU 		BLUE_SW_PATT 			= 	0b11111101


.EQU        BLACK_LEDS_MASK 	=               0b0000001101100101	 
.EQU        RED_LEDS_MASK 		=               0b1100011011001110 	 
.EQU        WHITE_LEDS_MASK 	=               0b1000011010000110 	 
.EQU        GREEN_LEDS_MASK 	=               0b1010011110010110
.EQU        BLUE_LEDS_MASK 	    =               0b0010110010101000 	 

.EQU        SW_TO_LED_TABLE_WIDTH   =   5
.EQU        SW_TO_LED_TABLE_LAST    =   BLUE_SW_PATT