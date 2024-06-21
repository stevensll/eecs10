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

.EQU    GAME_MAX_MOVE_COUNT = 0x50    ; Max moves that can be until game is over
.EQU    GAME_OVER_LED_PATT = 0b0000000000000000
.EQU    GAME_OVER_MOVE_COUNT = 0
; Table definitions
.EQU    SWITCH_HANDLER_TABLE_FIRST_ROW =  0
.EQU    SW_HAN_TABLE_ROW_OFFSET = 7
.EQU    ROTATION_TABLE_ROW_OFFSET = 2   ; 
; Switch definitions

.EQU 		BLACK_SW_PATT 			=  	0b11011111
.EQU 		RED_SW_PATT 			=   0b11101111
.EQU 		WHITE_SW_PATT 			= 	0b11110111
.EQU 		GREEN_SW_PATT 			= 	0b11111011
.EQU 		BLUE_SW_PATT 			= 	0b11111101


.EQU        BLUE_LEDS_MASK 	    =               0b0000001101100101	 
.EQU        RED_LEDS_MASK 		=               0b1100011011001110 	 
.EQU        WHITE_LEDS_MASK 	=               0b1000011010000110 	 
.EQU        GREEN_LEDS_MASK 	=               0b1010011110010110
.EQU        BLACK_LEDS_MASK 	=               0b0010110010101000 	 

.EQU        SW_HAN_TABLE_LAST    =   BLUE_SW_PATT