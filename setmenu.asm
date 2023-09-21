.MODEL	SMALL
.STACK	64
.DATA

SETMENU1     DB      "seta.txt", 0            ;FILENAME
SETMENU2     DB      "setb.txt", 0            ;FILENAME
SETMENU3     DB      "setc.txt", 0            ;FILENAME
MMBUFFER     DB      900 DUP(?)              ;BUFFER TO STORE FILE CONTENT
FILE_HANDLE  DW      ?                       ;FILE HANDLE
BYTESREAD    DW      0

;-----------------------------------------------------------------------------------
.CODE

	MAIN	PROC	FAR                        ;MAIN PROCEDURE START
	
	MOV     AX, @DATA
	MOV     DS, AX
  
;PRINT MENU
open_file:
    MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
    MOV     AL, 0                               ;READ-ONLY MODE
    LEA     DX, SETMENU1                       ;LOAD THE FILENAME INTO DX
    INT     21H

read_file:
    MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
    MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
    MOV     BX, FILE_HANDLE                     ;FILE HANDLE
    MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
    LEA     DX, MMBUFFER                        ;BUFFER TO STORE THE CONTENT
    INT     21H

display_menu:
    MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
    LEA     DX, MMBUFFER                        ;LOAD THE BUFFER ADDRESS
    INT     21H

close_file:
    MOV     AH, 3EH                             
    MOV     BX, FILE_HANDLE                     
    INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE

EXIT:   MOV     AX, 4C00H
        INT     21H

        MAIN    ENDP
	END MAIN