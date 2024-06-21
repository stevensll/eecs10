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
    ;             break;  
    ;         }
    ;     }
	; }


GameOverState:

DisplayGameOverMessage:
    LDS     R16, GameOverMessage
    LDS     R17, GameOverMessage+1
    RCALL   DisplayHex

GameOverStateLoop:
    RCALL   GetSwitches
    CPI     R16, START_RANDOM_RESET
    BREQ    RandomResetGame    
    CPI     R16, START_MANUAL_RESET0
    ; handle reset
    CPI     R16, START_MANUAL_RESET1   
    RJMP    GameOverStateLoop

RandomResetGame:
    RCALL   ResetMoveCounter
    RCALL   ResetGameLEDs

DoneGameOverState:
    LDI     R16, GAME_PLAY_STATE
    STS     GameState, R16     
    RET 




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

;;;;;;;;;;;;;;;;;;;;;;;
HexerPlayGameLoop:

SetupDisplays:
	RCALL   ClearDisplay            ; clear the display
	RCALL   Delay16
   

RunGameStateLoop:
    LDS     R16, GameState
    CPI     R16, GAME_PLAY_STATE
    BREQ    DoGamePlayState
    CPI     R16, GAME_OVER_STATE
    BREQ    DoGameOverState
    RCALL   GameOverState

DoGamePlayState:
    RCALL   GamePlayState
    RJMP    RunGameStateLoop

DoGameOverState:
    RCALL   GameOverState
    RJMP    RunGameStateLoop

DoneHexerPlayGameLoop:
    RET 
    


GamePlayState:

DisplayMoveCounter:                 ; display the number of moves left to play
    LDS		R16, MoveCounter            ; load the move counter
	LDS		R17, MoveCounter+1
	RCALL	DisplayHex		            ; and display it

HandleUserInput:                  ; loop until there is a switch press
    
	RCALL   GetSwitches             ; wait until a switch is avaiable (blocking)    
    RCALL   HandleSwitchPress       ; update the game based on the switch press
    RCALL   GameOver                ; and update the game state if win or loss

DoneGamePlayState:                  ; done with game play state 
    RET                                 ; and return
                                        ; NOTE: this procedure should be called
                                        ; in a loop!



; ;;;;;;;;;ResetGameLEDs
ResetGameLEDs:                          

GetDefaultGameLEDsPattern:              ; get the default game LEDs pattern
    LDI     R16, LOW(DEFAULT_RESET_GAME_LEDS_PATT)  ; load the default pattern
    LDI     R17, HIGH(DEFAULT_RESET_GAME_LEDS_PATT)      
    STS     CurrGameLEDsPatt, R16           ; store it as current pattern
    STS     CurrGameLEDsPatt+1, R17
    
DisplayDefaultGameLEDsPattern:          ; display the default game LEDs pattern
    RCALL   DisplayGameLEDs                 

DoneResetGameLEDs:                      ; done resetting game LEDs
    RET                                     ; and return

; ;;;;;;;;;ResetMoveCounter
ResetMoveCounter:

GetInitialMoveCount:                    ; get the intial move count
    LDI     R16, LOW(GAME_INIT_MOVE_COUNT)   ; load the initial move count
    LDI     R17, HIGH(GAME_INIT_MOVE_COUNT)     
    STS     MoveCounter, R16                 ; store it to the move count
    STS     MoveCounter+1, R17

DisplayInitialMoveCount:                ; display the inital move counter
    RCALL   DisplayHex                         

DoneResetMoveCounter:                   ; done resetting the move counter
    RET                                     ; so return
 

; GameOver(CurrGameLEDsPatt, MoveCounter){
    
;     IF (CurrGameLEDsPatt == GAME_OVER_LED_PATT){
;         GameOverMessage = "WIN"
;         GameState = GameOver
;         RETURN
;     } ELSE IF (MoveCounter == 0) {
;         GameOverMessage = "LOSE"
;         GameState = GameOver
;         RETURN
;     } 
;     RETURN
; }

GameOver:

CheckGameLEDsPatt:                      ; check if all LEDs are on    
    LDS     R16, CurrGameLEDsPatt           ; get the current game LEDs pattern
    LDS     R17, CurrGameLEDsPatt+1
    CPI     R16, LOW(GAME_OVER_LED_PATT)    ; and compare it with game over patt
    BRNE    CheckMoveCounter                ; if low byte no match, skip
    CPI     R17, HIGH(GAME_OVER_LED_PATT)
    BRNE    CheckMoveCounter                ; if high byte no match, skip
    RJMP    GetWinMessage                   ; else pattern matches, game is won 
                                            ; NOTE: this should occur even if
                                            ; the move counter hit the max
CheckMoveCounter:                       ; check if no moves left
    LDS     R16, MoveCounter                ; get the current move count
    LDS     R17, MoveCounter+1
    CPI     R16, LOW(GAME_OVER_MOVE_COUNT)  ; compare it with game over count
    BRNE    DoneGameOver                    ; if low byte no match, skip
    CPI     R17, HIGH(GAME_OVER_MOVE_COUNT) 
    BRNE    DoneGameOver                    ; if high byte no match, skip
    ;RJMP   GetLoseMessage                  ; else move counter is 0, game lost

GetLoseMessage:                         ;  get lose game over message
    LDI     R16, LOW(GAME_LOSE_MESSAGE)
    LDI     R17, HIGH(GAME_LOSE_MESSAGE)
    RJMP    UpdateMessageAndState

GetWinMessage:                          ; get win game over message
    LDI     R16, LOW(GAME_WIN_MESSAGE)
    LDI     R17, HIGH(GAME_WIN_MESSAGE)

UpdateMessageAndState:                  ; set game over message and game state
    STS     GameOverMessage, R16            ; store the game over message
    STS     GameOverMessage+1, R17  
    LDI     R16, GAME_OVER_STATE            ; load and store the game over state
    STS     GameState, R16

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

InitHexerGameLEDs:                  ; initialize the starting game LEDs pattern
    RCALL   ResetGameLEDs

InitHexerMoveCounter:               ; initialize the starting move count
	RCALL	ResetMoveCounter        

InitHexerGameState:                 ; switch state to allow user to reset game
    LDI     R16, GAME_OVER_STATE        ; load and store the game over state
    STS     GameState, R16    
    LDI     R16, LOW(GAME_LOSE_MESSAGE) ; load the lose message to display
	LDI		R17, HIGH(GAME_LOSE_MESSAGE);
    STS     GameOverMessage, R16        ; and store it
	STS 	GameOverMessage+1, R17

DoneInitHexerGame:                  ; done initializing HexerGame elements
    RET                                 ; so return




InvertGameLEDs:

MaskCurrLEDsPatt:            ; apply the LED mask to the current game LEDs
    LDS     R20, CurrGameLEDsPatt   ; load current game LEDs pattern
    LDS     R21, CurrGameLEDsPatt+1 
    AND     R20, R18                ; apply the mask in R19 | R18 to get shape
    AND     R21, R19
    COM     R20                     ; invert the selected bits
    COM     R21
	
	AND		R20, R18				; keep only the selected bits
	AND		R21, R19	
   
    COM     R18                         ; invert the mask bytes
    COM     R19
   
    LDS     R16, CurrGameLEDsPatt       ; load current game LEDs pattern
    LDS     R17, CurrGameLEDsPatt+1     
   
    AND     R16, R18                    ; clear all the bits set in the mask
    AND     R17, R19

    OR      R16, R20                    ; and apply the new shape pattern to
    OR      R17, R21                    ; the game LED pattern (R17 - R16)
	
	STS		CurrGameLedsPatt, R16
	STS		CurrGameLedsPatt+1, R17

DoneInvertGameLEDs:                    ; done rotating the shape 
    RCALL UpdateDisplay                 ; update the game LEDs and move counter 
    RET                                 ; so return 


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

    OR      R16, R20                    ; and apply the new shape pattern to
    OR      R17, R21                    ; the game LED pattern (R17 - R16)

    STS     CurrGameLEDsPatt, R16       ; and store the pattern as well to data
    STS     CurrGameLEDsPatt+1, R17
    RJMP    DoneRotateShape             ; now display it

GoToNextRotationTableRow:           ; No match, so move to next row
    ADIW    ZL, ROTATION_TABLE_ROW_OFFSET   ; advance index to next row in table
    RJMP    FindNextGameLEDsPattLoop        ; and loop

DoneRotateShape:                    ; done rotating the shape 
    RCALL UpdateDisplay                 ; update the game LEDs and move counter 
    RET                                 ; so return 


UpdateDisplay:

UpdateGameLEDs:
    RCALL DisplayGameLEDs  
UpdateMoveCounter:
    LDS     YL, MoveCounter
    LDS     YH, MoveCounter+1
    SBIW    Y, 1          
    STS     MoveCounter, YL
    STS     MoveCounter+1, YH
	MOV 	R16, YL
	MOV		R17, YH
	RCALL 	DisplayHex
	
	RET 
	

SwitchHandlerTable:
;    Switch Pattern     LED Mask            Table to Load             Function      

.DW  BLACK_SW_PATT,  BLACK_LEDS_MASK,  (2 * BlackHexagonRotation),  RotateShape         
.DW  RED_SW_PATT,    RED_LEDS_MASK,    (2 * RedTriangleRotation),   RotateShape
.DW  GREEN_SW_PATT,  GREEN_LEDS_MASK,  (2 * GreenTriangleRotation), RotateShape
.DW  BLUE_SW_PATT,   BLUE_LEDS_MASK,   (2 * BlueHexagonRotation),   RotateShape
.DW  WHITE_SW_PATT,  WHITE_LEDS_MASK,   0,                        InvertGameLEDs
; data segment
.dseg
;
MoveCounter:        .BYTE   2 
CurrGameLEDsPatt:   .BYTE   2
GameOverMessage:    .BYTE   2
GameState:          .BYTE   1
