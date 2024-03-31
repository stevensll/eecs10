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
;    05/19/23  Steven Lei       initial revision, adapted from "clckirq.asm"
;                               in EXAMPLES on Glen's website
;    05/19/23  Steven Lei       changed to call switch debouncing and handle
;                               timer compare matches instead of overflows.
;                               PUSH/POP on R17
;                               compare match events instead of overflow events.
;                               PUSH/POP R17 instead of R16, since R16 contains
;                               the debounced switch pattern.
;   06/25/23  Steven Lei        added LEDmuxing
;   03/27/24  Steven Lei        updated comments and formatting
.cseg

; Timer0CompareHandler
;
; Description:       This is the event handler for compare events on on timer
;                    0. It just calls the appropriate handlers.
;
; Operation:         The display mux function  is called
;                    and R16-R17 & Z (ZH | ZL) registers are saved.
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
; Stack Depth:       7 bytes
;
; Author:            Steven Lei
; Last Modified:     05/19/23

Timer0CompareHandler:

StartTimer0CompareHandler:             ;save all touched registers
        PUSH    ZH
        PUSH    ZL
        PUSH    R17
        PUSH    R16
        PUSH    R4
        PUSH    R0
        IN      R0, SREG               ;save the status register too
        PUSH    R0
DoDisplay:                             ;handle LED muxing 
        RCALL   

;DoSwitches:                            ;handle switch debouncing/repeating
;        RCALL   DebounceSwitches

DoneTimer0CompareHandler:              ;done with handler
        POP     R0                     ;restore flags
        OUT     SREG, R0
        POP     R0                     ;restore registers
        POP     R4
        POP     R16
        POP     R17
        POP     ZL
        POP     ZH
        RETI                           ;and return
