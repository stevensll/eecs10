;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   CLKSWTCH                                 ;
;                                Switch Routines                             ;
;                    Microprocessor-Based Clock (AVR version)                ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the functions for debouncing the switches and getting the
; switch status.  The public functions included are:
;    SwitchDebounce - debounce the "Hour Set" and "Minute Set" switches
;    InitSwitches   - initialize switch debouncing
;    MinSet         - have debounced "Minute Set" switch
;    HrSet          - have debounced "Hour Set" switch
;    SwMinSet       - "Minute Set" switch status (not debounced)
;    SwHrSet        - "Hour Set" switch status (not debounced)
;    SwSet          - "Set" switch status (not debounced)
;    SwAlarm        - "Alarm On/Off" switch status (not debounced)
;    SwSnooze       - "Snooze" switch status (not debounced)
;    SwDisplay      - "Display" switch setting (not debounced)
;    SwitchStatus   - status of all switches (not debounced)
;
; The local functions included are:
;    ResetMinSwitch - initialize minute switch debounce timing
;    ResetHrSwitch  - initialize hour switch debounce timing
;
; Revision History:
;    11/1/93   Glen George              initial revision
;    10/26/94  Glen George              updated comments
;    10/30/95  Glen George              changed sense of MINDebouncedFlg and
;                                          HRDebouncedFlg to be more intuitive
;                                       added enabling of alarm to the
;                                          SwitchDebounce function when one of
;                                          the set switches has been pressed
;                                       updated comments
;    10/28/96  Glen George              simplified the code in SwitchDebounce
;                                       updated comments
;     9/15/97  Glen George              broke InitSwitches into ResetMINSwitch
;                                          and ResetHRSwitch so they could
;                                          be used independently, especially
;                                          in SwitchDebounce
;                                       changed "Local Variables" to "Shared
;                                          Variables"
;    10/11/98  Glen George              changed procedure names to have an Sw
;                                          prefix instead of a suffix
;                                       changed capitalization of variables
;                                       added MinSet and HrSet functions
;                                       added $INCLUDE of GENERAL.INC to get
;                                          definitions of TRUE and FALSE
;    12/26/99  Glen George              fixed the handling of the interrupt
;                                          flag in the critical code sections
;                                          of MinSet and HrSet
;                                       updated comments
;     1/26/00  Glen George              fixed a minor bug in handling of
;                                          debounced flags (accessed as 16-bit
;                                          value instead of 8-bit)
;     1/30/02  Glen George              added proper assume for ES
;     1/31/03  Glen George              updated comments
;    12/24/03  Glen George              updated comments
;     7/12/10  Glen George              changed names of include files
;     7/14/10  Glen George              updated comments
;     9/07/12  Glen George              updated comments
;     4/24/18  Glen George              converted to AVR clock
;     5/07/18  Glen George              commented out .include statements
;     8/25/18  Glen George              converted to new hardware design
;     4/02/19  Glen George              updated to match new definitions



; device definitions
;.include  "4414def.inc"

; local include files
;.include  "clkgen.inc"
;.include  "clksw.inc"




.cseg




; SwitchDebounce
;
; Description:       This procedure debounces the "Minute Set" and "Hour Set"
;                    switches.  It also handles the auto-repeat for those same
;                    switches.  It is expected to be called approximately once
;                    per second.
;
; Operation:         The "Minute Set" and "Hour Set" switches are debounced.
;                    The debounce counter is reset if the switch is up and
;                    decremented if it is pressed.  When the counter reaches
;                    zero the appropriate flag is set and the counter is
;                    reloaded with the repeat time.  When a switch is down the
;                    associated repeat time counter is also decremented and
;                    when it reaches zero the associated repeat time is
;                    changed to the fast repeat rate.  When a switch is not
;                    pressed all of its associated counters are reset.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  hrCntr       - read and written (decremented and/or reset).
;                    hrDebounced  - written (set when "Hour Set" has been
;                                   debounced).
;                    hrRptCntr    - read and written (decremented and/or reset).
;                    hrRptRate    - written (set to FAST_RATE when hrRptCntr
;                                   hits zero, reset to SLOW_RATE when switch
;                                   is up).
;                    minCntr      - read and written (decremented and/or reset).
;                    minDebounced - written (set when "Minute Set" has been
;                                   debounced).
;                    minRptCntr   - read and written (decremented and/or reset).
;                    minRptRate   - written (set to FAST_RATE when minRptCntr
;                                   decrements to zero, reset to SLOW_RATE when
;                                   switch is up).
;
; Input:             The state of the "Minute Set" and "Hour Set" switches.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16, Z (ZH | ZL)
; Stack Depth:       2 bytes
;
; Author:            Glen George
; Last Modified:     April 24, 2018

SwitchDebounce:


DebMINSwitch:                           ;debounce the "Minute Set" switch
        RCALL   SwMinSet                ;check if the switch is down
        BREQ    MINSwitchDown           ;switch is down - process it
        ;BRNE   MINSwitchUp             ;else switch is up


MINSwitchUp:                            ;switch is up, reset counters
        RCALL   ResetMinSwitch
        RJMP    EndDebMINSwitch         ;and done "debouncing" the switch


MINSwitchDown:                          ;"Minute Set" switch is down - debounce it
	LDS	ZL, minCntr		;update debounce counter
	LDS	ZH, minCntr + 1
	SBIW	Z, 1			;decrement the counter
	STS	minCntr, ZL		;write it back to memory
	STS	minCntr + 1, ZH
        BRNE    MINNotDebounced         ;switch is not debounced yet
        ;BREQ   MINIsDebounced          ;"Minute Set" is now debounced (or repeated)

MINIsDebounced:                         ;have "Minute Set" switch press
        LDI     R16, TRUE               ;set flag indicating have switch
        STS     minDebounced, R16
        LDS     R16, minRptRate         ;setup to auto-repeat
        STS     minCntr, R16
        LDS     R16, minRptRate + 1
        STS     minCntr + 1, R16
        ;RJMP   MINRptCntUpdate         ;now update the repeat counter

MINNotDebounced:                        ;switch not debounced yet
        ;RJMP   MINRptCntUpdate         ;just update the repeat counter


MINRptCntUpdate:                        ;update (decrement) repeat rate counter
	LDS	ZL, minRptCntr		;get counter value
	LDS	ZH, minRptCntr + 1
	SBIW	Z, 1			;decrement the counter (to check for
	STS	minRptCntr, ZL	        ;   change in auto-repeat rate)
	STS	minRptCntr + 1, ZH      ;write it back to memory
        BRNE    MINNoRptRateUpdate      ;don't change auto-repeat rate yet
        ;BREQ   MINFastRpt              ;else switch to fast rate

MINFastRpt:                             ;time to switch to fast repeat rate
        LDI     R16, LOW(FAST_RATE)     ;change to fast repeat rate
        STS     minRptRate, R16
        LDI     R16, HIGH(FAST_RATE)
        STS     minRptRate + 1, R16
        ;RJMP   EndMINRptCntUpdate      ;done with repeat count update

MINNoRptRateUpdate:                     ;don't update the repeat rate yet
        ;RJMP   EndMINRptCntUpdate      ;done with repeat count update

EndMINRptCntUpdate:                     ;done with repeat rate adjustments
        ;RJMP   EndDebMINSwitch         ;done with "Minute Set" switch

EndDebMINSwitch:                        ;done with "Minute Set" switch
        ;RJMP   DebHRSwitch             ;debounce the "Hour Set" switch


DebHRSwitch:                            ;debounce the "Hour Set" switch
        RCALL   SwHrSet                 ;check if the switch is down
        BREQ    HRSwitchDown            ;switch is down - process it
        ;BRNE   HRSwitchUp              ;switch is up - reset everything


HRSwitchUp:                             ;switch is up, reset counters
        RCALL   ResetHrSwitch
        RJMP    EndDebHRSwitch          ;and done "debouncing" the switch


HRSwitchDown:                           ;"Hour Set" switch is down - debounce it
	LDS	ZL, hrCntr		;update debounce counter
	LDS	ZH, hrCntr + 1
	SBIW	Z, 1			;decrement the counter
	STS	hrCntr, ZL		;write it back to memory
	STS	hrCntr + 1, ZH
        BRNE    HRNotDebounced          ;switch is not debounced yet
        ;BREQ   HRIsDebounced           ;"Hour Set" is now debounced (or repeated)

HRIsDebounced:                          ;have "Hour Set" switch press
        LDI     R16, TRUE               ;set flag indicating have switch
        STS     hrDebounced, R16
        LDS     R16, hrRptRate          ;setup to auto-repeat
        STS     hrCntr, R16
        LDS     R16, hrRptRate + 1
        STS     hrCntr + 1, R16
        ;RJMP   HRRptCntUpdate          ;now update the repeat counter

HRNotDebounced:                         ;switch not debounced yet
        ;JMP    HRRptCntUpdate          ;just update the repeat counter


HRRptCntUpdate:                         ;update repeat rate counter
	LDS	ZL, hrRptCntr	        ;get counter value
	LDS	ZH, hrRptCntr + 1
	SBIW	Z, 1			;decrement the counter (to check for
	STS	hrRptCntr, ZL	        ;   change in auto-repeat rate)
	STS	hrRptCntr + 1, ZH       ;write it back to memory
        BRNE    HRNoRptRateUpdate       ;don't change auto-repeat rate yet
        ;BREQ   HRFastRpt               ;else switch to fast rate

HRFastRpt:                              ;time to switch to fast repeat rate
        LDI     R16, LOW(FAST_RATE)     ;change to fast repeat rate
        STS     hrRptRate, R16
        LDI     R16, HIGH(FAST_RATE)
        STS     hrRptRate + 1, R16
        ;RJMP   EndHRRptCntUpdate       ;done with repeat count update

HRNoRptRateUpdate:                      ;don't update the repeat rate yet
        ;RJMP   EndHRRptCntUpdate       ;done with repeat count update

EndHRRptCntUpdate:                      ;done with repeat rate adjustments
        ;RJMP   EndDebHRSwitch          ;done with "Hour Set" switch

EndDebHRSwitch:                         ;done with "Hour Set" switch
        ;RJMP   EndSwitchDebounce       ;done debouncing


EndSwitchDebounce:                      ;done debouncing switches
        RET                             ;just return




; InitSwitches
;
; Description:       This procedure initializes the switch debouncing
;                    variables.
;
; Operation:         The debouncing and repeating timers are reset and the
;                    auto-repeat rate is set the to slow rate.  The flags
;                    indicating a switch press is available are also cleared.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  hrDebounced  - written (reset to FALSE).
;                    minDebounced - written (reset to FALSE).
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: R16
; Stack Depth:       2 bytes
;
; Author:            Glen George
; Last Modified:     July 25, 2012

InitSwitches:


InitMINSwitch:                          ;initialize the "Minute Set" switch
        RCALL   ResetMinSwitch          ;reset all the counters
        LDI     R16, FALSE              ;no debounced switch
        STS     minDebounced, R16
        ;RJMP   InitHRSwitch            ;now initialize "Hour Set"

InitHRSwitch:                           ;initialize the "Hour Set" switch
        RCALL   ResetHrSwitch           ;reset all the counters
        LDI     R16, FALSE              ;no debounced switch
        STS     hrDebounced, R16
        ;RJMP   EndInitSwitches         ;done initializing the switches


EndInitSwitches:                        ;done so return
        RET




; MinSet
;
; Description:       Return whether or not have a debounced (or auto-repeated)
;                    "Minute Set" switch action.
;
; Operation:         The flag indicating there is a debounced "Minute Set"
;                    switch press (minDebounced) is checked and reset to
;                    FALSE.  This is done with interrupts disabled (critical
;                    code).
;
; Arguments:         None.
; Return Value:      Zero Flag - set if have a press or a repeat of the "Minute
;                                Set" switch.
;
; Local Variables:   None.
; Shared Variables:  minDebounced - read and written (set to FALSE).
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R0, R16, R17
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     July 25, 2012

MinSet:


        IN	R0, SREG                ;save interrupt flag status
        CLI                             ;can't interrupt this code

        LDS     R16, minDebounced       ;get the current switch flag status
        LDI     R17, FALSE              ;always reset the switch flag
        STS     minDebounced, R17

        OUT     SREG, R0                ;restore flags (possibly re-enabling interrupts)

        CPI     R16, TRUE               ;now set the zero flag appropriately


        RET                             ;done so return




; HrSet
;
; Description:       Return whether or not have a debounced (or auto-repeated)
;                    "Hour Set" switch action.
;
; Operation:         The flag indicating there is a debounced "Hour Set"
;                    switch press (hrDebounced) is checked and reset to FALSE.
;                    This is done with interrupts disabled (critical code).
;
; Arguments:         None.
; Return Value:      Zero Flag - set if have a press or a repeat of the "Hour
;                                Set" switch.
;
; Local Variables:   None.
; Shared Variables:  hrDebounced - read and written (set to FALSE).
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R0, R16, R17
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     July 25, 2012

HrSet:


        IN	R0, SREG                ;save interrupt flag status
        CLI                             ;can't interrupt this code

        LDS     R16, hrDebounced        ;get the current switch flag status
        LDI     R17, FALSE              ;always reset the switch flag
        STS     hrDebounced, R17

        OUT     SREG, R0                ;restore flags (possibly re-enabling interrupts)

        CPI     R16, TRUE               ;now set the zero flag appropriately


        RET                             ;done so return




; SwMinSet
;
; Description:       Return the status of the "Minute Set" switch (not
;                    debounced).
;
; Operation:         Reads the switches and returns the "Minute Set" switch
;                    status.
;
; Arguments:         None.
; Return Value:      ZF - set if the "Minute Set" switch is pressed.
;
; Local Variables:   None.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             Setting of the "Minute Set" switch.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16
; Stack Depth:       0 words
;
; Author:            Glen George
; Last Modified:     April 24, 2018

SwMinSet:


        IN      R16, SWITCH_PORT        ;get the minute set switch status
        ANDI    R16, SET_MIN_SW_BIT     ;set zero flag if switch is pressed


        RET                             ;done so return




; SwHrSet
;
; Description:       Return the status of the "Hour Set" switch (not
;                    debounced).
;
; Operation:         Reads the switches and returns the "Hour Set" switch
;                    status.
;
; Arguments:         None.
; Return Value:      ZF - set if the "Hour Set" switch is pressed.
;
; Local Variables:   None.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             Setting of the "Hour Set" switch.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16
; Stack Depth:       0 words
;
; Author:            Glen George
; Last Modified:     April 24, 2018

SwHrSet:


        IN      R16, SWITCH_PORT        ;get the hour set switch status
        ANDI    R16, SET_HR_SW_BIT      ;set zero flag if switch is pressed


        RET                             ;done so return




; SwSet
;
; Description:       Return the status of the "Set" switch (not debounced).
;
; Operation:         Reads the switches and returns the "Set" switch status.
;
; Arguments:         None.
; Return Value:      ZF - set if the "Set" switch is "on".
;
; Local Variables:   None.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             Setting of "Set" switch.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16
; Stack Depth:       0 words
;
; Author:            Glen George
; Last Modified:     April 24, 2018

SwSet:


        IN      R16, SWITCH_PORT        ;get the set switch status
        ANDI    R16, SET_SW_BIT         ;set the zero flag appropriately


        RET                             ;done so return




; SwAlarm
;
; Description:       Return the status of the "Alarm" switch (not debounced).
;
; Operation:         Reads the switches and returns the "Alarm" switch status.
;
; Arguments:         None.
; Return Value:      ZF - set if the "Alarm" switch is "on".
;
; Local Variables:   None.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             Setting of "Alarm" switch.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16
; Stack Depth:       0 words
;
; Author:            Glen George
; Last Modified:     April 24, 2018

SwAlarm:


        IN      R16, SWITCH_PORT        ;get the alarm switch status
        ANDI    R16, ALARM_SW_BIT       ;set the zero flag appropriately


        RET                             ;done so return




; SwSnooze
;
; Description:       Return the status of the "Snooze" switch (not debounced).
;
; Operation:         Reads the switches and returns the "Snooze" switch
;                    status.
;
; Arguments:         None.
; Return Value:      ZF - set if the "Snooze" switch is presseed.
;
; Local Variables:   None.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             Setting of "Snooze" switch.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16
; Stack Depth:       0 words
;
; Author:            Glen George
; Last Modified:     November 1, 1993

SwSnooze:


        IN      R16, SWITCH_PORT        ;get the snooze switch status
        ANDI    R16, SNOOZE_SW_BIT      ;set the zero flag appropriately


        RET                             ;done so return




; SwDisplay
;
; Description:       Return the status of the "Display" switch (not
;                    debounced).  This is returned as a 3-bit value.
;
; Operation:         Reads the switches and returns the current position of
;                    the "Display" switch.
;
; Arguments:         None.
; Return Value:      R16 - current setting of the "Display" switch.  It should
;                          be either DISPLAY_TIME, DISPLAY_ALARM, or
;                          DISPLAY_SNOOZE.
;
; Local Variables:   None.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             Setting of "Display" switch.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16
; Stack Depth:       0 words
;
; Author:            Glen George
; Last Modified:     April 24, 2018

SwDisplay:


        IN      R16, SWITCH_PORT        ;get the settings for the switches
        ANDI    R16, DISPLAY_SW_MASK    ;mask off the display switches


        RET                             ;done so return




; SwitchStatus
;
; Description:       Return the status of all of the switches (none
;                    debounced).
;
; Operation:         Reads the switches and returns the value read.
;
; Arguments:         None.
; Return Value:      R16 - current status of all the switches (no debouncing).
;
; Local Variables:   None.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             Settings of all switches.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: R16
; Stack Depth:       0 words
;
; Author:            Glen George
; Last Modified:     April 2, 2019

SwitchStatus:


        IN      R16, SWITCH_PORT        ;get the settings for the switches
        RET                             ;done so return




; ResetMinSwitch
;
; Description:       This procedure initializes the "Minute Set" switch
;                    debouncing variables.
;
; Operation:         The "Minute Set" switch timing variables are reset and
;                    the auto-repeat rate is set to the slow rate.  The
;                    debounced switch flag is left unchanged.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  minCntr    - written (set to DEBOUNCE_TIME).
;                    minRptCntr - written (set to REPEAT_TIME).
;                    minRptRate - written (set to SLOW_RATE).
;
; Input:             None.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: R16
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     July 25, 2012

ResetMinSwitch:


InitMinTimers:                          ;initialize the "Minute Set" switch
        LDI     R16, LOW(DEBOUNCE_TIME) ;reset switch debounce counter
        STS     minCntr, R16
        LDI     R16, HIGH(DEBOUNCE_TIME)
        STS     minCntr + 1, R16

        LDI     R16, LOW(REPEAT_TIME)   ;reset time until start fast repeat
        STS     minRptCntr, R16
        LDI     R16, HIGH(REPEAT_TIME)
        STS     minRptCntr + 1, R16

        LDI     R16, LOW(SLOW_RATE)     ;rate to repeat at (slow initially)
        STS     minRptRate, R16
        LDI     R16, HIGH(SLOW_RATE)
        STS     minRptRate + 1, R16
        ;RJMP   EndResetMinSwitch       ;done initializing the switch variables

EndResetMinSwitch:                      ;done so return
        RET




; ResetHrSwitch
;
; Description:       This procedure initializes the "Hour Set" switch
;                    debouncing variables.
;
; Operation:         The "Hour Set" switch timing variables are reset and the
;                    auto-repeat rate is set to the slow rate.  The debounced
;                    switch flag is left unchanged.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  hrCntr    - written (set to DEBOUNCE_TIME).
;                    hrRptCntr - written (set to REPEAT_TIME).
;                    hrRptRate - written (set to SLOW_RATE).
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
; Registers Changed: R16
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     July 25, 2012

ResetHrSwitch:


InitHrTimers:                           ;initialize the "Hour Set" timers
        LDI     R16, LOW(DEBOUNCE_TIME) ;reset switch debounce counter
        STS     hrCntr, R16
        LDI     R16, HIGH(DEBOUNCE_TIME)
        STS     hrCntr + 1, R16

        LDI     R16, LOW(REPEAT_TIME)   ;reset time until start fast repeat
        STS     hrRptCntr, R16
        LDI     R16, HIGH(REPEAT_TIME)
        STS     hrRptCntr + 1, R16

        LDI     R16, LOW(SLOW_RATE)     ;rate to repeat at (slow initially)
        STS     hrRptRate, R16
        LDI     R16, HIGH(SLOW_RATE)
        STS     hrRptRate + 1, R16
        ;RJMP   EndResetHrSwitch        ;done initializing the switch variables

EndResetHrSwitch:                       ;done so return
        RET




;the data segment


.dseg


;"Minute Set" variables
minCntr:	.BYTE   2      ;counter for debouncing "Minute Set" switch
minRptCntr:	.BYTE   2      ;time until switch to fast repeat of "Minute Set"
minRptRate:	.BYTE   2      ;rate at which to repeat "Minute Set"
minDebounced:	.BYTE   1      ;have a "Minute Set" switch press or auto-repeat

;"Hour Set" variables
hrCntr:		.BYTE   2      ;counter for debouncing "Hour Set" switch
hrRptCntr:	.BYTE   2      ;time until switch to fast repeat of "Hour Set"
hrRptRate:	.BYTE   2      ;rate at which to repeat "Hour Set"
hrDebounced:	.BYTE   1      ;have an "Hour Set" switch press or auto-repeat
