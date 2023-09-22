.MODEL	SMALL
.STACK	64
.DATA

FOODMENU     DB      "foodmenu.txt", 0	      ;FILENAME
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
  
;PRINT MENU
PRTFMENU:
    MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
    MOV     AL, 0                               ;READ-ONLY MODE
    LEA     DX, FOODMENU                        ;LOAD THE FILENAME INTO DX
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
    MOV     AH, 09H             ; DOS FUNCTION TO DISPLAY STRING
    LEA     DX, CHOICEMSG
    INT     21H

    MOV     AH, 01H             ; Read a character from input
    INT     21H

    MOV     CHOICE, AL          ; Move user input from AL to CHOICE

    CMP     CHOICE, '1'         ; Check if user input is '1'
    JNE     CHECK_2             ; If not '1', check if it's '2'
    JMP     SET1                ; Jump to SET1

CHECK_2:
    CMP     CHOICE, '2'         ; Check if user input is '2'
    JNE     CHECK_3             ; If not '2', check if it's '3'
    JMP     SET2                ; Jump to SET2

CHECK_3:
    CMP     CHOICE, '3'         ; Check if user input is '3'
    JNE     INVALID_CHOICE      ; If not '3', it's an invalid choice
    JMP     SET3                ; Jump to SET3

INVALID_CHOICE:
    MOV     AH, 09H             ; IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     PRTFMENU         ; Jump to PRTFOODMENU
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
    MOV     AH, 09H             ; DOS FUNCTION TO DISPLAY STRING
    LEA     DX, RETURNMSG
    INT     21H

    MOV     AH, 01H             ; Read a character from input
    INT     21H

    MOV     CHOICE, AL          ; Move user input from AL to CHOICE

    CMP     CHOICE, '#'         ; Check if user input is '#'
    JNE     INVALID_IN1		; Check if its invalid
    JMP     PRTFMENU         ; Jump to PRTFOODMENU to return to the food menu

INVALID_IN1:
    MOV     AH, 09H             ; IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     SET1 

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
    	MOV	    AH, 09H                     ;DOS FUNCTION TO DISPLAY STRING
	LEA	    DX, RETURNMSG
	INT	    21H

    	MOV	    AH, 01H
	INT	    21H			         ;GET USER CHAR

	MOV     CHOICE, AL                       ;MOVE USER INPUT FROM AL TO STORE IN CHOICE

 	CMP     CHOICE, '#'         ; Check if user input is '#'
   	JNE     INVALID_IN2		; Check if its invalid
    	JMP     PRTFMENU         ; Jump to PRTFOODMENU to return to the food menu

INVALID_IN2:
    MOV     AH, 09H             ; IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     SET2                         ;JUMP TO PRINT SET B

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
    	MOV	    AH, 09H                     ;DOS FUNCTION TO DISPLAY STRING
	LEA	    DX, RETURNMSG
	INT	    21H

    	MOV	    AH, 01H
	INT	    21H			         ;GET USER CHAR

	MOV     CHOICE, AL                       ;MOVE USER INPUT FROM AL TO STORE IN CHOICE

	CMP     CHOICE, '#'         ; Check if user input is '#'
    	JNE     INVALID_IN3		; Check if its invalid
    	JMP     PRTFMENU         ; Jump to PRTFOODMENU to return to the food menu

INVALID_IN3:
    MOV     AH, 09H             ; IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     SET3 

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