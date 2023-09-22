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

FMENU       DB      "foodmenu.txt", 0	      ;FILENAME
FMBUFFER    DB      900 DUP(?)               ;BUFFER TO STORE FILE CONTENT

;SET A MENU
SETMENU1     DB      "seta.txt", 0            ;FILENAME
SABUFFER     DB      900 DUP(?)               ;BUFFER TO STORE FILE CONTENT

;SET B MENU
SETMENU2     DB      "setb.txt", 0            ;FILENAME
SBBUFFER     DB      900 DUP(?)               ;BUFFER TO STORE FILE CONTENT

;SET C MENU
SETMENU3     DB      "setc.txt", 0            ;FILENAME
SCBUFFER     DB      900 DUP(?)               ;BUFFER TO STORE FILE CONTENT

;SUMMARY
SUMSCR      DB      "summary.txt", 0        ;FILENAME
SSBUFFER    DB      900 DUP(?)              ;BUFFER TO STORE FILE CONTENT

;UNIVERSAL
FILE_HANDLE DW      ?                       ;FILE HANDLE
BYTESREAD   DW      0

;=================================PRINTING VARIABLES==================================
;FOR DISPLAY
;LOGIN
GOODLOGIN   DB      "LOGIN SUCCESSFUL", LF, CR, "$"
BADLOGIN    DB      "WRONG USERNAME/PASSWORD. PLEASE TRY AGAIN.", LF, CR, "$"
;INVALID CHOICE
INVALIDMSG  DB      "INVALID INPUT. PLEASE ENTER AGAIN", LF, CR, "$"
;SUMMARY
SETMSG      DB      "SET ORDERED: $"
NAMEDIS     DB      "CUSTOMER NAME: $"
PAXDIS      DB      "PAX: $"
DATEDIS     DB      "DATE: $"
TIMEDIS     DB      "TIME: $"
TOTALDIS    DB      "TOTAL: $"

;FOR USER INPUT
;USER CHOICE SELECTION
CHOICEMSG   DB      "INPUT YOUR CHOICE > $"
RETURNMSG   DB      "ENTER '#' TO RETURN TO FOOD MENU > $"
;LOGIN INFO
MSGUSER     DB      "USERNAME > $"
MSGPSW      DB      "PASSWORD > $"
;CUSTOMER NAME
NAMEMSG     DB      "ENTER CUSTOMER'S NAME > $"
;PAX
PAXMSG      DB      "ENTER NO. OF PAX > $"
;DATE AND TIME
DATEMSG     DB      "ENTER RESERVATION DATE (DD/MM/YY) > $"
TIMEMSG     DB      "ENTER RESERVATION TIME (HH:MM)> $"
;MEMBER
MEMBERMSG   DB      "MEMBER? > $"
;===================================CHAR VARIABLE=====================================
CHOICE      DB      ?
MEMBER      DB      ?
PAX         DB      ?
ORDSET      DB      ?

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

;CUSTOMER NAME
INNAME      LABEL   BYTE
MAXNAME     DB      20
ACTUALNAME  DB      ?
SPACENAME   DB      20 DUP(' ')

;DATE
INDATE      LABEL   BYTE
MAXDATE     DB      9
ACTUALDATE  DB      ?
SPACEDATE   DB      9 DUP(' ')

;TIME
INTIME      LABEL   BYTE
MAXTIME     DB      5
ACTUALTIME  DB      ?
SPACETIME   DB      5 DUP(' ')

;================================USERNAME AND PASSWORD=================================
CHECKUSER   DB      "ADMIN$"
CHECKPSW    DB      "HUNGRY$"

;=====================================CONSTANTS=======================================
;NEW LINE
CR          EQU     0DH                     ;CARRIAGE RETURN SHORT FORM
LF          EQU     0AH                     ;LINE FEED SHORT FORM

;SET MENU PRICE
ASET        DW      2
BSET        DW      5

;SST AND SERVICE CHARGE
SST         DW      106
SRVC        DW      105

;SCALING FACTOR
SCALE       DW      10000

;==============================VARIABLES FOR CALCULATION===============================
COVINT      DB      ?, ?
COVDEC      DB      ?, ?
INTEGER     DW      ?
DECIMAL     DW      ?
TOTAL       DW      ?
QUOTIENT    DW      ?
REMAINDER   DW      ?

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

                CALL      FILE_ERROR                          ;JUMP IF ERROR

                ;READ THE FILE CONTENT
                MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
                MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
                MOV     BX, FILE_HANDLE                     ;FILE HANDLE
                MOV     CX, 862                             ;NUMBER OF BYTES TO READ AT A TIME
                LEA     DX, MMBUFFER                        ;BUFFER TO STORE THE CONTENT
                INT     21H

                CALL      FILE_ERROR                          ;JUMP IF ERROR

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

            CALL    NEWLINE                             ;NEXT LINE

            ;CHECK IF USER WANTS TO QUIT
            MOV     AL, INUSER[2]
            CMP     AL, 'X'                             ;IF USER INPUT X
            JE      EXIT1                               ;JUMP TO EXIT
            CMP     AL, 'x'                             ;IF USER INPUT X
            JE      EXIT1                               ;JUMP TO EXIT
            MOV     AL, 0                               ;CLEAR AL

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

            ;CHECK IF USER WANTS TO QUIT
            MOV     AL, INPSW[2]
            CMP     AL, 'X'                             ;IF USER INPUT X
            JE      EXIT1                               ;JUMP TO EXIT
            CMP     AL, 'x'                             ;IF USER INPUT X
            JE      EXIT1                               ;JUMP TO EXIT
            MOV     AL, 0                               ;CLEAR AL

            CALL    NEWLINE

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

;===========================START OF INDIVIDUAL RESERVATION===========================
    ;PRINT RESERVATION MENU
    INDIRES:        CALL    CLEARSCR
                    MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
                    MOV     AL, 0                               ;READ-ONLY MODE
                    LEA     DX, INDIMENU                        ;LOAD THE FILENAME INTO DX
                    INT     21H

                    ;READ THE FILE CONTENT
                    MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
                    MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
                    MOV     BX, FILE_HANDLE                     ;FILE HANDLE
                    MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
                    LEA     DX, IMBUFFER                        ;BUFFER TO STORE THE CONTENT
                    INT     21H

                    ;DISPLAY THE FILE CONTENT
                    MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
                    LEA     DX, IMBUFFER                        ;LOAD THE BUFFER ADDRESS
                    INT     21H

                    ;CLOSE THE FILE
                    MOV     AH, 3EH                             
                    MOV     BX, FILE_HANDLE                     
                    INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE

    CALL NEWLINE

    ;GET USER CHOICE INPUT
    CHOOSE:     MOV	    AH, 09H                             ;DOS FUNCTION TO DISPLAY STRING
                LEA	    DX, CHOICEMSG
                INT	    21H

                MOV	    AH, 01H
                INT	    21H			                        ;GET USER CHAR INPUT

                MOV     CHOICE, AL                          ;MOVE USER INPUT FROM AL TO STORE IN CHOICE

                CALL    NEWLINE

    CMP     CHOICE, '1'                         ;CHECK IF USER INPUT IS 1
    MOV     ORDSET, 'A'                         ;STORE AL TO ORDERED SET
    JE      INDIA                               ;JUMP TO SET 1

    CMP     CHOICE, '2'                         ;CHECK IF USER INPUT IS 2
    MOV     ORDSET, 'B'                         ;STORE AL TO ORDERED SET
    JE      INDIB                               ;JUMP TO SET 2

    CMP     CHOICE, '3'                         ;CHECK IF USER INPUT IS 4
    JE 	    MAKERES                             ;RETURN BACK TO MAIN MENU

    CALL    INVALID
    JMP     INDIRES                             ;JUMP TO PRINT INDIVIDUAL RESERVATION PAGE

    ;SET MENUS
    ;SET MENU 1
    INDIA:      MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, PAXMSG
                INT     21H

                CALL    GETPAX                  ;GET PAX

                MOV     AH, 0                   ;CLEAR AH
                MUL     ASET                    ;PAX * SET A PRICE
                MOV     TOTAL, AX               ;STORE RESULT IN TOTAL

                CALL    NEWLINE
                CALL    CHKMEM                  ;CALL FUNCTION TO CHECK FOR MEMBER STATUS AND CALCULATE FINAL TOTAL
                CALL    DETAILS                 ;CALL DETAILS FUNCTION TO GET RESERVATION DETAILS

                CALL    CLEARSCR
                ;DISPLAY SUMMARY
                CALL    SUMMARY                 ;CALL SUMMARY FUNCTION
                CALL    WRTRES                  ;CALL WRITE FILE FUCTION
                
    ;SET MENU 2
    INDIB:      MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, PAXMSG
                INT     21H

                CALL    GETPAX                  ;GET PAX

                MOV     AH, 0                   ;CLEAR AH
                MUL     BSET                    ;PAX * SET B PRICE
                MOV     TOTAL, AX               ;STORE RESULT IN TOTAL
                
                CALL    NEWLINE
                CALL     CHKMEM                 ;CALL FUNCTION TO CHECK FOR MEMBER STATUS AND CALCULATE FINAL TOTAL
                CALL     DETAILS                ;CALL DETAILS FUNCTION TO GET RESERVATION DETAILS
                
                CALL    CLEARSCR
                ;DISPLAY SUMMARY
                CALL    SUMMARY                 ;CALL SUMMARY FUNCTION
                CALL    WRTRES                  ;CALL WRITE FILE FUCTION

;============================END OF INDIVIDUAL RESERVATION=============================
;==================================START OF FOOD MENU==================================
;PRINT FOOD MENU
FOODMENU:
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
    MOV     AH, 09H             ; IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     FOODMENU         ; Jump to PRTFOODMENU

;===============================START OF DISPLAY SET MENUS=================================
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

    MOV     AH, 01H             ; READ CHARACTER FROM INPUT
    INT     21H

    MOV     CHOICE, AL          ; MOVE USER INPUT FROM AL TO CHOICE

    CMP     CHOICE, '#'         ; CHECK INPUT = '#'
    JNE     INVALID_IN1		; CHECK WHETHER INVALID
    JMP     FOODMENU            ; JUMP TO FOODMENU 

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

    	MOV     AH, 01H             ; READ CHARACTER FROM INPUT
   	INT     21H

    	MOV     CHOICE, AL          ; MOVE USER INPUT FROM AL TO CHOICE

    	CMP     CHOICE, '#'         ; CHECK INPUT = '#'
    	JNE     INVALID_IN2         ; CHECK WHETHER INVALID
    	JMP     FOODMENU            ; JUMP TO FOODMENU 

INVALID_IN2:
    MOV     AH, 09H                 ; IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     SET2                    ;JUMP TO PRINT SET B

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

    	MOV     AH, 01H             ; READ CHARACTER FROM INPUT
    	INT     21H

    	MOV     CHOICE, AL          ; MOVE USER INPUT FROM AL TO CHOICE

    	CMP     CHOICE, '#'         ; CHECK INPUT = '#'
    	JNE     INVALID_IN3	    ; CHECK WHETHER INVALID
    	JMP     FOODMENU            ; JUMP TO FOODMENU 

INVALID_IN3:
    MOV     AH, 09H                 ; IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     SET3 

;=================================END OF DISPLAY SET MENUS=============================
;===================================END OF FOOD MENU===================================
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
            MOV     CX, 65535                       ;LOADING DURATION
    LOADINGLOOP:    DEC     CX
                    JNZ     LOADINGLOOP             ;JUMP IF CX IS STILL NOT ZERO
            MOV     CX, 65535
    LOADINGLOOP2:   DEC     CX
                    JNZ     LOADINGLOOP2            ;LOADING DURATION
            MOV     CX, 65535
    LOADINGLOOP3:   DEC     CX
                    JNZ     LOADINGLOOP3            ;LOADING DURATION
            MOV     CX, 65535
    LOADINGLOOP4:   DEC     CX
                    JNZ     LOADINGLOOP4            ;LOADING DURATION
            MOV     CX, 65535
    LOADINGLOOP5:   DEC     CX
                    JNZ     LOADINGLOOP5            ;LOADING DURATION
            MOV     CX, 65535
    LOADINGLOOP6:   DEC     CX
                    JNZ     LOADINGLOOP6            ;LOADING DURATION
            MOV     CX, 65535
    LOADINGLOOP7:   DEC     CX
                    JNZ     LOADINGLOOP7            ;LOADING DURATION
            MOV     CX, 65535
    LOADINGLOOP8:   DEC     CX
                    JNZ     LOADINGLOOP8            ;LOADING DURATION
            MOV     CX, 65535
    LOADINGLOOP9:   DEC     CX
                    JNZ     LOADINGLOOP9            ;LOADING DURATION
            MOV     CX, 65535
    LOADINGLOOP10:   DEC     CX
                    JNZ     LOADINGLOOP10            ;LOADING DURATION
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

;INVALID MSG
    INVALID     PROC
            MOV     AH, 09H                 ;IF INVALID CHOICE, PRINT INVALIDMSG
            LEA     DX, INVALIDMSG
            INT     21H

            MOV     AX, 0                   ;CLEAR AX

            CALL    LOADING
            RET
    INVALID     ENDP

;GET PAX
    GETPAX      PROC                
            MOV	    AH, 01H
            INT	    21H			            ;GET USER PAX INPUT
            MOV     PAX, AL                 ;STORE USER INPUT IN PAX
            SUB     AL, 30H                 ;CONVERT ASCII TO REAL VALUE

            CMP     AL, 1
            JL      INVALIDPAX
            CMP     AL, 9
            JG      INVALIDPAX

            RET
    GETPAX      ENDP
    
;INVALID PAX
    INVALIDPAX      PROC
            CALL    INVALID                 ;CALL INVALID MSG
            JMP     CHOOSE                  ;GO BACK TO ASKING FOR PAX
    INVALIDPAX      ENDP

;GET DETAILS NAME AND PAX
    DETAILS    PROC
            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, NAMEMSG
            INT     21H

            MOV     AH, 0AH                 ;DOS FUNCTION TO ACCEPT STRING
            LEA     DX, INNAME
            INT     21H

            .386                            ;CALL FOR ADVANCE FUNCTION
            MOVZX   BX, ACTUALNAME
            MOV     SPACENAME[BX], '$'      ;TERMINATE USER INPUT STRING WITH $

            CALL    NEWLINE

            ;DATE
            MOV     AX, 0                   ;CLEAR AX
            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, DATEMSG
            INT     21H

            MOV     AH, 0AH                 ;DOS FUNCTION TO ACCEPT STRING
            LEA     DX, INDATE
            INT     21H

            .386                            ;CALL FOR ADVANCE FUNCTION
            MOVZX   BX, ACTUALDATE
            MOV     SPACEDATE[BX], '$'      ;TERMINATE USER INPUT STRING WITH $

            CALL    NEWLINE

            ;TIME
            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, TIMEMSG
            INT     21H

            MOV     AH, 0AH                 ;DOS FUNCTION TO ACCEPT STRING
            LEA     DX, INTIME
            INT     21H

            .386                            ;CALL FOR ADVANCE FUNCTION
            MOVZX   BX, ACTUALTIME
            MOV     SPACETIME[BX], '$'      ;TERMINATE USER INPUT STRING WITH $

            CALL    NEWLINE

            RET
    DETAILS    ENDP

;CHECK MEMBER
    CHKMEM      PROC
    MEMLOOP:    MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, MEMBERMSG
                INT     21H

                MOV	    AH, 01H
                INT	    21H			            ;GET USER CHAR INPUT

                MOV     MEMBER, AL              ;STORE USER INPUT TO MEMBER

                CALL    NEWLINE

                ;IF CUSTOMER IS A MEMBER
                CMP     MEMBER, 'Y'
                JE      GOTMEM                  ;JUMP TO CALCULATION WITH MEMBER DISCOUNT
                CMP     MEMBER, 'y'
                JE      GOTMEM                  ;JUMP TO CALCULATION WITH MEMBER DISCOUNT

                ;IF CUSTOMER IS A MEMBER
                CMP     MEMBER, 'N'
                JE      NOMEM                   ;JUMP TO CALCULATION WITH MEMBER DISCOUNT
                CMP     MEMBER, 'n'
                JE      NOMEM                   ;JUMP TO CALCULATION WITH MEMBER DISCOUNT

                ;INVALID INPUT
                MOV     AH, 09H                 ;IF INVALID CHOICE, PRINT INVALIDMSG
                LEA     DX, INVALIDMSG
                INT     21H
                CALL    NEWLINE
                JMP     MEMLOOP                 ;JUMP TO MEMLOOP

    ;HAS MEMBER
    GOTMEM:     MOV     AX, TOTAL               ;MOVE TOTAL TO AX FOR CALCULATIONS

                MUL     SST                     ;MULTIPLY AX WITH SST            
                MUL     SRVC                    ;MULTIPLY AX WITH SST
                DIV     SCALE                   ;DIVIDE WITH SCALING FACTOR

                SUB     AX, 5                   ;SUBTRACT 5 AS A DISCOUNT

                MOV     INTEGER, AX             ;STORE THE QUOTIENT TO INTEGER
                MOV     DECIMAL, DX             ;STORE THE REMAINDER TO DECIMAL

                RET

    ;NO MEMBER
    NOMEM:      MOV     AX, TOTAL               ;MOVE TOTAL TO AX FOR CALCULATIONS

                MUL     SST                     ;MULTIPLY AX WITH SST
                MUL     SRVC                    ;MULTIPLY AX WITH SST
                DIV     SCALE                   ;DIVIDE SCALING FACTOR

                MOV     INTEGER, AX             ;STORE THE QUOTIENT TO INTEGER
                MOV     DECIMAL, DX             ;STORE THE REMAINDER TO DECIMAL

                RET
    CHKMEM      ENDP

;PRINT SUMMARY
    SUMMARY     PROC
            SPASH SCREEN
            MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
            MOV     AL, 0                               ;READ-ONLY MODE
            LEA     DX, SUMSCR                          ;LOAD THE FILENAME INTO DX
            INT     21H

            ;READ THE FILE CONTENT
            MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
            MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
            MOV     BX, FILE_HANDLE                     ;FILE HANDLE
            MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
            LEA     DX, SSBUFFER                        ;BUFFER TO STORE THE CONTENT
            INT     21H

            ;DISPLAY THE FILE CONTENT
            MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
            LEA     DX, SSBUFFER                        ;LOAD THE BUFFER ADDRESS
            INT     21H

            ;CLOSE THE FILE
            MOV     AH, 3EH                             
            MOV     BX, FILE_HANDLE                     
            INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE

            ;ORDERED SET
            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, SETMSG
            INT     21H

            MOV     DX, 0                   ;CLEAR DX
            MOV     AH, 02H                 ;DOS FUNCTION FOR DISPLAY CHAR
            MOV     DL, ORDSET
            INT     21H

            CALL    NEWLINE

            ;NAME
            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, NAMEDIS
            INT     21H

            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, SPACENAME
            INT     21H

            CALL   NEWLINE                  ;NEXT LINE

            ;PAX
            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, PAXDIS
            INT     21H

            MOV     DX, 0                   ;CLEAR DX
            MOV     AH, 02H                 ;DOS FUNCTION FOR DISPLAY CHAR
            MOV     DL, PAX
            INT     21H

            CALL   NEWLINE                  ;NEXT LINE

            ;DATE
            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, DATEDIS
            INT     21H

            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, SPACEDATE
            INT     21H

            CALL   NEWLINE                  ;NEXT LINE

            ;TIME
            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, TIMEDIS
            INT     21H

            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, SPACETIME
            INT     21H

            CALL    NEWLINE

            ;TOTAL AMOUNT
            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, TOTALDIS
            INT     21H

            ;CHECK IF TOTAL NEEDS ROUNDING
            MOV     DX, 0                   ;CLEAR DX
            MOV     AX, DECIMAL             ;MOVE DECIMAL TO AX
            MOV     BX, 100                 ;STORE 10 IN BX FOR DIVISION
            DIV     BX                      ;AX/100, QUOTIENT IN AX, REMAINDER IN DX
            CMP     DX, 50                  ;COMPARE DX(3RD DECIMAL PLACE) TO 50
            JAE     ROUNDUP                 ;IF MORE THAN 50, GO TO ROUND UP
            MOV     DECIMAL, AX
            JMP     NOROUND

            ROUNDUP:    INC     AL                      ;AL(SECOND DECIMAL)++
                        CMP     AX, 100                 ;CHECK IF THE DECIMAL NEEDS TO CARRY TO THE INTEGER
                        JAE     CARRYTOINT              ;JUMP TO CARRYTOFIRST
                        MOV     DECIMAL, AX
                        JMP     NOROUND                 ;IF NO CARRY

            CARRYTOINT:     MOV     AX, 00H             ;CHANGE AX TO 00
                            MOV     DECIMAL, AX         ;CHANGE VALUE IN DECIMAL TO 0
                            MOV     CX, INTEGER         ;STORE INTEGER TO CX
                            ADD     CX, 1               ;CX++
                            MOV     INTEGER, CX         ;STORE CX BACK TO INTEGER
                            JMP     NOROUND             ;GO TO DISPLAY

            ;NO NEED ROUNDING UP
            ;DIPLAY INTEGER
            NOROUND:    MOV     AX, INTEGER         ;STORE INTEGER INTO AX
                        MOV     SI, 0
                        MOV     DX, 0               ;CLEAR DX
                        MOV     BX, 10              ;STORE 10 IN BX FOR DIVISION
                        DIV     BX                  ;AX/10, QUOTIENT IS STORED IN AX AND REMAINDER IS STORE IN DX
                        MOV     COVINT[SI], AL      ;MOVE INTEGER INTO ARRAY
                        INC     SI
                        MOV     COVINT[SI], DL

            MOV     SI, 0                            
            INTEGERLOOP:    MOV     AH, 02H         ;DOS FUNCTION TO DISPLAY CHAR
                            MOV     DL, COVINT[SI]  ;MOVE INT TO DL TO BE DISPLAYED
                            ADD     DL, 30H         ;CONVERT VALUE TO ASCII
                            INT     21H             ;DISPLAY ASCII VALUE

                            INC     SI
                            CMP     SI, 2
                            JNE     INTEGERLOOP

                        ;DISPLAY DECIMAL
                        MOV     AH, 02H                 ;DOS FUNCTION TO DISPLAY CHAR
                        MOV     DL, '.'                 ;DISPLAY DECIMAL DOT
                        INT     21H

                        MOV     AX, DECIMAL             ;STORE THE DECIMAL BACK TO AX
                        MOV     SI, 0
                        
                        MOV     DX, 0           ;CLEAR DX
                        MOV     BX, 10          ;STORE 10 IN BX FOR DIVISION
                        DIV     BX              ;AX/10, QUOTIENT IS STORED IN AX AND REMAINDER IS STORE IN DX
                        MOV     COVDEC[SI], AL
                        INC     SI
                        MOV     COVDEC[SI], DL

            MOV     SI, 0                            
            DECIMALLOOP:    MOV     AH, 02H         ;DOS FUNCTION TO DISPLAY CHAR
                            MOV     DL, COVDEC[SI]  ;MOVE INT TO DL TO BE DISPLAYED
                            ADD     DL, 30H         ;CONVERT VALUE TO ASCII
                            INT     21H             ;DISPLAY ASCII VALUE

                            INC     SI
                            CMP     SI, 2
                            JNE     DECIMALLOOP
            
            CALL    NEWLINE
            RET             ;RETURN ONCE DONE DISPLAYING      
    SUMMARY     ENDP

;WRITE RESERVATION TO FILE
    WRITERES    PROC
            MOV     AH, 3CH               ;DOS FUNCTION TO CREATE A FILE
            MOV     CX, 2                 ;APPEND MODE
            LEA     DX, SPACENAME         ;LOAD THE FILENAME INTO DX
            INT     21H

            ;SET POINTER TO EOF
            MOV     AX, 4202H             ;DOS FUNCTION TO SET FILE POINTER
            MOV     BX, AX                ;FILE HANDLER
            MOV     CX, 0                 ;SET POINTER TO LEFT COL
            MOV     DX, 0                 ;SET POINTER TO TOP ROW
            INT     21H

            ;WRITE DATA TO FILE
            ;NAME
            MOV     AH, 40H                   ;DOS FUNCTION TO WRITE TO A FILE
            MOV     BX, AX                    ;FILE HANDLER
            MOV     CX, 20                    ;LENGTH OF DATA TO WRITE
            LEA     DX, ACTUALNAME            ;ADDRESS OF DATA TO WRITE
            INT     21H

            ;PAX
            MOV     AH, 40H                   ;DOS FUNCTION TO WRITE TO A FILE
            MOV     BX, AX                    ;FILE HANDLER
            MOV     CX, LENGTHOF PAX          ;LENGTH OF DATA TO WRITE
            LEA     DX, PAX                   ;ADDRESS OF DATA TO WRITE
            INT     21H

            ;DATE
            MOV     AH, 40H                   ;DOS FUNCTION TO WRITE TO A FILE
            MOV     BX, AX                    ;FILE HANDLER
            MOV     CX, LENGTHOF SPACEDATE    ;LENGTH OF DATA TO WRITE
            LEA     DX, ACTUALDATE            ;ADDRESS OF DATA TO WRITE
            INT     21H

            ;TIME
            MOV     AH, 40H                   ;DOS FUNCTION TO WRITE TO A FILE
            MOV     BX, AX                    ;FILE HANDLER
            MOV     CX, LENGTHOF SPACETIME    ;LENGTH OF DATA TO WRITE
            LEA     DX, ACTUALTIME            ;ADDRESS OF DATA TO WRITE
            INT     21H

            ;CLOSE THE FILE
            MOV     AH, 3EH                                     
            INT     21H                   ;DOS FUNCTION TO CLOSE A FILE
            RET
    WRITERES    ENDP
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