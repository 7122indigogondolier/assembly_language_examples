;; Author: Utkrist P. Thapa '21 

;; This program computes the sum of 5 numbers in the array named LIST and 
;; stores this sum in the variable named SUM.

	.ORIG x3000

;; Pseudocode design: 
; for i in LIST: 
;	sum = sum + i

;; Main program register usage: 
; R1 = base address of array LIST
; R2 = logical size of the array LIST
; R3 = SUM
; R4 = temp

; Main program code: 

	LEA R1, LIST
	LD R2, SIZE
LOOP 	ADD R2, R2, #-1    ; while the logical size > 0 
	BRn ENDLOOP
	LDR R4, R1, #0	   ; temp = list[index] 
	ADD R3, R4, R3     ; sum = temp + sum
	ADD R1, R1, #1 	   ; incrementing the index of array
	BRnzp LOOP

ENDLOOP ST R3, SUM
	HALT

; Data for the main program: 
LIST	.BLKW 10
SIZE	.FILL #5
SUM	.BLKW 1
