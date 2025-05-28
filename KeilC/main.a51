ORG 0000H
	LJMP START        
ORG 0030H

col1		bit P2.0
col2		bit P2.1
col3		bit P2.2
col4		bit P2.3
row1		bit P2.4
row2		bit P2.5
row3		bit P2.6
row4		bit P2.7
so1		equ		32h
so2		equ 	34h
index	equ		36h
dau		equ		38h
sonhap	equ		3Ah
COL		equ		3Ch

RS      EQU P1.0
RW      EQU P1.1
EN      EQU P1.2
PORT    EQU P3        ; D4–D7 noi vào P3.4–P3.7

START:
mov so1, #0
mov so2, #0
mov dau, #0
mov index,#0
ACALL LCD_INIT      
    
SJMP MAIN           
	
MAIN:

CLR row1							; keo cac hang xuong muc thap
CLR row2							; ==> phat hien su kien nhan phim
CLR row3
CLR row4
JNB col1, quetphim					; kiem tra xem cot nao duoc nhan
JNB col2, quetphim
JNB col3, quetphim
JNB col4, quetphim

SJMP MAIN						; neu khong co phim nao duoc nhan thi tiep tuc kiem tra


quetphim:
acall DELAYLCD
acall keypad
acall decode
acall savenum
mov A,sonhap
add A,#48
PUSH ACC
acall LCD_DATA
POP ACC
acall tinhtoan
acall delay
sjmp main


keypad:

clr row1
setb row2
setb row3
setb row4
acall check_col
mov A,COL
jz to_row2
DEC A

mov sonhap,A

sjmp ok

to_row2:
clr row2
setb row1
setb row3
setb row4
acall check_col
mov A,COL
jz to_row3
add A,#3
mov sonhap,A
sjmp ok

to_row3:
clr row3
setb row1
setb row2
setb row4
acall check_col
mov A,COL
jz to_row4
add A,#7
mov sonhap,A
sjmp ok

to_row4:
clr row4
setb row1
setb row2
setb row3
acall check_col
mov A,COL
jz ok
add A,#11
mov sonhap,A
ok: ret


check_col:
jb col1,check_col2
mov	COL,#1			  				; co phim o Cot 1 duoc nhan
sjmp	finish
check_col2:
jb col2,check_col3
mov	COL,#2							;Cot 2
sjmp	finish
check_col3:
jb col3,check_col4
mov	COL,#3							; Cot 3
sjmp	finish
check_col4:
jb col4,no_col
mov	COL,#4							;Cot 4
sjmp	finish
no_col:
mov	COL,#0							;khong tim thay phim nao duoc nhan cua 1 Hang
finish:
ret

decode:								;giai ma thu tu so thanh cac so
mov R3,sonhap
cjne R3,#0,c1
mov sonhap,#7
sjmp done
c1:
cjne R3,#1,c2	
mov sonhap,#8
sjmp done
c2:
cjne R3,#2,c3
mov sonhap,#9
sjmp done
c3:
cjne R3,#3,c7
mov sonhap,#255
sjmp done
;c4:
;cjne R3,#3,c5
;mov sonhap,#4
;sjmp done
;c5:
;cjne R3,#3,c6
;mov sonhap,#5
;sjmp done
;c6:
;cjne R3,#3,c7
;mov sonhap,#6
;sjmp done
c7:
cjne R3,#7,c8
mov sonhap,#250
c8:
cjne R3,#8,c9
mov sonhap,#1
c9:
cjne R3,#9,c10
mov sonhap,#2
c10:
cjne R3,#10,c11
mov sonhap,#3
c11:
cjne R3,#11,c13
mov sonhap,#253
c13:
cjne R3,#13,c14
mov sonhap,#0
c14:
cjne R3,#14,c15
mov sonhap,#13
c15:
cjne R3,#15,done
mov sonhap,#251
done: ret

savenum:	
mov R4,index							;luu thu tu so va phep tinh 
cjne R4,#0,cal							;luu so thu nhat
mov so1,sonhap
inc index
jmp fin
cal:
cjne R4,#1,num2
mov dau,sonhap
inc index
jmp fin
num2:
cjne R4,#2,fin
mov so2,sonhap
inc index 
fin: ret

TINHTOAN:							;TINH TOAN VA XUAT KET QUA RA MAN HINH
CJNE A,#61,DONE1
MOV A,DAU
CJNE A,#251,TRU
MOV A,SO1
ADD A,SO2
MOV R5,A
ADD A,#246
JC TWODIGIT
MOV A,R5
ADD A,#48
ACALL LCD_DATA
JMP DONE1		
TRU:
CJNE A,#253,NHAN
MOV A,SO1
SUBB A,SO2
MOV R5,A
ADD A,#246
JC TWODIGIT
MOV A,R5
ADD A,#48
ACALL LCD_DATA
JMP DONE1
NHAN:
CJNE A,#250,CHIA
MOV A,SO1
MOV B,SO2
MUL AB
MOV R5,A
ADD A,#246
JC TWODIGIT
MOV A,R5
ADD A,#48
ACALL LCD_DATA
JMP DONE1
CHIA:
CJNE A,#255,DONE1
MOV A,SO1
MOV B,SO2
DIV AB
MOV R5,A
ADD A,#246
JC TWODIGIT
MOV A,R5
ADD A,#48
ACALL LCD_DATA	
DONE1: RET

TWODIGIT:
MOV A, R5
MOV B, #10      
DIV AB          ; A = A / 10 (thuong), B = A % 10 (sO du)
ADD A, #48      
ACALL LCD_DATA
MOV A, B       
ADD A, #48     
ACALL LCD_DATA
SJMP DONE1

;-----------------------
LCD_INIT:
MOV A,#00H
ACALL LCD_CMD_4
MOV A,#03H
ACALL LCD_CMD_4
MOV A,#02H         ; Kh?i t?o ch? d? 4-bit
ACALL LCD_CMD_4
MOV A,#28H         ; 4-bit, 2 dòng, font 5x7
ACALL LCD_CMD
MOV A,#0CH         ; Hien thi ON, tat con tro
ACALL LCD_CMD
MOV A,#06H         ; T? d?ng tang, không d?ch màn hình
ACALL LCD_CMD
MOV A,#01H         ; Xóa màn hình
ACALL LCD_CMD
RET

;-----------------------
LCD_CMD:
CLR RS
CLR RW
ACALL SEND_4BIT
ACALL SHORT_DELAY
RET

LCD_DATA:
SETB RS
CLR RW
ACALL SEND_4BIT
ACALL SHORT_DELAY
RET

SEND_4BIT:
    MOV R0, A         ; ? Luu ban goc A (8-bit can gui)

    ; G?i nibble cao
    ANL A, #0F0H
    MOV R1, A
    MOV A, PORT
    ANL A, #0FH
    ORL A, R1
    MOV PORT, A
    SETB EN
    ACALL DELAYLCD
    CLR EN
    ACALL DELAYLCD

    ; G?i nibble th?p
    MOV A, R0         ; ? Lay lai ban goc
    SWAP A
    ANL A, #0F0H
    MOV R1, A
    MOV A, PORT
    ANL A, #0FH
    ORL A, R1
    MOV PORT, A
    SETB EN
    ACALL DELAYLCD
    CLR EN
    ACALL DELAYLCD
    RET

LCD_CMD_4:
    ; Dùng de khoi tao 4-bit (chi gui nibble cao)
	clr RS
	clr RW
	SWAP A
    ANL A, #0F0H
    MOV R1, A
    MOV A, PORT
    ANL A, #0FH
    ORL A, R1
    MOV PORT, A
    SETB EN
    ACALL DELAYLCD
    CLR EN
    ACALL DELAYLCD
    RET

;-----------------------
DELAYLCD: 						; delay 102ms
    MOV R2,#200
D1: MOV R1,#255
D2: DJNZ R1,D2
    DJNZ R2,D1
    RET
SHORT_DELAY:  						; delay ngan cho xung En LCD
    MOV R7, #10   
SD_LOOP:
    DJNZ R7, SD_LOOP
    RET
;-----------------------

delay:                                            	;CHUONG TRINH CON DELAY 500MS
MOV TMOD,#10H
MOV R7,#10
LOOP:
MOV TH1,#HIGH(-50000)
MOV TL1,#LOW(-50000)
SETB TR1
JNB TF1,$
CLR TR1
CLR TF1
DJNZ R7,LOOP
RET
     
END
