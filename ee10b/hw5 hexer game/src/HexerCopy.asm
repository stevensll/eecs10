;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   HexerGame                                ;
;                          Hexer Game - Gameplay Procedures                  ;
;                              	  EE/CS 10b - HW5                            ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the game play procedures necessary to play the Hexer Game.
; All procedures are called the HexerPlayGameLoop procedure, which handles all 
; user input and updates the game state. The functions included are:
;    DisplayTest - test the homework display functions
;
; Revision History:
;   06/15/23  Steven Lei                create file
;   06/17/24  Steven Lei                update code outline
;   06/19/24  Steven Lei                handled button presses and LEDs updating
;   06/20/24  Steven Lei                finished


;code segment
.cseg


; HexerPlayGameLoop
;
; Description:       This procedure loops infinitely and plays the hexer game. 
;					 It handles user input from button presses and updates the 
;                    game LEDs and move counter accordingly. When the player 
;                    wins (all game LEDs blank and still have moves left) or 
;                    loses (no moves left but some game LEDs are still on), 
;                    the player can reset the game either manually or randomly.
;					  
; Operation:         Resets the debounce counter, the repeat counter, and the 
;					 repeat rate. The debounce flag is also reset to FALSE.
;					 The old and new switch pattern variables are reset to
;					 SWITCH_UP (all bits are high when switch is not pressed).
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  debounceCounter:	Counter used for debouncing and WRITTEN 
;									    as the debounce time (10 ms).
;					 repeatCounter:		Counter used for counting until the 
;										repeat rate is switched to fast, WRITTEN
;										as the fast repeat time (500ms)
;					 repeatRate:		The rate in which a repeated switch 
;										pattern is debounced, WRITTEN as 
;										the slow rate (50ms)
;					 debounceFlag: 		Flag indicating if a switch is 
;										debounced, WRITTEN to false.
;					 prevSwitchPatt:	Previous switch pattern, WRITTEN to 
;										SWITCH_UP
;					 newSwitchPatt: 	New debounced switch pattern, WRITTEN to 
;										SWITCH_UP 
;
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
;
; Limitations:		 None.
; Special notes:	 A pressed switch is represented with the low bit (0).
;
; Author:            Steven Lei
; Last Modified:	 03/26/2024
;
; Pseudo code:
	; HexerPlayGameLoop(){
    ;     SWITCH (GameState) {
    ;         CASE (GAME_OVER): {
    ;             DisplayHex(GameStatus)          ; display either "WIN" or "LOSE"
    ;             delay(500)                          ; for 500 ms
    ;             break
    ;             GameState = RESET
    ;         }
    ;         CASE (RESET): {
    ;             DisplayHex("LOSE")
    ;             delay(5)
    ;         }
    ;         CASE (RESET_MANUAL): {

    ;         }
    ;         CASE (PLAY_GAME): {
    ;             SwitchPattern = GetSwitches()   ; this is blocking until a switch is pressed
    ;             HandleSwitchPress(SwitchPattern) ; t
    ;             GameOver(MoveCounter, CurrGameLEDsPatt)
    ;         }
    ;     }
	; }


; HandleSwitchPress:
; Pseudo code: 
    ; HandleSwitchPress(SwitchPattern){
    ;     SwitchToLEDTable = InitSwitchToLEDTable()
    ;     column = 0;
    ;     FOR (row = 0, row < SWITCH_TO_LED_TABLE_LENGTH, i++) {
    ;         IF (SwitchToLEDsTable[row][column] == SwitchPattern){
    ;             NextLEDTable = SwitchToLEDsTable[row][column + NEXT_LED_TABLE_OFFSET]
    ;             UpdateLEDProcedure = SwitchToLEDsTable[row][column + UPDATE_LED_PROCEDURE_OFFSET]
    ;             UpdateLEDProcedure(NextLEDTable)
    ;         }
    ;     }
    ; }

HandleSwitchPress:

InitHandleSwitchPress:                  ; initialize the table and indexer
    LDI     ZL, LOW(2 * SwitchHandlerTable)         ; initialize the table
    LDI     ZH, HIGH(2 * SwitchHandlerTable)
    LDI     R17, SWITCH_HANDLER_TABLE_FIRST_ROW     ; initialize the row index
      
InitSwitchHandlerCounter:   

GetSwitchHandlerLoop:           ; loop and find the corresponding switch handler
    LPM     R17, Z+                 ; first column of table is the switch patt
    CP      R16, R17                ; so compare to debounced switch patt in R16
    BREQ    RunSwitchHandler           ; and set the switch handler if matched

    CPI     R17, SW_TO_LED_TABLE_LAST   ; if at last row of table and switch  
    BREQ    DoneHandleSwitchPress       ; pattern not found, return

    ADIW    Z, 5                    ; skip to next row of table if no match
    RJMP    GetSwitchHandlerLoop    ; and loop until at the end of table

RunSwitchHandler:                   ; set arguments for functions to update LEDs
	ADIW	Z, 	1						; increment the z pointer 

    LPM     R18, Z+                     ; get the respective table to use
    LPM     R19, Z+

    LPM     R20, Z+                     ; and finally call the procedure
    LPM     R21, Z
    MOV     ZL, R20
    MOV     ZH, R21
    ICALL
DoneHandleSwitchPress:
	RET

HexerPlayGameLoop:

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

HandleUserInput:
    RCALL   HandleSwitchPress   

UpdateGameState:                    ; check if the player has now win/lost 
    RCALL   GameOver                    ; and update the game state if so

RestartHexerPlayGameLoop:           ; restart the play loop to loop forever 
    JMP    SwitchWaitLoop               ; loop forever for user input
    RET                                 ; should never get here




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

CheckGameLEDsPatt:                      ; check if there are no more LEDs on     
    LDS     R16, CurrGameLEDsPatt           ; get the current game LEDs pattern
    CPI     R16, GAME_OVER_LED_PATT         ; and compare it with game over patt
    BREQ    ProcessWinGame                  ; if all LEDs are off, game is won 
                                            ; NOTE: this should occur even if
                                            ; the move counter hit the max
CheckMoveCounter:                       ; 
    LDS     R16, MoveCounter
    CPI     R16, GAME_MAX_MOVES
    BREQ    ProcessLoseGame             ; if move counter is at max, player lost

ProcessWinGame:                         ; show WIN message and update game state

ProcessLoseGame:                        ; show LOSE message and update game state

DoneGameOver:                       ; done checking if game is over
    RET                                 ; so return

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






SwitchHandlerTable:
;       Switch Pattern      Table to Load       Function      

.DW     BLACK_SW_PATT,     (2 * BlackHexagonRotation),     RotateShape         
.DW     RED_SW_PATT,       (2 * RedTriangleRotation),      RotateShape
.DW     GREEN_SW_PATT,     (2 * GreenTriangleRotation),    RotateShape
.DW     BLUE_SW_PATT,      (2 * BlueHexagonRotation),      RotateShape

; data segment
.dseg
;
MoveCounter:         .BYTE   4 
CurrGameLEDsPatt:    .BYTE   2

