### Steven Lei

## Procedure: InitLEDs()
### Description:
Initializes the `LEDbuffer` array used by the `ClearDisplay(), DisplayHex(), DisplayGameLEDs()` procedures, all LEDS, the timer, the I/O port, and the switches.
### Operational Description:
The `LEDbuffer`  and `LEDsArray` array are initialized to a 6 byte array of zeroes. Each row of the array corresponds to the following LEDS, as specified by the *Hexer-Game Specification and Requirements* document:

![[Pasted image 20230515001718.png | 400]]
The `LEDbuffer` is used to write to the LEDs upon each call of `MultiplexLEDs()`.
The timer, switches, and I/O port are initialized using the functions specified in the HW2 funcitonal spec.
### Arguments:
None
### Return values:
None
### Local variables:
None
### Shared variables:
`LEDbuffer` (W): 6 byte array. All rows are cleared to 0. 
`LEDsArray` (W): 6 byte array. All rows are cleared to 0.
### Global variables:
None
### User interface:
None
### Error handling:
None
### Algorithms:
None
### Data structures:
None
### Limitations:
None
### Special notes:
None.
## Pseudo code:
```
RESET_BYTE = 0b00000000
LEDbuffer = [RESET_BYTE, RESET_BYTE, RESET_BYTE, RESET_BYTE, RESET_BYTE, RESET_BYTE]
LEDS

InitPorts()
InitTimer()
InitSwitches()
```

# Procedure: MultiplexLEDs()
### Description:
Directly updates the game LEDs and 7-segment LEDs from the LED buffer. Since there are 6 bytes in the buffer array and assuming each should be displayed at a refresh rate of at least 50 hz, the interrupt event handler calls this function every 1ms (1000 hz.)
### Operational description:
Writes one row of the `LEDbuffer` array to the corresponding row of LEDs. The `currDisplayRow` variable is incremented with each call by the event handler and then modulated to wrap around.  Note that the registers need to be saved and restored to prevent corruption from event handler timing.
### Arguments:
None
### Return values:
None
### Local variables:
`currRow`: Current row of the `LEDbuffer`, pointer used to index through the array
### Shared variables:
`LEDbuffer` (R): The bytes of the buffer are read and then written to the `LEDsArray`
`LEDsArray` (W): 6 bytes directly corresponding to the game and 7-seg LEDs.
`currDisplayRow` (R,W): The current row that is being displayed from the `LEDbuffer`.
### Global variables:
None
### User interface:
None
### Error handling:
None
### Algorithms:
None
### Data structures:
None
### Limitations:
None
### Special notes:
None.
## Pseudo code:
```
SaveRegisters()
LEDsArray[currDisplayRow] = buffer[currDisplayRow]
currDisplayRow = (currDisplayRow+1) mod BUFFER_LENGTH
RestoreRegisters()
return
```

# Procedure: ClearDisplay()

### Description:
Clears the 7-segment display and the game LEDS. After it is called, all LEDS should be off.
### Operational description:
The display and game LEDS are cleared by resetting each row (1 byte) of the `LEDbuffer` array.  The `LEDbuffer` is then written to the LEDS by the `MultiplexLEDS()` interrupt function to turn off each LED. 
### Arguments:
None
### Return values:
None
### Local variables
- `currRow`: the current row of the `LEDbuffer` array, used to index through the array
### Shared variables:
- `LEDbuffer` (W): each row of the `LEDbuffer` is set to the 8-bit value of 0.
### Global variables
None
### Input:
None
### Output:
None
### User interface:
None
### Error handling:
None
### Algorithms:
None
### Data structures:
None
### Limitations:
None
### Special notes:
None.
## Pseudo code:
```
//CONSTANTS
BUFFER_LENGTH = 6
LED_CLEAR = 0b00000000

FOR currRow  = 0 , currRow < BUFFER_LENGTH, currRow++
	LEDbuffer[currRow] = LED_CLEAR
END FOR
return
```

# Procedure: DisplayHex(n)
### Description:
Given a 16 bit unsigned value `n`, displays the value in hexadecimal (at most 4 digits) to the 7-segment LED display. 
### Operational description:
The argument `n` is broken up into a high and low byte. Since `4` bits represents a hexadecimal digit, the nibbles of each byte are separated by copying the byte and AND-ing it with either `00001111` or `11110000` to the get the respective half of the nibble. For example, if `10101111 10011000` is the input, then the four bytes of the following are created:
```
nHighByteHigh = 10100000
nHighByteLow = 00001111
nLowByteHigh = 10010000
nHighByteLow = 00001000
```
Each new modified byte is then written to the `LEDbuffer` array in sequential order.

### Arguments:
`n`: 16 bit unsigned value. The argument is broken up into a high and low byte (R17|R16). 
### Return values:
None
### Local variables
* `currRow`: the current row of the `LEDbuffer` array, used for indexing
- `nHighByteHighNibble`: the high nibble of the high byte, appended by `0000` for the low nibble. Stored in R18
- `nHighByteLowNibble`: `0000` for the high nibble appended by the low nibble of the high byte. Stored in R17
- `nLowByteHighNibble`: the high nibble of the low byte appended by `0000` for the low nibble. Stored in R16
- `nLowByteLowNibble`: `0000` for the high nibble appended by the low nibble of the low byte. Stored in R15
- `nibbleArray`: an array of the modified bytes specified above ^. Assumes the size is 4 which corresponds to the amount of 7-segment bytes. 
### Shared variables:
- `LEDbuffer` (W): the rows corresponding to the 7-segment LEDs of the `LEDbuffer` are each written by the bytes in `nibbleArray`
### Global variables
None
### Input:
None
### Output:
None
### User interface:
None
### Error handling:
None
### Algorithms:
None
### Data structures:
None
### Limitations:
None
### Special notes:
None.
## Pseudo code:
```
//CONSTANTS
HIGH_NIBBLE = 0b11110000
LOW_NIBBLE = 0b00001111
SEG_START = 2 //starting position of the 7-segmentLEDS in the LEDbuffer array
SEG_END = 6

//get only the nibbles of each byte
//bitewise &

nHighByteHighNibble = nHighByte & HIGH_NIBBLE //R18
nHighByteLowNibble = nHighByte & LOW_NIBBLE   //R17
nLowByteHighNibble = nLowByte & HIGH_NIBBLE   //R16
nLowByteHighNibble = nLowByte & LOW_NIBBLE    //R15

nibbleArray = [nHighByteHighNibble, nHighByteLowNibble, nLowByteHighNibble, nLowByteLowNibble]

//write each nibble to the rows

FOR currRow = SEG_START, currRow < SEG_END, currRow++
	LEDbuffer[currRow] = nibbleArray[currRow]
END FOR
return
```

# Procedure: DisplayGameLEDs(m)

### Description:

Given a 16 bit mask `m`, turns on or off the game LEDS depending if the corresponding mask bit is set (ON) or reset (OFF). The mask bits correspond to each game LED specified by the table below:

| Bit | 15 | 14 | 13 | 12 | 11 | 10 | 9 | 8 | 7  | 6  | 5 | 4  | 3  | 2  | 1 | 0 |
|-----|----|----|----|----|----|----|---|---|----|----|---|----|----|----|---|---|
| LED | 9  | 1  | 5  |    | 0  | 4  | 3 | 2 | 13 | 11 | 8 | 15 | 14 | 12 | 7 | 6 |

Unused bits have no effect on the LEDs.

### Operational description:

The game LEDS are set/reset by writing each byte of the mask to the corresponding row of the `LEDbuffer` array. The first row of the `LEDbuffer` array corresponds to the mask high byte and the second row of the `LEDbuffer` array corresponds to the mask low byte.

### Arguments:
`m`: 16 bit mask that indicates the game board LEDS to turn on or off. If the mask bit is set, then the corresponding LED is turned on and if reset, the corresponding LED is turned off. The `m` argument is broken up into a `maskHigh` (high byte, R17) and `maskLow` (low byte, R16) since the registers can only store 1 byte. 

### Return values:
None
### Local variables
None
### Shared variables:
- `LEDbuffer` (W): The high and low bytes of the mask is written to the first two bytes of the `LEDbuffer` array.
### Global variables
None
### Input:
None
### Output:
None
### User interface:
None
### Error handling:
None
### Algorithms:
None
### Data structures:
None
### Limitations:
None
### Special notes:
None.
## Pseudo code: 
```
LEDbuffer[0] = maskHigh
LEDbuffer[1] = maskLow
return
```
