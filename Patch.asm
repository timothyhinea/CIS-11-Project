.ORIG x3000


MINSTRING	.STRINGZ "The minimum score on this exam is: "
MAXSTRING	.STRINGZ "The maximum score on this exam is: "
AVGSTRING	.STRINGZ "The average score on this exam is: "
PROMPT 		.STRINGZ "Enter your 5 test scores: "


JSR GETVALUES

OUTPUTS ;This section takes values stored in
	;MIN, MAX, and AVG and outputs a string
	; and the corisponding letter grade for
	;each variable. 

LEA R0, AVGSTRING	;Output average string
PUTS

LD R1, CALCVALUES
LDR R1, R1, #0	;Output for AVG
STI R1, X		
JSR LETTER		;Get value of grade using function		
LDI R0, ASCII_OUT
OUT			;output AVG letter grade
JSR OUTPUTNUM	
AND R0, R0, #0
ADD R0, R0, #10
OUT			;out new line
			;END of min

LEA R0, MAXSTRING	;Output max string
PUTS

LD R1, CALCVALUES
LDR R1, R1, #-1	
STI R1, X
JSR LETTER			
LDI R0, ASCII_OUT
OUT			;output for max letter grade
JSR OUTPUTNUM	
AND R0, R0, #0
ADD R0, R0, #10
OUT			;out new line
			;END of MAX

LEA R0, MINSTRING	;Output MIN string
PUTS

LD R1, CALCVALUES
LDR R1, R1, #-2	
STI R1, X
JSR LETTER			
LDI R0, ASCII_OUT
OUT			;output for min letter grade
JSR OUTPUTNUM	
AND R0, R0, #0
ADD R0, R0, #10
OUT			;out new line
			;END of min
	;END OF OUTPUTS FUNCTION 

HALT


	
LETTER 	;This Subroutine takes a value stored in X 
		;And returns ACII value of the letter grade in label ACII_OUT
	STI R0, SAVER0
	STI R1, SAVER1
	STI R2, SAVER2
	STI R3, SAVER3
	STI R4, SAVER4
	STI R5, SAVER5
	STI R6, SAVER6
	STI R7, SAVER7
	


	
	ADD R5,R5, #0
	LDI R1, X
	LD R2, ASCII_F
	AND R5, R5, x0		;CLEAR OUT R5 for checking letter grade
	AND R4, R4, x0		;CLEAR OUT R4 for a counter in the loop
	ADD R5, R1, #-16	;R5= X-59
	ADD R5, R5, #-16
	ADD R5, R5, #-16
	ADD R5, R5, #-11	;Incramets of 16 
	BRnz SAVELETTER		;if x <= 59 jump to SAVELETTER

	ADD R4,R4, #-1
		
	TENLOOP
	ADD R4, R4, #-1
	ADD R5, R5, #-10
	BRp TENLOOP		
	
	ADD R6, R4, #5
	BRzp SAVELETTER		;Validation for over 100
	AND R4, R4,#0
	ADD R4, R4, #-5

	SAVELETTER
	AND R5, R5, #0		;Empty R5
	ADD R5, R2, R4		;ADD Counter variable and and ASCII F
	STI R5, ASCII_OUT	;Save ASCII value of letter to ASCII_OUT
	
	LDI R0, SAVER0
	LDI R1, SAVER1
	LDI R2, SAVER2
	LDI R3, SAVER3
	LDI R4, SAVER4
	LDI R5, SAVER5
	LDI R6, SAVER6
	LDI R7, SAVER7
	


 RET	;END OF LETTER FUNCTION

	

GETVALUES
STI R0, SAVER0
STI R1, SAVER1
STI R2, SAVER2
STI R3, SAVER3
STI R4, SAVER4
STI R5, SAVER5
STI R6, SAVER6
STI R7, SAVER7

LEA R0, PROMPT
PUTS

AND R0, R0, #0

LD R5, NUM_5

NEXT_NUM
AND R1, R1, #0
LD R3, ASCII_NUM

GET_DIGIT
GETC
OUT
ADD R0, R0, R3
BRn END_OF_NUM
ADD R1, R1, #0
BRz FIRST_DIGIT
LD R2, NUM_10
ADD R4, R1, #0
MULT_TEN
ADD R1, R1, R4
ADD R2, R2, #-1
BRp MULT_TEN

FIRST_DIGIT
ADD R1, R1, R0
ST R1, INPUT
BR GET_DIGIT

END_OF_NUM
LD R4, AVG
ADD R4, R4, R1
ST R4, AVG

LD R2, MIN
LD R3, MAX
ST R5, COUNTER
NOT R5, R1
ADD R5, R5, #1 ; R5 = -Score (R1)
ADD R6, R2, R5 ; (IF R1 < MIN then MIN = R1)
BRnz SKIP1
ST R1, MIN
SKIP1
ADD R6, R3, R5 ; (IF R1 > MAX then MAX = R1)
BRzp SKIP2
ST R1, MAX
SKIP2

LD R5, COUNTER
ADD R5,R5, #-1
BRp NEXT_NUM

LD R0, AVG
LD R1, NUM_5
NOT R1, R1
ADD R1, R1, #1
AND R2, R2, #0

DIVISION_LOOP
ADD R0, R0, R1
BRn EXIT
ADD R2, R2, #1
BR DIVISION_LOOP

EXIT
ST R2, AVG
LD R1, CALCVALUES
LD R2, MIN
STR R2, R1, #0
ADD R1, R1, x1
LD R2, MAX
STR R2, R1, #0
ADD R1, R1, x1
LD R2, AVG
STR R2, R1, #0
ST R1, CALCVALUES
ST R2, AVG

LDI R0, SAVER0
LDI R1, SAVER1
LDI R2, SAVER2
LDI R3, SAVER3
LDI R4, SAVER4
LDI R5, SAVER5
LDI R6, SAVER6
LDI R7, SAVER7

RET


OUTPUTNUM			;This subroutine Outputs the value stored in X 
	STI R7, SAVE7
	LDI R1, X 		;Value being passed into subroutine for output
	STI R1, Y		;Move value stored in X to Y
	AND R5, R5, #0		;Counter value for loop
	ADD R5, R5, #-3		; put counter in R5 for checking numbers place
	STI R5, COUNTERTWO

	OUTLOOP			;This loop takes the number stored in X and saves 
					;the digits in locations ONESPLACE TENSPLACE and HUNDREDSPLACE
		
		JSR DIVIDE
		LDI R3, QUOTIENT
		STI R3, Y 
		LDI R2, REMAINDER 
		
		LDI R5, COUNTERTWO			;R5 is the counting variable
		ADD R5, R5, #1			;IF R5 == -3 put remainder in Hundreds place
		BRz HUNDREDPL
		ADD R5, R5, #1			;IF R5 == -2 put remainder in tensplace
		BRz TENSPL
		ADD R5, R5, #1			;IF R5 == 0	 Put remainder in ONESPLACE
		BRz ONESPL
	

	ONESPL
		ADD R5, R5, #-2
		STI R2, ONESPLACE	;Store the remainder in onesplace
		STI R5, COUNTERTWO
		BR OUTLOOP

	TENSPL
		ADD R5, R5, #-1
		STI R2, TENSPLACE	;Store remainder in tensplace
		STI R5, COUNTERTWO
		BR OUTLOOP

	HUNDREDPL
		STI R2, HUNDREDSPLACE	;Store remainder in hundreds place
					;END OF LOOP
					;Fall out of loop


OUTPUTSECTION		;This section of the subroutine outputs the values 
					;Stored in ONESPLACE TENSPLACE and HUNDREDSPLACE 
	AND R0, R1, #0
	AND R1, R1, #0
	LD R1, ASCII_SPACE
	ADD R0, R1, #0
	OUT	

	AND R0, R1, #0
	AND R1, R1, #0
	AND R2, R1, #0
	AND R3, R1, #0
	AND R4, R1, #0
	LDI R1, ONESPLACE
	LDI R2, TENSPLACE
	LDI R3, HUNDREDSPLACE
	LD R4, ASCII_NUMPOS
	
	ADD R5, R3, #0		;IF HUNDREDSPLACE == 0 do NOT output a digit in HUNDREDSPLACE
	BRz OUTPUTTENS
	
OUTPUTHUNDREDS

	AND R0, R0, #0
	ADD R0, R3, R4
	OUT

OUTPUTTENS
	AND R0, R0, #0
	ADD R0, R2, R4
	OUT

OUTPUTONES
	AND R0, R0, #0
	ADD R0, R1, R4
	OUT
	
	AND R0, R1, #0
	AND R1, R1, #0
	LD R1, ASCII_PERCENT
	ADD R0, R1, #0
	OUT	

	LDI R7, SAVE7
RET					;Outputted number onto the console and return




DIVIDE


	AND R0, R1, #0
	AND R1, R1, #0
	AND R2, R1, #0
	AND R3, R1, #0
	AND R4, R1, #0
	AND R5, R1, #0
	AND R6, R1, #0
	
	ADD R2, R2, #10		;The devisory is always 10
	LDI R1, Y		;Load the dividend into R1
	
	ADD R3, R1, #0		;Load the Dividend into R3
	BRz ZERO_QUOTIENT	;If Dividend is 0 return 0
	BRn INVALID
	ADD R4, R2, #0		;R2 is always 10
	BRnz INVALID
	NOT R4, R4
	ADD R4, R4, #1	; negate Y for subtraction for division
	ADD R5, R3, R4	; R5 is remainder container
	BRn XLESSY		; If X < Y then jump to special condition
	BRz XEQUALY		; If X equals Y then we have our answer
	ADD R6, R6, #1		; If this is continuing through then we have already "divided" once
	DIV_LOOP
	ADD R5, R5, R4
	BRn REMAINDER_EXISTS	
	BRz	RETURN_QUOTIENT
	ADD R6, R6, #1		; R6 is quotient
	BR DIV_LOOP
	; Below are outcome branches

	ZERO_QUOTIENT
	AND R6, R6, #0
	AND R5, R5, #0
	STI R5, REMAINDER
	STI R6, QUOTIENT

	RET
	
	INVALID
	RET
	
	XLESSY
	AND R6, R6, #0
	ADD R5, R1, #0	; X is your remainder
	STI R5, REMAINDER	;STORE Remainder in remainder
	STI R6, QUOTIENT
	RET
	
	XEQUALY
	AND R6, R6, #0
	ADD R6, R6, #1
	AND R5, R5, #0
	STI R5, REMAINDER
	STI R6, QUOTIENT
	RET
	
	REMAINDER_EXISTS
	ADD R5, R5, R2
	STI R5, REMAINDER
	STI R6, QUOTIENT
	RET
	
	RETURN_QUOTIENT
	ADD R6, R6, #1
	STI R5, REMAINDER
	STI R6, QUOTIENT
	RET						;END OF DIVISION SUBROUTINE 
	

CALCVALUES 		.FILL x4000			
X			.FILL x4004			;Values for LETTER subroutine
ASCII_OUT		.FILL x4005
ASCII_F			.FILL #70

ASCII_NUMPOS		.FILL #48		;Variables for OUTPUTNUM subroutine and divide subroutine
ASCII_SPACE		.FILL #32
ASCII_PERCENT		.FILL #37
REMAINDER		.FILL x4050
QUOTIENT		.FILL x4051
Y			.FILL x4053
COUNTERTWO		.FILL x4054
ONESPLACE		.FILL x4055
TENSPLACE		.FILL x4056
HUNDREDSPLACE		.FILL x4107
SAVE7			.FILL x0


SAVER0 .FILL x3F00
SAVER1 .FILL x3F01
SAVER2 .FILL x3F02
SAVER3 .FILL x3F03
SAVER4 .FILL x3F04
SAVER5 .FILL x3F05
SAVER6 .FILL x3F06
SAVER7 .FILL x3F07
COUNTER .FILL #0
INPUT .FILL #0
ASCII_NUM .FILL #-48
NUM_10 .FILL #9		;Because the value already being in the target register counts as the first multiplication
NUM_5 .FILL #5
MIN .FILL #101
MAX .FILL #0
AVG .FILL #0





.END