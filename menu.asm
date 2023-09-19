TITLE   ASSIGNMENT  TEST MENU

.MODEL  SMALL
.STACK  64
.DATA

;START OF VARIABLES DECLARATION
;READ FILE VARIABLES
;MAINMENU
MAINMENU    DB      "TEST.txt", 0   ;FILENAME
MMBUFFER    DB      1000 DUP(?)          ;BUFFER TO STORE FILE CONTENT
FILE_HANDLE DW      ?                    ;FILE HANDLE

;NEW LINE VARIABLES
CR          EQU     0DH                 ;CARRIAGE RETURN SHORT FORM
LF          EQU     0AH                 ;LINE FEED SHORT FORM
;END OF VARIABLES DECLARATION
;-------------------------------------------------------------------------
;START OF HEADER
.CODE                                   ;DEFINE CODE SEGMENT

    MAIN    PROC FAR                    ;MAIN PROCEDURE START

    MOV     AX, @DATA
    MOV     DS, AX                      ;SET ADDRESS OF DATA SEGMENT IN DS
;END OF HEADER

;START OF MAIN MENU
    ;START OF MAIN MENU
    ;OPEN FILE
    MOV     AH ,3DH				        ;OPEN FILE COMMAND
    LEA     DX, MAINMENU
    MOV     AL, 0
    INT     21H
    MOV     FILE_HANDLE, AX

    ;READ FILE
    MOV     AH, 3FH
    MOV     BX, FILE_HANDLE
    LEA     DX, MMBUFFER       
    MOV     CX, 1000		            ;NUMBER OF BYTES TO READ FROM THE FILE
    INT     21H

    ;DISPLAY FILE
    MOV     AH, 09H
    LEA     DX, MMBUFFER
    INT     21H

    ;CLOSE FILE
    MOV     AH, 3EH
    MOV     BX, FILE_HANDLE	            ;FILE HANDLE 
    INT     21H
    ;END OF MAIN MENU

;END OF MAIN MENU

;START OF FOOTER
    MOV     AX, 4C00H
    INT     21H

    MAIN    ENDP

END MAIN
;END OF FOOTER