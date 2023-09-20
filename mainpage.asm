;TITLE
TITLE   ASSIGNMENT  MAINPROGRAM

.MODEL  SMALL
.STACK  64
.DATA

;-------------------------------------------------------------------------------------
;START OF VARIABLES DECLARATION
;=================================READ FILE VARIABLES=================================
;MAINPAGE
MAINPAGE    DB      "mainpage.txt", 0       ;FILENAME
MPBUFFER    DB      900 DUP(?)              ;BUFFER TO STORE FILE CONTENT
FILE_HANDLE DW      ?                       ;FILE HANDLE
BYTESREAD   DW      0

;=================================NEW LINE VARIABLES==================================
CR          EQU     0DH                     ;CARRIAGE RETURN SHORT FORM
LF          EQU     0AH                     ;LINE FEED SHORT FORM

;=================================PRINTING VARIABLES==================================
ERRFILE     DB      "FILE ERROR$"
GOODLOGIN   DB      "LOGIN SUCCESSFUL", LF, CR, "$"
BADLOGIN    DB      "WRONG USERNAME/PASSWORD. PLEASE TRY AGAIN.", LF, CR, "$"
MSGUSER     DB      "USERNAME > $"
MSGPSW      DB      "PASSWORD > $"

;===================================STRING INPUT======================================
;USERNAME
INUSER      LABEL   BYTE
MAXUSER     DB      20
ACTUALUSER  DB      ?
SPACEUSER   DB      20 DUP(' ')

;PASSWORD
INPSW       LABEL   BYTE
MAXPSW      DB      20
ACTUALPSW   DB      ?
SPACEPSW    DB      20 DUP(' ')

;END OF VARIABLES DECLARATION
;-------------------------------------------------------------------------------------
;==================================START OF HEADER====================================
.CODE                                       ;DEFINE CODE SEGMENT

    MAIN    PROC FAR                        ;MAIN PROCEDURE START

    MOV     AX, @DATA
    MOV     DS, AX                          ;SET ADDRESS OF DATA SEGMENT IN DS
;====================================END OF HEADER====================================

;=================================START OF MAIN PAGE===================================
    MAINPAGE:   MOV     AH, 09H                 ;DOS FUNCTION TO DISPLAY STRING
                LEA     DX, GOODLOGIN
                INT     21H

    ;WAIT AROUND 2 SECONDS TO SIMULATE LOADING  
    LOADING:        MOV     CX, 5000                ;LOADING DURATION
    LOADINGLOOP:    DEC     CX
                    JNZ     LOADINGLOOP             ;JUMP IF CX IS STILL NOT ZERO

    ;CLEAR SCREEN
    CLEARSCR:       MOV     AH, 06H
                    MOV     AL, 0
                    MOV     BH, 07H
                    MOV     CX, 0
                    MOV     DX, 0
                    MOV     CH, 24
                    MOV     CL, 79
                    INT     10H

    ;PRINT MENU
    ;OPEN THE FILE
    ; MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
    ; MOV     AL, 0                               ;READ-ONLY MODE
    ; LEA     DX, MAINPAGE                        ;LOAD THE FILENAME INTO DX
    ; INT     21H

    ; JC      FILE_ERROR                          ;JUMP IF ERROR

    ; ;READ THE FILE CONTENT
    ; MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
    ; MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
    ; MOV     BX, FILE_HANDLE                     ;FILE HANDLE
    ; MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
    ; LEA     DX, MPBUFFER                        ;BUFFER TO STORE THE CONTENT
    ; INT     21H

    ; JC      FILE_ERROR                          ;JUMP IF ERROR

    ; ;DISPLAY THE FILE CONTENT
    ; MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
    ; LEA     DX, MPBUFFER                        ;LOAD THE BUFFER ADDRESS
    ; INT     21H

    ; ;CLOSE THE FILE
    ; MOV     AH, 3EH                             
    ; MOV     BX, FILE_HANDLE                     
    ; INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE
    ; JMP     EXIT

    ; ;ERROR HANDLER
    ; FILE_ERROR:     MOV     AH, 09H
    ;                 LEA     DX, ERRFILE
    ;                 INT     21H
    ;                 JMP     EXIT

;==================================END OF MAIN PAGE====================================

;===================================START OF FOOTER====================================
    EXIT:   MOV     AX, 4C00H
            INT     21H

            MAIN    ENDP

END MAIN
;====================================END OF FOOTER=====================================