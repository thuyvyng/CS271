TITLE Elementary Arithmetic      (template.asm)

; Author: Thuy-Vy Nguyen
; Course / Project ID:  CS271 Program 1					Due Date: 13 January 2019
; Description: Elementary Arithmetic-					This program will introduce us to MASM assembly language 
;														by requiring us to print strings to the screen and perform a basic calculator 
;														by asking the user for 2 ints and performing basic calculations on those integers.

INCLUDE Irvine32.inc

.data

welcome_prompt			BYTE			"Elementary Arithmetic by ThuyVy Nguyen", 0
extra_credit			BYTE			"EC 1: Repeat Until User Chooses to Quit & 2: Validate that the second number is less than the first",0

intro_prompt			BYTE			"Enter 2 numbers to see their sum, difference, product, quotient, and remainder!", 0

int1_prompt				BYTE			"Number 1: ", 0
user_int1				DWORD			?
int2_prompt				BYTE			"Number 2: ", 0
user_int2				DWORD			?

add_op					BYTE			" + ", 0
sub_op					BYTE			" - ", 0
mult_op					BYTE			" * ", 0
div_op					BYTE			" / ", 0
equal_op				BYTE			" = ", 0
rem_op					BYTE			" remainder ", 0

add_va					DWORD			?
sub_va					DWORD			?
mult_va					DWORD			?
div_va					DWORD			?
rem_va					DWORD			?

;Extra credit definitions
continue				DWORD			?
ex1						BYTE			"Would you like to go again? Press 1 for yes. Else for no. ",0
user_ex1				DWORD			?
bye_prompt				BYTE			"Wow what fun calculations. Bye now", 0
error					BYTE			"Error! Your second number is not less than their first number. ", 0
error_2					BYTE			"Unable to perform division and remainder because second number is 0. "



.code
main PROC

;Introduction- This welcomes the user and states which extra credit options were completed
	mov		edx, OFFSET welcome_prompt
	call WriteString
	call CrLf
	mov		edx, OFFSET extra_credit
	call WriteString
	call CrLf

math:
;Prints out the instructions
	call CrLf
	mov		edx, OFFSET intro_prompt
	call WriteString
	call CrLf
	jmp input

; only called if second number is not less than first number - informs user of their error
input_error:
	call CrLf
	mov		edx, OFFSET error
	call WriteString
	call CrLf
	jmp input

; will print an error message in user's choice of numbers because nothing is divisible by 0
zero_error:
	call CrLf
	mov		edx, OFFSET error_2
	call WriteString
	call CrLf
	jmp print_calc
	

input:
;Get User Input for Number 1
	call CrLf
	mov		edx, OFFSET int1_prompt
	call WriteString
	call ReadInt
	mov		user_int1, eax

;Get User Input for Number 2
	mov		edx, OFFSET int2_prompt
	call WriteString
	call ReadInt
	mov		user_int2, eax

;extra credit option- whether second number < first number
	mov		eax, user_int1
	cmp		eax, user_int2
	js	input_error
	je	input_error


calculations:
;Performs and stores Addition
	mov		eax, user_int1
	add		eax, user_int2
	mov		add_va, eax

;Subtraction
	mov		eax, user_int1
	sub		eax, user_int2
	mov		sub_va, eax

;Mult
	mov		eax, user_int1
	mul 	user_int2
	mov		mult_va, eax

;Div 

	cmp		user_int2, 0
	je	zero_error

	mov		eax, user_int1
	cdq
	mov		ebx, user_int2
	div		ebx;
	mov		div_va, eax

;Remainder
	mov		eax, user_int1
	cdq
	mov		ebx, user_int2
	div		ebx
	mov		rem_va, edx
	mov		eax, edx

print_calc:

;Print ADD
	call Crlf;
	mov		eax, user_int1
	call WriteDec
	mov	edx, OFFSET add_op
	call WriteString
	mov		eax, user_int2
	call WriteDec
	mov		edx, OFFSET equal_op
	call WriteString
	mov		eax, add_va
	call WriteDec
	call CrLf

; Print Sub
	mov		eax, user_int1
	call WriteDec
	mov	edx, OFFSET sub_op
	call WriteString
	mov		eax, user_int2
	call WriteDec
	mov		edx, OFFSET equal_op
	call WriteString
	mov		eax, sub_va
	call WriteDec
	call CrLf

; Print Mult
	mov		eax, user_int1
	call WriteDec
	mov	edx, OFFSET mult_op
	call WriteString
	mov		eax, user_int2
	call WriteDec
	mov		edx, OFFSET equal_op
	call WriteString
	mov		eax, mult_va
	call WriteDec
	call CrLf



;Print Div & Remainder

	cmp		user_int2, 0
	je	end1

	mov		eax, user_int1
	call WriteDec
	mov	edx, OFFSET div_op
	call WriteString
	mov		eax, user_int2
	call WriteDec
	mov		edx, OFFSET equal_op
	call WriteString
	mov		eax, div_va
	call WriteDec
	mov		edx, OFFSET rem_op
	call WriteString
	mov		eax, rem_va
	call WriteDec
	call CrLf

end1:
;EXTRA CREDIT 1 - asks if user wants to go again and jumps backs if yes 
	call CrLf;

	mov	edx, OFFSET ex1
	call WriteString;
	call ReadInt
	mov		user_ex1, eax

	CMP user_ex1, 1
	je math

;Print Bye
	mov edx, OFFSET bye_prompt
	call WriteString


; (insert executable instructions here)

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
