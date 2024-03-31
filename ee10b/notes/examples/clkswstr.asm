;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   CLKSWSTR                                 ;
;                        Switch Routines using Structures                    ;
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
;    DebounceSwitch - debounce a switch
;    ResetSwitch    - initialize switch debouncing
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
;     9/7/12   Glen George              updated comments
;     4/24/18  Glen George              converted to AVR clock
;     4/29/18  Glen George              converted to using structures
;     5/07/18  Glen George              fixed syntax error



; device definitions
;.include  "4414def.inc"

; local include files
;.include(clkgen.inc)
;.include(clksws.inc)




.cseg




; SwitchDebounce
;
; Description:       This procedure debounces the "Minute Set" and "Hour Set"
;                    switches.  It also handles the auto-repeat for those same
;                    switches.  It is expected to be called approximately once
;                    per second.
;
; Operation:         The "Minute Set" and "Hour Set" switches are debounced
;                    using the DebounceSwitch function.
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
; Registers Changed: flags, R16, R18, Y (YH | YL), Z (ZH | ZL)
; Stack Depth:       4 bytes
;
; Author:            Glen George
; Last Modified:     April 29, 2018

SwitchDebounce:


DebMINSwitch:                           ;debounce the "Minute Set" switch
	LDI	R18, SET_MIN_SW_BIT	;get mask for "Minute Set" switch
	LDI	YL, LOW(minCntr)	;get pointer to "Minute Set" structure
	LDI	YH, HIGH(minCntr)
	RCALL	DebounceSwitch		;and debounce the switch
        ;RJMP   DebHRSwitch             ;debounce the "Hour Set" switch


DebHRSwitch:                            ;debounce the "Hour Set" switch
	LDI	R18, SET_HR_SW_BIT	;get mask for "Hour Set" switch
	LDI	YL, LOW(hrCntr)		;get pointer to "Hour Set" structure
	LDI	YH, HIGH(hrCntr)
	RCALL	DebounceSwitch		;and debounce the switch
        ;RJMP   EndSwitchDebounce       ;done debouncing


EndSwitchDebounce:                      ;done debouncing switches
        RET                             ;just return




; DebounceSwitch
;
; Description:       This procedure debounces the switch whose structure and
;                    mask is passed.  It also handles the auto-repeat for the
;                    switch.  It is expected to be called approximately once
;                    per second.
;
; Operation:         The debounce counter is reset if the switch is up and
;                    decremented if it is pressed.  When the counter reaches
;                    zero the debounced flag is set and the counter is
;                    reloaded with the repeat time.  When a switch is down the
;                    associated repeat time counter is also decremented and
;                    when it reaches zero the associated repeat time is
;                    changed to the fast repeat rate.  When a switch is not
;                    pressed all of its associated counters are reset.
;
; Arguments:         R18 - mask for switch.
;                    Y   - pointer to structure for switch to debounce.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  None.
;
; Input:             The state of the switches.
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
; Last Modified:     April 29, 2018

DebounceSwitch:


DebSwitch:                              ;debounce the switch
        IN      R16, SWITCH_PORT        ;read the switches
	AND	R16, R18                ;check if the switch is down
        BREQ    SwitchDown              ;switch is down - process it
        ;BRNE   SwitchUp                ;else switch is up


SwitchUp:                               ;switch is up, reset counters
        RCALL   ResetSwitch
        RJMP    EndDebSwitch            ;and done "debouncing" the switch


SwitchDown:                             ;switch is down - debounce it
	LDD	ZL, Y + SW_CNTR_OFF	;update debounce counter
	LDD	ZH, Y + SW_CNTR_OFF + 1
	SBIW	Z, 1			;decrement the counter
	STD	Y + SW_CNTR_OFF, ZL	;write it back to memory
	STD	Y + SW_CNTR_OFF + 1, ZH
        BRNE    NotDebounced            ;switch is not debounced yet
        ;BREQ   IsDebounced             ;switch is now debounced (or repeated)

IsDebounced:                            ;have switch press
        LDI     R16, TRUE               ;set flag indicating have switch
        STD     Y + SW_DEBOUNCED_OFF, R16
        LDD     R16, Y + SW_RPTRATE_OFF ;setup to auto-repeat
        STD     Y + SW_CNTR_OFF, R16
        LDD     R16, Y + SW_RPTRATE_OFF + 1
        STD     Y + SW_CNTR_OFF + 1, R16
        ;RJMP   RptCntUpdate            ;now update the repeat counter

NotDebounced:                           ;switch not debounced yet
        ;RJMP   RptCntUpdate            ;just update the repeat counter


RptCntUpdate:                           ;update (decrement) repeat rate counter
	LDD	ZL, Y + SW_RPTCNTR_OFF	;get counter value
	LDD	ZH, Y + SW_RPTCNTR_OFF + 1
	SBIW	Z, 1			;decrement the counter (to check for
	STD	Y + SW_RPTCNTR_OFF, ZL  ;   change in auto-repeat rate)
	STD	Y + SW_RPTCNTR_OFF + 1, ZH ;write it back to memory
        BRNE    NoRptRateUpdate         ;don't change auto-repeat rate yet
        ;BREQ   FastRpt                 ;else switch to fast rate

FastRpt:                                ;time to switch to fast repeat rate
        LDI     R16, LOW(FAST_RATE)     ;change to fast repeat rate
        STD     Y + SW_RPTRATE_OFF, R16
        LDI     R16, HIGH(FAST_RATE)
        STD     Y + SW_RPTRATE_OFF + 1, R16
        ;RJMP   EndRptCntUpdate         ;done with repeat count update

NoRptRateUpdate:                        ;don't update the repeat rate yet
        ;RJMP   EndRptCntUpdate         ;done with repeat count update

EndRptCntUpdate:                        ;done with repeat rate adjustments
        ;RJMP   EndDebSwitch            ;done with switch

EndDebSwitch:                           ;done with switch
        ;RJMP   EndDebounceSwitch       ;done debouncing


EndDebounceSwitch:                      ;done debouncing switches
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
; Last Modified:     April 24, 2018

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
; Last Modified:     April 29, 2018

ResetMinSwitch:


InitMinTimers:                          ;initialize the "Minute Set" switch
        LDI     YL, LOW(minCntr)        ;point to start of minute switch structure
        LDI     YH, HIGH(minCntr)
	RCALL	ResetSwitch
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
        LDI     YL, LOW(hrCntr)         ;point to start of hour switch structure
        LDI     YH, HIGH(hrCntr)
	RCALL	ResetSwitch
        ;RJMP   EndResetHrSwitch        ;done initializing the switch variables

EndResetHrSwitch:                       ;done so return
        RET




; ResetSwitch
;
; Description:       This procedure initializes the debouncing variables for
;                    the passed switch.
;
; Operation:         The switch timing variables are reset and the auto-repeat
;                    rate is set to the slow rate.  The debounced switch flag
;                    is left unchanged.
;
; Arguments:         Y - pointer to the switch information structure.
; Return Value:      None.
;
; Local Variables:   None.
; Shared Variables:  None.
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
; Last Modified:     April 29, 2018

ResetSwitch:


InitTimers:                             ;initialize the switch
        LDI     R16, LOW(DEBOUNCE_TIME) ;reset switch debounce counter
        STD     Y + SW_CNTR_OFF, R16
        LDI     R16, HIGH(DEBOUNCE_TIME)
        STD     Y + SW_CNTR_OFF + 1, R16

        LDI     R16, LOW(REPEAT_TIME)   ;reset time until start fast repeat
        STD     Y + SW_RPTCNTR_OFF, R16
        LDI     R16, HIGH(REPEAT_TIME)
        STD     Y + SW_RPTCNTR_OFF + 1, R16

        LDI     R16, LOW(SLOW_RATE)     ;rate to repeat at (slow initially)
        STD     Y + SW_RPTRATE_OFF, R16
        LDI     R16, HIGH(SLOW_RATE)
        STD     Y + SW_RPTRATE_OFF + 1, R16
        ;RJMP   EndResetSwitch          ;done initializing the switch variables

EndResetSwitch:                         ;done so return
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
