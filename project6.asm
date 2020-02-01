TITLE Project 6     (template.asm)

; Author: Thuy-Vy Nguyen
; Course / Project ID - CS271                Date: 11 March 2019
; Description: OptionA- Takes 10 unsigned numbers as a string, stores them in an array, and calculates their average, sum, and then displays it. So we have to convert string into int and vice versa. We must create our own version of ReadInt and those. Practice string manipulation and using macros.

INCLUDE Irvine32.inc
MAX				equ			10
TRUE			equ			1
FALSE			equ			0

getString				MACRO	message, location, count
	pushad

	displayString	message
	mov		edx,	location
	mov		ecx,	12
	call	ReadString
	mov		count,	eax

	popad
ENDM

displayOffString		MACRO	message
	pushad
	mov		edx,	OFFSET	message
	call	WriteString
	popad
ENDM

displayString			MACRO	message
	pushad
	mov		edx,	message
	call	WriteString
	popad
ENDM

.data

	welcome_prompt			BYTE			"Designing low-level I/O procedures by Thuy-Vy Nguyen",13, 10, 13,10, 0

	about					BYTE			"Please provide 10 unsigned decimal numbers." , 13, 10, "After you finish I will display a list of the integers, their sum, and their averages!", 13, 10, 13,10, 0
	instruct				BYTE			"Enter number: ", 0

	error_prompt			BYTE			"	Error. Input is either not unsigned, an int, or is too large! ", 13, 10, 0
	extra					BYTE			"EXTRA CREDIT- 1. Number each line of user input  ", 13, 10, 0
	extra2					BYTE			"EXTRA CREDIT- 2. Display a running subtotal ", 13, 10, 0
	spaces					BYTE			"   ", 0
	avg						BYTE			"This is the avg: ", 0
	entered					BYTE			13,10,"You entered these: ", 0
	sum2					BYTE			"Sum: ", 0
	adios					BYTE			13,10, "Last assignment of mine to be graded for 271 woo!!!! - thx thuyvy", 13, 10,0
	int_length				DWORD			?

	total					BYTE			13,10, "Running Total: ", 13, 10, 0
	array					DWORD			10			DUP(?)
	check					BYTE			15			DUP(?)
	num_convert				DWORD			?
	count					DWORD			0
	sum						DWORD			0
	plus					DWORD			0
	stringint				DB				16			DUP(0)



.code
main PROC

	displayOffString	welcome_prompt			;i thought we had to use macros for printing all of our strings so sorry!
	displayOffString	about


;	mov		edx,	OFFSET	extra
;	call	writestring
;	mov		edx,	OFFSET	extra2
;	call	writestring
;	call	crlf

	push	int_length			;28
	push	OFFSET	total		;24
	push	OFFSET	array		;20
	push	OFFSET	instruct	;16
	push	OFFSET	error_prompt;12		
	push	OFFSET	check		;8		
	call	ReadVal

	mov		edx,	OFFSET	entered
	call	writestring
	push	OFFSET stringint
	push	OFFSET array
	call	writeVal

	push	OFFSET	array
	push	10
	push	OFFSET	spaces
	call	add_list

	mov		edx,	OFFSET	adios
	call	writestring

	exit	
main ENDP


	;Proc: ReadVal
	;Description: should invoke the getString macro to get the user’s string of digits.  It should then convert the digit string to numeric, while validating the user’s input.
	;Returns: It should fill the array with valid input
	;Preconditions: that getstring works
	;Registers: none changed

	ReadVal			PROC
		push	ebp
		mov		ebp,	esp
		
		mov		edi,	[ebp+20]					;array here
		mov		ecx,	10							;do it ten times

		fillarray:
			push	ecx

			validate:
				
				getString	[ebp+16], [ebp+8], [ebp+24]
				mov		esi,	[ebp+8]													
				mov		ecx,	[ebp+24]

				cld
				mov		ebx,	0					;ebx is the running total
					convertloop:
						clc
						lodsb
						movzx	eax,	al			;extends it so it can fit the eax register
						cmp		eax,	'0'			;checks if its a number (the char is 0-9)
						jl		invalid
						cmp		eax,	'9'
						jg		invalid
						sub		eax,	'0'
						push	eax
						mov		eax,	ebx			
						mov		ebx,	10
						mul		ebx
						jc		invalid				;has to make sure it fits in the reg
						mov		ebx,	eax
						pop		eax
						add		ebx,	eax
						mov		eax,	ebx
						jc		invalid				;gets reset so gotta do it again
						loop	convertloop
					jmp		valid
					invalid:
						displayString	[ebp+12]
						jmp		validate
			valid:
			mov	eax,	ebx
			mov	[edi],	eax
			add	edi,	4
			pop	ecx
			loop	fillarray

		pop		ebp
		ret		16
	ReadVal			ENDP


	;Proc: WriteVal
	;Description: should convert a numeric value to a string of digits, and invoke the displayString macro to produce the output. 
	;Returns: prints output in proc ( not really returned)
	;Preconditions: displayString is good, array is good
	;Registers: not changed after
	WriteVal		PROC	
	push	ebp
	mov		ebp, esp

	mov		edi, [ebp + 8]						;array
	mov		ecx, 10								;do it 10 times for 10 ints
	bigloop:				
		push	ecx
			mov		edx, 0						;reset everything
			mov		eax, [edi]					;eax gets value in array
		    mov		ebx, 10						;division value -- doesnt change
			mov		ecx,	0					;counter

			divide:
				mov		edx,	0				;sets the remainder to 0 again
				div		ebx						;divides by ten (shifts down decimal place)
				push	dx						;lower end of edx(remainder)
				inc		ecx						;inc ecx for next
				cmp		eax, 0					;helps calculte the places of number ex 123 = 3 
				jne		divide					  
						  				  
				lea		esi, stringint			; its like mov expect its the load effective address


			next:
				pop		ax						
				add		ax, '0'					;ascii value addition
				mov		[esi], ax				;prints strings one char at time
				displayString OFFSET stringint
				loop	next
			
		pop		ecx 
		
		
		mov		edx,	OFFSET spaces
		call	WriteString
		add		edi, 4
		loop bigloop
	

	call	crlf
	pop		ebp			
	ret		8		
	WriteVal		ENDP


	;Proc: add_list
	;Description: does the sum and average of the array
	;Returns: prints out sum and avg
	;Preconditions: array that is filled with 10 ints
	;Registers: none
	add_list		PROC
		push	ebp
		mov		ebp,	esp

		mov		eax,	0
		mov		edx,	0
		mov		ebx,	0
		mov		ebp,	esp

		mov		esi,	[ebp+16]
		mov		ecx,	10
		
		print:
			mov		edx,	[esi]
			add		eax,	edx
			inc		ebx
			add		esi,	4
			loop	print

		mov	edx,	OFFSET	sum2
		call	writestring
		call	writedec
		call	crlf
		
			mov	eax,	eax
			mov	edx,	0
			mov	ebx,	10
			div	ebx
			mov	edx,	OFFSET	avg
			call	writestring
			call	writedec
			call	crlf
		pop		ebp

		ret	12
	add_list		ENDP
	



	;Proc: NotRight
	;Description: just prints out error message - helped me with my readability
	;Returns: nothing
	;Preconditions:	 there is an error that needs an erro message
	;Registers: none
	NotRight		PROC
		push	ebp
		mov		ebp,	esp

		call	crlf
		displayString	[ebp+8]
		call	Crlf

		pop		ebp
		ret	8
	NotRight		ENDP

	;Proc: checkvalidint-- didnt end up using this
	;Description: checks if we converts string to int
	;Returns: whether or not the string can be an int
	;Preconditions: that a string is passed
	;Registers: ebx = 0/1
	checkvalidint			PROC
		push	ebp
		mov		ebp,	esp

		sub		eax,	'0';
		cmp		eax,	0
		jl		invalid
		cmp		eax,	9
		jg		invalid
		jmp		ok
		invalid:
			mov		ebx,	FALSE
		ok:
		pop		ebp
		ret
	checkvalidint			ENDP

	;Proc: Checking --- didnt end up using this, used carry flag instead!
	;Description: checks how long the int is, if its greater than 11 it doesnt fit in the register for unsigned
	;Returns: true or not
	;Preconditions: is passed a string
	;Registers: ebx
	Checking		PROC
		push	ebp
		mov		ebp,	esp

		mov		ebx,	TRUE
		cmp		eax,	10
		jg		invalid
		jmp		good
		invalid:
			mov	ebx,	FALSE
		good:
		pop		ebp
		ret
	Checking		ENDP

	;Proc: display_list
	;Description: prints out the list -- used to error handle
	;Returns: none
	;Preconditions: passed array
	;Registers: none
	display_list	PROC
		push	ebp
		mov		ebx,	0
		mov		ebp,	esp

		mov		esi,	[ebp+16]
		mov		ecx,	[ebp+12]
		print:
			mov		eax,	[esi]
			call	WriteDec
			call	crlf
			
			inc		ebx
			add		esi,	4
			loop	print
		pop		ebp
		ret		8
	display_list	ENDP

END main

