;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                                   HW2TEST                                  ;
;                            Homework #2 Test Code                           ;
;                                  EE/CS 10b                                 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Description:      This program tests the switch functions for Homework #2.
;                   It sets up the stack and calls the homework test function.
;
; Input:            User presses on the switches are stored in memory.
; Output:           None.
;
; User Interface:   No real user interface.  The user inputs switch presses
;                   and appropriate data is written to memory.
; Error Handling:   None.
;
; Algorithms:       None.
; Data Structures:  None.
;
; Known Bugs:       None.
; Limitations:      Only the last 128 switch entries are stored.
;
; Revision History:
;    3/23/23  Glen George               initial revision
;    5/05/23  Glen George               updated comments




;set the device
.device	ATMEGA64




;get the definitions for the device
.include  "m64def.inc"

;include all the .inc files since all .asm files are needed here (no linker)
.include  "Hexer.inc"
.include  "HexerHW.inc"
.include  "switch.inc"




.cseg




;setup the vector area

.org	$0000

	JMP	Start			;reset vector
	JMP	PC			;external interrupt 0
	JMP	PC			;external interrupt 1
	JMP	PC			;external interrupt 2
	JMP	PC			;external interrupt 3
	JMP	PC			;external interrupt 4
	JMP	PC			;external interrupt 5
	JMP	PC			;external interrupt 6
	JMP	PC			;external interrupt 7
	JMP	PC			;timer 2 compare match
	JMP	PC			;timer 2 overflow
	JMP	PC			;timer 1 capture
	JMP	PC			;timer 1 compare match A
	JMP	PC			;timer 1 compare match B
	JMP	PC			;timer 1 overflow
	JMP	PC                      ;timer 0 compare match
	JMP	PC		    	;timer 0 overflow
	JMP	PC			;SPI transfer complete
	JMP	PC			;UART 0 Rx complete
	JMP	PC			;UART 0 Tx empty
	JMP	PC			;UART 0 Tx complete
	JMP	PC			;ADC conversion complete
	JMP	PC			;EEPROM ready
	JMP	PC			;analog comparator
	JMP	PC			;timer 1 compare match C
	JMP	PC			;timer 3 capture
	JMP	PC     			;timer 3 compare match A
	JMP	PC			;timer 3 compare match B
	JMP	PC			;timer 3 compare match C
	JMP	PC			;timer 3 overflow
	JMP	PC			;UART 1 Rx complete
	JMP	PC			;UART 1 Tx empty
	JMP	PC			;UART 1 Tx complete
	JMP	PC			;Two-wire serial interface
	JMP	PC			;store program memory ready




; start of the actual program

Start:					;start the CPU after a reset
	LDI	R16, LOW(TopOfStack)	;initialize the stack pointer
	OUT	SPL, R16
	LDI	R16, HIGH(TopOfStack)
	OUT	SPH, R16


	;initialization of the system
	;initialize I/O ports and timer

	SEI				;ready to go, allow interrupts

        RCALL   SwitchTest              ;do the switch tests
	RJMP	Start			;shouldn't return, but if it does, restart




; SwitchTest
;
; Description:       This procedure tests the switch functions for Homework #2
;                    (SwitchAvailable and GetSwitches).  It alternates calls
;                    to the two functions, filling KeyBuf with the data it
;                    receives.  If the functions are working properly the
;                    buffer should be filled with debounced switch patterns
;                    alternating with 0xFF.  The function does not test that
;                    the GetSwitches function properly blocks.  This function
;                    never returns.
;
; Operation:         The function first clears the buffer by filling it with
;                    0x55.  It then loops calling SwitchAvailable and
;                    GetSwitches to test the functions.  First GetSwitches is
;                    called checking SwitchAvailable first and the returned
;                    switch pattern is put in the buffer.  Next SwitchAvailable
;                    is called.  If there is no switch available (there should
;                    not be since we just called GetSwitches), 0xFF is written
;                    to the buffer.  Next GetSwitches is called without waiting
;                    for a switch pattern to check that it does wait for a new
;                    switch press.  The returned switch pattern is then written
;                    to the buffer.  Finally SwitchAvailable is called again
;                    and 0xFF is written to the buffer if there is no switch
;                    pattern available.  Then all of this is repeated.
;
; Arguments:         None.
; Return Value:      None.
;
; Local Variables:   R4 - index into KeyBuf
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
; Registers Changed: flags, R4, R16, R17, Y (YH | YL)
; Stack Depth:       at least 3 bytes
;
; Author:            Glen George
; Last Modified:     April 23, 2023
;
; Special Notes:     The buffer (KeyBuf) must be 256 bytes long since the index
;                    is incremented and allowed to wrap at 255.

SwitchTest:

STClearBuffer:			;first clear the buffer
	LDI	YL, LOW(KeyBuf)	;get the start of the buffer
	LDI	YH, HIGH(KeyBuf)
	LDI	R17, 0x55	;will fill buffer with 55 to start
	CLR	R4		;initialize the loop counter

STClearBufferLoop:		;loop clearing the buffer
	ST	Y+, R17		;initialize one byte of the buffer
	INC	R4  		;update the loop index
	BRNE	STClearBufferLoop	;and loop until fill 256 bytes

	CLR	R4		;initialize the buffer index

SwitchTestLoop:			;loop testing the functions

STCheckGetSwitches1:		;first call to GetSwitches uses SwitchAvailable
	PUSH	R4		;save the buffer index

STWaitLoop:			;loop until there is a switch press
	RCALL	SwitchAvailable
	BREQ	STWaitLoop	;wait for there to be a switch press

	RCALL	GetSwitches	;switch pattern is available - get it
	POP	R4		;get buffer index back
	RCALL	STStoreBuffer	;store switch pattern in the buffer

STCheckSwitchAvailable1:	;now check that SwitchAvailable is working
	PUSH	R4		;check if a switch pattern is still available
	RCALL	SwitchAvailable	;   (don't trash buffer index)
	POP	R4

	BRNE	STSkipFFwrite1	;if there is not a pattern, write FF to buffer
	LDI	R16, 0xFF
	RCALL	STStoreBuffer	;store 0xFF in the buffer
STSkipFFwrite1:
	;RJMP	STCheckGetSwitches2	;do second test of GetSwitches


STCheckGetSwitches2:		;second call to GetSwitches does not use SwitchAvailable
	PUSH	R4		;save the buffer index
	RCALL	GetSwitches	;should wait for a key
	POP	R4		;get buffer index back
	RCALL	STStoreBuffer	;store switch pattern in the buffer

STCheckSwitchAvailable2:	;now check that SwitchAvailable is working again
	PUSH	R4		;check if a switch pattern is still available
	RCALL	SwitchAvailable	;   (don't trash buffer index)
	POP	R4

	BRNE	STSkipFFwrite2	;if there is not a key, write FF to buffer
	LDI	R16, 0xFF
	RCALL	STStoreBuffer	;store 0xFF in the buffer
STSkipFFwrite2:


	RJMP	SwitchTestLoop	;and keep looping forever

	RET			;should never get here




; STStoreBuffer
;
; Description:       This procedure stores the byte passed in R16 at the
;                    offset in the KeyBuf buffer passed in R4.  The offset is
;                    updated and the new offset is returned in R4.
;
; Operation:         The Y register is loaded with the buffer address.  The
;                    passed offset is then added to this address and the
;                    passed byte is stored at this location.  The passed
;                    offset is then incremented and returned.
;
; Arguments:         R4  - offset in KeyBuf at which to write the passed byte.
;                    R16 - byte to write to the buffer at the passed offset.
; Return Value:      R4  - offset of the next location in the buffer.
;
; Local Variables:   Y - pointer into buffer.
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
; Registers Changed: flags, R4, R17, Y (YH | YL)
; Stack Depth:       0 bytes
;
; Author:            Glen George
; Last Modified:     May 1, 2018

STStoreBuffer:

	LDI	YL, LOW(KeyBuf)	;get buffer location to store switch at
	LDI	YH, HIGH(KeyBuf)

	LDI	R17, 0		;for carry propagation
	ADD	YL, R4		;add the passed offset
	ADC	YH, R17

	ST	Y, R16		;store the passed byte in the buffer

        INC     R4              ;update the buffer offset, wrapping at 256


	RET			;all done, return




;the data segment


.dseg


; buffer in which to store keys (length must be 256)
KeyBuf:         .BYTE   256


; the stack - 128 bytes
		.BYTE	127
TopOfStack:	.BYTE	1		;top of the stack




; since don't have a linker, include all the .asm files
;.include "file.asm"
