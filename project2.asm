TITLE Fibonacci     (template.asm)

; Author: Thuy-Vy Nguyen
; Course / Project ID:  CS271 Program 2                Due Date: 20 January 2019
; Description: I will have to write a program that calculates Fibonacci numbers. Objectives: using loops, string inpout, data validation, and keeping track of a previous value.

INCLUDE Irvine32.inc


;constant def
	MIN						equ				1
	MAX						equ				46
	LINE					equ				5

.data

;variable def

	welcome_prompt			BYTE			"Fibonacci Numbers Calculator ", 0
	thuyvy					BYTE			"by Thuy-Vy Nguyen",0
	username_prompt			BYTE			"What's your name? ", 0
	username_input			BYTE			33 DUP(0)			
	ec_prompt				BYTE			"EC Prompt 2: Do Something Incredible - Colored Text", 0
	hello_prompt			BYTE			"Hello ",0
	space					BYTE			"     ",0
	sep						BYTE			" ", 0
	terms_prompt			BYTE			"How many Fibonacci terms do you want? (Enter interger in range [1...46]): ", 0
	user_int1				DWORD			?
	farewell_prompt			BYTE			"Hope you enjoyed calculating fibonacci numbers. Programmed by Thuy-Vy Nguyen",0
	goodbye_prompt			BYTE			"Bye ",0
	fib						DWORD			0
	counter					DWORD			0
	digit					DWORD			0
	calc					DWORD			0
	edx1					DWORD			0
	ebx1					DWORD			0
	eax1					DWORD			0

.code
main PROC

;introduction

	mov		eax,		white							;sets text color to white
    call	SetTextColor

	mov		edx,		OFFSET welcome_prompt			;introduces assignment
	call	WriteString

	mov		eax,		cyan								
    call	SetTextColor

	mov		edx,		OFFSET thuyvy					;name
	call	WriteString
	call	CrLf

	mov		eax,		white								
    call	SetTextColor

;extra credit prompt
	mov		edx,		OFFSET ec_prompt			;introduces assignment
	call	WriteString
	call	CrLf
	call	CrLf

;get user's name
	mov		edx,		OFFSET username_prompt			;asks user for their name 
	call	WriteString

	mov		eax,		lightcyan
    call	SetTextColor

	mov		edx,		OFFSET username_input			;gets and stores user's name
	mov		ecx,		32
	call	ReadString
	call	CrLf
	
	mov		eax,		white
    call	SetTextColor

;hi user!
	mov		edx,		OFFSET hello_prompt			;says personal hello to user
	call	WriteString

	mov		eax,		lightcyan
    call	SetTextColor

	mov		edx,		OFFSET username_input
	call	WriteString
	call	CrLf

;userInstructions

valid_input:	
	mov		eax,		white
    call	SetTextColor

	mov		edx,		OFFSET terms_prompt			;asks users for how many terms they want
	call	WriteString

;getUserData - ints

	mov		eax,		yellow
    call	SetTextColor

	call	ReadInt								;gets users input
	mov		user_int1,	eax
	cmp		user_int1,	MIN
	jl		valid_input
	cmp		user_int1,	MAX
	jg		valid_input

	mov		eax,		magenta
    call	SetTextColor

;displayFibs								;starts fib sequence
	mov		eax,		1
	mov		ebx,		0
	mov		ecx,		user_int1

	call	CrLf

FibLoop:

;calc fibs
	inc		counter
	add		ebx,		eax
	mov		edx,		OFFSET space				;prints off the 5 space
	call	WriteString
	mov		fib,		ebx							;algorithm for doing next number
	mov		calc,		ebx
	call	WriteDec

	mov		ebx,		eax
	mov		eax,		fib

	cmp		counter,	5							;ensures only 5 ints per line
	je		print_line

look_back:
	loop	FibLoop
	jmp		farewell


print_line:
	call	CrLf
	mov		counter,	0
	jmp		look_back
	
;farewell

farewell:
	call	CrLf

	mov		eax,	white
    call	SetTextColor
	call	CrLf;
	mov		edx,	OFFSET farewell_prompt
	call	WriteString
	call	CrLf
	mov		edx,	OFFSET goodbye_prompt
	call	WriteString
	mov		eax,	lightcyan
    call	SetTextColor
	mov		edx,	OFFSET username_input
	call	WriteString
	mov		eax,	white
    call	SetTextColor
	call	CrLf

	exit	; exit to operating system

main ENDP
END main
