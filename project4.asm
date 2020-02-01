TITLE Composite Numbers    (template.asm)

; Author: ThuyVy Nguyen
; Course / Project ID: Assignment 4                Date: 2/17/19
; Description: This assignment will calculate composite numbers- focusing on using procedures and loops

INCLUDE Irvine32.inc

	MAX				=		400
	TRUE			=		1
	FALSE			=		0
	MAX_WIDTH		=		8


.data
	welcome_prompt			BYTE			"Composite Numbers by Thuy-Vy Nguyen",0

	instruct				BYTE			"Enter the number of composite numbers you would like to see----up to 400 composites.",0 
	extra					BYTE			"EXTRA CREDIT- Option 1: Align the columns", 0

	error_prompt			BYTE			"	Error. Input is not [1...400]",0
	terms_prompt			BYTE			"Enter a number in [1...400]: ", 0
	end_prompt				BYTE			"Results certified by Thuy-Vy Nguyen",0
	space					BYTE			" ",0

	digit					DWORD			0
	counter					DWORD			0
	val_int					DWORD			0
	user_int				DWORD			?
	print_int				DWORD			0
	is_comp					DWORD			1
	square_root				DWORD			?
	num_mult1				DWORD			?
	current					DWORD			?
	num_mult2				DWORD			?

	bye_prompt				BYTE			"Good bye user!",0

.code
main PROC
	call	introduction
	call	getuserdata
	call	showComposites
	call	Crlf
	call	farewell

	exit
	
main ENDP


	introduction	PROC
		mov		edx,	OFFSET		welcome_prompt
		call	WriteString
		call	Crlf

		mov		edx,	OFFSET		instruct
		call	WriteString
		call	Crlf
		mov		edx,	OFFSET		extra
		call	WriteString
		call	Crlf
		call	Crlf

		ret
	introduction	ENDP



	error			PROC
		mov		edx,	OFFSET		error_prompt
		call	WriteString
		call	Crlf

		call	getuserdata
		ret
	error			ENDP


	getuserdata		PROC
		mov		edx,	OFFSET		terms_prompt
		call	WriteString
		call	ReadInt
		mov		user_int, eax
		call	validate

		ret
	getuserdata		ENDP


	validate		PROC
		cmp		user_int,	0
		jle		error_in
		cmp		user_int,	MAX
		jg		error_in
		jmp		end_in

		error_in:
			call	error

		end_in:
		ret
	validate		ENDP

	showComposites	PROC
		call		CrLf
		mov			ecx,		user_int
		mov			current,	1

		comp:
			push	ecx
			
			check_loop:
					inc			current			
					call		isComposite
					pop			eax
					cmp			eax,	FALSE
					je			check_loop

			printing_stuff:
				
				

				;EXTRA CREDIT SPACES HERE
				mov		digit,		0
				mov		eax,		current
				log_loop:
					inc	digit
					cdq
					mov	ebx,	10
					div	ebx
					cmp	eax,	0
					jg	log_loop

					mov		ecx,		MAX_WIDTH
					sub		ecx,		digit

					space_loop:
						mov		edx,		OFFSET	space
						call	WriteString
						loop	space_loop
				
				inc		counter
				mov		eax,		current
				call	WriteDec

				cmp		counter,	10
				jne		ignore
				call	CrLf
				mov		counter,	0
				ignore:

			pop		ecx
			loop	comp

		ret
	showComposites	ENDP
		
	
	isComposite		PROC
		mov		ecx,		2
		cmp		current,	3
		jle		prime

		check_prime_loop:
			mov		edx,	0
			mov		eax,	current
			div		ecx

			cmp		edx,	0
			je		composite

			mov		eax, ecx
			mul		ecx

			cmp		eax, current
			jg		prime
			inc		ecx
			jmp		check_prime_loop

		composite:
			pop		eax
			push	TRUE
			push	eax

			ret
		prime:
			pop		eax
			push	FALSE
			push	eax
			
		ret
	isComposite		ENDP

	farewell		PROC
		call	Crlf
		mov		edx,	OFFSET		bye_prompt
		call	WriteString
		call	Crlf
		mov		edx,	OFFSET		end_prompt
		call	WriteString
		call	Crlf

		ret
	farewell		ENDP

END main
	
