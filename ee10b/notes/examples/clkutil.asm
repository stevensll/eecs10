;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                    CLKUTIL                                 ;
;                               Utility Routines                             ;
;                   Microprocessor-Based Clock (AVR version)                 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the utility functions for the clock.  The public
; functions included are:
;    BCD2Bin - convert a BCD value (0 to 99) to binary
;    Bin2BCD - convert a value from 0 to 63 in binary to BCD
;    IncTime - add the passed hours and minutes to the passed time
;    SetTime - update the passed time based on the Set switches
;
; The local functions included are:
;    none
;
; Revision History:
;     7/14/10  Glen George              initial revision
;     9/04/10  Glen George              fixed bug in IncTime
;     9/30/10  Glen George              added time changed return value to
;                                          SetTime
;    10/07/10  Glen George              changed IncTime to only do increments
;                                          if the passed value is non-zero
;     8/26/18  Glen George              modified for AVR system



; device definitions
;.include  "4414def.inc"

; local include files
;.include  "clkgen.inc"
;.include  "clkdisp.inc"




.cseg




; IncTime
;
; Description:       This function increments the passed time by the number of
;                    hours and minutes passed to it.  The time is kept in 24
;                    hour format and any overflow out of a day (more than 24
;                    hours) is lost.  The passed minute and hour increment
;                    amounts must be non-negative.  The incremented (updated)
;                    time is returned.
;
; Operation:         The passed minute increment is added to the passed time
;                    minutes.  The minutes are then normalized (to keep them
;                    between 0 and 59).  Then the passed hour increment is
;                    added to the passed time and the hours are normalized
;                    (to keep them between 1 and 12 with AM/PM).
;
; Arguments:         R16     - the number of minutes by which to increment the
;                              time (can't be negative).
;                    R17     - the number of hours by which to increment the
;                              time (can't be negative).
;                    R5 | R4 - the time to be updated (incremented) in packed
;                              BCD format.
; Return Values:     R5 | R4 - the incremented time in packed BCD format.
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
; Registers Changed: flags, R4, R5, R16, R17, R18, R19
; Stack Depth:       2 bytes
;
; Author:            Glen George
; Last Modified:     August 25, 2018

IncTime:


StartIncTime:                   ;start incrementing the passed time
        TST     R16             ;are there any minutes
        BREQ    AddHours        ;if not, just do the hours
        ;BRNE   ReduceMinInc    ;otherwise, add in the minutes

ReduceMinInc:                   ;reduce minutes to 0 to 59
	CPI	R16, 60		;are there any hours in the minutes
	BRLO	AddMin		;if not, can add the minutes
	SUBI	R16, 60		;otherwise reduce the minutes by an hour
	INC	R17		;and add it to the hours
	RJMP	ReduceMinInc	;and keep at it until minutes are 0 to 59


AddMin:                         ;convert minutes of the passed time to binary
	MOV	R18, R4
	RCALL	BCD2Bin
	ADD	R18, R16	;add in the minutes increment
	;RJMP	AdjustMin	;now adjust the minutes

AdjustMin:                      ;check for minutes out of 0-59 range
	CPI	R18, 60		;note that maximum value is 118
	BRLO	ConvertMinBCD	;in range, so convert back to BCD
	SUBI	R18, 60		;remove an hour
	INC	R17		;and add to hours to add later
	;RJMP	ConvertMinBCD	;and convert back to BCD

ConvertMinBCD:			;convert minutes back to BCD
	RCALL	Bin2BCD
	MOV	R4, R18		;store the minutes in the result in BCD
        ;RJMP   AddHours        ;now add in the hours increment amount


AddHours:                       ;now add in the hours
        TST     R17             ;are there any hours to add
        BREQ    DoneIncTime     ;no hours to add, all done
        ;BRNE   ConvertBinary   ;have hours to add, do it

ConvertBinary:                  ;start by converting the time hours to binary
        MOV     R18, R5         ;get a temporary copy of the current hours
        ANDI    R18, ~PM_MASK	;mask off AM/PM indicator
	RCALL	BCD2Bin		;now convert from BCD to binary

        CPI     R18, 12         ;need to map 12 (noon/midnite) to 0
        BRNE    CheckPM         ;not noon/midnite so done and check for PM
        SUBI    R18, 12         ;have noon/midnite, change to the 0 hour
        ;JMP    CheckPM         ;and check for a PM indicator

CheckPM:
	LDI	R16, PM_MASK    ;check if there was a PM indicator
        CP      R5, R16
        BRLO    DoneTensHours   ;if not, done with tens of hours
        SUBI    R18, -12        ;had a PM indicator so need 12 more hours

DoneTensHours:                  ;done with tens of hours
        ADD     R18, R17        ;add in the hours to increment by
        ;JMP    ReduceHours     ;now reduce it to 0 to 23

ReduceHrInc:                    ;reduce hours to 0 to 23
	CPI	R18, 24		;check if 0 to 23
	BRLO	AdjustHours	;if so, adjust back to BCD
	SUBI	R18, 24		;otherwise reduce it by a day (24 hours)
	RJMP	ReduceHrInc	;and keep subtracting out days

AdjustHours:                    ;now adjust back to BCD
	LDI	R16, AMPM_MASK  ;check if using 24 hour or 12 hour format
        AND	R16, R5
        BRNE    Hours12Fmt      ;hours in 12 hour format
        ;BREQ   Hours24Fmt      ;hours in 24 hour format

Hours24Fmt:                     ;hours in 24 hour format
        CLR     R5              ;no AM/PM indicator in result
        RJMP    DoHours         ;and translate the hours to BCD

Hours12Fmt:                     ;hours in 12 hour format
        CPI     R18, 12         ;check for AM/PM
        BRSH    HavePM          ;12 to 23 is PM
        ;BRLO   HaveAM          ;0 to 11 is AM

HaveAM:                         ;hours are AM
        LDI     R16, AM_MASK     ;set AM in the return value
	MOV	R5, R16
        RJMP    Check12Hour     ;and adjust for 12:00

HavePM:                         ;hours are PM
        SUBI    R18, 12         ;convert to 12 hour format
        LDI     R16, PM_MASK    ;set PM in the return value
	MOV	R5, R16
        ;RJMP   Check12Hour     ;and adjust for 12:00

Check12Hour:                    ;need to convert hour 0 to 12:00
        CPI     R18, 0
        BRNE    DoHours         ;not hour 0, just convert hours to BCD
        LDI     R18, 12         ;change hour 0 to 12:00
        ;RJMP   DoHours         ;and convert hours to BCD

DoHours:                        ;now convert the hours to BCD
	RCALL	Bin2BCD
	OR	R5, R18		;combine the hours digit with AM/PM indicator
        ;JMP    DoneIncTime     ;and done incrementing the time

DoneIncTime:                    ;done incrementing the time, return
        RET




; SetTime
;
; Description:       This procedure handles the setting of a time.  The
;                    current value of the time to be set is passed to it and
;                    the procedure updates that time as needed, depending on
;                    whether the "Hour Set" or "Minute Set" switches have been
;                    pressed an appropriate length of time.  This fact is
;                    determined by another function which just sets flags used
;                    by this routine.  The possibly updated time is returned.
;                    Note that this routine does not necessarily change the
;                    passed time, it only does so if the appropriate switches
;                    are pressed.  If the time was changed the zero flag is
;                    reset and it is set if the time did not change.
;
; Operation:         If the "Hour Set" switch is pressed, an hour is added to
;                    the passed time.  Then if the "Minute Set" switch is
;                    pressed, a minute is added to the passed time without
;                    changing the hours.
;
; Arguments:         R5|R4 (time) - initial value of time to be set.
; Return Values:     R5|R4 (time) - updated version of passed time (update due
;                                   to set switches being pressed).
;                    ZF (flag)    - set if the passed time (R5|R4) was not
;                                   changed and reset if was changed.
;
; Local Variables:   R16 (flag) - TRUE to indicate the time was changed.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             "Hour Set" and "Minute Set" keys.
; Output:            None.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R4, R5, R16, R17, R18, R19, R20, R21
; Stack Depth:       4 bytes
;
; Author:            Glen George
; Last Modified:     August 25, 2018

SetTime:


StartSetTime:                           ;try setting the time
        LDI     R20, FALSE              ;time was not changed

CheckHrSet:
        RCALL   HrSet                   ;check if "Hour Set" is pressed
        BRNE    CheckMinSet             ;no "Hour Set", check minutes
        ;BREQ   DoHrSet                 ;have "Hour Set"

DoHrSet:                                ;"Hour Set" pressed, increment hours
        LDI     R16, 0                  ;add no minutes
        LDI     R17, 1                  ;add 1 hour
        RCALL   IncTime                 ;and update the time
        LDI     R20, TRUE               ;time was changed
        ;RJMP   CheckMinSet             ;now check for minutes


CheckMinSet:                            ;check if "Minute Set" pressed
        RCALL   MinSet
        BRNE    DoneSetTime             ;if no "Minute Set", done setting time
        ;BREQ   DoMinSet                ;otherwise set the minutes

DoMinSet:                               ;"Minute Set" is pressed
        MOV     R21, R5                 ;save current hours

        LDI     R16, 1                  ;add 1 minute
        LDI     R17, 0                  ;add no hours
        RCALL   IncTime                 ;and update the time

        MOV     R5, R21                 ;restore the hours (so only minutes changed)
        LDI     R20, TRUE               ;and the time has changed
        ;RJMP   DoneSetTime             ;and done setting the time


DoneSetTime:                            ;done setting the timer, return
        TST     R20                     ;set ZF to indicate if time changed
        RET




; BCD2Bin
;
; Description:       This function converts the passed BCD value to binary.
;                    The passed value must be a valid BCD value in the range 0
;                    to 99.  If it is out of this range an invalid value will
;                    be returned.
;
; Operation:         First the low nibble is copied to the binary result.
;                    Then the upper nibble (tens digit) is added to the binary
;                    value after shifting it by 1 and 3 (multiply by 2 and 8).
;
; Arguments:         R18 - the BCD value to be converted to binary (must be
;                          between 0 and 99).
; Return Values:     R18 - the passed BCD value converted to binary.
;
; Local Variables:   None.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    If the passed value is outside the range of 0 to 99 an
;                    invalid value will be returned.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R18, R19
; Stack Depth:       0 words
;
; Author:            Glen George
; Last Modified:     August 25, 2018

BCD2Bin:


StartBCD2Bin:		    	;copy number and convert low nibble
	MOV	R19, R18	;get copy of original number
	ANDI	R18, 0b00001111	;low nibble (units digit) just copies to result
	ANDI	R19, 0b11110000	;get the upper nibble (tens digit)
	LSR	R19		;multiply nibble by 8
	ADD	R18, R19	;and add it to the result
	LSR	R19		;now multiply nibble by 2
	LSR	R19
	ADD	R18, R19	;and add it to the result
	;RJMP	DoneBCD2Bin	;and done


DoneBCD2Bin:                    ;done with the convertsion, return
        RET




; Bin2BCD
;
; Description:       This function converts the passed binary value to BCD.
;                    The passed value must be in the range 0 to 63.  If it is
;                    out of this range an invalid value will be returned.
;
; Operation:         First the low nibble is converted to a valid BCD digit
;                    (units).  Next the number is adjusted for bits 4 and 5
;                    (value 16 and 32 in binary and 10 and 20 in BCD).
;                    Finally the units are again adjusted to be valid.
;
; Arguments:         R18 - the binary value to be converted to BCD (must be
;                          between 0 and 63).
; Return Values:     R18 - the passed binary value converted to BCD.
;
; Local Variables:   None.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             None.
; Output:            None.
;
; Error Handling:    If the passed value is outside the range of 0 to 63 an
;                    invalid value will be returned.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R18, R19
; Stack Depth:       0 words
;
; Author:            Glen George
; Last Modified:     August 25, 2018

Bin2BCD:


StartBin2BCD:		    	;copy number and convert low nibble
	MOV	R19, R18	;get copy of original number
	SUBI	R18, -6		;adjust units 0-9 to 6-15 and 10-15 to 0-5
	BRHC	DoUpperNibble	;if no half-borrow, was 10-15 so needed adjustment
	SUBI	R18, 6		;otherwise take out the adjustment (was 0-9)

DoUpperNibble:		     	;take care of bits in upper nibble (bits 4, 5)
	SBRS	R19, 5		;check bit 5 (32 in binary and 20 in BCD)
	RJMP	CheckBit4	;bit 5 clear, check bit 4
	SUBI	R18, -0x12	;bit 5 set so need extra 12 in BCD
	BRHS	CheckBit4	;if half-borrow check for bit 4 adjustment
	SUBI	R18, -0x06	;otherwise borrow was worth 16, not 10

CheckBit4:			;check bit 4 (16 in binary and 10 in BCD)
	SBRS	R19, 4
	RJMP	CheckBCDUnits	;bit 4 clear, just check units digit for 0-9
	SUBI	R18, -0x06	;bit 4 set so need extra 6 in BCD
	BRHS	CheckBCDUnits	;if half-borrow check units for 0-9
	SUBI	R18, -0x06	;otherwise borrow was worth 16, not 10
	;RJMP	CheckBCDUnits	;now check units for 0-9

CheckBCDUnits:			;check that units are 0-9
	SUBI	R18, -6		;map units 0-9 to 6-15 and 10-15 to 0-5
	BRHC	DoneBin2BCD	;if no half-borrow was 10-15 so needed adjustment
	SUBI	R18, 6		;otherwise take out the adjustment (was 0-9)
	;RJMP	DoneBin2BCD	;and done


DoneBin2BCD:                    ;done with the convertsion, return
        RET
