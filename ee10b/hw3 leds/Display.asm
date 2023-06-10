;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                    DISPLAY                                 ;
;                               Display Routines                             ;
;                   Microprocessor-Based Hexer Game (AVR version)            ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions for displaying the game LEDs and the 7 segment
; display for the Hexer Game. The functions included are: 
;    InitDisplay        - initialize the display and its variables
;    ClearDisplay       - clears the LED buffer
;    DisplayHex         -
;    DisplayGameLEDs()  -

; The local functions included are:
;   None
; Revision History:
;   06/09/23    Steven Lei      Initial revision
;


; local include files
;.include  "clkgen.inc"
;.include  "clkdisp.inc"




.cseg




; InitDisplay
;
; Description:       This function initializes the display (colon off, digits
;                    blanked, alarm as set) and display multiplexing
;                    variables.
;
; Operation:         This function turns off the colon, blanks the digits, and
;                    sets the alarm LED appropriately.  It also initializes
;                    the display muxing variables.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   R16 - segment counter.
;                    Y   - pointer to display buffer.
; Shared Variables:  currentSegs - buffer is filled with LED_BLANK.
; Global Variables:  None.
;
; Input:             None.
; Output:            The LED display is blanked and the alarm LED is turned
;                    on or off (depending on the alarm setting).
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16, R17, Y (YH | YL)
;
; Author:            Steven Lei
; Last Modified:     June 9, 2023

InitDisplay:


StartInitDisplay:                       ;start clearing the display
        LDI     R16, NUM_SEGS           ;number of segments to clear
        LDI YL, LOW(currentSegs)    ;point to the segments
        LDI YH, HIGH(currentSegs)
        LDI     R17, LED_BLANK          ;get the blank segment pattern

InitBuffLoop:               ;loop clearing the segments
        ST  Y+, R17         ;clear the segments
    DEC R16         ;update loop counter
    BRNE    InitBuffLoop        ;and loop until done
        ;BREQ   InitColonAlarm          ;then initialize the colon and alarm


InitColonAlarm:                         ;turn off colon and set alarm
        RCALL   DisplayColonOff

        RCALL   AlarmSet                ;next keep the alarm setting right
        RCALL   DisplayAlarm

        RCALL   InitLEDMux              ;finally, initialize muxing

        ;RJMP   EndInitDisplay          ;all done now


EndInitDisplay:                         ;done initializing the display - return
        RET




; ClearDisplay()
;
; Description:       This function clears the 7 segment and game LEDS. After it is called,
;                    all LEDs should be off.
;
; Operation:         The function gets the digits from the passed time and
;                  
;
; Arguments:         None
; Return Value:      None.
;
; Local Variables:   R16 - the current row of the buffer

; Shared Variables:  currentSegs - set to segment pattern for passed time.
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
; Registers Changed: flags, R0, R16, R17, R18, R19, R20, R21, R22, R23,
;                    
;
; Author:            Steven Lei
; Last Modified:     June 9, 2023

ClearDisplay:

ClearLoop:
    LDI     R16, LED_BLANK
    STS     LEDbuffer+currRow, R16
    INC     currRow     
    CPI     currRow, BUFFER_SIZE
    BREQ    ClearDisplayDone

ClearDisplayDone:
    LDI     R16, ZEROES                     ; reset the counter
    STS     currRow, R16 
    RET 


; DisplayHex(n)
;
; Description:       This function clears the 7 segment and game LEDS. After it is called,
;                    all LEDs should be off.
;
; Operation:         The function gets the digits from the passed time and
;                  
;
; Arguments:         None
; Return Value:      None.
;
; Local Variables:   R16 - the current row of the buffer

; Shared Variables:  currentSegs - set to segment pattern for passed time.
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
; Registers Changed: flags, R0, R16, R17, R18, R19, R20, R21, R22, R23,
;                    
;
; Author:            Steven Lei
; Last Modified:     June 9, 2023


; DisplayGameLEDs(m)
;
; Description:       This functino is passed a 16 bit mask that indicates the game LEDs to turn off. 
;                    If the bit in the mask is set, the corresponding game LED is turned on and 
;                    if it is reset, the LED is turned off. The bits are defined as the follows:
;                    MASK BITS: | 15 | 14 | 13 | 12 | 11 | 10 | 09 | 08 | 07 | 06 | 05 | 04 | 03 | 02 | 01 | 00 |
;                    LEDS:      | L9 | L1 | L5 |NONE|L10 | L4 | L3 | L2 |L13 |L11 | L8 |L15 |L14 |L12 | L7 | L6 |
;                    
; Operation:         The function gets the digits from the passed time and
;                    Unused  bits (NONE) have no effect on the display
;
; Arguments:         R17 | R16 - the 16 bit mask (m) 
; Return Value:      None.
;
; Local Variables:   R16 - the current row of the buffer

; Shared Variables:  
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
; Registers Changed: 
;                    
;
; Author:            Steven Lei
; Last Modified:     June 9, 2023

DisplayGameLEDs:

MaskHiGameLED:                     ; high bit of (m) is in R17
    ANDI    R17, GAME_LED_HI_MASK      ; mask the 4th bit of (m) to low since it is not used
    LDS     LEDbuffer+GAME_LED_HI, R18 ;
    ANDI    R18, -GAME_LED_HI_MASK     ;
    OR      R17, R18
    STS     LEDbuffer+GAME_LED_HI, R17 ; 

MaskLowGameLED:                    ; low bit of (m) is in R16
    STS     LEDbuffer+GAME_LED_LO, R16  ; doesn't need any masking since all bits in mask are used
    RET                             ; done so return




; ClearDisplay()
;
; Description:       This function clears the 7 segment and game LEDS. After it is called,
;                    all LEDs should be off.
;
; Operation:         The function gets the digits from the passed time and
;                  
;
; Arguments:         None
; Return Value:      None.
;
; Local Variables:   R16 - the current row of the buffer

; Shared Variables:  currentSegs - set to segment pattern for passed time.
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
; Registers Changed: flags, R0, R16, R17, R18, R19, R20, R21, R22, R23,
;                    
;
; Author:            Steven Lei
; Last Modified:     June 9, 2023




SegTable:

;                  gfedcba     gfedcba
        .DB 0b00111111, 0b00000110  ;digits 0, 1
        .DB 0b01011011, 0b01001111  ;digits 2, 3
        .DB 0b01100110, 0b01101101  ;digits 4, 5
        .DB 0b01111100, 0b00000111  ;digits 6, 7
        .DB 0b01111111, 0b01100111  ;digits 8, 9
        .DB 0b00000000, 0b00000000  ;digits 10, 11 (unused)
        .DB 0b00000000, 0b00000110  ;digit 12  1:00 AM - 9:59 AM
                    ;digit 13 10:00 AM - 12:59 AM
        .DB 0b00000000, 0b00000110  ;digit 14  1:00 PM - 9:59 PM
                    ;digit 15 10:00 PM - 12:59 PM




;the data segment

.dseg


LEDbuffer  :    .BYTE   BUFFER_SIZE ;the 7 byte LED buffer containing the game LED and 7 segment bits

currRow    :    .BYTE   1           ;


currentSegs:    .BYTE   NUM_SEGS    ;buffer holding currently displayed segment patterns

curMuxSeg:      .BYTE   1               ;current segment number being multiplexed
curMuxSegPatt:  .BYTE   1       ;current segment output pattern