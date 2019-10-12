;; Author: Utkrist P. Thapa '21

;; This program multiplies the numbers in the variables FIRST and SECOND and 
;; stores the result in the variable PRODUCT

	.ORIG x3000

;; Pseudocode design: 
; PRODUCT = FIRST * SECOND 

;; Main program register usage: 
; R1 = FIRST
; R2 = SECOND
; R3 = PRODUCT

; Main program code: 

	LD R1, FIRST
	LD R2, SECOND
LOOP	ADD R2, R2, #-1		; while the number in SECOND > 0
	BRn ENDLOOP
	ADD R3, R3, R1
	BRnzp LOOP

ENDLOOP	ST R3, PRODUCT
	HALT 

; Data for the program:
FIRST	.BLKW 1
SECOND	.BLKW 1
PRODUCT	.BLKW 1