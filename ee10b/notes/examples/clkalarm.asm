;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   CLKALARM                                 ;
;                                Alarm Routines                              ;
;                   Microprocessor-Based Clock (AVR version)                 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the utility functions for the clock.  The public
; functions included are:
;    Alarm        - returns the current state of the alarm
;    AlarmDisable - disable the alarm
;    AlarmEnable  - enable the alarm
;    AlarmOff     - turns off the alarm
;    AlarmOn      - turns on the alarm if it is enabled
;    AlarmSet     - returns whether the alarm is currently enabled
;    InitAlarm    - initialize the alarm variables and hardware
;    TimeoutAlarm - turns off the alarm if the timeout period has elapsed
;
; The local functions included are:
;    none
;
; Revision History:
;     7/14/10  Glen George              initial revision
;     8/25/18  Glen George              changed to AVR assembly




; device definitions
;.include  "4414def.inc"

; local include files
;.include  "clkgen.inc"
;.include  "clkalarm.inc"




.cseg




; InitAlarm
;
; Description:       This procedure initializes the alarm functions.
;
; Operation:         The alarm is disabled and alarmOffTime is set to
;                    ALARMTIMEOUT.
;
; Arguments:         None.
; Return Values:     None.
;
; Local Variables:   None.
; Shared Variables:  alarmOffTime - written to (initialized to ALARMTIMEOUT).
; Global Variables:  None.
;
; Input:             None.
; Output:            The alarm is turned off by initializing timer 1.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: R16
; Stack Depth:       4 bytes
;
; Author:            Glen George
; Last Modified:     August 24, 2018

InitAlarm:


        LDI     R16, ALARMTIMEOUT	;initialize alarm timeout
        STS     alarmOffTime, R16
        RCALL   AlarmDisable            ;and disable the alarm

	LDI	R16, 0			;reset the timer count register
	OUT	TCNT1H, R16		;note that 16-bit registers must be
	OUT	TCNT1L, R16		;   written high byte first


	LDI	R16, HIGH(ALARM_FREQ)	;set the alarm tone for when it is on
	OUT	OCR1AH, R16		;must write high byte first
	LDI	R16, LOW(ALARM_FREQ)
	OUT	OCR1AL, R16

        RET                             ;done initializing alarm, return




; AlarmDisable
;
; Description:       This procedure disables the alarm.
;
; Operation:         The variable alarmOK is set to FALSE and the alarm is
;                    turned off.
;
; Arguments:         None.
; Return Values:     None.
;
; Local Variables:   None.
; Shared Variables:  alarmOK - written to (set to FALSE to disable the alarm).
; Global Variables:  None.
;
; Input:             None.
; Output:            The alarm is turned off.
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
; Last Modified:     August 24, 2018

AlarmDisable:


        LDI     R16, FALSE		;the alarm cannot sound
        STS     alarmOK, R16
        RCALL   AlarmOff                ;turn off the alarm


        RET                             ;done disabling the alarm, return




; AlarmEnable
;
; Description:       This procedure enables the alarm, meaning it can sound
;                    if set.
;
; Operation:         The variable alarmOK is set to TRUE.
;
; Arguments:         None.
; Return Values:     None.
;
; Local Variables:   None.
; Shared Variables:  alarmOK - written to (set to TRUE to enable the alarm).
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
; Stack Depth:       0 words
;
; Author:            Glen George
; Last Modified:     August 24, 2018

AlarmEnable:


        LDI     R16, TRUE		;allow the alarm to sound
        STS     alarmOK, R16

        RET                             ;and return




; AlarmOff
;
; Description:       This procedure turns off the alarm.
;
; Operation:         The alarm is turned off and the variable alarmStatus is
;                    set to FALSE.
;
; Arguments:         None.
; Return Values:     None.
;
; Local Variables:   None.
; Shared Variables:  alarmStatus - written to (set to FALSE to indicate the
;                                  alarm is off).
; Global Variables:  None.
;
; Input:             None.
; Output:            Alarm is turned off.
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
; Last Modified:     August 24, 2018

AlarmOff:


AlarmHardwareOff:                       ;turn off the hardware alarm
	LDI	R16, TIMER1A_OFF	;turn off the alarm timer
	OUT	TCCR1A, R16		;    no output on OC1B
	LDI	R16, TIMER1B_OFF	;setup rest of timer
	OUT	TCCR1B, R16

ResetAlarmFlag:				;reset alarm status
        LDI     R16, FALSE              ;alarm is now off
        STS     alarmStatus, R16


        RET                             ;done turning off alarm, return




; AlarmOn
;
; Description:       This procedure turns on the alarm, but only if it is
;                    enabled.  It also sets the alarmTime for automatic
;                    timeout.
;
; Operation:         If alarmOK is TRUE (meaning alarm is enabled) then the
;                    alarmStatus is set to TRUE and alarmOffTime is set to
;                    ALARMTIMEOUT and the hardware alarm is turned on.
;                    Otherwise (alarmOK is FALSE), nothing happens.
;
; Arguments:         None.
; Return Values:     None.
;
; Local Variables:   None.
; Shared Variables:  alarmOK      - written to (checked for TRUE to see if the
;                                   alarm is enabled).
;                    alarmStatus  - written to (set to TRUE to indicate the
;                                   alarm is on, if the alarm is enabled).
;                    alarmOffTime - written to (set to ALARMTIMEOUT).
; Global Variables:  None.
;
; Input:             None.
; Output:            Alarm is turned on if it is enabled.
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
; Last Modified:     August 24, 2018

AlarmOn:


CheckEnabled:                           ;first check if the alarm is enabled
	LDS	R16, alarmOK            ;can't turn on alarm if not enabled
        TST     R16
        BREQ    DoneAlarmOn             ;not enabled, all done
        ;BRNE   TurnAlarmOn             ;otherwise turn on the alarm

TurnAlarmOn:                            ;turn on the alarm
        LDI     R16, TRUE               ;indicate the alarm is on
        STS     alarmStatus, R16
        LDI     R16, ALARMTIMEOUT       ;set the timeout for the alarm
        STS     alarmOffTime, R16

AlarmHardwareOn:                        ;turn on the hardware alarm

	LDI	R16, TIMER1A_ON		;just turn on timer output
	OUT	TCCR1A, R16		;count registers already setup
	LDI	R16, TIMER1B_ON
	OUT	TCCR1B, R16
        ;RJMP   DoneAlarmOn             ;and done turning on the alarm


DoneAlarmOn:                            ;done turning on alarm, return
        RET




; TimeoutAlarm
;
; Description:       This procedure turns off the alarm if the automatic
;                    timeout period has passed.  This is determined by the
;                    number of times this function is called.  This function
;                    should be called at a fixed rate.
;
; Operation:         If the alarm is sounding then alarmOffTime is decremented
;                    and if it is now zero, the alarm is turned off.
;
; Arguments:         None.
; Return Values:     None.
;
; Local Variables:   None.
; Shared Variables:  alarmOffTime - read and written (decremented if the
;                                   alarm is on).
; Global Variables:  None.
;
; Input:             None.
; Output:            Alarm is turned off if the timeout period has passed.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16
; Stack Depth:       2 bytes
;
; Author:            Glen George
; Last Modified:     April 20, 2018

TimeoutAlarm:


CheckAlarm:                             ;check if the alarm is sounding
        RCALL   Alarm
        BRNE    DoneTimeoutAlarm        ;no alarm sounding so can't timeout
        ;BREQ   UpdateTimout            ;otherwise update the timeout time

UpdateTimeout:                          ;update time until timeout
	LDS     R16, alarmOffTime	;decrement the timeout
	DEC	R16
	STS     alarmOffTime, R16
        BRNE    DoneTimeoutAlarm        ;if not 0 yet, no timeout yet
        ;BREQ   AlarmTimedOut           ;otherwise the alarm has timed out

AlarmTimedOut:                          ;alarm has been sounding for too long
        RCALL   AlarmOff                ;turn it off
        ;RJMP   DoneTimeoutAlarm        ;and done dealing with the timeout


DoneTimeoutAlarm:                       ;done checking for an alarm timeout,
        RET                             ;   return




; AlarmSet
;
; Description:       This function returns whether or not the alarm is
;                    currently enabled.  TRUE is returned if the alarm is
;                    currently set and enabled, and FALSE is returned if the
;                    alarm switch is off or the alarm is not enabled (due to
;                    power on conditions).
;
; Operation:         If the shared variable alarmOK is TRUE and SwAlarm()
;                    returns TRUE, TRUE is returned.  Otherwise FALSE is
;                    returned.
;
; Arguments:         None.
; Return Values:     ZF (boolean) - TRUE if the alarm is enabled, FALSE if it
;                                   is not.
;
; Local Variables:   None.
; Shared Variables:  alarmOK - read only (checked to determine if alarm is
;                              enabled).
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
; Registers Changed: flags, R16
; Stack Depth:       2 bytes
;
; Author:            Glen George
; Last Modified:     April 20, 2018

AlarmSet:


        RCALL   SwAlarm                 ;check if the "Alarm" switch is on
        BRNE    DoneAlarmSet            ;if not, alarm is not set

        LDS     R16, alarmOK            ;"Alarm" switch on, check if alarm
        CPI     R16, TRUE               ;   enabled
        ;RJMP   DoneAlarmSet            ;flag is set appropriately, done


DoneAlarmSet:                           ;done getting alarm status, return
        RET




; Alarm
;
; Description:       This function returns the current status of the alarm.
;                    TRUE is returned if the alarm is currently on, and FALSE
;                    if it is off.
;
; Operation:         The alarmStatus variable is checked to see if the alarm
;                    is on.
;
; Arguments:         None.
; Return Values:     ZF - set (TRUE) if the alarm is on, reset (FALSE)
;                         otherwise.
;
; Local Variables:   None.
; Shared Variables:  alarmStatus - read only (checked to determine if alarm is
;                                  on).
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
; Registers Changed: flags, R16
; Stack Depth:       0 words
;
; Author:            Glen George
; Last Modified:     August 24, 2018

Alarm:

        LDS     R16, alarmStatus        ;check the alarm status
        CPI     R16, TRUE

        RET                             ;and return with ZF set appropriately




;the data segment

.dseg


alarmOK:	.BYTE   1       ;indicates if it is OK to turn the alarm on
alarmStatus:	.BYTE   1       ;current status of the alarm (on or off)
alarmOffTime:	.BYTE   1       ;time until the alarm automatically turns off
