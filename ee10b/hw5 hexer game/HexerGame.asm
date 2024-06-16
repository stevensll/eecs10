;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   HexerLoop                                ;
;                            Homework #5 Game Main loop                      ;
;                                  EE/CS 10b                                 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; This file contains the main loop code for homework #5.  The function makes a
; number of calls to the display functions to test them.  The functions
; included are:
;    DisplayTest - test the homework display functions
;
; Revision History:
;    4/29/19  Glen George               initial revision
;    5/18/23  Glen George               updated for Hexer
;   06/15/23  Steven Lei                retrieved from website

; local include files
; .include "HexerGame.inc"            ; Game constants


;Code segment
.cseg

HexerPlayLoop:
	RCALL   ClearDisplay            ; clear the display
	RCALL   Delay16
	LDI		R16, 0
	LDI		R17, 0
	RCALL	DisplayHex				; display 0 on the screen
    RCALL   ResetGameLEDs           

SwitchWaitLoop:                     ;loop until there is a switch press
    RCALL   SwitchAvailable        
    BREQ    SwitchWaitLoop              ;wait for there to be a switch press

    RCALL   GetSwitches             ;switch pattern is availble - get it in R16

InitSwitchToLEDsTable:
    LDI     ZL, LOW(2 * SwitchToLEDsTable)
    LDI     ZH, HIGH(2 * SwitchToLEDsTable)

MatchSwitchToLEDsLoop:
    LPM     R17, Z+                 ; first entry to the table is switch pattern
    CP      R16, R17                ; so find the switch just pressed in R16
    BREQ    MatchedSwitch               ; and handle the button press

    CPI     R17, SW_TO_LED_TABLE_LAST   ; if at last entry of the table and 
    BREQ    RestartHexerPlayLoop        ; no match, ignore the pressed sw patt

    ADIW    Z, 5    ; if no match, check the next pattern
    RJMP    MatchSwitchToLEDsLoop

MatchedSwitch:                      ; set arguments for functions to update LEDs
	ADIW	Z, 	1						; increment the z pointer 

    LPM     R18, Z+                     ; get the respective table to use
    LPM     R19, Z+

    LPM     R20, Z+                     ; and finally call the procedure
    LPM     R21, Z
    MOV     ZL, R20
    MOV     ZH, R21
    ICALL

CheckWinLosStatus:                      ; check if the player has now win/loss
    RCALL   GameOver                        ; and  handle the game if so

RestartHexerPlayLoop:               ; restart the play loop to loop forever for
    JMP    SwitchWaitLoop               ; loop forever for user input
    RET                                ; should never get here




; ResetGameLEDs

ResetGameLEDs:

TurnGameLEDsOn:
    LDI     R16, 0b00000000
    STS     CurrGameLEDsPatt, R16
    LDI     R17, 0b00000001
    STS     CurrGameLEDsPatt+1, R17
    RCALL   DisplayGameLEDs

DoneResetGameLeds:
    RET

 

;;

GameOver:

CheckMoveCounter:
    LDS     R16, MoveCounter
    CPI     R16, GAME_MAX_MOVES

DoneGameOver:
    RET                             ; done so return

; Delay16
;
; Description:       This procedure delays the number of clocks passed in R16
;                    times 80000.  Thus with a 8 MHz clock the passed delay is
;                    in 10 millisecond units.
;
; Operation:         The function just loops decrementing Y until it is 0.
;
; Arguments:         R16 - 1/80000 the number of CPU clocks to delay.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16, Y (YH | YL)
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     May 6, 2018

Delay16:

Delay16Loop:                      ;outer loop runs R16 times
    LDI     YL, LOW(20000)          ;inner loop is 4 clocks
    LDI     YH, HIGH(20000)         ;so loop 20000 times to get 80000 clocks
Delay16InnerLoop:                       ;do the delay
    SBIW    Y, 1
    BRNE    Delay16InnerLoop

    DEC     R16                     ;count outer loop iterations
    BRNE    Delay16Loop


DoneDelay16:                            ;done with the delay loop - return
    RET


;
InitMoveCounter:

InitCounter:
    LDI     R16, 0
    STS     MoveCounter, R16

DoneInitMoveCounter:
    RET



RotateShape:
; Table is in R19 | R18

InitGameLEDsTable:                  ; initialize the table to get the next LEDs
    MOV     ZH, R19                 
    MOV     ZL, R18

InitCurrGameLEDsPatt:
    LDS     R16, CurrGameLEDsPatt
    LDS     R17, CurrGameLEDsPatt+1

FindNextGameLEDsPatt:
    LPM     R18, Z+
    LPM     R19, Z+
    CP      R19, R17                ; Check if the current pattern matches
    BRNE    FindNextGameLEDsPattLoop    ; with the table
    CP      R18, R16                ; if not, move to the next entry
    BRNE    FindNextGameLEDsPattLoop     
    ;BREQ   UpdateGameLEDsPatt      ; else, get the next pattern

UpdateGameLEDsPatt:
    LPM     R18, Z+
    LPM     R19, Z+
    MOV     R17, R19                ; copy the pattern
    MOV     R16, R18                
    STS     CurrGameLEDsPatt, R16        ; and store it
    STS     CurrGameLEDsPatt+1, R17
    RJMP    DoneGetNextGameLEDsPatt

FindNextGameLEDsPattLoop:
    ADIW    ZL, 2
    RJMP    FindNextGameLEDsPatt    

DoneGetNextGameLEDsPatt:
	RCALL	DisplayGameLEDs
    RET






SwitchToLEDsTable:
;       Switch Pattern      Table to Load       Function      

.DW     BLACK_SW_PATT,     (2 * BlackHexagonRotation),     RotateShape         
.DW     RED_SW_PATT,       (2 * RedTriangleRotation),      RotateShape
.DW     GREEN_SW_PATT,     (2 * GreenTriangleRotation),    RotateShape
.DW     BLUE_SW_PATT,      (2 * BlueHexagonRotation),      RotateShape

.dseg
;
MoveCounter:         .BYTE   4 
CurrGameLEDsPatt:    .BYTE   2

