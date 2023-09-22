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
CHOICEMSG   DB      "INPUT YOUR CHOICE > $"
INVALIDMSG  DB      "INVALID CHOICE. PLEASE ENTER AGAIN", LF, CR, "$"
;======================================CHAR INPUT=====================================
CHOICE      DB      ?
;===================================STRING INPUT======================================

;END OF VARIABLES DECLARATION
;-------------------------------------------------------------------------------------
;==================================START OF HEADER====================================
.CODE                                       ;DEFINE CODE SEGMENT

    MAIN    PROC FAR                        ;MAIN PROCEDURE START

    MOV     AX, @DATA
    MOV     DS, AX                          ;SET ADDRESS OF DATA SEGMENT IN DS
;====================================END OF HEADER====================================

;=================================START OF MAIN PAGE===================================
    ;SHOW LOGIN SUCCESSFUL MSG
    LOGGEDIN:   MOV     AH, 09H                     ;DOS FUNCTION TO DISPLAY STRING
                LEA     DX, GOODLOGIN
                INT     21H

    ;LOAD AND CLEAR SCREEN
    CALL     LOADING
    CALL     CLEARSCR
    ;PRINT MAINPAGE
    ;OPEN THE FILE
    PRTMAINPAGE:    ; MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
                    ; MOV     AL, 0                               ;READ-ONLY MODE
                    ; LEA     DX, MAINPAGE                        ;LOAD THE FILENAME INTO DX
                    ; INT     21H

                    ; ;READ THE FILE CONTENT
                    ; MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
                    ; MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
                    ; MOV     BX, FILE_HANDLE                     ;FILE HANDLE
                    ; MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
                    ; LEA     DX, MPBUFFER                        ;BUFFER TO STORE THE CONTENT
                    ; INT     21H

                    ; ;DISPLAY THE FILE CONTENT
                    ; MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
                    ; LEA     DX, MPBUFFER                        ;LOAD THE BUFFER ADDRESS
                    ; INT     21H

                    ; ;CLOSE THE FILE
                    ; MOV     AH, 3EH                             
                    ; MOV     BX, FILE_HANDLE                     
                    ; INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE
                    
    CALL     NEWLINE
    
    ;GET USER CHOICE INPUT
    MOV	    AH, 09H                             ;DOS FUNCTION TO DISPLAY STRING
	LEA	    DX, CHOICEMSG
	INT	    21H

    MOV	    AH, 01H
	INT	    21H			                        ;GET USER CHAR INPUT

    MOV     CHOICE, AL                          ;MOVE USER INPUT FROM AL TO STORE IN CHOICE

    CMP     CHOICE, '1'                         ;CHECK IF USER INPUT IS 1
    JE      RESERVATION                         ;JUMP TO RESERVATION PAGE

    CMP     CHOICE, '2'                         ;CHECK IF USER INPUT IS 2
    JE      FOODMENU                            ;JUMP TO FOODMENU

    CMP     CHOICE, '3'                         ;CHECK IF USER INPUT IS 3
    JE 	    PRTMMENU                            ;RETURN BACK TO MAIN MENU

    MOV     AH, 09H                             ;IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     PRTMAINPAGE                         ;JUMP TO PRINT MAIN PAGE
;==================================END OF MAIN PAGE====================================

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

;WAIT AROUND 2 SECONDS TO SIMULATE LOADING  
    LOADING     PROC
            MOV     CX, 5000                        ;LOADING DURATION
    LOADINGLOOP:    DEC     CX
                    JNZ     LOADINGLOOP             ;JUMP IF CX IS STILL NOT ZERO
                    RET                             ;RETURN
    LOADING     ENDP
;CLEAR SCREEN
    CLEARSCR    PROC
            MOV     AH, 06H                 ;DOS FUNCTION TO SCROLL UP 
            MOV     AL, 0                   ;CLEAR ENTIRE SCREEN
            MOV     BH, 07H                 ;DISPLAY PAGE 0
            MOV     CX, 0                   ;CLEAR CX REGISTER TO START AT LEFT COL AND TOP ROW
            MOV     DX, 184FH               ;SET SCREEN SIZE BACK TO 80X30
            
            INT     10H                     ;BIOS INTERRUPT
            RET                             ;RETURN
    CLEARSCR    ENDP
;===================================END OF FUNCTIONS===================================

;===================================START OF FOOTER====================================
    EXIT:   MOV     AX, 4C00H
            INT     21H

            MAIN    ENDP

END MAIN
;====================================END OF FOOTER=====================================