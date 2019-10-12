;; Author: Utkrist P. Thapa '21 

;; This program prompts user for their name and outputs the name as it is 
;; input as well as in uppercase letters 

		.ORIG x3000

;; Pseudocode Design: 
; character = GETC("Please enter your name: ") ;;GETC gets one char at a time
; WHILE character != return AND SIZE != 0:
; 	ARRAY[i] = character 
;	i = i + 1
;	IF character != " " : 
;		UCARRAY[j] = ucase(character)
;		j = j + 1
;	ELSE: 
;		UCARRAY[j] = character
;		j = j + 1
; 	SIZE = SIZE -1
; ENDWHILE
; OUTPUT("Thank you, " + ARRAY + "!")
; OUTPUT("Your name in uppercase is " + UCARRAY)

;; Main program register usage: 
; R0 = the input character 
; R1 = the return character (negated CR) 
; R2 = base address of ARRAY
; R3 = temp 
; R4 = the return character (negated LF)
; R5 = base address of UCARRAY
; R6 = SIZE

; Main program code: 

		LEA	R0, PROMPT	; display prompt 
		PUTS 
		LD 	R1, RETCR	; initialize the return character (CR)
		LD	R4, RETLF	; initialize the return character (CF) 
		LD	R6, SIZE	; loading the content of CONST into R6
		LEA	R2, ARRAY	; Get base address of ARRAY
		LEA	R5, UCARRAY	; Get base address of UCARRAY

WHILE		GETC
		OUT			; Read and echo a character (stored in R0)
		ADD	R3, R0, R1	; WHILE character != return (CR)
		BRz 	ENDWHILE 
		ADD	R3, R0, R4	; WHILE character != return (LF)
		BRz	ENDWHILE
		ADD	R3, R6, #-1	; WHILE size != 0
		BRz	ENDWHILE
		STR	R0, R2, #0	; ARRAY[i] = character
		ADD	R2, R2, #1	; i = i + 1
		ADD	R3, R0, #-32	; IF character != " "
		BRz	SPACE
		ADD	R0, R0, #-32	; capitalizing the string
		STR	R0, R5, #0	; UCARRAY[i] = ucase(character)
		ADD	R5, R5, #1	; j = j + 1
		BR	WHILE	
SPACE		STR	R0, R5, #0	; UCARRAY[i] = character
		ADD	R5, R5, #1	; j = j + 1
		BR	WHILE
		

ENDWHILE	STR 	R0, R2, #0	; store the null character after the last input 		
		LEA	R0, OUTPUT	; preparing output by loading base address in R0
		PUTS			; OUTPUT
		LEA	R0, ARRAY	
		PUTS
		LEA	R0, EXCL
		PUTS
		LEA	R0, UCASE	; printing uppercase 
		PUTS
		LEA	R0, UCARRAY	
		PUTS
		HALT
		

PROMPT	.STRINGZ "Please enter your name: "
OUTPUT	.STRINGZ "Thank you, "
EXCL	.STRINGZ "!\n"
UCASE	.STRINGZ "Your name in uppercase is "

RETCR	.FILL x-000D	; return character (negated CR)
RETLF	.FILL x-000A	; return character (negated LF)
ARRAY	.BLKW 60	; reserve 60 cells for ARRAY 
UCARRAY	.BLKW 60	; reserve 60 cells for uppercase string array UCARRAY
SIZE	.FILL #60	; size of array
