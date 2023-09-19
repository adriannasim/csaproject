TITLE   ASSIGNMENT  TESTMENU

.MODEL  SMALL
.STACK  64
.DATA

;START OF VARIABLES DECLARATION
;-------------------------------------------------------------------------------------
;=================================READ FILE VARIABLES=================================
;MAINMENU
MAINMENU    DB      "menu.txt", 0           ;FILENAME
MMBUFFER    DB      862 DUP(?)              ;BUFFER TO STORE FILE CONTENT
FILE_HANDLE DW      ?                       ;FILE HANDLE
BYTESREAD   DW      0

;=================================NEW LINE VARIABLES==================================
CR          EQU     0DH                     ;CARRIAGE RETURN SHORT FORM
LF          EQU     0AH                     ;LINE FEED SHORT FORM

;=================================PRINTING VARIABLES==================================
ERRMSG      DB      "FILE ERROR$"

;END OF VARIABLES DECLARATION
;-------------------------------------------------------------------------------------
;==================================START OF HEADER====================================
.CODE                                       ;DEFINE CODE SEGMENT

    MAIN    PROC FAR                        ;MAIN PROCEDURE START

    MOV     AX, @DATA
    MOV     DS, AX                          ;SET ADDRESS OF DATA SEGMENT IN DS
;====================================END OF HEADER====================================

;=================================START OF MAIN MENU==================================
    ;OPEN THE FILE
    MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
    MOV     AL, 0                               ;READ-ONLY MODE
    LEA     DX, MAINMENU                        ;LOAD THE FILENAME INTO DX
    INT     21H

    JC      FILE_ERROR                          ;JUMP IF ERROR

    ;READ THE FILE CONTENT
    MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
    MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
    MOV     BX, FILE_HANDLE                     ;FILE HANDLE
    MOV     CX, 862                             ;NUMBER OF BYTES TO READ AT A TIME
    LEA     DX, MMBUFFER                        ;BUFFER TO STORE THE CONTENT
    INT     21H

    JC      FILE_ERROR                          ;JUMP IF ERROR

    ;DISPLAY THE FILE CONTENT
    MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
    LEA     DX, MMBUFFER                        ;LOAD THE BUFFER ADDRESS
    INT     21H

    ;CLOSE THE FILE
    MOV     AH, 3EH                             
    MOV     BX, FILE_HANDLE                     
    INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE
    JMP     EXIT

    ;ERROR HANDLER
    FILE_ERROR:     MOV     AH, 09H
                    LEA     DX, ERRMSG
                    INT     21H
                    JMP     EXIT
;===================================END OF MAIN MENU===================================

;===================================START OF FOOTER====================================
    EXIT:   MOV     AX, 4C00H
            INT     21H

            MAIN    ENDP

END MAIN
;====================================END OF FOOTER=====================================