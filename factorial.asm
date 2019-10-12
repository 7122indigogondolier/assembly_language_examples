;; Author: Utkrist P. Thapa '21 

;; This program computes the factorial of a number
;; and then divides the number by 5 to obtain the
;; quotient and the remainder

.ORIG x3000

;; Main program register usage:
; R1 = NUMBER
; R6 = stack pointer

;; Main program pseudocode:
; buffer = input("Enter a number: ")
; number = int(buffer)
; result = factorial(number)
; print("The factorial of", str(number), "is", str(result))

; Main program code 
	LEA	R0, PROMPT	; loading base address of the prompt in R0 
	PUTS	
	JSR	GETS
	LD 	R6, STACKBOTTOM	; initialize the stack pointer 
	LEA	R1, BUFFER
	JSR	INT
	ST	R2, NUMBER
	LD	R1, NUMBER
	JSR	FACTORIAL	
	ST	R1, RESULT
	
	LEA	R0, OUTPUT1	; print("The factorial of", str(number), "is", str(result)) 
	PUTS
	LD	R2, NUMBER	; converting integer stored in NUMBER to string in order to output it
	JSR	TOSTRING	
	LD	R0, R1		; TOSTRING subroutine puts the base address of the string buffer into R1
				; so we load the base address into R0 for output
	PUTS
	LEA	R0, OUTPUT2
	PUTS
	LD	R2, RESULT	; converting integer stored in RESULT to string in order to output it
	JSR	TOSTRING	
	LD	R0, R1
	PUTS
	HALT

; Main program data variables
PROMPT		.STRINGZ	"Enter a number: "
BUFFER		.BLKW 1
RESULT		.BLKW 1
NUMBER		.BLKW 1
STACKBOTTOM	.FILL xFDFF	; Address of the bottom of the stack
OUTPUT1		.STRINGZ	"The factorial of "
OUTPUT2		.STRINGZ	"is "




;; Subroutine FACTORIAL
;  Returns the factorial of R1 in R1
;  Input parameter: R1 (the number)
;  Output parameter: R1 (the number)
;  Working storage: R2 and R3

; Pseudocode:

; product = 1
; while n > 0
;    product *= n
;    n -= 1

FACTORIAL	ADD R0, R7, #0	; Save registers
		JSR PUSH
           	ADD R0, R3, #0
		JSR PUSH
           	ADD R0, R2, #0
		JSR PUSH
		LD R2, FACTONE	; Initialize the product to 1
FACTLOOP	JSR MUL		; R3 = R1 * R2
		ADD R2, R3, #0	; Shift the product back to R2
		ADD R1, R1, #-1	; Decrement the number
		BRp FACTLOOP
		ADD R1, R2, #0	; Shift product for return
		JSR POP		; Restore registers
		ADD R2, R0, #0
		JSR POP		; Restore registers
		ADD R3, R0, #0
		JSR POP
		ADD R7, R0, #0
		RET

; Data for subroutine FACTORIAL
FACTONE	.FILL #1


;; Subroutine MUL
;  Multiplies R1 by R2 and stores result in R3
;  R3 = R1 * R2
;  Input parameters: R1 and R2, both non-negative
;  Output parameter: R3

;; Pseudocode design:

; sum = 0
; while first > 0
;	sum += second
;	first -= 1
; return sum

MUL	ADD R0, R7, #0	; Save registers
	JSR PUSH
	ADD R0, R1, #0	        
	JSR PUSH
	AND R3, R3, #0	; Initialize sum for accumulation
        ADD R1, R1, #0  ; if first or second is 0, quit
        BRz ENDMUL
        ADD R2, R2, #0
        BRz ENDMUL
MULLOOP	ADD R3, R3, R2	; sum += second
	ADD R1, R1, #-1	; first -= 1
	BRp MULLOOP	; Exit when first == 0
ENDMUL	JSR POP		; Restore registers
	ADD R1, R0, #0
	JSR POP
	ADD R7, R0, #0

	RET


;; Subroutine DIV
;  Divides R1 by R2 and stores quotient in R3 and remainder in R4
;  R3 = R1 // R2, R4 = R1 % R2
;  Input parameters: R1 (dividend) and R2 (divisor), both positive integers
;  Output parameters: R3 (quotient) and R4 (remainder)

; Pseudocode:

; quotient = 0
; while (dividend - divisor) >= 0
;     dividend -= divisor
;     quotient += 1
; remainder = dividend

DIV	ADD R0, R7, #0	; Save registers
	JSR PUSH
	ADD R0, R2, #0	        
	JSR PUSH
	ADD R0, R1, #0
        JSR PUSH
	NOT R2, R2	; Negate the divisor
	ADD R2, R2, #1  
	AND R3, R3, #0	; Initialize the quotient (a counter)
DIVLOOP	ADD R4, R1, R2	; Entry test for the division loop (dividend - divisor >= 0)
	BRn ENDDIV
	ADD R1, R1, R2	; dividend -= divisor
	ADD R3, R3, #1	; quotient += 1
	BR DIVLOOP	; Return to the top of the loop
ENDDIV	ADD R4, R1, #0	; Set the remainder to dividend for return	
	JSR POP		; Restore registers
	ADD R1, R0, #0
	JSR POP
	ADD R2, R0, #0
	JSR POP
	ADD R7, R0, #0
	RET


;; Runtime stack management

;; Subroutine PUSH
;  Copies R0 to the top of the stack and decrements the stack pointer
;  Input parameters: R0 (the datum) and R6 (the stack pointer)
;  Output parameter: R6 (the stack pointer)
PUSH	ADD 	R6, R6, #-1
	STR 	R0, R6, #0
	RET

;; Subroutine POP
;  Copies the top of the stack to R0 and increments the stack pointer
;  Input parameter: R6 (the stack pointer)
;  Output parameters: R0 (the datum) R6 (the stack pointer)
POP	LDR 	R0, R6, #0
	ADD 	R6, R6, #1
	RET

;; Subroutine INT
;  Converts a string of digits with base address in R1 to an integer 
;  Input parameter: R1 = The address of the string buffer 
;  Output parameter: R2 = The integer represented by the string 

;; Register usage: 
;  R3 = temporary working storage 
;  R4 = the pointer into the string buffer 

;; Pseudocode design: 
;  def int(string):
;   number = 0
;   for digit in string:
;       number = 10 * number + ord(digit) - ord('0')
;   return number

INT	PUSH 	R7, R1, R3, and R4	; save registers 

	ADD 	R3, R3, #0
	ST 	R3, INTSUM		; set the pointer into the buffer
INTLOOP LDR	R1, R4, 0		; get the next digit from the buffer 
	BRz	ENDINT			; quit when its null
	LD	R2, ORZERO		; convert the digit to an int 
	ADD	R1, R1, R2
	ST 	R1, INTDIGIT	
	LD	R1, INTSUM		; multiply the sum by 10
	LD	R2, INT10		
	JSR	MUL		
	LD	R1, INTDIGIT		; add int value of the digit to the sum
	ADD	R3, R3, R1
	ST 	R3, INTSUM	
	ADD	R4, R4, #1		; advance to the next character in the buffer 
	BR	INTLOOP
ENDINT	LD	R2, INTSUM		; set the output parameter 

	POP 	R4, R3, R1 and R7	; restore the registers 
	RET

; Subroutine INT data variables 
INTDIGIT	.BLKW 	1		; holds the integer value of the digit 
ORDZERO		.FILL 	#-48		; ASCII for the digit '0' (negated)
INT10		.FILL 	#10		; Base of 10
INTSUM		.FILL	#0		; Holds the running total for the sum 

;; Subroutine TOSTRING
;  Converts an integer in R2 to a string of digits with base address in R1
;  Input parameters: R1 = Base address of string buffer 
;  		     R2 = An integer 
;  Output parameter: R1 = Base address of the string buffer

;; Register usage:
;  R0 = temporary working storage 
;  R3 = temporary working storage 

;; Pseudocode design: 
;  def str(number):
;      if number == 0: return '0'
;      stack = Stack()   
;      while number > 0:
;          remainder = number % 10
;          number //= 10
;          stack.push(chr(remainder + ord('0')))
;      string = ''    
;      while not stack.isEmpty(): 
;          string += stack.pop()
;      return string        


TOSTRING	ST 	R1, STRBASE
		PUSH 	R7, R4, R3, and R2	; save return address, parameters and temporaries

		AND	R0, R0, #0		; Push the null character onto the stack 
		JSR	PUSH	
		ADD	R1, R2, #0		; Set the initial dividend
STRLOOP		LD 	R2, TOS10		; Divide the number by 10
		JSR 	DIV			
		LD	R2, CHRZERO		; convert the remainder and push it onto the stack
		ADD	R0, R4, R2		
		JSR	PUSH	
		ADD	R1, R3, #0		; set the dividend to the quotient 
		BRp	STRLOOP			; While quotient > 0 

		LD	R1, STRBASE		; Move characters from the stack to the string buffer, 
						; stopping after the null character is moved

POPLOOP		JSR	POP
		STR	R0, R1, #0
		ADD	R0, R0, #0
		BRz	ENDPOP
		ADD	R1, R1, #1
		BR	POPLOOP

ENDPOP		LD	R1, STRBASE		; Restore all registers
		POP	R2, R3, R4, and R7
		RET

; Subroutine TOSTRING data variables: 
CHRZERO		.FILL	#48			; ASCII for the digit '0'
STRBASE		.BLKW	1			; Base address of string buffer for the sumIN
TOS10		.FILL	#10			; Base of 10

;; Subroutine GETS
;  Gets the string input from the keyboard and stores it in BUFFER
;  Input parameter: none
;  Output parameter: R5 = base address of the input string

;; Register usage: 
;  R0 = the input character
;  R2 = the return character (negated CR)
;  R3 = temporary working storage 
;  R4 = the return character (negated LF) 
;  R5 = base address of input string 

;; Pseudocode Design: 
; character = GETC("Please enter your name: ") ;;GETC gets one char at a time
; WHILE character != return:
; 	BUFFER[i] = character 
;	i = i + 1
; ENDWHILE 

GETS		LEA	R5, BUFFER	; Load base address of ARRAY into R2
		LD	R2, RETCR	; Load negated CR into R2
		LD	R4, RETLF	; Load negated LF into R4
WHILE		GETC
		OUT			; Read and echo a character (stored in R0)
		ADD	R3, R0, R2	; WHILE character != return (CR)
		BRz	ENDWHILE
		ADD	R3, R0, R4	; WHILE character != return (LF)
		BRz	ENDWHILE
		STR	R0, R5, #0	; BUFFER[i] = character
		ADD	R5, R5, #1	; i = i + 1
		BR	WHILE

ENDWHILE	STR	R0, R5, #0	; store the null/return character 
		RET

; Subroutine GETS data variables: 
RETCR	.FILL	x-000D			; return character (negated CR)
RETLF	.FILL	x-000A			; return character (negated LF)
BUFFER	.BLKW	10			; reserve 10 cells for BUFFER

.END

