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

GetSwitchHandlerLoop:           ; loop and find the corresponding switch handler
    LPM     R17, Z+                 ; first column of table is the switch patt
    CP      R16, R17                ; so compare to debounced switch patt in R16
    BREQ    InitSwitchHandler           ; and set the switch handler if matched

    CPI     R17, SW_HAN_TABLE_LAST      ; if at last row of table and switch  
    BREQ    DoneHandleSwitchPress       ; pattern not found, return

    ADIW    Z, SW_HAN_TABLE_ROW_OFFSET ; skip to next row of table if no match
    RJMP    GetSwitchHandlerLoop        ; and loop until at the end of table

InitSwitchHandler:
    
	ADIW	Z, 	1						; increment the z pointer 

    LPM     R18, Z+                     ; get the LED mask to apply
    LPM     R19, Z+

    LPM     R20, Z+                     ; get the rotation table to use
    LPM     R21, Z+

    LPM     R22, Z+                     ; get the function to call
    LPM     R23, Z
    MOV     ZL, R22
    MOV     ZH, R23

RunSwitchHandler:                   ; set arguments for functions to update LEDs
    ICALL

DoneHandleSwitchPress:
	RET


HexerPlayGameLoop:

	RCALL   ClearDisplay            ; clear the display
	RCALL   Delay16
	LDS		R16, MoveCounter
	LDS		R17, MoveCounter+1
	RCALL	DisplayHex				; 
    RCALL   ResetGameLEDs           

SwitchWaitLoop:                     ; loop until there is a switch press
    RCALL   GetSwitches             ; wait until a switch is avaiable (blocking)
    ;RJMP   HandleUserInput         ; switch is pressed, handle the input

HandleUserInput:
    RCALL   HandleSwitchPress   

UpdateGameState:                    ; check if the player has now win/lost 
    RCALL   GameOver                    ; and update the game state if so

RestartHexerPlayGameLoop:           ; restart the play loop to loop forever 
    JMP    SwitchWaitLoop               ; loop forever for user input
    RET                                 ; should never get here




; ResetGameLEDs

ResetGameLEDs:

InitGameLEDs:
    LDI     R16, LOW(BLUE_LEDS_MASK)
    STS     CurrGameLEDsPatt, R16
    LDI     R17, HIGH(BLUE_LEDS_MASK)
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
    CPI     R16, GAME_OVER_MOVE_COUNT
    BREQ    ProcessLoseGame             ; if move counter is at 0, player lost

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



InitHexerGame:
	RCALL	ResetMoveCounter


;
ResetMoveCounter:

InitMoveCounter:
    LDI     R16, LOW(GAME_MAX_MOVE_COUNT)
    LDI     R17, HIGH(GAME_MAX_MOVE_COUNT)
    STS     MoveCounter, R16
    STS     MoveCounter+1, R17

DoneResetMoveCounter:
    RET



RotateShape:

InitRotationTable:     ; initialize table mapping current game LEDs to next patt
    MOV     ZL, R20         ; table address is in R21 | R20           
    MOV     ZH, R21

MaskCurrGameLEDsPatt:            ; apply the LED mask to the current game LEDs
    LDS     R16, CurrGameLEDsPatt   ; load current game LEDs pattern
    LDS     R17, CurrGameLEDsPatt+1 
    AND     R16, R18                ; apply the mask in R19 | R18 to get shape
    AND     R17, R19


FindNextGameLEDsPattLoop: ; loop to find next pattern by comparing to current 
    LPM     R20, Z+         ; load the two bytes of the pattern to R19 | R18
    LPM     R21, Z+             
    CP      R21, R17       ; check if masked pattern matches with table entry
    BRNE    GoToNextRotationTableRow    ; if not, move onto next entry
    CP      R20, R16                    
    BRNE    GoToNextRotationTableRow     
    ;BREQ   UseNewGameLEDsPatt      ; pattern matches, so get the next pattern 

UseNewGameLEDsPatt:                 ; Found next pattern, store and display it                                                
    LPM     R20, Z+                     ; load the next pattern
    LPM     R21, Z+ 
   
    COM     R18                         ; invert the mask bytes
    COM     R19
   
    LDS     R16, CurrGameLEDsPatt       ; load current game LEDs pattern
    LDS     R17, CurrGameLEDsPatt+1     
    AND     R16, R18                    ; clear all the bits set in the mask
    AND     R17, R19

    OR     R16, R20                    ; and apply the new shape pattern to
    OR     R17, R21                    ; the game LED pattern (R17 - R16)

    STS     CurrGameLEDsPatt, R16       ; and store the pattern as well to data
    STS     CurrGameLEDsPatt+1, R17
    RJMP    DisplayNextGameLEDsPatt     ; now display it

GoToNextRotationTableRow:           ; No match, so move to next row
    ADIW    ZL, ROTATION_TABLE_ROW_OFFSET   ; advance index to next row in table
    RJMP    FindNextGameLEDsPattLoop        ; and loop

DisplayNextGameLEDsPatt:            ; have the next pattern, now display it
    RCALL DisplayGameLEDs  

UpdateMoveCounter:                  ; since next pattern is found, button press  
    LDS     R16, MoveCounter            ; was valid, so decrement move counter
    LDS     R16, MoveCounter+1

    DEC     R16
    STS     MoveCounter, R16
DoneRotateShape:                    ; done rotating the shape 
    RET                                 ; so return 






SwitchHandlerTable:
;    Switch Pattern     LED Mask            Table to Load             Function      

.DW  BLACK_SW_PATT,  BLACK_LEDS_MASK,  (2 * BlackHexagonRotation),  RotateShape         
.DW  RED_SW_PATT,    RED_LEDS_MASK,    (2 * RedTriangleRotation),   RotateShape
.DW  GREEN_SW_PATT,  GREEN_LEDS_MASK,  (2 * GreenTriangleRotation), RotateShape
.DW  BLUE_SW_PATT,   BLUE_LEDS_MASK,   (2 * BlueHexagonRotation),   RotateShape

; data segment
.dseg
;
MoveCounter:         .BYTE   2 
CurrGameLEDsPatt:    .BYTE   2

