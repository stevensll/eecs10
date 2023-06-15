

ProcessButtonPress:

UpdateMoveCounter
    
INC MoveCounter
DisplayHex(MoveCounter)

MoveLED

MapButton to Segtable
MapSegtable value to LEDpatt
DisplayGameLED(LEDpatt)


CheckWin

if no LEDs left

DisplayHex(WIN)


; set the device
.device ATMEGA64

; get definitions for device
.include "m64def.inc"

; local include files

.include "HexerHW.inc"
.include "HexerDisplay.inc"
.include "HexerSwitches.inc"


.dseg
;

; since don't have a linker, include all the .asm files

.include "HexerInit.asm"		; initialize timer and IO ports
.include "HexerIRQ.asm"			; handle interrupts for switches/display

.include "Display.asm"			; display procedures
.include "Switches.asm"			; switch procedures

.include "Segtable.asm"			; seg table for