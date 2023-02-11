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

;0000            start:			;initialize variables
0000                LDI   $0    ;load input 1 into accumulator
0001                STD   a		;load acc into a
0002                INC         ;load input 2 into accumlator
0003                STD   b		;load accumulator into b
0004                STD   t 	;load accumulator into t
0005
;0006            WhileLoop:			;loop decrementing a until b is 0
0006                LDD   b			;load B
0007                JZ    Done		;if b is now 0, we're done

                    JZ    Done      ;
0008                ;JNZ  FibBody		;otherwise compute the next number
0009                STD   n			;always store new value of n (branch slot)
000A
            WhileBody:			;compute the next fibonacci number
            IfCase1:
                LDD   a		    ;get the value of a in accumulator
                SUB   b		    ;subtract the value of b
                STD   a			;and store it to a

            IfCase2:
                LDD   a		;get the value of a in the accumulator
                STD   t		;store it in t 
                LDD   b		;get the value of b in the accumulator
                STD   a		;store it in a
                LDD   t	    ;get the value of t in the accumulator
                STD   B     ;store it in b

            Done:			;done with the calculation
                LDD   a			;get returned gcd value into accumulator
                RTS                     ;and return

;Variables

        a       DB    ?			;the first number for GCD comparison
        b       DB    ?			;the second number for GCD comparison
        a1      DB    ?			;
        t       DB    ?			;temporary storage for swapping