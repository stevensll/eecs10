;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                 HexerIRQ                                   ;
;                         General Interrupt Handlers                         ;
;                           Hexer Game (AVR version)                         ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the general interrupt handlers for the clock.  The
; handlers included are:
;    Timer0OverflowHandler  - handler for timer 0 overflow interrupts
;
; Revision History:
;    12/09/12  Glen George      initial revision
;     9/21/13  Glen George      removed unneeded push/pop of R17
;     4/20/18  Glen George      modified to include LED muxing for new
;                                  hardware design
;     4/29/18  Glen George      pushed more registers so it works with the
;                                  structure version of switch code too
;     5/02/18  Glen George      changed filename from irq.asm to clkirq.asm
;     8/24/18  Glen George      changed to using Timer 0 instead of Timer 1
;    05/19/23  Steven Lei       changed to call switch debouncing and handle
;                               compare match events instead of overflow events.
;                               PUSH/POP R17 instead of R16, since R16 contains
;                               the debounced switch pattern.
;   06/15/23   Steven Lei       added LEDmuxing


.cseg




; Timer0OverflowHandler
;
; Description:       This is the event handler for compare events on on timer
;                    0.  It just calls the appropriate handlers.
;
; Operation:         The switch debounce function (DebounceSwitches) is called
;                    and R17-R19 & Z registers are saved.
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
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: None.
;
; Author:            Steven Lei
; Last Modified:     June 15, 2023

Timer0CompareHandler:

StartTimer0CompareHandler:             ;save all touched registers
        PUSH    ZH
        PUSH    ZL
        PUSH    YH
        PUSH    YL
        PUSH    R19
        PUSH    R18
        PUSH    R17
        PUSH    R16
        PUSH    R4
        PUSH    R0
        IN      R0, SREG                ;save the status register too
        PUSH    R0

;DoSwitches:                             ;handle switch debouncing/repeating
;       RCALL   DebounceSwitches
DoLEDS:                                 ;handle LED muxing
        RCALL   LEDmux
DoneTimer0CompareHandler:              ;done with handler
        POP     R0                      ;restore flags
        OUT     SREG, R0
        POP     R0                      ;restore registers
        POP     R4
        POP     R16
        POP     R17
        POP     R18
        POP     R19
        POP     YL
        POP     YH
        POP     ZL
        POP     ZH
        RETI                            ;and return
