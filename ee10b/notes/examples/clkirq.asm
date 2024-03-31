;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   CLKIRQ                                   ;
;                         General Interrupt Handlers                         ;
;                   Microprocessor-Based Clock (AVR version)                 ;
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



; device definitions
;.include  "4414def.inc"

; local include files
;    none




.cseg




; Timer0OverflowHandler
;
; Description:       This is the event handler for overflow events on on timer
;                    0.  It just calls the appropriate handlers.
;
; Operation:         The timing handler, switch debouncer, and LED muxing
;                    functions are called.
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
; Stack Depth:       11 bytes
;
; Author:            Glen George
; Last Modified:     August 24, 2018

Timer0OverflowHandler:

StartTimer0OverflowHandler:             ;save all touched registers
        PUSH    ZH
        PUSH    ZL
        PUSH    R19
        PUSH    R18
        PUSH    R16
        PUSH    R0
        IN      R0, SREG                ;save the status register too
        PUSH    R0


DoTiming:                               ;handle timing functions
        RCALL   TimingHandler

DoSwitches:                             ;handle switch debouncing/repeating
        RCALL   SwitchDebounce

DoLEDs:                                 ;handle LED muxing
        RCALL   LEDMux

        ;RJMP   DoneTimer0OverflowHandler  ;and done with the handler


DoneTimer0OverflowHandler:              ;done with handler
        POP     R0                      ;restore flags
        OUT     SREG, R0
        POP     R0                      ;restore registers
        POP     R16
        POP     R18
        POP     R19
        POP     ZL
        POP     ZH
        RETI                            ;and return
