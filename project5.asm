TITLE Assignment 5 - - Random Number Array (template.asm)

; Author: ThuyVy  Nguyen
; Course / Project ID: Assignment 5                 Due	Date: 24 February 2019
; Description: Make an array, fill with random numbers, then sort it. We are supposed to practice using the stack, passing parameters, and arrays

INCLUDE Irvine32.inc
	MIN						=				10
	MAX						=				200
	LO						=				100
	HI						=				999
	TRUE					=				1
	FALSE					=				0

.data
	welcome_prompt			BYTE			"Random Number Array by Thuy-Vy Nguyen",0
	about					BYTE			"Enter a [10-200] number to see a list of random numbers, and then it sorted in descending order.",0
	instruct				BYTE			"How many numbers would you like generated?: ",0 
	extra					BYTE			"EXTRA CREDIT- 5:Other (Colored Text!)", 0
	sort					BYTE			"Sorted List:",0
	non_sort				BYTE			"Un-sorted List:",0
	error_prompt			BYTE			"Error. Input is not [10-200]",0
	space					BYTE			"   ",0
	med						BYTE			"This is the median: ",0
	list					DWORD			MAX			DUP(?)
	count					DWORD			0

.code
main PROC
	mov		eax,		white
    call	SetTextColor
	call	Randomize

	push	OFFSET		extra
	push	OFFSET		about
	push	OFFSET		welcome_prompt
	call	introduction

	push	OFFSET		instruct
	push	OFFSET		error_prompt
	call	get_data

	mov		count,		eax				
	push	OFFSET		list
	push	eax
	call	fill_array

	push	OFFSET		non_sort
	call	print_unsort_name

	push	OFFSET		list
	push	count
	push	OFFSET		space
	call	display_list

	call	Crlf

	push	OFFSET		list
	push	count
	call	sort_list

	push	OFFSET		sort
	call	print_sort_name

	push	OFFSET		list
	push	count
	push	OFFSET		space
	call	display_list

	mov		eax,		magenta
    call	SetTextColor

	push	OFFSET		list
	push	count
	push	OFFSET		med
	call	display_median

	call	Crlf
	mov		eax,		white
    call	SetTextColor
	exit
	
main ENDP
	;Proc: print_sort_name
	;descripion: prints "Sorted List"
	;returns: nothing
	;preconditions:none
	;registers changed:eax,edx

	print_sort_name	PROC
		push	ebp
		mov		ebp,	esp
		mov		eax,	lightgreen
		call	SetTextColor

		call	Crlf
		mov		edx,	[ebp+8]
		call	WriteString
		call	CrLf
		mov		eax,	white
		call	SetTextColor

		pop		ebp
		ret
	print_sort_name	ENDP

	;Proc: print_unsort_name
	;descripion: prints "UnSorted List"
	;returns: nothing
	;preconditions:none
	;registers changed:eax,edx

	print_unsort_name	PROC
		push	ebp
		mov		ebp,	esp

		mov		eax,	lightgreen
		call	SetTextColor

		call	Crlf
		mov		edx,	[ebp+8]
		call	WriteString
		call	CrLf

		mov		eax,	white
		call	SetTextColor

		pop		ebp
		ret
	print_unsort_name	ENDP


	;Proc: introduction
	;descripion: prints instructions and introductions for assignment
	;returns: nothing
	;preconditions:none (print things are pushed on stack)
	;registers changed:edx

	introduction	PROC
		push	ebp
		mov		ebp,	esp

	print_welcome:
		mov		edx,	[ebp+8]
		call	WriteString
		call	CrLf
	print_about:
		mov		edx,	[ebp+12]
		call	WriteString
		call	Crlf
	print_extra:
		mov		eax,	lightgray
		call	SetTextColor
		mov		edx,	[ebp+16]
		call	WriteString

		mov		eax,	white
		call	SetTextColor
		call	Crlf
		pop		ebp
		ret		12
	introduction	ENDP


	;Proc: get_data
	;descripion: gets data from user
	;returns: user's data
	;preconditions: print statements are on stack
	;registers changed:eax,edx

	get_data		PROC
		call	CrLf
		push	ebp
		mov		ebp,	esp
		
		mov		eax,	FALSE
	valid_loop:
		cmp		eax,	TRUE
		je		out_of_loop
		mov		eax,	cyan
		call	SetTextColor
		mov		edx,	[ebp+12]
		call	WriteString
	
		mov		eax,	green
		call	SetTextColor
		call	ReadInt	

		push	eax
		mov		ebx,	eax
		push	[ebp+8]

		mov		eax,	white
		call	SetTextColor

		
		call	validate
		jmp		valid_loop

	out_of_loop:
		
		mov		eax,	ebx
		pop		ebp
		ret		8
	get_data		ENDP
	
	;Proc: validate
	;descripion: validates input from user
	;returns: whether data is valid
	;preconditions:get user data has been called
	;registers changed: eax (true or false)

	validate		PROC
		push	ebp
		mov		ebp,	esp
		mov		eax,	[ebp+12]

		cmp		eax,	MIN
		jl		error_in
		cmp		eax,	MAX
		jg		error_in
		jmp		end_in

		error_in:
			mov		edx,	[ebp+8]
			call	WriteString
			call	Crlf
			mov		eax,	FALSE
			jmp outtie
		end_in:
			mov		eax,	TRUE
		outtie:
		pop		ebp
		ret		8
	validate		ENDP

	;Proc: fill array
	;descripion: fills array with random number
	;returns: array with random numbers
	;preconditions:array exist, array and counter on stack
	;registers changed: stack, ecx

	fill_array		PROC
		push	ebp
		mov		ebp,	esp
		mov		edi,	[ebp+12]
		mov		ecx,	[ebp+8]
		random_numbers:
			mov		eax,	900
			call	RandomRange
			add		eax,	100
			mov		[edi],	eax
			add		edi,	4
			loop	random_numbers	
		pop	ebp
		ret	8
	fill_array		ENDP

	;Proc: sorts_list
	;descripion: sorts list to be descending
	;returns: organized array
	;preconditions: array exists with numbers, array and counter on stack
	;registers changed: eax, ecx, ebx

	sort_list		PROC
		push	ebp
		mov		ebp,	esp
		mov		edi,	[ebp+12]				;sets edi to @list
		mov		ecx,	[ebp+8]					;sets ecx as count
		dec		ecx
		outer_loop:
			push	ecx
			push	edi
			mov		esi,	edi				
			inner_loop:
				add		edi,	4			
				mov		eax,	[edi]			
				mov		ebx,	[esi]			
				cmp		ebx,	eax
				jge		no_switch
				mov		esi, edi
				no_switch:
				loop	inner_loop
			pop		edi
			mov		eax,	[edi]			
			mov		ebx,	[esi]
			mov		[esi],	eax
			mov		[edi],	ebx
			
			add		edi, 4
			pop		ecx
			loop	outer_loop	
		pop		ebp
		ret		8
	sort_list		ENDP


	;Proc: display_median
	;descripion: finds and print out median of array
	;returns: nothing
	;preconditions:array is organized with numbers, array and counter on stack
	;registers changed:eax, edx, ebx
	display_median	PROC
		push	ebp
		mov		ebp,	esp
		mov		edi,	[ebp+16]		;top of the stack
		call	crlf
		call	crlf

		mov		eax,		magenta
		call	SetTextColor

		print:
		
		mov		edx,	[ebp+8]
		call	WriteString
		mov		eax,	lightmagenta
		call	SetTextColor
		divide_ecx:
		mov		eax,	[ebp+12]
		cdq
		mov		ebx,	2
		div		ebx
	
		cmp		edx,	0
		je	no_remainder
		remainder:
			mov		ebx,	4
			mul		ebx
			mov		eax,	[edi+eax]
			jmp		complete
		no_remainder:
			push	eax
			dec		eax
			mov		ebx,	4
			mul		ebx
			mov		edx,	[edi+eax]
			pop		eax
			push	edx
			
			mov		ebx,	4
			mul		ebx
			mov		eax,	[edi+eax]
			pop		edx
			add		eax,	edx
			

			rounding:
			mov		eax,	eax			;i know its dumb but makes it easier to read for me
			cdq
			mov		ebx,	2
			div		ebx
	
			cmp		edx,	0
			je		complete
			inc		eax

		complete:
			call	WriteDec
			
		pop		ebp
		ret	8
	display_median	ENDP


	;Proc: displays_list
	;descripion: prints contents of array 
	;returns: nothing (just prints)
	;preconditions:array and counter are on stack
	;registers changed:eax,edx
	display_list	PROC
		push	ebp
		mov		ebx,	0
		mov		ebp,	esp

		mov		esi,	[ebp+16]
		mov		ecx,	[ebp+12]
		print:
			cmp		ebx,	10
			jne		not_ten
					mov		ebx,	0
					call	Crlf
			not_ten:
			mov		eax,	[esi]
			call	WriteDec
			mov		edx,	[ebp+8]
			call	WriteString
			inc		ebx
			add		esi,	4
			loop	print
		pop		ebp
		ret		8
	display_list	ENDP

END main
