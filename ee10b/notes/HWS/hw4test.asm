;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   HW4TEST                                  ;
;                            Homework #4 Test Code                           ;
;                                  EE/CS 10b                                 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This file contains the test code for Homework #4.  The function makes a
; number of calls to the PlayNote and SD Card read and write functions to test
; them.  The functions included are:
;    SDCardSoundTest - test the homework sound and SD Card functions
;
; Revision History:
;    6/01/19  Glen George               initial revision
;    6/02/19  Glen George               modified address in two tests
;                                       added skipping of padding byte in
;                                          table and restoring test number
;                                          when tests fail
;    6/04/23  Glen George               updated code for hexer board
;                                       added full block test



; chip definitions
;.include  "m64def.inc"

; local include files
;    none




.cseg




; SDCardSoundTest
;
; Description:       This procedure tests the sound and SD card functions.  It
;                    first loops calling the PlayNote function.  Following
;                    this it waits for the user to press any switch.  After
;                    the user presses a switch is makes a number of calls to
;                    WriteSDCard to write some blocks to the SD card.  It then
;                    makes a number of calls to ReadSDCard to verify the data
;                    written.  Tones are output while testing the SD card
;                    functions.  The tone increases in pitch as the tests are
;                    done.  If a test fails a low tone is output and the
;                    leftmost LED is turned on.  At the end the start of the
;                    Twilight Zone theme is played and the rightmost LED is
;                    turned on if the tests pass.  The function never returns.
;
; Operation:         The arguments to call each function with are stored in
;                    tables.  The function loops through the tables making the
;                    appropriate function calls.  Delays are done after calls
;                    to PlayNote so the sound can be heard.  The data written
;                    to the SD card is randomly generated.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   R20         - test counter.
;                    Z (ZH | ZL) - test table pointer.
; Shared Variables:  None.
; Global Variables:  None.
;
; Input:             The switches are checked for presses.
; Output:            The LEDs are potentially turned on.
;
; Error Handling:    None.
;
; Algorithms:        None.
; Data Structures:   None.
;
; Registers Changed: flags, R16, R17, R18, R19, R20, X (XH | XL), Y (YH | YL),
;                    Z (ZH | ZL)
; Stack Depth:       unknown (at least 7 bytes)
;
; Author:            Glen George
; Last Modified:     June 4, 2023

SDCardSoundTest:

TestSetup:
	LDI	R16, 0xFF		;will be using LEDs, set up direction
	OUT	DDRC, R16
	OUT	DDRD, R16
	LDI	R16, 0			;turn off all segments and digits
	OUT	PORTC, R16
	OUT	PORTD, R16
	LDI	R16, 0x00		;will read switches on port E
	OUT	DDRE, R16
	;RJMP	PlayNoteTests		;now start the tests


PlayNoteTests:				;do some tests of PlayNote only
	LDI	ZL, LOW(2 * TestPNTab)	;start at the beginning of the
	LDI	ZH, HIGH(2 * TestPNTab)	;   PlayNote test table
	LDI	R20, 8			;get the number of tests

PlayNoteTestLoop:
	LPM	R16, Z+			;get the PlayNote argument from the
	LPM	R17, Z+			;   table

	PUSH	ZL			;save registers around PlayNote call
	PUSH	ZH
	PUSH	R20
	RCALL	PlayNote		;call the function
	POP	R20			;restore the registers
	POP	ZH
	POP	ZL

	LDI	R16, 200		;delay for 2 seconds
	RCALL	Delay16			;and do the delay

	DEC	R20			;update loop counter
	BRNE	PlayNoteTestLoop	;and keep looping if not done
	;BREQ	StartSDCardTests    	;otherwise get ready to test SD card


StartSDCardTests:			;wait for button press to start test
	LDI	R24, 0			;running a counter for random values
	LDI	R25, 0

SDCardTestReleaseWait:			;wait for all switches to be released
	ADIW	R24, 1			;update counter
	IN	R16, PINE		;read switches
	ANDI	R16, 0b01111110		;mask off the switches
	CPI	R16, 0b01111110		;check if any switches are pressed
	BRNE	SDCardTestReleaseWait	;there is a pressed switch, wait for it
	;BREQ	SDCardTestPressWait	;   to be released, otherwise continue

SDCardTestPressWait:			;wait for a switch to be pressed
	ADIW	R24, 1			;update counter
	IN	R16, PINE		;read switches
	ANDI	R16, 0b01111110		;mask off the switches
	CPI	R16, 0b01111110		;check if any switches are pressed
	BREQ	SDCardTestPressWait	;no pressed switch, wait for one
	;BREQ	SDCardTestBegin		;otherwise can start tests


SDCardTestBegin:			;start the SD card tests
	EOR	R24, R25		;get a data offset to use for tests
	LDI	ZL, LOW(2 * TestRWTab)	;start at the beginning of the
	LDI	ZH, HIGH(2 * TestRWTab)	;   ReadEEROM test table
	LDI	R20, 16			;get the number of tests


SDCardTestLoop:
	PUSH	R20			;keep test number saved around calls

	LPM	R16, Z+			;get sound to play while testing EEROM
	LPM	R17, Z+			;   reads

	PUSH	ZL			;save registers around PlayNote call
	PUSH	ZH
	PUSH	R24
	RCALL	PlayNote		;call the function
	POP	R24			;restore the registers
	POP	ZH
	POP	ZL

	LPM	R0, Z+			;get test type
	LPM	R23, Z+			;get data offset
	TST	R0			;check if read or write test
	BRNE	SDCardTestArgSetup	;if reading, nothing to do, setup args
	;BREQ	SDCardTestBufferFill	;otherwise need to fill write buffer

SDCardTestBufferFill:			;copy test data from code to buffer
	MOV	R16, R24		;start fill with offset
	LDI	YL, LOW(TestBuffer)	;buffer with data to write
	LDI	YH, HIGH(TestBuffer)
	LDI	R17, 0			;always fill buffer with 256 words

FillLoop:
	SUB	R16, R23		;get value to write
	ST	Y+, R16			;store in compare buffer
	SUB	R16, R23		;need to write a word (2 bytes)
	ST	Y+, R16
	DEC	R17			;update loop counter
	BRNE	FillLoop		;and loop while still have bytes to fill
	;BREQ	SDCardTestArgSetup	;otherwise setup the arguments


SDCardTestArgSetup:			;get the SD card arguments from table
	LPM	R16, Z+			;get number of bytes to read/write
	LPM	R20, Z+			;get the block number
	LPM	R19, Z+
	LPM	R18, Z+
	LPM	R17, Z+
	ADIW	Z, 1		 	;skip padding byte
	LDI	YL, LOW(TestBuffer)	;buffer pointer for read/write
	LDI	YH, HIGH(TestBuffer)

	PUSH	ZL			;save registers around call
	PUSH	ZH
	PUSH	R16
	PUSH	R23
	PUSH	R24
	PUSH	R0
	TST	R0			;check which function to call
	BRNE	SDCardTestRead		;test read
	;BREQ	SDCardTestWrite		;test write

SDCardTestWrite:			;doing a write
	RCALL	WriteSDCard
	RJMP	SDCardTestReturn

SDCardTestRead:				;doing a read
	RCALL	ReadSDCard
	;RJMP	SDCardTestReturn

SDCardTestReturn:			;returned from read/write call
	MOV	R17, R16		;save the return value
	POP	R0			;restore the registers
	POP	R24
	POP	R23
	POP	R16
	POP	ZH
	POP	ZL


CheckReturnValue:		    	;first check return value (should be OK)
	TST	R17			;0 means good return
	BRNE	SDCardTestFailed	;if not, failure
	;BREQ	CheckData		;otherwise check the data

CheckData:				;check the data read
	TST	R0			;check if writing
	BREQ	DoneChecking		;if writing, nothing to check
	;BRNE	CheckDataSetup		;otherwise setup to check read data

CheckDataSetup:			    	;setup to check the read data
	LDI	YL, LOW(TestBuffer)	;buffer with data read
	LDI	YH, HIGH(TestBuffer)
	MOV	R17, R24		;values start with R24

CheckDataLoop:				;now loop checking the bytes
	SUB	R17, R23		;get data value to check against
	LD	R18, Y+			;get read data
	CP	R18, R17		;check if the same
	BRNE	SDCardTestFailed	;if not, failure
	SUB	R17, R23		;get second byte to check against
	LD	R18, Y+			;get read data
	CP	R18, R17		;check if the same
	BRNE	SDCardTestFailed	;if not, failure
	DEC	R16			;otherwise decrement word count
	BRNE	CheckDataLoop		;and check all the data
	;BREQ	DoneChecking		;otherwise done checking and it worked

DoneChecking:				;test passed
	LDI	R16, 25			;let the note play for 250 milliseconds
	RCALL	Delay16

	POP	R20		  	;get loop counter back
	DEC	R20			;update loop counter
	BREQ	SDCardTestPassed    	;if done - everything worked
	RJMP	SDCardTestLoop		;keep looping if not done


SDCardTestPassed:			;SD card tests passed
	LDI	R16, 0b00000001		;turn on leftmost LED (#6)
	OUT	PORTC, R16
	LDI	R16, 0b00000010
	OUT	PORTD, R16

	LDI	ZL, LOW(2 * SuccessTab)	;start at the beginning of the
	LDI	ZH, HIGH(2 * SuccessTab);   special success tune table
	LDI	R20, 35			;get the number of notes

PlaySuccessLoop:
	LPM	R16, Z+			;get the PlayNote argument from the
	LPM	R17, Z+			;   table

	PUSH	ZL			;save registers around PlayNote calls
	PUSH	ZH
	PUSH	R20

	RCALL	PlayNote		;call the function
	LDI	R16, 14			;each note is 140 ms
	RCALL	Delay16			;and do the delay

	LDI	R16, 0			;play a rest
	LDI	R17, 0
	RCALL	PlayNote		;call the function
	LDI	R16, 1			;rest is 10 ms
	RCALL	Delay16			;and do the delay

	POP	R20			;restore the registers
	POP	ZH
	POP	ZL

	DEC	R20			;update loop counter
	BRNE	PlaySuccessLoop		;and keep looping if not done
	BREQ	DoneSDCardSoundTests   	;otherwise done with tests


SDCardTestFailed:			;SD card tests failed
	LDI	R16, 0b00001000		;turn on rightmost LED (#10)
	OUT	PORTC, R16
	LDI	R16, 0b00000001
	OUT	PORTD, R16

	LDI	R16, LOW(523)		;play C5 indicating failure
	LDI	R17, HIGH(523)
	RCALL	PlayNote

	LDI	R16, 50			;1/2 second note
	RCALL	Delay16

	LDI	R16, LOW(164)		;play E3
	LDI	R17, HIGH(164)
	RCALL	PlayNote

	LDI	R16, 100		;1 second note
	RCALL	Delay16

	POP	R20			;get back the test counter
	;BREQ	DoneSDCardSoundTests   	;and done with tests


DoneSDCardSoundTests:			;have done all the tests
	LDI	R16, 0			;turn off the sound
	LDI	R17, 0
	RCALL	PlayNote

        RJMP    PC			;and tests are done


        RET	   	                ;should never get here




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

Delay16Loop:				;outer loop runs R16 times
	LDI	YL, LOW(20000)		;inner loop is 4 clocks
	LDI	YH, HIGH(20000)		;so loop 20000 times to get 80000 clocks
Delay16InnerLoop:			;do the delay
	SBIW	Y, 1
	BRNE	Delay16InnerLoop

	DEC	R16			;count outer loop iterations
	BRNE	Delay16Loop


DoneDelay16:				;done with the delay loop - return
	RET




; Test Tables


; TestPNTab
;
; Description:      This table contains the values of arguments for testing
;                   the PlayNote function.  Each entry is just a 16-bit
;                   frequency for the note to play.
;
; Author:           Glen George
; Last Modified:    May 31, 2018

TestPNTab:

	.DW	261			;middle C
	.DW	440			;middle A
	.DW	1000
	.DW	0			;turn off output for a bit
	.DW	2000
	.DW	50
	.DW	4000
	.DW	100




; TestRWTab
;
; Description:      This table contains the values of arguments for testing
;                   the SD card read and write functions.  Each entry consists
;                   of the note frequency to play during the test, the test
;                   type (zero for write, non-zero for read), the data offset
;                   for the test, number of bytes to read or write, and the
;                   block number where the read or write is to occur.  There is
;                   also a padding byte at the end of each test line.
;
; Author:           Glen George
; Last Modified:    June 4, 2023

TestRWTab:
	.DW	146
	.DB	0, 13,  50, BYTE4(1),     BYTE3(1),     BYTE2(1),     LOW(1),     0
	.DW	220
	.DB	0, 27,  21, BYTE4(3),     BYTE3(3),     BYTE2(3),     LOW(3),     0
	.DW	294
	.DB	0, 75, 200, BYTE4(357),   BYTE3(357),   BYTE2(357),   LOW(357),   0
	.DW	370
	.DB	1, 27,  21, BYTE4(3),     BYTE3(3),     BYTE2(3),     LOW(3),     0
	.DW	440
	.DB	0,  1,   1, BYTE4(4000),  BYTE3(4000),  BYTE2(4000),  LOW(4000),  0
	.DW	523
	.DB	1, 13,  50, BYTE4(1),     BYTE3(1),     BYTE2(1),     LOW(1),     0
	.DW	622
	.DB	1, 75, 200, BYTE4(357),   BYTE3(357),   BYTE2(357),   LOW(357),   0
	.DW	784
	.DB	0,  1,  75, BYTE4(29000), BYTE3(29000), BYTE2(29000), LOW(29000), 0
	.DW	1000
	.DB	1, 27,  21, BYTE4(3),     BYTE3(3),     BYTE2(3),     LOW(3),     0
	.DW	1200
	.DB	0,  55,  0, BYTE4(11000), BYTE3(11000), BYTE2(11000), LOW(11000), 0
	.DW	1400
	.DB	1,  1,   1, BYTE4(4000),  BYTE3(4000),  BYTE2(4000),  LOW(4000),  0
	.DW	1800
	.DB	0,  7, 100, BYTE4(20000), BYTE3(20000), BYTE2(20000), LOW(20000), 0
	.DW	2200
	.DB	1,  1,  75, BYTE4(29000), BYTE3(29000), BYTE2(29000), LOW(29000), 0
	.DW	2800
	.DB	1,  55,  0, BYTE4(11000), BYTE3(11000), BYTE2(11000), LOW(11000), 0
	.DW	3500
	.DB	1,  7, 100, BYTE4(20000), BYTE3(20000), BYTE2(20000), LOW(20000), 0
	.DW	4500
	.DB	1, 13,  50, BYTE4(1),     BYTE3(1),     BYTE2(1),     LOW(1),     0




; SuccessTab
;
; Description:      This table contains the tune to play upon successful
;                   completion of the tests.  Each entry is the frequency of a
;                   note to play.
;
; Author:           Glen George
; Last Modified:    May 31, 2019

SuccessTab:
	.DW	392, 523, 659, 784, 784, 784, 784
	.DW	784, 659, 659, 659, 659, 659, 523
	.DW	659, 523, 392,   0, 392, 523, 659
	.DW	784, 784, 784, 784, 784, 784, 523
	.DW	659, 392, 392, 392, 392, 392, 659




;the data segment


.dseg


; buffer for data to read from or write to the SD card (one block)
TestBuffer:	.BYTE	512
