;; Author: Utkrist P. Thapa '21 

;; This program subtracts the number in the variable SECOND from the number 
;; in the variable FIRST and stores the result in the variable DIFF

	.ORIG x3000

;; Pseudocode design: 
; DIFF = FIRST - SECOND

;; Main program register usage:
; R1 = FIRST
; R2 = SECOND
; R3 = DIFF

; Main program code: 

	LD  R1, FIRST
	LD  R2, SECOND
	NOT R2, R2	; inverting the bits in SECOND
	ADD R2, R2, #1	; adding 1 to the inverted bits in SECOND
			; this converts SECOND to -SECOND (negative)
	ADD R3, R1, R2
	ST  R3, DIFF 
	HALT

; Data for the main program: 
FIRST	.BLKW 1
SECOND	.BLKW 1
DIFF	.BLKW 1 
	
