MOV TMOD, #01	
MOV TL0, #0F2H
MOV TH0, #0FFH
CPL P1.5
ACALL 000FH
SJMP 0003
SETB TR0
JNB TF0, 0011
CLR TR0
CLR TF0
RET
