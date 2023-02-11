; This subroutine computes GCD value of two unsigned 8-bit integers.
; The algorithm implemented is Euclid's subtraction algorithm, and is given
; by the pseudo code below:
;       gcd(a,b):
;           while(b!=0):
;               if a >= b: a = a-b
;               else: swap a with b (need 3rd memory slot)
;           return a
; The values of a and b are 8-bit values stored in memory in the variable a and b
; respectively. At the end of the function, the GCD of (a,b) is returned in the 
; accumulator.
; For error handling, faulty inputs (e.g. gcd(0,0) or overflow) will return 0.
; The value of n is destroyed by the program.  Note that there
; is no error checking on the value of n and a value of 0 or values larger
; than 13 (decimal) will cause an overflow and generate incorrect results.
;
; Revision History
;	10 Feb 23 Steven Lei	   Created pseudo code with comments
; 	10 Feb 23 Steven Lei	   Converted pseudo code to assembly
;	10 Feb 23 Steven Lei       Hand compliled .asm to .obj

;0000           WhileLoop:		        ;loop decrementing a until b is 0
0001  8002;         LDD  b              ;load B
0002  9F00;         JZ   Done	        ;if b is now 0, we're done
                   ;JNZ  WhileBody     ;otherwise compute the gcd
                
;0003           WhileBody:              ;compute GCD
0003  8000;         LDD   a             ;get the value of a in the accumulator
0004  3001;         CMP   b             ;update the C flags by subtracting b from accumulator
0005  8C03;         JAE   Sub           ;if the carry is clear, then a>=b so go to subtract
0006  1F80;         NOP
0007  8C07;          JNC   Swap          ;if the carry is not clear, then a < b so swap
0008  1F80;         NOP

;0009           Sub:                    ;subtract b from a
0009  8000;         LDD   a             ;get the value of a in accumulator
000A  2002;         SUB   b		        ;subtract the value of b
000B  A001;         STD   a			    ;and store it to a
000C  C001;         JMP   WhileLoop     ;jump back to the start of Whileloop
000D  1F80;         NOP           

;000F           Swap:                   ;swap a and b 
000F  8000;         LDD   a		        ;get the value of a in the accumulator
0010  A002;         STD   t		        ;store it in t 
0011  8002;         LDD   b		        ;get the value of b in the accumulator
0012  A000;         STD   a		        ;store it in a
0013  8002;         LDD   t	            ;get the value of t in the accumulator
0014  A001;         STD   b             ;store it in b
0015  C001;         JMP   WhileLoop     ;go back to the start of the WhileLoop
0016  1F80;         NOP 

;0017            Done:			        ;done with the calculation
0017  8000;         LDD   a			;get returned gcd value into accumulator
0018  1F00;         RTS                     ;and return

;Variables
;00  ??  a       DB    ?			;the first number for GCD comparison
;01  ??  b       DB    ?			;the second number for GCD comparison
;02  ??  t       DB    ?			;temporary storage for swapping