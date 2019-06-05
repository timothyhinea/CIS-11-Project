.ORIG x3000

JSR GETVALUES

OUTPUTS ;This function takes values stored in
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
AND R0, R0, #0
ADD R0, R0, #10
OUT			;out new line
			;END of min
	;END OF OUTPUTS FUNCTION 

HALT


	
LETTER 	;This function takes a value stored in X 
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

	
; This subroutine is intended to read in 5 test scores
; while simultaneously comparing for minimum and maximum values
; and calculating the average score.
GETVALUES
STI R0, SAVER0
STI R1, SAVER1
STI R2, SAVER2
STI R3, SAVER3
STI R4, SAVER4
STI R5, SAVER5
STI R6, SAVER6
STI R7, SAVER7

; Output prompt asking for 5 test scores
LEA R0, PROMPT
PUTS

AND R0, R0, #0

; Counter for 5 test scores
LD R5, NUM_5

; Start of getting a single test score
NEXT_NUM
AND R1, R1, #0
LD R3, ASCII_NUM ; ASCII offset for char to int conversion

; We grab teh score one digit at a time understanding that the
; first digit is the left most one in the number
GET_DIGIT
GETC
OUT
ADD R0, R0, R3	; If the entry is not a numeric value (specifically an new line character)
BRn END_OF_NUM  ; then we have gotten on entire score and proceed to check if we need to get another.
ADD R1, R1, #0
BRz FIRST_DIGIT	; If this is the first digit entered we can skip some work
LD R2, NUM_10	; Otherwise we multiply the existing score by 10 so we can append the new digit
ADD R4, R1, #0
MULT_TEN	; Multiply by 10 loop (add to itself 10 times)
ADD R1, R1, R4
ADD R2, R2, #-1
BRp MULT_TEN

FIRST_DIGIT
ADD R1, R1, R0
ST R1, INPUT	; Store what we currently have as the input
BR GET_DIGIT	; Jump back to get the next digit or be told it is the end of the score

END_OF_NUM
LD R4, AVG	; Add score to the rest for eventual computing of average
ADD R4, R4, R1
ST R4, AVG

LD R2, MIN	; Compare score to min and max values, to see if any replacements need to be made
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

LD R5, COUNTER	; decrement score counter
ADD R5,R5, #-1
BRp NEXT_NUM	; Go to get next score

LD R0, AVG	; Prep for calculating average
LD R1, NUM_5	; Reuse a variable and take its 2's compelement to save on label declarations
NOT R1, R1
ADD R1, R1, #1
AND R2, R2, #0

DIVISION_LOOP	; Divide the sum of the scores by 5 to get average
ADD R0, R0, R1
BRn EXIT
ADD R2, R2, #1
BR DIVISION_LOOP

EXIT		; Store values in a stack
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

; Data
CALCVALUES .FILL x4000
X		.FILL x4004
ASCII_OUT	.FILL x4005
ASCII_F		.FILL #70


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
MINSTRING	.STRINGZ "The minimum score on this exam is: "
MAXSTRING	.STRINGZ "The maximum score on this exam is: "
AVGSTRING	.STRINGZ "The average score on this exam is: "
PROMPT .STRINGZ "Enter your 5 test scores: "


.END
