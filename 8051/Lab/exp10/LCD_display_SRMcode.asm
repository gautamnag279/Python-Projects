ORG 0000H
RS       EQU P1.3
 E         EQU P1.2
; THE R/W* is  hardwired to 0v,therefore it is always in write mode
; ..MAIN..
MAIN:
;SELECT INSTRUCTION REGISTER (IR)
    CLR RS  ; RS=0 INSTRUCTION REGISTER IS SELECTED
                  ;  STORE INSTRUCTION CODE
; FUNCTION SET
      CALL FUNCSET
; DISPLAY ON/OFF CONTROL
       CALL DISPCON
; ENTRY MODE SET(4 BIT MODE)
       CALL ENTRYMODE
; SEND DATA
        SETB RS    ; RS= 1  DATA REGISTER IS SELECTED
                          ; SENT DATA TO DATA REGISTER TO BE DISPLAYED
         MOV DPTR ,#LUT
BACK:   CLR A
MOVC A,@A+DPTR     ;------- LOOKUP TABLE (LUT)------------------------
JZ FINISH                      
                                        
CALL SENDCHAR
INC DPTR
JMP BACK
FINISH: JMP $       ;PROHRAM ENDS AND STAYS HERE
;  .END OF MAIN..
FUNCSET:   CLR P1.7     
      CLR P1.6  
SETB P1.5   ;  I BIT  5=1
CLR P1.4     ;  I(DB4)  DL =0  -PUTS LCD MODULE INTO  4-BIT MODE
CALL PULSE
CALL DELAY   ; WAIT FOR BF TO CLEAR
CALL  PULSE

SETB P1.7   ; P1.7  =1   (N)  + 2 LINES
CLR  P1.6
CLR P1.5
CLR P1.4
CALL PULSE
CALL DELAY
 RET
; -------------------------DISPLAY ON/OFF  CONTROL-------------
; THE DISPLAY IS TURNED ON,THE CURSOR IS  TURNED ON
DISPCON:   CLR  P1.7   
CLR P1.6   ; I
CLR  P1.5   ;  I
CLR P1.4     ;  I  HIGH NIBBLE SET  (0H-HEX)
CALL PULSE
SETB P1.7   ; I
SETB P1.6  ; I SET ENTIRE DISPLAY ON 
SETB P1.5  ; I CURSOR ON
SETB P1.4  ;  CURSOR BLINKING ON
CALL PULSE
CALL DELAY     ; WAIT  FOR BF TO CLEAR
RET
; .ENTRY MODE SET  ( 4-BIT) MODE..
; SET TO INCREMENT THE ADDRESS BY ONE AND CURSOR SHIFTED TO THE RIGHT
ENTRYMODE:  CLR P1.7    
CLR P1.6    ;  I P1.6 =0
CLR P1.5      ;  I P1.5  =0
CLR  P1.4   ;  I  P1.4 =0
CALL PULSE
CLR P1.7  ; I P1.7  =O
 SETB  P1.6  ;   I P1.6  =L
SETB P1.5  ; I P1.5 =L
CLR P1.4    ;  I P1.4  =0
CALL PULSE
CALL DELAY  ; WAIT FOR  BF TO CLEAR
RET
;PULSE
PULSE : SETB  E  ;I  *P1.2 IS CONNECT TO E PIN OF LCD MODULE *
CLR E  ; I NEGATIVE EDGE ON E
RET
;..SENDCHAR--------------------------------------
SENDCHAR:
MOV C,ACC.7
MOV P1.7,C
MOV C,ACC.6
MOV P1.6,C
MOV C,ACC.5
MOV P1.5,C
MOV C,ACC.4
CALL PULSE
MOV C,ACC.3
MOV P1.7 , C
MOV C,ACC.1
MOV P1.5,C
MOV C,ACC.0
MOV P1.4,C
CALL PULSE
CALL DELAY
RET
; DELAY.
DELAY: MOV R0,#50H
DJNZ R0,$
RET
;LOOK-UP TABLE (LUT)
ORG 0200H
LUT: DB 'D','e','l','l'
STOP: JMP $
END
