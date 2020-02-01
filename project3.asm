TITLE Integer Accumulator     (template.asm)

; Author: Thuy-Vy Nguyen
; Course / Project ID    CS271 - Project 3             Date: Due Jan 27th
; Description: This program will take input from the user, validate their inputs, and accumulate negative numbers inputted by the user. We get to work with negative numbers!

INCLUDE Irvine32.inc

;STUFF I NEED TO DO AND FINISH: Rounding, extra credit, style

;constant def
	MIN						equ				-100
	MAX						equ				-1

.data

;basic def
	welcome_prompt			BYTE			"Integer Accumulator", 0
	thuyvy					BYTE			"by Thuy-Vy Nguyen",0
	username_prompt			BYTE			"What's your name? ", 0
	hello_prompt			BYTE			"Hello ",0
	farewell_prompt			BYTE			"Hope you enjoyed adding up negative numbers. Programmed by Thuy-Vy Nguyen",0
	goodbye_prompt			BYTE			"Bye ",0
	terms_prompt			BYTE			"Please enter numbers in [-100, -1].   Enter a non-negative number when you are finished to see results.", 0
	input_instruction		BYTE			". Enter int: ", 0
	divider					BYTE			"-------------------------------------------------------------------------------------------------------",0
	error_mess				BYTE			"Error: Please enter numbers in [-100, -1].", 0
	sum_message				BYTE			"Sum of Valid Integers: ",0
	counter_message			BYTE			"Number of Valid Integers Entered: ",0
	average_message			BYTE			"Rounded Average: ",0
	no_valid_mess			BYTE			"Unable to calculate average due to lack of valid ints. ",0
	ec_1					BYTE			"**Extra Credit: Option 1 - Number the lines during user input",0
	ec_2					BYTE			"**Extra Credit: Option 2 - Do something creative (colored text) ", 0


;variables defined by user
	username_input			BYTE			33 DUP(0)	
	user_int				DWORD			?

;results variables
	final_neg				DWORD			?
	counter					DWORD			0
	line_num				DWORD			0
	div_va					DWORD			?
	remainder				DWORD			0
	pos_rem					DWORD			?
	half					DWORD			0


.code
main PROC


;introduction  
	mov		eax,		white							;sextextcolor just sets textcolor				
    call	SetTextColor
	mov		edx,		OFFSET welcome_prompt			;introduces assignment
	call	WriteString
	mov		eax,		cyan								
    call	SetTextColor
	call	CrLF
	mov		edx,		OFFSET thuyvy					;introduces programmer ---me!
	call	WriteString
	call	CrLf

	mov		eax,		gray								
    call	SetTextColor

	mov		edx,		OFFSET ec_1						;ec prompts
	call	WriteString
	call	CrLf

	mov		edx,		OFFSET ec_2						
	call	WriteString
	call	CrLf

	call	CrLf
	call	CrLf
	mov		eax,		white								
    call	SetTextColor

;user info
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

;hi user
	mov		eax,		lightmagenta
    call	SetTextColor
	mov		edx,		OFFSET hello_prompt				;says personal hello to user
	call	WriteString
	mov		edx,		OFFSET username_input			;user's name
	call	WriteString
	mov		eax,		white
    call	SetTextColor
	call	CrLf
	mov		edx,		OFFSET divider
	call	WriteString
	call	CrLf


;instructions
	mov		edx,		OFFSET terms_prompt				;prints instructions (range of numbers)
	call	WriteString
	call	CrLf
	call	CrLf


;accumulator loop
	mov		final_neg,	0								; ensures these values are 0 - kind of unneeded
	mov		user_int,	0
	jmp		add_loop

error:
	mov		eax,		user_int						; counteracts user's mistakes and removes incorrect range from total and subtracts from counter
	sub		final_neg,	eax
	sub		counter,	1

	mov		eax,		lightred						;error message in red :)
    call	SetTextColor
	mov		edx,		OFFSET error_mess	
	call	WriteString
	call	CrLf
	mov		eax,		white
    call	SetTextColor

	cmp		counter,	0								;ensures negative counter wont happen
	jl		counter_neg
	jmp		add_loop
counter_neg:
	mov		counter,	0	
	
add_loop:
	mov		eax,		user_int						;adds user_int to final_neg (adds user int to running tota;)
	add		eax,		final_neg
	mov		final_neg,	eax
	add		counter,	1								;increases the counter & line number and then displays it (extra credit)
	add		line_num,	1
	mov		eax,		line_num
	call	WriteDec

	mov		edx,		OFFSET input_instruction		;prints off instruction
	call	WriteString
	call	ReadInt										;gets users input
	
	mov		user_int,	eax								;controls the loop conditions-- ensures that user's input is in range
	cmp		user_int,	MIN
	jl		error
	cmp		user_int,	MAX
	jle		add_loop

	sub		counter,	1
	call	CrLf

;prints the counter of neg numbers
	mov		edx,		OFFSET	counter_message	
	call	WriteString
	mov		eax,		counter
	call	WriteDec
	call	CrLf

;prints the total!
	mov		edx,		OFFSET	sum_message
	call	WriteString
	mov		eax,		final_neg
	call	WriteInt
	call	CrLF

division:
	cmp		counter,	0								;if no numbers were valid just exit
	je		no_valid

	mov		edx,		OFFSET	average_message			
	call	WriteString

	mov		eax,		final_neg						;divides total by how many valid ints and stores it in div_va and the remainder in remainder
	cdq
	mov		ebx,		counter
	idiv	ebx;
	mov		remainder,	edx
	mov		div_va,		eax

	mov		eax,		remainder						;this makes the remainder positive-- post_rem
	neg		eax
	mov		pos_rem,	eax

rounding:
	mov		eax,		counter							;this controls the rounding- divide by counter by 2, if the remainder is greater than (counter/2) then subtract 1 from the average else jump to end
	cdq
	mov		ebx,		2
	div		ebx
	mov		half,		eax
	mov		eax,		pos_rem
	cmp		eax,		half
	jle		skip
	sub		div_va,		1								;skip is used for when the decimal is .5 or less

skip:
	mov		eax,		div_va							;prints average
	call	WriteInt
	call	CrLf
	jmp		goodbye

no_valid:
	mov		edx,	OFFSET no_valid_mess				;sums up assignment
	call	WriteString


goodbye:
	call	CrLf
	mov		eax,	white
    call	SetTextColor
	call	CrLf;
	mov		edx,	OFFSET farewell_prompt				;sums up assignment
	call	WriteString
	call	CrLf
	mov		edx,	OFFSET goodbye_prompt				;goodbye
	call	WriteString
	mov		eax,	lightcyan
    call	SetTextColor
	mov		edx,	OFFSET username_input				;personal goodbye
	call	WriteString
	mov		eax,	white
    call	SetTextColor
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
