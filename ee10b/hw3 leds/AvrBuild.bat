@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "U:\slei\eecs10\ee10b\hw3 leds\labels.tmp" -fI -W+ie -o "U:\slei\eecs10\ee10b\hw3 leds\hw3.hex" -d "U:\slei\eecs10\ee10b\hw3 leds\hw3.obj" -e "U:\slei\eecs10\ee10b\hw3 leds\hw3.eep" -m "U:\slei\eecs10\ee10b\hw3 leds\hw3.map" "U:\slei\eecs10\ee10b\hw3 leds\HW3Test.asm"
