; From x86-64 Assembly Language Programming with Ubuntu
; By Prof. Ed Jorgensen
; Section: 8.3 Addressing Modes

; Benjamin Boden
; UVU ID: 10760739
; 10/11/12022
; Lab 10, part B

; ******************************************************

; Program calculates simple geometric
; information for each square pyramid in
; a series of square pyramids.

; Calculates the total surface area and
; Volume of eac square pyramid.

; Once the values are computed, the program finds
; the minimum, maximum, sum, and average for the 
; total surface areas and volumes.

; Formulas for (n) triangle:
; -> total_Surface_Areas(n) = aSides(n) *
;					(2*aSides(n)*sSides(n)
;
; -> volume(n) = (aSides(n)^2 *heights(n)) / 3
; *******************************************

; Data Declaration
section .data

EXIT_SUCCESS	equ	0
SYS_EXIT	equ	60
;ddTwo		equ	2
;ddThree		equ	3


; Provide the data
; 50 diffrent Peramids
; 5x10 grids:
aSides	db 10, 14, 13, 37, 54
		db 31, 13, 20, 61, 36
		db 14, 53, 44, 19, 42
		db 27, 41, 53, 62, 10
		db 19, 18, 14, 10, 15
		db 15, 11, 22, 33, 70
		db 15, 23, 15, 63, 26
		db 24, 33, 10, 61, 15
		db 14, 34, 13, 71, 81
		db 38, 13, 29, 17, 93
		
sSides	dw 1233, 1114, 1773, 1131, 1675
		dw 1164, 1973, 1974, 1123, 1156
		dw 1344, 1752, 1973, 1142, 1456
		dw 1165, 1754, 1273, 1175, 1546
		dw 1153, 1673, 1453, 1567, 1535
		dw 1144, 1579, 1764, 1567, 1334
		dw 1456, 1563, 1564, 1753, 1165
		dw 1646, 1862, 1457, 1167, 1534
		dw 1867, 1864, 1757, 1755, 1453
		dw 1863, 1673, 1275, 1756, 1353

heights	dd 14145, 11134, 15123, 15123, 14123
		dd 18454, 15454, 12156, 12164, 12542
		dd 18453, 18453, 11184, 15142, 12354
		dd 14564, 14134, 12156, 12344, 13142
		dd 11153, 18543, 17156, 12352, 15434
		dd 18455, 14134, 12123, 15324, 13453
		dd 11134, 14134, 15156, 15234, 17142
		dd 19567, 14134, 12134, 17546, 16123
		dd 11134, 14134, 14576, 15457, 17142
		dd 13153, 11153, 12184, 14142, 17134

; Needed numbers		
length	dd 50 ; Array length
ddTwo	dd 2
ddThree	dd 3

; Total Area values
taMin	dd 0
taMax	dd 0
taSum	dd 0
taAve	dd 0

; Volume values
volMin	dd 0
volMax	dd 0
volSum	dd 0
volAve	dd 0

; 

; UNINITIALIZED DATA:
section	.bss

totalAreas	resd	50			; Peramid Ereas
volumes		resd	50			; Peramid Volumes

;*********************************************************

; PROGRAM LOGIC:
section .text
global _start



_start:	
	; __init__
	mov	ecx, dword [length]		; Loop counter based on peramids left
	mov	rsi, 0					; index of Perimid



; Find the Surface area and volume of a given peramid
; repeat for every peramid
calculationLoop:
	; Surface area of peramid:
	; total_Surface_Areas(n) = 2 * aSides(n) * aSides(n) * sSides(n)
	movzx	r8d, byte [aSides+rsi]
	movzx	r9d, word [sSides+rsi*2]
	mov	eax, r8d
	
	mul	dword [ddTwo]	; eax = eax * 2
	mul	r8d		; eax = eax * aSides(rsi)
	mul	r9d		; eax = eax * sSides(rsi)
	
	mov	dword [totalAreas+rsi*4], eax ; push answer to memory as array
	
	; Volume of Peramid:
	; volume(n) = (aSides(n)^2 *heights(n)) / 3
	movzx	eax, byte [aSides+rsi]
	mul	eax		; eax = aSides^2
	mul	dWord [heights+rsi*4]
	div	dword [ddThree]		; eax = eax/3
	
	mov	dword [volumes+rsi*4], eax  ; push back to memory
	
	inc	rsi
	loop	calculationLoop		; repeat untill rcx is 0
	


; Find Min, Max, Sum, and average of for the areas
; and volumes.
SetValues:
	mov	rsi, 0	
	mov	eax, dword [totalAreas+rsi*4]
	mov	dword [taMin], eax
	mov	dword [taMax], eax
	
	mov	eax, dword [volumes+rsi*4]
	mov	dword [volMin], eax
	mov	dword [volMax], eax
	
	mov	dword [taSum], 0
	mov	dword [volSum], 0

	mov	ecx, dword [length]
	
statsLoop:
	mov	eax, dword [totalAreas+rsi*4]
	add	dword [taSum], eax
	cmp	eax, dword [taMin]
	jae	notNewTaMin
	mov	dword [taMin], eax

notNewTaMin:
	cmp	eax, dword [taMax]	; if eax >= taMax
	jbe	notNewTaMax		; jump to 
	mov	dword [taMax], eax	; else	

notNewTaMax:
	mov	eax, dword [volumes+rsi*4]
	add	dword [volSum], eax
	cmp	eax, dword [volMin]
	jae	notNewVolMin
	mov	dword [volMin], eax

notNewVolMin:
	cmp	eax, dword [volMax]
	jbe	notNewVolMax
	mov	dword [volMax], eax

notNewVolMax:
	inc	rsi
	loop	statsLoop


; Calculate averages.
mov	eax, dword [taSum]
mov	edx, 0
div	dword [length]
mov	dword [taAve], eax

mov	eax, dword [volSum]
mov	edx, 0
div	dword [length]
mov	dword [volAve], eax

; end programm
last:
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall
