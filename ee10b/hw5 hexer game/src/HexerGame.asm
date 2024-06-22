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
;
; Table of contents:
;   ResetGameLEDs:      resets the game LEDs to the default pattern
;   ResetMovesCounter:  resets the move counter to the initial value
;   InitHexerGame:      initialiez variables used to run Hexer Game
;   DisplayCurrGameLEDs:   displays the current game LEds pattern
;   DisplayMovesCounter:    display the move counter
;   HexerPlayGameLoop:   infinite loop to play the hexer game
;   GamePlayState:      plays the Hexer Game by processing button presses
;   GameOverState:      waits for the user to reset the game 
;   HandlePlaySwitchPress:  proceses theh switch pressed and calls handler
;   RotateShape:       rotates specified LED shape and updates current game LEDs
;   InvertGameLEDs:    inverts theh game LEDs about the white hexagon
;   GameOver:          check if game is over, and if so, updates game state
;   UpdateCounter:     decrements the counter
;   Delay16;           Delay for 100 ms
;code segment
.cseg


; ResetGameLEDs
;
; Description:       This function initializes the current game LEDs to the  
;                    default game LEDs pattern. It does NOT display the LED 
;                    pattern. 
;
; Operation:         Loads the default game LEDs pattern into the shared 
;                    CurrentGameLEDsPatt variable.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  CurrentGameLEDsPatt (W) - current game LEDs is set to 
;                                              default pattern
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Registers Used:    R16, R17.
; Stack Depth:       0 bytes.
;
; Author:            Steven Lei
; Last Modified:     June 21, 2024
;
; Psuedo code:
	; ResetGameLEDs(){
	; 	CurrGameLEDsPatt = DEFAULT_RESET_GAME_LEDS_PATT
	; 	RETURN
	; }

ResetGameLEDs:                          

GetDefaultGameLEDsPattern:              ; get the default game LEDs pattern
    LDI     R16, LOW(DEFAULT_RESET_GAME_LEDS_PATT)  ; load the default pattern
    LDI     R17, HIGH(DEFAULT_RESET_GAME_LEDS_PATT)      
    STS     CurrGameLEDsPatt, R16           ; store it as current pattern
    STS     CurrGameLEDsPatt+1, R17
    
DoneResetGameLEDs:                      ; done resetting game LEDs
    RET                                     ; and return

; ResetMoveCounter
;
; Description:       This function initializes the move counter to the  
;                    move count when the game is restarted. It does NOT display 
;                    the MoveCounter. 
;
; Operation:         Loads the initial move count into the shared MoveCounter 
;                    variable.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  MoveCounter (W) - the move counter is set to the inital
;                                      move count 
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Registers Used:    R16, R17.
; Stack Depth:       0 bytes.
;
; Author:            Steven Lei
; Last Modified:     June 21, 2024
;
; Psuedo code:
	; ResetMoveCount(){
	; 	MoveCounter = GAME_INIT_MOVE_COUNT
	; 	RETURN
	; }
    
ResetMoveCounter:

GetInitialMoveCount:                    ; get the intial move count
    LDI     R16, LOW(GAME_INIT_MOVE_COUNT)   ; load the initial move count
    LDI     R17, HIGH(GAME_INIT_MOVE_COUNT)     
    STS     MoveCounter, R16                 ; store it to the move count
    STS     MoveCounter+1, R17

DoneResetMoveCounter:                   ; done resetting the move counter
    RET                                     ; so return
 

; InitHexerGame
;
; Description:       This function initializes the variables used in the Hexer 
;                    Game. The move counter is reset to the initial move count
;                    and the game LEDs pattern is reset to the default game LED
;                    pattern. The game state is also reset to the game over 
;                    state with the lose message to be displayed.
;
; Operation:         Calls ResetGameLEDs and ResetMoveCounter to reset the
;                    game LEDs and move counter to the initial conditions.
;                    The GAME_OVER_STATE is loaded into the shared GameState
;                    variable and the GAME_LOSE_MESSAGE is loaded into the
;                    shared GameOVerMessage variable.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  MoveCounter (W) - the move counter is set to the inital
;                                      move count 
;                    CurrGameLEDsPatt (W) - The current game LEDs pattern is
;                                           set to the default game LEDs pattern
;                    GameState (W) - The game state is set to GAME_OVER
;                    GameOVerMessage - The game over message is set to lose
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Registers Used:    R16, R17.
; Stack Depth:       O bytes.
;
; Author:            Steven Lei
; Last Modified:     June 21, 2024
;
; Psuedo code:
	; InitHexerGame(){
	; 	ResetGameLEDs()
	; 	ResetMoveCounter()
    ;   GameState = GAME_OVER
    ;   GameOverMessage = "LOSE"
	; }

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

DoneInitHexerGame:                  ; done initializing hexer game variables
    RET                                 ; so return


; DisplayMoveCounter
;
; Description:       This function displays the move counter, indicating
;                    the amount of moves the player has left. 
;
; Operation:         Loads the high and low bytes of the MoveCounter
;                    into R17 and R16 respectively. The DisplayHex 
;                    procedure is then called.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  MoveCounter (R) - current move count is read to 
;                                              be displayed
; Global Variables:  None.
;
; Input:             None.
; Output:            The move count is shown on the 7 segment display.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Registers Used:    R16, R17.
; Stack Depth:       None.
;
; Author:            Steven Lei
; Last Modified:     June 21, 2024
;
; Psuedo code:
	; DisplayMoveCounter(){
	; 	DisplayHex(MoveCounter)
	; 	RETURN
	; }

DisplayMoveCounter:
    LDS		R16, MoveCounter       ; set the current move counter as arguments
	LDS		R17, MoveCounter+1
	RCALL	DisplayHex		            ; and display it
DoneDisplayMoveCounter:            ; done displayingn move counter
	RET                                 ; and return

; DisplayCurrGameLEDs
;
; Description:       This function displays the current game LED pattern. The
;                    current game LED pattern should be stored in the shared
;                    variable CurrGameLEDSspatt.
;
; Operation:         Loads the high and low bytes of the CurrGameLEDsPatt
;                    into R17 and R16 respectively. The DisplayGameLEDs 
;                    procedure is then called.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  CurrentGameLEDsPatt (R) - current game LEDs is read to 
;                                              be displayed
; Global Variables:  None.
;
; Input:             None.
; Output:            The current game LEDs is shown on the LEDs display.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Registers Used:    R16, R17.
; Stack Depth:       0 bytes.
;
; Author:            Steven Lei
; Last Modified:     June 21, 2024
;
; Psuedo code:
	; DisplayCurrGameLEDs(){
	; 	DisplayGameLEDS(CurrGameLEDsPatt)
	; 	RETURN
	; }


DisplayCurrGameLEDs:               
    LDS     R16, CurrGameLEDsPatt   ; set the current LEDs pattern as arguments     
    LDS     R17, CurrGameLedsPatt+1
    RCALL   DisplayGameLEDs             ; and display it

DoneDisplayCurrGameLEDs:            ; done displaying
	RET                                 ; so return



; HexerPlayGameLoop
;
; Description:       This function plays the HexerGame and loops infinitely.  
;                    Depending on the game state machine, this user will either
;                    be able to reset the game or play the game until they win
;                    or lose. 
;
; Operation:         Uses a state machine to check which game state to run. 
;                    The GAME_PLAY state allows the user to play the game by 
;                    pressing valid switches to update the move count and change
;                    the game LEDs orientation. The GAME_OVER state displays
;                    the game over message (either win or loss) and allows the 
;                    user to reset the game manually or randomly. The GAME_
;                    MANUAL_RESET_STATE allows the user to manually reset LEDs.
; 
; Arguments:         None.
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
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Registers Used:    None.
; Stack Depth:       O bytes.
;
; Author:            Steven Lei
; Last Modified:     June 21, 2024
;
; Pseudocode:
;
; HexerPlayGameLoop(){
    ; WHILE(TRUE){
    ;     SWITCH (GameState){
    ;         CASE (GAME_PLAY_STATE) {
    ;             GamePlayState()
    ;             break
    ;         } 
    ;         CASE (GAME_OVER_STATE) {
    ;             GameOverState()
    ;             break
    ;         }
    ;         CASE (GAME_MANUAL_RESET_STATE) {
    ;             GameManualResetState()
    ;             break
    ;         }
    ;     }
    ; }
    ; RETURN
; }

HexerPlayGameLoop:

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
    


; GameOverState
;
; Description:       This function runs the game over state, which is when the
;                    user has either won or lost the game and the game is 
;                    waiting for input to restart the game. The game can only
;                    be restarted by pressing START + RANDOM_RESET buttons
;                    together or START + MANUAL_RESET0/1 together. This
;                    function also displays the game over message, e.g.
;                    "WIN" or "LOSE". All other button presses do nothing. 
;
; Operation:         Calls DisplayHex to display the game over message. The
;                    function waits until user input is provided by GetSwitches
;                    (which is a blocking function) and then checks if the
;                    switch press is a combination of START + RANDOM_RESET
;                    or START + MANUAL_RESET0/1. If the switch press is valid,
;                    the appropriate reset option will be chosen.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  GameState (W) - the game state is set to GAME_PLAY if user 
;                                    resets the game
;                    GameOverMessage (R)- The game over message is read and
;                                          displayed.
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Registers Used:    R16, R17.
; Stack Depth:       O bytes.
;
; Author:            Steven Lei
; Last Modified:     June 21, 2024
;
; Psuedo code:
	; GameOverState(){
	; 	DisplayHex(GameOverMessage)
    ;   SwitchPattern = GetSwitches()
    ;   IF (SwitchPattern == START_RANDOM_RESET) {
    ;       RandomResetGame(); 
    ;   } ELSE IF (SwitchPattern == START_MANUAL_RESET0 || SwitchPattern 
    ;                                        == START_MANUAL_RESET1 ) {
    ;       ManualResetGame();
    ;   }
    ;   RETURN
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



; HandlePlaySwitchPress
;
; Description:       This function handles a switch press in the game play 
;                    state. If the switch press is corresponds to a game LEDs
;                    switch, the game LEDs and move counter will be updated by
;                    calling the associated switch handler function with the
;                    proper arguments. 
;                    If the switch press does not match a valid switch pattern,
;                    the function will just return. 
;
; Operation:         Calls GetSwitches (blocking) to get the switch press. Then 
;                    Iterates through the SwitchHandlerTable to see if the
;                    switch press matches any switch pattern in the table. If it
;                    does, initializes the LEDs Mask, RotationTable, and calls
;                    the respective function to manipulate the corresponding
;                    game LEDs on the board. If reached the end of the table
;                    and no match is found, return.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   R16 - The debounced switch pattern.
;                    Z - the switch handler table
;                    
; Shared Variables:  SwitchHandlerTable: The switch handler table
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Registers Used:    R16, R17, R18, R19, R20, R21, R22, R23, Z (ZH | ZL)
; Stack Depth:       O bytes.
;
; Author:            Steven Lei
; Last Modified:     June 21, 2024
;
; Pseudo code: 
    ; HandlePlaySwitchPress(){
        ; SwitchPattern = GetSwitches
        ; Row = 0
        ; Columm = 0
        ; MatchedPattern = false
        ; WHILE (!MatchedPattern){
        ;     IF(SwitchHandlerTable[Row][Column] == SwitchPattern){
        ;         Column++
        ;         LEDs_Mask = SwitchHandlerTable[Row][Column] 
        ;         Column+=2
        ;         RotatationTable = SwitchHandlerTable[Row][Column] 
        ;         Column+=2 
        ;         HandlerFunc = SwitchHandlerTable[Row][Column] 
        ;         RETURN HandlerFunc(LEDs_MASK, RotatationTable)
        ;     } ELSE IF (SwitchHandlerTable[Row][Column] == SW_HAN_TABLE_LAST) {
        ;         RETURN
        ;     } ELSE {
        ;         Row += SW_HAN_TABLE_ROW_OFFSET
        ;     }
        ;     RETURN
        ; }

HandlePlaySwitchPress:

InitHandlePlaySwitchPress:                  ; initialize the table and indexer
    LDI     ZL, LOW(2 * SwitchHandlerTable)         ; initialize the table
    LDI     ZH, HIGH(2 * SwitchHandlerTable)

GetSwitchHandlerLoop:           ; loop and find the corresponding switch handler
    LPM     R17, Z+                 ; first column of table is the switch patt
    CP      R16, R17                ; so compare to debounced switch patt in R16
    BREQ    InitSwitchHandler           ; and set the switch handler if matched

    CPI     R17, SW_HAN_TABLE_LAST      ; if at last row of table and switch  
    BREQ    DoneHandlePlaySwitchPress       ; pattern not found, return

    ADIW    Z, SW_HAN_TABLE_ROW_OFFSET ; skip to next row of table if no match
    RJMP    GetSwitchHandlerLoop        ; and loop until at the end of table

InitSwitchHandler:              ; set up arguments for switch handler 
	ADIW	Z, 	1						; increment the z pointer 

    LPM     R18, Z+                     ; get the LED mask to apply
    LPM     R19, Z+

    LPM     R20, Z+                     ; get the rotation table to use
    LPM     R21, Z+

    LPM     R22, Z+                     ; get the function to call
    LPM     R23, Z
    MOV     ZL, R22
    MOV     ZH, R23

RunSwitchHandler:              ; Call the switch handler
    ICALL

DoneHandlePlaySwitchPress:      ; Done handling switch press
	RET                             ; and return

; GamePlayState
;
; Description:       This function runs the game play state, which is when the
;                    user is currently playing the game. The move counter
;                    is only updated if a valid game LED switch is pressed.
;                    After each button press, the move counter and LED pattern
;                    is checked to see if the player has lost, won, or can still
;                    play.
;
; Operation:         Calls GetSwitches() to wait for a user switch press
;                    (blocking). Then calls HandlePlaySwitchPress to handle any
;                    switch presses that could change game LEDs. Calls GameOver 
;                    after the switch press is handled to see if the game
;                    is over or can be continued. Then calls DisplayCurrGameLEDs
;                    and DisplayMoveCounter to update the displays.
; 
; Arguments:         None.
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
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Registers Used:    None.
; Stack Depth:       O bytes.
;
; Author:            Steven Lei
; Last Modified:     June 21, 2024
;
; Pseudocode:
;
; GamePlayState(){
;     SwitchPattern = GetSwitches
;     HandlePlaySwitchPress(SwitchPattern)
;     GameOver(CurrGameLEDsPatt, MoveCounter)
;     DisplayMoveCounter()
;     DisplayCurrGameLEDs()
; }

GamePlayState:                  ; NOTE: This function should be called in a loop

HandleUserInput:                ; loop until there is a switch press
    
	RCALL   GetSwitches             ; wait until a switch is avaiable (blocking)    
    RCALL   HandlePlaySwitchPress       ; update the game based on the switch press
    RCALL   GameOver                ; and update the game state if win or loss

DisplayAll:                     ; display updated move counter and game LEDs
    RCALL   DisplayMoveCounter
    RCALL   DisplayCurrGameLEDs

DoneGamePlayState:              ; done with game play state 
    RET                             ; and return

; GameOver
;
; Description:       This function takes in the current game LEDs pattern and
;                    move count as arguments and checks if the game is now over.
;                    The game is won when the player has turned on all LEDs 
;                    and the game is loss when the player has no moves left.
;                    It prioritizes wins over losses, so if the player's last 
;                    move resulted in the game LEDs being all lit, the game
;                    is won instead of lost. If the game is either won or lost,
;                    the game state is changed to GAME_OVER, and the respective
;                    message is displayed. If neither are true, the function
;                    simply returns.
;
; Operation:         Loads the CurrGameLEDsPatt and compares it to the 
;                    GAME_OVER_LED_PATT pattern. If the patterns match, the
;                    WIN message is displayed and the GameState shared variable
;                    is changed to GAME_OVER. If not, loads the move counter
;                    and compare it with zero. If match, the LOST message is
;                    displayed and the GameState shared variable is changed to
;                    GameOver. If no matches, just return.
;
; Arguments:         CurrGameLEDsPatt - The current game LEDs pattern
;                    MoveCounter - The number of moves left
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  MoveCounter (R) - the move count is compare to zero 
;                    CurrGameLEDsPatt (R) - the current game LEDs pattern is
;                                           compared to all LEDs ON
;                    GameState (W) - The game state is set to GAME_OVER if
;                                    all LEDs are ON or no moves left
;                    GameOverMessage (W) - The game over message is set to LOSE 
;                                          or WIN if the respective conditions
;                                          are true
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Registers Used:    R16, R17.
; Stack Depth:       0 bytes.
;
; Author:            Steven Lei
; Last Modified:     June 21, 2024
;
; Psuedo code:
	; GameOver(CurrGameLEDsPatt, MoveCounter){
	; 	IF (CurrGameLEDsPatt == GAME_OVER_LED_PATT) {
    ;       GameOverMessage = "WIN"
    ;       GameState = GAME_OVER
    ;   } ELSE IF (MoveCOutner == GAME_OVER_MOVE_COUNT){
    ;       GameOverMessage = "LOSE"       
    ;       GameState = GAME_OVER
    ;   } 
    ;   RETURN
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

DoneGameOver:                           ; done checking if game is over
    RET                                     ; so return

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

; InvertGameLEDs
;
; Description:       This function takes in the current game LEDs pattern and 
;                    the white hexagon LEDs mask and then inverts only LEDs in t
;                    the white hexagon area. LEDs that are off in the white 
;                    hexagon are now on and vice versa. The new LED pattern is 
;                    then stored. This function does NOT display the new led 
;                    pattern. Upon success, the move count is 
;                    decremented.
;
; Operation:         The white hexagon LED mask is first applied to  the current 
;                    pattern to get the white hexagon bits. Then this is 
;                    inverted. The white hexagon bits in the pattern are then 
;                    cleared so that the inverted bits can be applied to the 
;                    pattern. Calls UpdateMoveCounter to decrement the move 
;                    the MoveCounter.
;                     
;
; Arguments:         CurrGameLEDsPatt - The current game LEDs pattern
;                    WHITE_LEDS_MASK -  The white hexagon LEDs mask to aply 
; Return Value:      None.
;
; Local Variables:   R20 | 21 : The final LED mask to apply to the pattern
;                    R16 | R17: The current LED pattern
; Shared Variables:  MoveCounter (W) - the move count is decremented 
;                    CurrGameLEDsPatt (R,W) - the current game LEDs pattern is
;                                           masked to get white hexagon LEDs
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Registers Used:    R16, R17, R18, R19, R20, R21.
; Stack Depth:       0 bytes.
;
; Author:            Steven Lei
; Last Modified:     June 21, 2024
;
; Psuedo code:
	; InvertGameLEDs(CurrGameLEDsPatt, LEDs_MASK){
	; 	  NewWhiteHexagonLEDs = CurrGameLEDsPatt &  LEDs_MASK
    ;     NewWhiteHexagonLEDs = (~NewWhiteHexagonLEDs) & LEDs_MASK
    ;     CurrentGameLEDs &= ~LEDs_MASK
    ;     CurrentGameLEDs = CurrentGameLEDs | NewWhiteHexagonLEDs
    ;   RETURN
	; }

InvertGameLEDs:

MaskCurrLEDsPatt:            ; apply the LED mask to the current game LEDs
    LDS     R20, CurrGameLEDsPatt   ; load current game LEDs pattern
    LDS     R21, CurrGameLEDsPatt+1 
    AND     R20, R18                ; apply the mask in R19|R18 to get shape
    AND     R21, R19

InvertOnlyMaskedBits:       ; invert only the masked bits
    COM     R20                     ; invert the entire pattern
    COM     R21
	AND		R20, R18				; apply the mask to get only the masked bits
	AND		R21, R19	

ClearMaskedBits:            ; clear the masked bits on the current pattern
    COM     R18                     ; invert the mask 
    COM     R19
    LDS     R16, CurrGameLEDsPatt   ; load current game LEDs pattern
    LDS     R17, CurrGameLEDsPatt+1     
    AND     R16, R18                ; clear all the corresponding mask bits
    AND     R17, R19
ApplyInvertedBits:          ; now apply the inverted bits to the pattern
    OR      R16, R20                ; get the new pattern          
    OR      R17, R21                    	
	STS		CurrGameLedsPatt, R16   ; and store the new pattern
	STS		CurrGameLedsPatt+1, R17

DoneInvertGameLEDs:           ; done inverting the LEDs 
    RCALL   UpdateMoveCounter           ; update the move counter 
    RET                                 ; and return 

; RotateShape
;
; Description:       This function takes in the current game LEDs pattern, a
;                    LED mask, and a rotation table to get the next rotated LED
;                    pattern. The new rotated LED pattern is stored into the
;                    CurrGameLEDsPatt variable and the move counter is 
;                    decremented.
;
; Operation:         The current game LEDs pattern is masked with the specified
;                    LED mask to get only the bits corresponding to that shape
;                    (e.g. blue hexagon). The masked bits are then looked up
;                    in the rotation table to find the next pattern. The next
;                    pattern is retrieved and applied back to only the mask bits
;                    on the current game LEDs pattern.
;                    
; Arguments:         CurrGameLEDsPatt - The current game LEDs pattern
;                    LEDsMask -  The  LEDs mask to apply 
;                    RotatationTable - the rotation table to use to get next patt
; Return Value:      None.
;
; Local Variables:   R20 | 21 : The final LED mask to apply to the pattern
;                    R16 | R17: The current LED pattern
; Shared Variables:  MoveCounter (W) - the move count is decremented 
;                    CurrGameLEDsPatt (R,W) - the current game LEDs pattern is
;                                           masked to get the selected  LEDs
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Registers Used:    R16, R17, R18, R19, R20, R21.
; Stack Depth:       0 bytes.
;
; Author:            Steven Lei
; Last Modified:     June 21, 2024
;
; Psuedo code:
	; RotateShape(CurrGameLEDsPatt, LEDs_Mask, RotationTable){
    ;     MaskedLEDs = LEDsMask & CurrGameLEDsPatt
    ;     FoundMatch = false
    ;     TableIndex = 0;
    ;     WHILE (!FoundMatch) {
    ;       IF( MaskedLEDs == RotationTable[TableIndex]){
    ;            RotatedLEDs = RotationTable[TableIndex + 1]
    ;        } ELSE {
    ;            TableIndex+=ROT_TABLE_ROW_OFFSET
    ;        }  
    ;    }
    ;     CurrentGameLEDs &= ~LEDs_MASK
    ;     CurrentGameLEDs = CurrentGameLEDs | RotatedLEDs
    ;   RETURN
	; }

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
    AND     R16, R18                    ; clear all the mask bits in the pattern
    AND     R17, R19

    OR      R16, R20                    ; and apply the new shape pattern to
    OR      R17, R21                    ; the game LED pattern (R17 - R16)

    STS     CurrGameLEDsPatt, R16       ; and store the pattern as well to data
    STS     CurrGameLEDsPatt+1, R17
    RJMP    DoneRotateShape             ; now display it

GoToNextRotationTableRow:           ; No match, so move to next row
    ADIW    ZL, ROT_TABLE_ROW_OFFSET        ; advance index to next row in table
    RJMP    FindNextGameLEDsPattLoop        ; and loop

DoneRotateShape:                    ; done rotating the shape 
    RCALL UpdateMoveCounter         ; update the move counter 
    RET                                 ; so return 

; UpdateMoveCounter
;
; Description:       This function updates the move counter by decrementing it.
;                    Note: this function should be called after a valid game
;                    button press.
; Operation:         The MoveCounter shared variable is loaded, decremented by 
;                    1, and then stored.
;                     
; Arguments:         None
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  MoveCounter (W) - the move count is decremented 
;
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
; Algorithms:        None.
; Data Structures:   None.
;
; Special Notes:	 None.
; Limitations:		 None.
;
; Registers Used:    R16, R17, Y (YH | YL)
; Stack Depth:       0 bytes.
;
; Author:            Steven Lei
; Last Modified:     June 21, 2024
;
UpdateMoveCounter:                  ; decrement the move counter
    LDS     YL, MoveCounter             ; use the y pointer, counter is 2 bytes
    LDS     YH, MoveCounter+1
    SBIW    Y, 1          
    STS     MoveCounter, YL
    STS     MoveCounter+1, YH
	MOV 	R16, YL
	MOV		R17, YH
	RCALL 	DisplayHex
	
DoneUpdateMoveCounter:              ; done updating the move counter
	RET                                 ; so return
	

; This table corresponds the switch pattern pressed with the LEDs to change.
; The LEDMask and Tables are both used as arguments into the correspoding 
; function.

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
MoveCounter:        .BYTE   2   ; The move counter
CurrGameLEDsPatt:   .BYTE   2   ; The current game LEDs pattern
GameOverMessage:    .BYTE   2   ; The game over message to displa
GameState:          .BYTE   1   ; The current state of the game
