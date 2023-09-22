;TITLE
TITLE   ASSIGNMENT  MAINPROGRAM

.MODEL  SMALL
.STACK  64
.DATA

;-------------------------------------------------------------------------------------
;START OF VARIABLES DECLARATION
;=================================READ FILE VARIABLES=================================
;MAINMENU
MAINMENU    DB      "menu.txt", 0           ;FILENAME
MMBUFFER    DB      900 DUP(?)              ;BUFFER TO STORE FILE CONTENT

;MAINPAGE
MAINPAGE    DB      "mainpage.txt", 0       ;FILENAME
MPBUFFER    DB      900 DUP(?)              ;BUFFER TO STORE FILE CONTENT

;RESERVATION MENU
RESMENU     DB      "reservation.txt", 0    ;FILENAME
RESBUFFER   DB      900 DUP(?)              ;BUFFER TO STORE FILE CONTENT

;MAKERES
MAKEMENU    DB      "makeres.txt", 0        ;FILENAME
MRBUFFER    DB      900 DUP(?)              ;BUFFER TO STORE FILE CONTENT

;INDIVIDUAL RESERVATION MENU
INDIMENU    DB      "indires.txt", 0        ;FILENAME
IMBUFFER    DB      900 DUP(?)              ;BUFFER TO STORE FILE CONTENT

;SUMMARY
SUMSCR      DB      "summary.txt", 0        ;FILENAME
SSBUFFER    DB      900 DUP(?)              ;BUFFER TO STORE FILE CONTENT

;UNIVERSAL
FILE_HANDLE DW      ?                       ;FILE HANDLE
BYTESREAD   DW      0
;=================================NEW LINE VARIABLES==================================
CR          EQU     0DH                     ;CARRIAGE RETURN SHORT FORM
LF          EQU     0AH                     ;LINE FEED SHORT FORM

;=================================PRINTING VARIABLES==================================
;FOR DISPLAY
;LOGIN
GOODLOGIN   DB      "LOGIN SUCCESSFUL", LF, CR, "$"
BADLOGIN    DB      "WRONG USERNAME/PASSWORD. PLEASE TRY AGAIN.", LF, CR, "$"
;INVALID CHOICE
INVALIDMSG  DB      "INVALID CHOICE. PLEASE ENTER AGAIN", LF, CR, "$"

;FOR USER INPUT
;USER CHOICE SELECTION
CHOICEMSG   DB      "INPUT YOUR CHOICE > $"
;LOGIN INFO
MSGUSER     DB      "USERNAME > $"
MSGPSW      DB      "PASSWORD > $"
;======================================CHAR INPUT=====================================
CHOICE      DB      ?

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

;================================USERNAME AND PASSWORD=================================
CHECKUSER   DB      "ADMIN$"
CHECKPSW    DB      "HUNGRY$"

;END OF VARIABLES DECLARATION
;-------------------------------------------------------------------------------------
;START OF MAIN PROGRAM
;==================================START OF HEADER====================================
.CODE                                       ;DEFINE CODE SEGMENT

    MAIN    PROC FAR                        ;MAIN PROCEDURE START

    MOV     AX, @DATA
    MOV     DS, AX                          ;SET ADDRESS OF DATA SEGMENT IN DS
;====================================END OF HEADER====================================

;=================================START OF MAIN MENU==================================
    ;PRINT MENU
    ;OPEN THE FILE
    PRTMMENU:   MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
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

    ;USER LOGIN
    ;ASK FOR USERNAME
    LOGIN:  MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY STRING
            LEA     DX, MSGUSER
            INT     21H

            MOV     AH, 0AH                             ;DOS FUNCTION TO ACCEPT STRING
            LEA     DX, INUSER
            INT     21H

            .386                                        ;CALL FOR ADVANCE FUNCTION
            MOVZX   BX, ACTUALUSER
            MOV     SPACEUSER[BX], '$'                  ;TERMINATE USER INPUT STRING WITH $

            CALL   NEWLINE                              ;NEXT LINE

            ;ASK FOR PASSWORD
            MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY STRING
            LEA     DX, MSGPSW
            INT     21H

            MOV     AH, 0AH                             ;DOS FUNCTION TO ACCEPT STRING
            LEA     DX, INPSW
            INT     21H

            .386                                        ;CALL FOR ADVANCE FUNCTION
            MOVZX   BX, ACTUALPSW
            MOV     SPACEPSW[BX], '$'                   ;TERMINATE USER INPUT STRING WITH $

            MOV     AH, 02H
            MOV     DL, CR
            INT     21H
            MOV     DL, LF
            INT     21H                                 ;NEXT LINE

    ;CHECK USERNAME AND PASSWORD
    ;COMPARE USERNAME LOOP
    MOV     SI, 0                               ;STRING INDEX
    USERCMP:    MOV     AL, INUSER[SI+2]        ;LOAD USER INPUT'S CHAR IN AL
                MOV     BL, [CHECKUSER + SI]    ;LOAD ACTUAL USERNAME'S CHAR IN BL

                CMP     AL, BL                  ;COMPARE THE 2 CHARACTERS

                JNE     INVALIDLOGIN            ;IF USERNAME IS INVALID

                CMP     AL, '$'                 ;CHECK FOR THE TERMINATOR IF STRING IS DONE
                JE      PSWCMP                  ;IF USERNAME IS CORRECT, JUMP TO PSWCMP

                INC     SI                      ;SI++
                JMP     USERCMP                 ;LOOP AGAIN TO CHECK NEXT CHAR

    ;COMPARE PASSWORD LOOP
    PSWCMP:     MOV     SI, 0                   ;CHANGE SI BACK TO 0
    PSWLOOP:    MOV     AL, INPSW[SI+2]         ;LOAD USER'S INPUT CHAR IN AL
                MOV     BL, [CHECKPSW + SI]     ;LOAD ACTUAL USERNAME'S CHAR IN BL

                CMP     AL, BL                  ;COMPARE THE 2 CHARACTERS

                JNE     INVALIDLOGIN            ;IF PASSWORD IS INVALID

                CMP     AL, '$'                 ;CHECK FOR THE TERMINATOR IF STRING IS DONE
                JE      LOGGEDIN                ;IF PASSWORD IS CORRECT, JUMP TO MAINPAGE

                INC     SI                      ;SI++
                JMP     PSWLOOP                 ;LOOP AGAIN TO CHECK NEXT CHAR

    ;WRONG USERNAME AND PASSWORD
    INVALIDLOGIN:   MOV     AH, 09H             ;DOS FUNCTION TO DISPLAY STRING
                    LEA     DX, BADLOGIN
                    INT     21H
                    JMP     LOGIN
;===================================END OF MAIN MENU===================================

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
                    MOV     AL, 0                               ;READ-ONLY MODE
                    LEA     DX, MAINPAGE                        ;LOAD THE FILENAME INTO DX
                    INT     21H

                    ;READ THE FILE CONTENT
                    MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
                    MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
                    MOV     BX, FILE_HANDLE                     ;FILE HANDLE
                    MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
                    LEA     DX, MPBUFFER                        ;BUFFER TO STORE THE CONTENT
                    INT     21H

                    ;DISPLAY THE FILE CONTENT
                    MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
                    LEA     DX, MPBUFFER                        ;LOAD THE BUFFER ADDRESS
                    INT     21H

                    ;CLOSE THE FILE
                    MOV     AH, 3EH                             
                    MOV     BX, FILE_HANDLE                     
                    INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE
                    
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

;=================================START OF RESERVATION=================================
    ;PRINT RESERVATION MENU
    RESERVATION:    MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
                    MOV     AL, 0                               ;READ-ONLY MODE
                    LEA     DX, RESMENU                         ;LOAD THE FILENAME INTO DX
                    INT     21H

                    ;READ THE FILE CONTENT
                    MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
                    MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
                    MOV     BX, FILE_HANDLE                     ;FILE HANDLE
                    MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
                    LEA     DX, RESBUFFER                       ;BUFFER TO STORE THE CONTENT
                    INT     21H

                    ;DISPLAY THE FILE CONTENT
                    MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
                    LEA     DX, RESBUFFER                       ;LOAD THE BUFFER ADDRESS
                    INT     21H

                    ;CLOSE THE FILE
                    MOV     AH, 3EH                             
                    MOV     BX, FILE_HANDLE                     
                    INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE

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

;===========================START OF MAKE RESERVATION PAGE============================
    ;PRINT MAKE RESERVATION MENU
    MAKERES:        MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
                    MOV     AL, 0                               ;READ-ONLY MODE
                    LEA     DX, MAKEMENU                        ;LOAD THE FILENAME INTO DX
                    INT     21H

                    ;READ THE FILE CONTENT
                    MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
                    MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
                    MOV     BX, FILE_HANDLE                     ;FILE HANDLE
                    MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
                    LEA     DX, MRBUFFER                        ;BUFFER TO STORE THE CONTENT
                    INT     21H

                    ;DISPLAY THE FILE CONTENT
                    MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
                    LEA     DX, MRBUFFER                        ;LOAD THE BUFFER ADDRESS
                    INT     21H

                    ;CLOSE THE FILE
                    MOV     AH, 3EH                             
                    MOV     BX, FILE_HANDLE                     
                    INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE

    CALL NEWLINE

    ;GET USER CHOICE INPUT
    MOV	    AH, 09H                             ;DOS FUNCTION TO DISPLAY STRING
	LEA	    DX, CHOICEMSG
	INT	    21H

    MOV	    AH, 01H
	INT	    21H			                        ;GET USER CHAR INPUT

    MOV     CHOICE, AL                          ;MOVE USER INPUT FROM AL TO STORE IN CHOICE

    CMP     CHOICE, '1'                         ;CHECK IF USER INPUT IS 1
    JE      INDIRES                             ;JUMP TO INDIVIDUAL RESERVATION PAGE

    CMP     CHOICE, '2'                         ;CHECK IF USER INPUT IS 2
    JE      EVENTRES                            ;JUMP TO EVENT RESERVATION PAGE

    CMP     CHOICE, '3'                         ;CHECK IF USER INPUT IS 3
    JE 	    RESERVATION                         ;RETURN BACK TO MAIN MENU

    MOV     AH, 09H                             ;IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     MAKERES                             ;JUMP TO PRINT MAIN PAGE

;=============================END OF MAKE RESERVATION PAGE=============================

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
;END OF MAIN PROGRAM
;--------------------------------------------------------------------------------------

;EXIT PROGRAM
;===================================START OF FOOTER====================================
    EXIT:   MOV     AX, 4C00H
            INT     21H

            MAIN    ENDP

END MAIN
;====================================END OF FOOTER=====================================