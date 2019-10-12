;; Author: Utkrist P. Thapa '21 

;; This program manipulates the numbers in the two variables SMALLER and 
;; LARGER until the number in SMALLER is smaller than the number in LARGER

	.ORIG x3000

;; Pseudocode design: 
; if SMALLER > LARGER: 
;	temp = SMALLER
;	SMALLER = LARGER
;	LARGER = temp

;; Main program register usage: 
; R1 = SMALLER
; R2 = LARGER 
; R3 = temp

; Main program code: 

	LD R1, SMALLER
	LD R2, LARGER
	NOT R3, R1
	ADD R3, R3, #1
IF 	ADD R3, R2, R3		; If (R2 - R3 > 0)
	BRp ENDIF
	ST R2, SMALLER		; swapping SMALLER and LARGER
	ST R1, LARGER
	HALT 

; Data for the main program: 
SMALLER	.BLKW 1 
LARGER	.BLKW 1
