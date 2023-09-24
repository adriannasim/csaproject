.MODEL	SMALL
.STACK	64
.DATA

EVENTMENU     DB     "eventres.txt", 0	      ;FILENAME
EMBUFFER     DB      900 DUP(?)               ;BUFFER TO STORE FILE CONTENT

EVENTFM    DB      "evntmenu.txt", 0	      ;FILENAME
EFBUFFER     DB      900 DUP(?)               ;BUFFER TO STORE FILE CONTENT

WEDDINGFM  DB      "wedfmenu.txt", 0	      ;FILENAME
WFBUFFER     DB      900 DUP(?)               ;BUFFER TO STORE FILE CONTENT

FILE_HANDLE  DW      ?                        ;FILE HANDLE
BYTESREAD    DW      0

CR          EQU     0DH                       ;CARRIAGE RETURN SHORT FORM
LF          EQU     0AH                       ;LINE FEED SHORT FORM

;USER CHOICE SELECTION 
CHOICEMSG   DB      "INPUT YOUR CHOICE > $"
INVALIDMSG  DB      "INVALID CHOICE. PLEASE ENTER AGAIN", LF, CR, "$"
RETURNMSG   DB      "ENTER '#' TO RETURN TO EVENT RESERVATIONS > $"
CHOICE      DB      ?
;-----------------------------------------------------------------------------------
.CODE

	MAIN	PROC	FAR                           ;MAIN PROCEDURE START
	
	MOV     AX, @DATA
	MOV     DS, AX
  
;PRINT EVENT RESERVATION
EVENTRES: 
	  CALL NEWLINE     
	  MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
    	  MOV     AL, 0                               ;READ-ONLY MODE
    	  LEA     DX, EVENTMENU                        ;LOAD THE FILENAME INTO DX
   	  INT     21H

; read_file
    	  MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
    	  MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
     	  MOV     BX, FILE_HANDLE                     ;FILE HANDLE
   	  MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
    	  LEA     DX, EMBUFFER                        ;BUFFER TO STORE THE CONTENT
    	  INT     21H

; display_menu
    	  MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
    	  LEA     DX, EMBUFFER                        ;LOAD THE BUFFER ADDRESS
    	  INT     21H

; close_file
    	  MOV     AH, 3EH                             
    	  MOV     BX, FILE_HANDLE                     
    	  INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE

CALL	NEWLINE

;GET USER CHOICE INPUT
ERLOOP:				; EVENT RESERVATION INPUT LOOP
    MOV     AH, 09H             ; DOS FUNCTION TO DISPLAY STRING
    LEA     DX, CHOICEMSG
    INT     21H

    MOV     AH, 01H             ; READ CHARACTER FROM INPUT
    INT     21H

    MOV     CHOICE, AL          ; MOVE INPUT FROM AL TO CHOICE

    CMP     CHOICE, '1'         ; CHECK IF INPUT = '1'
    JNE     CHECK2              ; IF NOT '1', CHECK IF ITS '2'
    JMP     PRTEVTMENU          ; JUMP TO PRINT EVENT FOOD MENU

CHECK2:
    CMP     CHOICE, '2'         ; CHECK IF INPUT = '2'
    JNE     CHECK3              ; IF NOT '2', CHECK IF ITS '3'
    JMP     PRTWEDMENU          ; JUMP TO PRINT WEDDING MENU

CHECK3:
    CMP     CHOICE, '3'         ; CHECK IF INPUT = '3'
    JNE     INVALIDCHOICE	; IF NOT '3', CHECK IF ITS INVALID
    JMP     MAKERES	        ; JUMP BACK TO MAKE RESERVATIONS 

INVALIDCHOICE:
    CALL    NEWLINE
    MOV     AH, 09H             ; IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     ERLOOP         	; JUMP TO VERIFY INPUT

;=====================================EVENT MENU=====================================
;PRINT EVENT MENU
PRTEVTMENU: 
	  CALL NEWLINE     
	  MOV     AH, 3DH                       ;DOS FUNCTION TO OPEN A FILE
    	  MOV     AL, 0                         ;READ-ONLY MODE
    	  LEA     DX, EVENTFM                 ;LOAD THE FILENAME INTO DX
   	  INT     21H

; read_file
    	  MOV     FILE_HANDLE, AX               ;STORE THE FILE HANDLE
    	  MOV     AH, 3FH                       ;DOS FUNCTION TO READ FROM A FILE
     	  MOV     BX, FILE_HANDLE               ;FILE HANDLE
   	  MOV     CX, 900                       ;NUMBER OF BYTES TO READ AT A TIME
    	  LEA     DX, EFBUFFER                  ;BUFFER TO STORE THE CONTENT
    	  INT     21H

; display_menu
    	  MOV     AH, 09H                       ;DOS FUNCTION TO DISPLAY A STRING
    	  LEA     DX, EFBUFFER                  ;LOAD THE BUFFER ADDRESS
    	  INT     21H

; close_file
    	  MOV     AH, 3EH                             
    	  MOV     BX, FILE_HANDLE                     
    	  INT     21H                           ;DOS FUNCTION TO CLOSE A FILE

CALL	NEWLINE

;GET USER CHOICE INPUT
EMLOOP:						;EVENT MENU INPUT LOOP
    	MOV	    AH, 09H                     ;DOS FUNCTION TO DISPLAY STRING
	LEA	    DX, RETURNMSG
	INT	    21H

    	MOV	    AH, 01H
	INT	    21H			        ;GET USER CHAR

	MOV     CHOICE, AL                      ;MOVE USER INPUT FROM AL TO STORE IN CHOICE

	CMP     CHOICE, '#'         		; CHECK IF INPUT = '#'
    	JNE     INVALID_IN4			; CHECK IF ITS INVALID
    	JMP     EVENTRES         		; JUMP TO EVENT RESERVATION

INVALID_IN4:
    CALL    NEWLINE
    MOV     AH, 09H             		; IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     EMLOOP 				; JUMP TO VERIFY INPUT

PRTWEDMENU: 
	  CALL NEWLINE     
	  MOV     AH, 3DH                       ;DOS FUNCTION TO OPEN A FILE
    	  MOV     AL, 0                         ;READ-ONLY MODE
    	  LEA     DX, WEDDINGFM               ;LOAD THE FILENAME INTO DX
   	  INT     21H

; read_file
    	  MOV     FILE_HANDLE, AX               ;STORE THE FILE HANDLE
    	  MOV     AH, 3FH                       ;DOS FUNCTION TO READ FROM A FILE
     	  MOV     BX, FILE_HANDLE               ;FILE HANDLE
   	  MOV     CX, 900                       ;NUMBER OF BYTES TO READ AT A TIME
    	  LEA     DX, WFBUFFER                  ;BUFFER TO STORE THE CONTENT
    	  INT     21H

; display_menu
    	  MOV     AH, 09H                       ;DOS FUNCTION TO DISPLAY A STRING
    	  LEA     DX, WFBUFFER                  ;LOAD THE BUFFER ADDRESS
    	  INT     21H

; close_file
    	  MOV     AH, 3EH                             
    	  MOV     BX, FILE_HANDLE                     
    	  INT     21H                           ;DOS FUNCTION TO CLOSE A FILE

CALL	NEWLINE

;GET USER CHOICE INPUT
WMLOOP:						;WEDDING MENU INPUT LOOP				
    	MOV	    AH, 09H                     ;DOS FUNCTION TO DISPLAY STRING
	LEA	    DX, RETURNMSG
	INT	    21H

    	MOV	    AH, 01H
	INT	    21H			        ;GET USER CHAR

	MOV     CHOICE, AL                      ;MOVE USER INPUT FROM AL TO STORE IN CHOICE

	CMP     CHOICE, '#'         		; CHECK IF INPUT = '#'
    	JNE     INVALID_IN5			; CHECK IF ITS INVALID
    	JMP     EVENTRES         		; JUMP TO EVENT RESERVATION
	
INVALID_IN5:
    CALL    NEWLINE
    MOV     AH, 09H             		; IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     WMLOOP 				; JUMP TO VERIFY INPUT
;==========================================================================================
;NEW LINE
    NEWLINE     PROC
            MOV     AH, 02H
            MOV     DL, LF
            INT     21H
            MOV     DL, CR
            INT     21H
            RET  
    NEWLINE     ENDP 

EXIT:   MOV     AX, 4C00H
        INT     21H

        MAIN    ENDP
	END MAIN