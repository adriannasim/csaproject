;TITLE
TITLE   ASSIGNMENT  MAINPROGRAM

.MODEL  SMALL
.STACK  64
.DATA

;-------------------------------------------------------------------------------------
;START OF VARIABLES DECLARATION
;=================================READ FILE VARIABLES=================================
;RESERVATION MENU
RESMENU     DB      "reservation.txt", 0    ;FILENAME
RESBUFFER   DB      900 DUP(?)              ;BUFFER TO STORE FILE CONTENT
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

;=================================START OF RESERVATION=================================
    ;PRINT RESERVATION MENU
    RESERVATION:    ; MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
                    ; MOV     AL, 0                               ;READ-ONLY MODE
                    ; LEA     DX, RESMENU                         ;LOAD THE FILENAME INTO DX
                    ; INT     21H

                    ; ;READ THE FILE CONTENT
                    ; MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
                    ; MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
                    ; MOV     BX, FILE_HANDLE                     ;FILE HANDLE
                    ; MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
                    ; LEA     DX, RESBUFFER                       ;BUFFER TO STORE THE CONTENT
                    ; INT     21H

                    ; ;DISPLAY THE FILE CONTENT
                    ; MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
                    ; LEA     DX, RESBUFFER                       ;LOAD THE BUFFER ADDRESS
                    ; INT     21H

                    ; ;CLOSE THE FILE
                    ; MOV     AH, 3EH                             
                    ; MOV     BX, FILE_HANDLE                     
                    ; INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE

    CALL NEWLINE

    ;GET USER CHOICE INPUT
    MOV	    AH, 09H                             ;DOS FUNCTION TO DISPLAY STRING
	LEA	    DX, CHOICEMSG
	INT	    21H

    MOV	    AH, 01H
	INT	    21H			                        ;GET USER CHAR INPUT

    MOV     CHOICE, AL                          ;MOVE USER INPUT FROM AL TO STORE IN CHOICE

    CMP     CHOICE, '1'                         ;CHECK IF USER INPUT IS 1
    JE      CHECKRES                            ;JUMP TO CHECK RESERVATION

    CMP     CHOICE, '2'                         ;CHECK IF USER INPUT IS 2
    JE      MAKERES                             ;JUMP TO MAKE RESERVATION

    CMP     CHOICE, '3'                         ;CHECK IF USER INPUT IS 3
    JE 	    PRTMAINPAGE                         ;RETURN BACK TO MAIN MENU

    MOV     AH, 09H                             ;IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     RESERVATION                         ;JUMP TO PRINT MAIN PAGE

;==================================END OF RESERVATION==================================

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
            MOV     BH, 07H                 ;SET TEXT STYLE
            MOV     CX, 0                   ;CLEAR CX REGISTER TO START AT LEFT COL
            MOV     DX, 0                   ;CLEAR DX REGISTER TO START AT TOP ROW
            MOV     CH, 24                  ;SET SCREEN SIZE BACK TO 80X30
            MOV     CL, 79
            INT     10H                     ;BIOS INTERRUPT
            RET                             ;RETURN
    CLEARSCR ENDP
;===================================END OF FUNCTIONS===================================

;===================================START OF FOOTER====================================
    EXIT:   MOV     AX, 4C00H
            INT     21H

            MAIN    ENDP

END MAIN
;====================================END OF FOOTER=====================================