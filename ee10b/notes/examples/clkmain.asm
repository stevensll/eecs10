;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                    CLKMAIN                                 ;
;                                   Main Loop                                ;
;                    Microprocessor-Based Clock (AVR version)                ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Description:      This program implements a digital clock with an alarm and
;                   snooze.  The clock only displays time (no date).  The
;                   snooze interval may be set by the user.  There are LEDs to
;                   display the time; slide switches to determine what is
;                   being displayed or set (time, alarm time, or snooze
;                   length) and to turn the alarm on or off; and momentary
;                   switches to set the hours and minutes and enable snoozing.
;
; Input:            All input is through slide and pushbutton switches.  There
;                   are slide switches to determine what to display, to turn
;                   on set mode, and to turn the alarm on/off.  There are push
;                   button switches to set the hours, set the minutes, and
;                   turn on snoozing.
;
; Output:           Four-digit LED display of the current time, alarm setting,
;                   or snooze interval; a single LED to indicate AM or PM; and
;                   another single LED alarm indicator.  The time is always
;                   displayed in 12-hour format using the AM/PM indicator LED.
;                   The colon in the time display blinks at a 1 Hz rate.  The
;                   alarm indicator is on when the alarm is enabled.  There is
;                   also a speaker for sounding the alarm.
;
; User Interface:   The clock displays the time selected by the user with the
;                   Display switch (current time, alarm time, or snooze
;                   interval).  The time includes the hours, minutes, and
;                   AM/PM indication (except for snooze).  If the "Set" switch
;                   is on, the displayed time may be set using the "Minute
;                   Set" and "Hour Set" switches.  If the "Set" switch is off,
;                   the "Minute Set" and "Hour Set" switches have no effect.
;                   If the "Set" switch is on, pressing the "Minute Set" or
;                   "Hour Set" switch causes the appropriate value (minutes or
;                   hours) to advance one minute or hour every two seconds.
;                   If the switch is left pressed for more than 5 seconds, the
;                   value will advance at two minutes or hours per second.
;                   The values only advance forward (no counting down) and
;                   minutes wrap from 59 to 0 without affecting the hours.
;                   The snooze interval, however, cannot be set to more than
;                   59 minutes (so the "Hour Set" switch has no affect).  If
;                   the alarm switch is on, the alarm LED will be lit.  Also,
;                   when the current time equals the alarm time, the alarm
;                   will sound via the speaker.  The alarm will continue to
;                   sound until either the alarm switch is turned off, three
;                   (3) minutes have elapsed, or the "Snooze" button is
;                   pressed.  In the last case, the alarm is turned off for
;                   the snooze interval, before it sounds again.  The "Snooze"
;                   button has no effect if the alarm is not sounding.  If the
;                   alarm is turned on at the alarm time, it does not sound
;                   until the next alarm time (24 hours later).  This allows
;                   the alarm to be immediately rearmed after it is activated
;                   and then turned off and back on.
;
; Error Handling:   If there is a power failure the clock will reset to 12:00
;                   AM (and run from there) with the alarm turned off (no
;                   matter what the position of the alarm switch is).  The
;                   alarm time is reset to 12:00 AM and the snooze interval to
;                   five minutes (0:05).
;
; Algorithms:       None.
; Data Structures:  Times are stored in 16-bits in the following format
;                      bits 0-3    BCD of minutes units
;                      bits 4-7    BCD of minutes tens
;                      bits 8-11   BCD of hours units
;                      bits 12-15  BCD of hours tens & AM/PM
;                                     0-2  no AM/PM
;                                     12   no digit and AM
;                                     13   "1" digit and AM
;                                     14   no digit and PM
;                                     15   "1" digit and PM
;
; Limitations:      None.
;
; Revision History:
;     7/14/10  Glen George              initial revision
;     8/31/10  Glen George              added timer initialization
;     9/4/10   Glen George              changed how the display is updated so
;                                          the colon is not always overwritten
;     9/30/10  Glen George              enable alarm whenever something is set
;     9/7/12   Glen George              only enable the alarm when it is set,
;                                          not when the switch is active
;     8/26/18  Glen George              converted to AVR clock



;set the device
.device	AT90S4414




;get the definitions for the device
.include  "4414def.inc"

;include all the .inc files since all .asm files are needed here (no linker)
.include  "clkHW.inc"
.include  "clkgen.inc"
.include  "clksw.inc"
.include  "clkdisp.inc"
.include  "clkalarm.inc"




; Registers used for main loop variables

.DEF	currentTimeHr    = R7   ;the current time in special packed BCD format
.DEF	currentTimeMin   = R6
.DEF    alarmTimeHr      = R9   ;the alarm time in special packed BCD format
.DEF    alarmTimeMin     = R8
.DEF	snoozeSettingHr  = R11  ;amount of time to snooze in packed BCD
.DEF	snoozeSettingMin = R10
.DEF	snoozeTimeHr     = R13  ;amount of time snoozed so far in packed BCD
.DEF	snoozeTimeMin    = R12
.DEF	snoozing         = R14  ;whether currently snoozing
.DEF    prevSwDisplay    = R15  ;what was previously on the display
.DEF	updateDisplay    = R3   ;whether to display a new value on LEDs




.cseg




;setup the vector area

.org	$0000

	RJMP	StartClock		;reset vector
	RETI				;external interrupt 0
	RETI				;external interrupt 1
	RETI				;timer 1 capture
	RETI				;timer 1 compare match A
	RETI				;timer 1 compare match B
	RETI				;timer 1 overflow
	RJMP    Timer0OverflowHandler	;timer 0 overflow
	RETI				;SPI transfer complete
	RETI				;UART Rx complete
	RETI				;UART Tx empty
	RETI				;UART Tx complete
	RETI				;analog comparator




StartClock:                             ;start of the clock main loop

	LDI	R16, LOW(TopOfStack)	;initialize the stack pointer
	OUT	SPL, R16
	LDI	R16, HIGH(TopOfStack)
	OUT	SPH, R16

        RCALL   InitPorts               ;initialize I/O
        RCALL   InitTimer0              ;initialize the timer
        RCALL   InitSwitches            ;initialize the switches
        RCALL   InitDisplay             ;initialize the display
        RCALL   InitClock               ;initialize the clock

        SEI				;ready to go, turn on interrupts


MainLoop:                               ;the main (infinite) loop of the clock

        RCALL   HaveNewMinute           ;check if there is a new minute
        BRNE    CheckAlarmOff           ;if not, check if should turn off alarm
        RCALL   SwSet                   ;new minute, but is the "Set" switch pressed
        BRNE    UpdateTime              ;if not, update the time
        RCALL   SwDisplay               ;otherwise check if the time is being
        CPI     R16, DISPLAY_TIME       ;   set (if so don't update the time)
        BREQ    CheckAlarmOff           ;setting time, just check alarm
        ;BRNE   UpdateTime              ;not setting time, update current time

UpdateTime:                             ;update the current time
        MOV     R4, currentTimeMin      ;get the current time
        MOV     R5, currentTimeHr
        LDI     R16, 1                  ;add 1 minute and no hours to it
        LDI     R17, 0
        RCALL   IncTime
        MOV     currentTimeMin, R4      ;and store the new time
        MOV     currentTimeHr, R5
        ;RJMP   CheckAlarmTime          ;and check if it is time for the alarm

CheckAlarmTime:                         ;check if alarm should sound
        RCALL   AlarmSet                ;is the alarm on
        BRNE    CheckSnooze             ;alarm not on, check for snoozing
        RCALL   SwSet                   ;check if setting anything
        BREQ    CheckSnooze             ;if setting something, no alarm
        CP      R4, alarmTimeMin        ;check if alarm should sound
        CPC     R5, alarmTimeHr
        BRNE    CheckSnooze             ;not the right time, check snoozing
        ;BRNE   SoundAlarm              ;it's time for the alarm to go off

SoundAlarm:                             ;time to sound the alarm
        RCALL   AlarmOn                 ;turn on the alarm
        ;RJMP   CheckSnooze             ;and now check the snooze time

CheckSnooze:                            ;check if snooze interval has expired
        MOV     R16, snoozing           ;check if currently snoozing
        CPI     R16, TRUE
        BRNE    CheckAlarmTimeout       ;if not, just check if alarm timed out
        RCALL   SwSet                   ;don't sound alarm if setting things
        BREQ    CheckAlarmTimeout
        ;RJMP   CheckSnoozeTime         ;otherwise check the snooze time

CheckSnoozeTime:                        ;check if time for snooze to go off
        MOV     R4, snoozeTimeMin       ;update the current snooze time
        MOV     R5, snoozeTimeHr
        LDI     R16, 1                  ;add 1 minute and no hours to it
        LDI     R17, 0
        RCALL   IncTime
        MOV     snoozeTimeMin, R4       ;store the new snooze time
        MOV     snoozeTimeHr, R5
        RCALL   SwAlarm                 ;is the alarm switch on
        BRNE    CheckAlarmTimeout       ;if not, just check for timeout
        CP      R4, snoozeSettingMin    ;else, has the snooze time elapsed
        CPC     R5, snoozeSettingHr
        BRNE    CheckAlarmTimeout       ;if not, check for alarm timeout
        ;BREQ   SnoozeAlarm             ;otherwise, sound the alarm

SnoozeAlarm:                            ;snooze timed out - sound the alarm
        RCALL   AlarmOn
        ;RJMP   CheckAlarmTimeout       ;and check for alarm timeout

CheckAlarmTimeout:                      ;check for the alarm timing out
        RCALL   TimeoutAlarm
        LDI     R16, TRUE               ;need to update the display too
        MOV     updateDisplay, R16
        ;RJMP   CheckAlarmOff           ;now check if the alarm has been turned off


CheckAlarmOff:                          ;check if alarm has been turned off
        RCALL   SwAlarm                 ;is the alarm enabled
        BREQ    CheckSnoozePress        ;if so, check for the snooze button
        ;BRNE   TurnOffAlarm            ;otherwise, turn off the alarm

TurnOffAlarm:                           ;turn off the alarm
        RCALL   AlarmOff
        LDI     R16, FALSE              ;and no longer snoozing
        MOV     snoozing, R16
        ;JMP    CheckSnoozePress        ;now check if snooze was pressed


CheckSnoozePress:                       ;check if the "Snooze" button pressed
        RCALL   Alarm                   ;is the alarm sounding
        BRNE    DoUpdateDisplay         ;if not, don't care about "Snooze", update display
        RCALL   SwSnooze                ;otherwise, check for "Snooze"
        BRNE    DoUpdateDisplay         ;"Snooze" not pressed, update display
        ;BREQ   HaveSnooze              ;otherwise user wants to snooze

HaveSnooze:                             ;"Snooze" was pressed
        RCALL   AlarmOff                ;so turn off the alarm
        LDI     R16, TRUE               ;and snoozing now
        MOV     snoozing, R16
        LDI     R16, LOW(SNOOZE_ZERO)   ;no snooze time has elapsed yet
        MOV     snoozeTimeMin, R16
        LDI     R16, HIGH(SNOOZE_ZERO)
        MOV     snoozeTimeHr, R16
        ;RJMP   DoUpdateDisplay         ;now take care of updating the display


DoUpdateDisplay:                        ;update what is on the display
        RCALL   SwDisplay               ;has the display switch changed
        CP      R16, prevSwDisplay	;check if switch changed
        MOV     prevSwDisplay, R16      ;remember the new switch setting
        BREQ    ContinueDisplay         ;has not changed, just continue
        RCALL   InitSwitches            ;changed display, reset repeat rates
        LDI     R16, TRUE	        ;and need to update the display
        MOV     updateDisplay, R16
        ;RJMP   ContinueDisplay         ;and continue with display update

ContinueDisplay:                        ;continue with updating the display
        RCALL   SwSet                   ;check if setting the displayed time
        BRNE    NotSetting
        ;BREQ   UpdateSetting           ;if so, update the settings

UpdateSetting:                          ;update the displayed setting
        RCALL   SwDisplay               ;what is being displayed
        CPI     R16, DISPLAY_TIME       ;check for current time
        BREQ    UpdateCurrentTime
        CPI     R16, DISPLAY_ALARM      ;check for alarm time
        BREQ    UpdateAlarmTime
        CPI     R16, DISPLAY_SNOOZE     ;check for snooze time
        ;BREQ   UpdateSnoozeTime
        BRNE    DoneUpdateSetting       ;anything else illegal, ignore it

UpdateSnoozeTime:                       ;update the snooze time
        MOV     R4, snoozeSettingMin
        MOV     R5, snoozeSettingHr
        RCALL   SetTime
        LDI     R16, HIGH(MIN_SNOOZE)   ;don't let hours change
        MOV     R5, R16
	BREQ	DoneUpdateSetting       ;snooze time hasn't changed, done
	;BRNE	HaveSnoozeUpdate
HaveSnoozeUpdate:		        ;have an update to the snooze time
        LDI     R16, TRUE               ;so flag that display needs to change
        MOV     updateDisplay, R16
CheckSnoozeMax:                         ;check if above maximum value
        LDI     R16, LOW(MAX_SNOOZE + 1);has the maximum value been reached
        CP      R4, R16                 ;   only need to check minutes (hours can't change)
        BRSH    SetSnoozeMin            ;if so, wrap to the minimum value
        ;BRLO   CheckSnoozeMin          ;otherwise, check for the minimum
CheckSnoozeMin:                         ;check if below minimum value
        LDI     R16, LOW(MIN_SNOOZE)    ;is it below the minimum value
        CP      R4, R16                 ;   only need to check minutes (hours can't change)
        BRSH    SetSnoozeTime           ;if not, just set it
        ;BRLO   SetSnoozeMin            ;otherwise set it to the minimum
SetSnoozeMin:                           ;set to the minimum snooze time
        LDI     R16, LOW(MIN_SNOOZE)    ;otherwise, wrap back to minimum value
	MOV	R4, R16			;high byte is already OK
        ;RJMP   SetSnoozeTime           ;and set the snooze time
SetSnoozeTime:                          ;set the snooze time
        MOV     snoozeSettingMin, R4	;store the new snooze time
        MOV     snoozeSettingHr, R5
        RJMP    DoneUpdateSetting       ;and done updating the settings

UpdateAlarmTime:                        ;update the alarm time
        MOV     R4, alarmTimeMin
        MOV     R5, alarmTimeHr
        RCALL   SetTime
        MOV     alarmTimeMin, R4
        MOV     alarmTimeHr, R5
        RJMP    DoneUpdateSetting       ;and done updating the setting

UpdateCurrentTime:                      ;update the current time
        RCALL   ResetSeconds            ;reset seconds when set current time
        RCALL   DisplayColonOn          ;and turn the colon on
        MOV     R4, currentTimeMin         ;now set the time
        MOV     R5, currentTimeHr
        RCALL   SetTime
        MOV     currentTimeMin, R4
        MOV     currentTimeHr, R5
        ;RJMP   DoneUpdateSetting       ;and done updating the setting

DoneUpdateSetting:                      ;done updating the setting
        BREQ    DoneWithSetting         ;if time didn't change done w/setting
        LDI     R16, TRUE               ;else, need to update the display too
        MOV     updateDisplay, R16
        RCALL   AlarmEnable             ;and once something was set enable alarm
        RJMP    DoneWithSetting         ;and done handling the setting

NotSetting:                             ;not setting anything
        RCALL   InitSwitches            ;reset the repeat rates on the switches
        ;RJMP   DoneWithSetting         ;and done with dealing with settings


DoneWithSetting:                        ;done dealing with "Set", do display
        MOV     R16, updateDisplay      ;only display if need to update it
        CPI     R16, TRUE
        BRNE    DoneDisplayUpdate       ;don't need to update the display
        ;BREQ   DoDisplayUpdate         ;otherwise update the display

DoDisplayUpdate:                        ;update the display
        RCALL   SwDisplay               ;what is being displayed?
        CPI     R16, DISPLAY_TIME       ;displaying current time
        BREQ    DisplayCurrentTime
        CPI     R16, DISPLAY_ALARM      ;displaying the alarm time
        BREQ    DisplayAlarmTime
        CPI     R16, DISPLAY_SNOOZE     ;displaying the snooze interval
        ;BREQ   DisplaySnoozeTime
        BRNE    DoneDisplayUpdate       ;otherwise (shouldn't happen) done with update

DisplaySnoozeTime:                      ;displaying the snooze interval
        MOV     R16, snoozeSettingMin
        MOV     R17, snoozeSettingHr
        RJMP    DoDisplay

DisplayAlarmTime:                       ;displaying the alarm time
        MOV     R16, alarmTimeMin
        MOV     R17, alarmTimeHr
        RJMP    DoDisplay

DisplayCurrentTime:                     ;displaying the current time
        MOV     R16, currentTimeMin
        MOV     R17, currentTimeHr
        ;RJMP   DoDisplay

DoDisplay:                              ;actually output the displayed value
        RCALL   DisplayTime
        ;RJMP   DoneDisplayUpdate       ;and done with the display update

DoneDisplayUpdate:                      ;done with the display update
        RCALL   AlarmSet                ;get the alarm setting
        RCALL   DisplayAlarm            ;and display it (always)
        LDI     R16, FALSE              ;don't need to update display now
        MOV     updateDisplay, R16

        RJMP    MainLoop                ;all there is to do, just keep looping




; InitClock
;
; Description:       This procedure initializes the system.  It resets
;                    counters, initializes the alarm and sets the current
;                    time, alarm, and snooze settings to the power-on
;                    defaults.  It also sets the update display flag so the
;                    initialized values will be displayed.
;
; Operation:         The current time and alarm time are initialized to
;                    MIDNITE,  The display is set to displaying the time.  The
;                    alarm system is initialized and the snoozing is turned
;                    off.
;
; Arguments:         None.
; Return Values:     None.
;
; Local Variables:   None.
; Shared Variables:  currentTime   - written to (set to 12:00 AM).
;                    alarmTime     - written to (set to 12:00 AM).
;                    snoozeSetting - written to (set to INIT_SNOOZE).
;                    snoozeTime    - written to (set to SNOOZE_ZERO).
;                    snoozing      - written to (set to FALSE).
;                    prevSwDisplay - written to (set to DISPLAY_TIME).
;                    updateDisplay - written to (set to TRUE).
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
;                    Y (YH | YL), Z (ZH | ZL)
; Stack Depth:       6 bytes
;
; Author:            Glen George
; Last Modified:     August 26, 2018

InitClock:


StartInitClock:                         ;start initializing the clock

        LDI     R16, LOW(MIDNITE)       ;set the current time to midnite
        MOV     currentTimeMin, R16
        LDI     R16, HIGH(MIDNITE)
        MOV     currentTimeHr, R16

        RCALL   ResetSeconds            ;reset the seconds

        LDI     R16, DISPLAY_TIME       ;start off displaying the time
        MOV     prevSwDisplay, R16

        RCALL   InitAlarm               ;initialize the alarm
        LDI     R16, LOW(MIDNITE)       ;start off the alarm at midnite
        MOV     alarmTimeMin, R16
        LDI     R16, HIGH(MIDNITE)
        MOV     alarmTimeHr, R16

        LDI     R16, LOW(INIT_SNOOZE)   ;initialize snooze interval
        MOV     snoozeSettingMin, R16
        LDI     R16, HIGH(INIT_SNOOZE)
        MOV     snoozeSettingHr, R16
        LDI     R16, LOW(SNOOZE_ZERO)   ;not snoozing so time at 0
        MOV     snoozeTimeMin, R16
        LDI     R16, HIGH(SNOOZE_ZERO)
        MOV     snoozeTimeHr, R16
        LDI     R16, FALSE              ;not snoozing initially
        MOV     snoozing, R16

        MOV     R16, currentTimeMin     ;display the current time
        MOV     R17, currentTimeHr
        RCALL   DisplayTime

        LDI     R16, TRUE               ;want initialized values to be displayed
        MOV     updateDisplay, R16
        ;JMP    DoneInitClock           ;and done with the initialization


DoneInitClock:                          ;done initializing the clock, return
        RET




;the data segment


.dseg





; the stack - 128 bytes
                ;maximum stack depth for the main loop is 4 words
                ;maximum stack depth for interrupts is 13 bytes
                ;thus maximum total depth is 4 + 5 + 3 = 12 words
		.BYTE	127
TopOfStack:	.BYTE	1		;top of the stack




; since don't have a linker, include all the .asm files

.include  "clkinit.asm"
.include  "clkirq.asm"
.include  "clkswtch.asm"
.include  "clkdisp.asm"
.include  "clkalarm.asm"
.include  "clktimer.asm"
.include  "clkutil.asm"
