.MODEL	SMALL
.STACK	64
.DATA

FMENU     DB      "foodmenu.txt", 0	      ;FILENAME
FMBUFFER     DB      900 DUP(?)               ;BUFFER TO STORE FILE CONTENT

SETMENU1     DB      "seta.txt", 0            ;FILENAME
SABUFFER     DB      900 DUP(?)               ;BUFFER TO STORE FILE CONTENT

SETMENU2     DB      "setb.txt", 0            ;FILENAME
SBBUFFER     DB      900 DUP(?)               ;BUFFER TO STORE FILE CONTENT

SETMENU3     DB      "setc.txt", 0            ;FILENAME
SCBUFFER     DB      900 DUP(?)               ;BUFFER TO STORE FILE CONTENT

FILE_HANDLE  DW      ?                        ;FILE HANDLE
BYTESREAD    DW      0

;=================================NEW LINE VARIABLES==================================
CR          EQU     0DH                     ;CARRIAGE RETURN SHORT FORM
LF          EQU     0AH                     ;LINE FEED SHORT FORM

;===========================PRINTING VARIABLES==================================
;FOR USER INPUT
;USER CHOICE SELECTION
CHOICEMSG   DB      "INPUT YOUR CHOICE > $"
INVALIDMSG  DB      "INVALID CHOICE. PLEASE ENTER AGAIN", LF, CR, "$"
RETURNMSG   DB      "ENTER '#' TO RETURN TO FOOD MENU > $"

;===============================CHAR INPUT====================================
CHOICE      DB      ?

;-----------------------------------------------------------------------------------
.CODE

	MAIN	PROC	FAR                        ;MAIN PROCEDURE START
	
	MOV     AX, @DATA
	MOV     DS, AX
  
;PRINT FOOD MENU
FOODMENU:
    CALL NEWLINE
    MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
    MOV     AL, 0                               ;READ-ONLY MODE
    LEA     DX, FMENU                           ;LOAD THE FILENAME INTO DX
    INT     21H

; read_file
    MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
    MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
    MOV     BX, FILE_HANDLE                     ;FILE HANDLE
    MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
    LEA     DX, FMBUFFER                        ;BUFFER TO STORE THE CONTENT
    INT     21H

; display_menu
    MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
    LEA     DX, FMBUFFER                        ;LOAD THE BUFFER ADDRESS
    INT     21H

; close_file
    MOV     AH, 3EH                             
    MOV     BX, FILE_HANDLE                     
    INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE
    
    CALL NEWLINE

;GET USER CHOICE INPUT
FMLOOP:
    MOV     AH, 09H             ; DOS FUNCTION TO DISPLAY STRING
    LEA     DX, CHOICEMSG
    INT     21H

    MOV     AH, 01H             ; READ CHARACTER FROM INPUT
    INT     21H

    MOV     CHOICE, AL          ; MOVE USER INPUT FROM AL TO CHOICE

    CMP     CHOICE, '1'         ; CHECK USER INPUT = '1'
    JNE     CHECK_2             ; IF NOT '1', CHECK IF IT'S '2'
    JMP     SET1                ; Jump to SET1

CHECK_2:
    CMP     CHOICE, '2'         ; CHECK USER INPUT = '2'
    JNE     CHECK_3             ; IF NOT '2', CHECK IF IT'S '3'
    JMP     SET2                ; Jump to SET2

CHECK_3:
    CMP     CHOICE, '3'         ; CHECK USER INPUT = '3'
    JNE     CHECK_4     	; IF NOT '3', CHECK IF IT'S '4'
    JMP     SET3                ; JUMP TO SET3

CHECK_4:
    CMP	    CHOICE, '4'		; CHECK USER INPUT = '4'
    JNE     INVALID_CHOICE	; IF NOT '4', INVALID CHOICE
    JMP     PRTMAINPAGE

INVALID_CHOICE:
    CALL    NEWLINE
    MOV     AH, 09H             ; IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     FMLOOP         	; JUMP TO VALIDATE INPUT
;===============================START OF DISPLAY SET MENUS============================
;PRINT SET A
SET1:    CALL NEWLINE     
	  MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
    	  MOV     AL, 0                               ;READ-ONLY MODE
    	  LEA     DX, SETMENU1                        ;LOAD THE FILENAME INTO DX
   	  INT     21H

; read_file
    	  MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
    	  MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
     	  MOV     BX, FILE_HANDLE                     ;FILE HANDLE
   	  MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
    	  LEA     DX, SABUFFER                        ;BUFFER TO STORE THE CONTENT
    	  INT     21H

; display_menu
    	  MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
    	  LEA     DX, SABUFFER                        ;LOAD THE BUFFER ADDRESS
    	  INT     21H

; close_file
    	  MOV     AH, 3EH                             
    	  MOV     BX, FILE_HANDLE                     
    	  INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE
    
    CALL NEWLINE

;GET USER CHOICE INPUT
S1LOOP:
    MOV     AH, 09H             ; DOS FUNCTION TO DISPLAY STRING
    LEA     DX, RETURNMSG
    INT     21H

    MOV     AH, 01H             ; READ CHARACTER FROM INPUT
    INT     21H

    MOV     CHOICE, AL          ; MOVE USER INPUT FROM AL TO CHOICE

    CMP     CHOICE, '#'         ; CHECK INPUT = '#'
    JNE     INVALID_IN1		; CHECK WHETHER INVALID
    JMP     FOODMENU            ; JUMP TO FOODMENU 

INVALID_IN1:
    CALL    NEWLINE
    MOV     AH, 09H             ; IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     S1LOOP		; JUMP TO VALIDATE INPUT 

;PRINT SET B
SET2:    CALL NEWLINE
	 MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
    	 MOV     AL, 0                               ;READ-ONLY MODE
   	 LEA     DX, SETMENU2                        ;LOAD THE FILENAME INTO DX
    	 INT     21H

; read_file
   	 MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
  	 MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
   	 MOV     BX, FILE_HANDLE                     ;FILE HANDLE
    	 MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
    	 LEA     DX, SBBUFFER                        ;BUFFER TO STORE THE CONTENT
    	 INT     21H

; display_menu
    	 MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
    	 LEA     DX, SBBUFFER                        ;LOAD THE BUFFER ADDRESS
    	 INT     21H

; close_file
    	 MOV     AH, 3EH                             
    	 MOV     BX, FILE_HANDLE                     
    	 INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE
    
    CALL NEWLINE

;GET USER CHOICE INPUT
S2LOOP:
    	MOV	    AH, 09H                     ;DOS FUNCTION TO DISPLAY STRING
	LEA	    DX, RETURNMSG
	INT	    21H

    	MOV     AH, 01H             ; READ CHARACTER FROM INPUT
   	INT     21H

    	MOV     CHOICE, AL          ; MOVE USER INPUT FROM AL TO CHOICE

    	CMP     CHOICE, '#'         ; CHECK INPUT = '#'
    	JNE     INVALID_IN2         ; CHECK WHETHER INVALID
    	JMP     FOODMENU            ; JUMP TO FOODMENU 

INVALID_IN2:
    CALL    NEWLINE
    MOV     AH, 09H                 ; IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     S2LOOP                  ; JUMP TO VERIFY INPUT

;PRINT SET C
SET3:    CALL NEWLINE
	 MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
    	 MOV     AL, 0                               ;READ-ONLY MODE
   	 LEA     DX, SETMENU3                        ;LOAD THE FILENAME INTO DX
   	 INT     21H

; read_file
   	  MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
   	  MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
   	  MOV     BX, FILE_HANDLE                     ;FILE HANDLE
    	  MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
   	  LEA     DX, SCBUFFER                        ;BUFFER TO STORE THE CONTENT
    	  INT     21H

; display_menu
    	  MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
   	  LEA     DX, SCBUFFER                        ;LOAD THE BUFFER ADDRESS
    	  INT     21H

; close_file
    	  MOV     AH, 3EH                             
    	  MOV     BX, FILE_HANDLE                     
    	  INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE
    
    CALL NEWLINE

;GET USER CHOICE INPUT
S3LOOP: 
    	MOV	    AH, 09H                     ;DOS FUNCTION TO DISPLAY STRING
	LEA	    DX, RETURNMSG
	INT	    21H

    	MOV     AH, 01H             ; READ CHARACTER FROM INPUT
    	INT     21H

    	MOV     CHOICE, AL          ; MOVE USER INPUT FROM AL TO CHOICE

    	CMP     CHOICE, '#'         ; CHECK INPUT = '#'
    	JNE     INVALID_IN3	    ; CHECK WHETHER INVALID
    	JMP     FOODMENU            ; JUMP TO FOODMENU 

INVALID_IN3:
    CALL    NEWLINE
    MOV     AH, 09H                 ; IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     S3LOOP		    ; JUMP TO VERIFY INPUT 

;===================================START OF FUNCTIONS=================================
;NEW LINE
    NEWLINE     PROC
            MOV     AH, 02H
            MOV     DL, LF
            INT     21H
            MOV     DL, CR
            INT     21H
            RET  
    NEWLINE     ENDP 
;=================================END PROGRAM=====================================
EXIT:   MOV     AX, 4C00H
        INT     21H

        MAIN    ENDP
	END MAIN