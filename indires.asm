;TITLE
TITLE   ASSIGNMENT  MAINPROGRAM

.MODEL  SMALL
.STACK  64
.DATA

;-------------------------------------------------------------------------------------
;START OF VARIABLES DECLARATION
;=================================READ FILE VARIABLES=================================
;INDIVIDUAL RESERVATION MENU
INDIMENU    DB      "indires.txt", 0        ;FILENAME
IMBUFFER    DB      900 DUP(?)              ;BUFFER TO STORE FILE CONTENT

;SUMMARY
SUMSCR      DB      "summary.txt", 0        ;FILENAME
SSBUFFER    DB      900 DUP(?)              ;BUFFER TO STORE FILE CONTENT

;UNIVERSAL
FILE_HANDLE DW      ?                       ;FILE HANDLE
BYTESREAD   DW      0
;================================WRITE FILE VARIABLES=================================
RESFILE     DB      "resfile.txt", 0        ;FILENAME
RFBUFFER    EQU      100                    ;BUFFER TO STORE FILE CONTENT

;=================================PRINTING VARIABLES==================================
;FOR USER INPUT
;CHOICE
CHOICEMSG   DB      "INPUT YOUR CHOICE > $"
;CUSTOMER NAME
NAMEMSG     DB      "ENTER CUSTOMER'S NAME > $"
;PAX
PAXMSG      DB      "ENTER NO. OF PAX > $"
;DATE AND TIME
DATEMSG     DB      "ENTER RESERVATION DATE (DD/MM/YY) > $"
TIMEMSG     DB      "ENTER RESERVATION TIME (HH.MMAM)> $"
;MEMBER
MEMBERMSG   DB      "MEMBER? > $"

;FOR DISPLAY 
;INVALID
INVALIDMSG  DB      "INVALID CHOICE. PLEASE ENTER AGAIN", LF, CR, "$"
;SUMMARY
AMSG        DB      "SET ORDERED: SET A", LF, CR, "$"
BMSG        DB      "SET ORDERED: SET B", LF, CR, "$"
CMSG        DB      "SET ORDERED: SET C", LF, CR, "$"
NAMEDIS     DB      "CUSTOMER NAME: $"
PAXDIS      DB      "PAX: $"
DATEDIS     DB      "DATE: $"
TIMEDIS     DB      "TIME: $"


;======================================CHAR INPUT=====================================
CHOICE      DB      ?
MEMBER      DB      ?
TOTAL       DB      ?
PAX         DB      ?
;===================================STRING INPUT======================================
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
MAXTIME     DB      8
ACTUALTIME  DB      ?
SPACETIME   DB      8 DUP(' ')

;=====================================CONSTANTS=======================================
;NEW LINE
CR          EQU     0DH                     ;CARRIAGE RETURN SHORT FORM
LF          EQU     0AH                     ;LINE FEED SHORT FORM

;SET MENU PRICE
ASET        DW     5
BSET        DW     10
CSET        DW     20

;SST AND SERVICE CHARGE
SST         DW     106
SRVC        DW     105
DISC        DW     90

;PERCENTAGE SCALING FACTOR
PERC        DW     100
;END OF VARIABLES DECLARATION
;-------------------------------------------------------------------------------------
;==================================START OF HEADER====================================
.CODE                                       ;DEFINE CODE SEGMENT

    MAIN    PROC FAR                        ;MAIN PROCEDURE START

    MOV     AX, @DATA
    MOV     DS, AX                          ;SET ADDRESS OF DATA SEGMENT IN DS
;====================================END OF HEADER====================================

;===========================START OF INDIVIDUAL RESERVATION===========================
    ;PRINT RESERVATION MENU
    INDIRES:        CALL    CLEARSCR
                    ; MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
                    ; MOV     AL, 0                               ;READ-ONLY MODE
                    ; LEA     DX, INDIMENU                        ;LOAD THE FILENAME INTO DX
                    ; INT     21H

                    ; ;READ THE FILE CONTENT
                    ; MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
                    ; MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
                    ; MOV     BX, FILE_HANDLE                     ;FILE HANDLE
                    ; MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
                    ; LEA     DX, IMBUFFER                        ;BUFFER TO STORE THE CONTENT
                    ; INT     21H

                    ; ;DISPLAY THE FILE CONTENT
                    ; MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
                    ; LEA     DX, IMBUFFER                        ;LOAD THE BUFFER ADDRESS
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
    JE      INDIA                               ;JUMP TO SET 1

    CMP     CHOICE, '2'                         ;CHECK IF USER INPUT IS 2
    JE      INDIB                               ;JUMP TO SET 2

    CMP     CHOICE, '3'                         ;CHECK IF USER INPUT IS 3
    JE 	    INDIC                               ;JUMP TO SET 3

    CMP     CHOICE, '4'                         ;CHECK IF USER INPUT IS 4
    ;JE 	    MAKERES                             ;RETURN BACK TO MAIN MENU

    MOV     AH, 09H                             ;IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    JMP     INDIRES                             ;JUMP TO PRINT INDIVIDUAL RESERVATION PAGE

    ;SET MENUS
    ;SET MENU 1
    INDIA:      CALL    NEWLINE
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, PAXMSG
                INT     21H

                MOV	    AH, 01H
                INT	    21H			            ;GET USER PAX INPUT
                MOV     PAX, AL                 ;STORE USER INPUT IN PAX
                SUB     AL, 30H                 ;CONVERT ASCII TO REAL VALUE

                MUL     ASET                    ;PAX * SET A PRICE
                MOV     TOTAL, AL               ;STORE RESULT IN TOTAL

                CALL    NEWLINE

                CALL    CHKMEM                  ;CALL FUNCTION TO CHECK FOR MEMBER STATUS AND CALCULATE FINAL TOTAL
                CALL    DETAILS                 ;CALL DETAILS FUNCTION TO GET RESERVATION DETAILS

                ;DISPLAY SUMMARY
                ;SET A
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, AMSG
                INT     21H

                CALL    SUMMARY                 ;CALL SUMMARY FUNCTION
                ;CALL    WRTRES                  ;CALL WRITE FILE FUCTION
                
    ;SET MENU 2
    INDIB:      CALL    NEWLINE
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, PAXMSG
                INT     21H

                MOV	    AH, 01H
                INT	    21H			            ;GET USER PAX INPUT
                MOV     PAX, AL                 ;STORE USER INPUT IN PAX
                SUB     AL, 30H                 ;CONVERT ASCII TO REAL VALUE

                
                MUL     BSET                    ;PAX * SET B PRICE
                MOV     TOTAL, AL               ;STORE RESULT IN TOTAL
                
                CALL    NEWLINE

                CALL     CHKMEM                 ;CALL FUNCTION TO CHECK FOR MEMBER STATUS AND CALCULATE FINAL TOTAL
                CALL     DETAILS                ;CALL DETAILS FUNCTION TO GET RESERVATION DETAILS
                
                ;DISPLAY SUMMARY
                ;SET B
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, BMSG
                INT     21H

                CALL    SUMMARY                 ;CALL SUMMARY FUNCTION
                ;CALL    WRTRES                  ;CALL WRITE FILE FUCTION

    ;SET MENU 3
    INDIC:      CALL    NEWLINE
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, PAXMSG
                INT     21H
                
                MOV	    AH, 01H
                INT	    21H			            ;GET USER PAX INPUT
                MOV     PAX, AL                 ;STORE USER INPUT IN PAX
                SUB     AL, 30H                 ;CONVERT ASCII TO REAL VALUE

                MUL     CSET                    ;PAX * SET C PRICE
                MOV     TOTAL, AL               ;STORE RESULT IN TOTAL

                CALL    NEWLINE

                CALL     CHKMEM                 ;CALL FUNCTION TO CHECK FOR MEMBER STATUS AND CALCULATE FINAL TOTAL
                CALL     DETAILS                ;CALL DETAILS FUNCTION TO GET RESERVATION DETAILS

                ;DISPLAY SUMMARY
                ;SET C
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, CMSG
                INT     21H

                CALL    SUMMARY                 ;CALL SUMMARY FUNCTION
                ;CALL    WRTRES                  ;CALL WRITE FILE FUCTION

;============================END OF INDIVIDUAL RESERVATION=============================

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
                JMP     GOTMEM                  ;JUMP TO CALCULATION WITH MEMBER DISCOUNT

                ;IF CUSTOMER IS A MEMBER
                CMP     MEMBER, 'N'
                JE      NOMEM                   ;JUMP TO CALCULATION WITH MEMBER DISCOUNT
                CMP     MEMBER, 'n'
                JMP     NOMEM                   ;JUMP TO CALCULATION WITH MEMBER DISCOUNT

                ;INVALID INPUT
                MOV     AH, 09H                 ;IF INVALID CHOICE, PRINT INVALIDMSG
                LEA     DX, INVALIDMSG
                INT     21H
                CALL    NEWLINE
                JMP     MEMLOOP                 ;JUMP TO MEMLOOP

    ;HAS MEMBER
    GOTMEM:     MOV     AH, 0                   ;CLEAR AH
                MOV     AL, TOTAL               ;MOVE TOTAL TO AX FOR CALCULATIONS
                MUL     DISC                    ;MULTIPLY AX WITH DISCOUNT
                DIV     PERC                    ;DIVIDE WITH PERCENTAGE SCALING FACTOR

                MUL     SST                     ;MULTIPLY AX WITH SST
                DIV     PERC                    ;DIVIDE WITH PERCENTAGE SCALING FACTOR
                
                MUL     SRVC                    ;MULTIPLY AX WITH SST
                DIV     PERC                    ;DIVIDE WITH PERCENTAGE SCALING FACTOR

                MOV     TOTAL, AL               ;STORE RESULT BACK TO TOTAL
                RET

    ;NO MEMBER
    NOMEM:      MOV     AH, 0                   ;CLEAR AH
                MOV     AL, TOTAL               ;MOVE TOTAL TO AX FOR CALCULATIONS

                MUL     SST                     ;MULTIPLY AX WITH SST
                DIV     PERC                    ;DIVIDE WITH PERCENTAGE SCALING FACTOR
                
                MUL     SRVC                    ;MULTIPLY AX WITH SST
                DIV     PERC                    ;DIVIDE WITH PERCENTAGE SCALING FACTOR

                MOV     TOTAL, AL               ;STORE RESULT BACK TO TOTAL
                RET
    CHKMEM      ENDP

;PRINT SUMMARY
    SUMMARY     PROC
            ;SPASH SCREEN
            CALL    CLEARSCR
            ; MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
            ; MOV     AL, 0                               ;READ-ONLY MODE
            ; LEA     DX, SUMSCR                          ;LOAD THE FILENAME INTO DX
            ; INT     21H

            ; ;READ THE FILE CONTENT
            ; MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
            ; MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
            ; MOV     BX, FILE_HANDLE                     ;FILE HANDLE
            ; MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
            ; LEA     DX, SSBUFFER                        ;BUFFER TO STORE THE CONTENT
            ; INT     21H

            ; ;DISPLAY THE FILE CONTENT
            ; MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
            ; LEA     DX, SSBUFFER                        ;LOAD THE BUFFER ADDRESS
            ; INT     21H

            ; ;CLOSE THE FILE
            ; MOV     AH, 3EH                             
            ; MOV     BX, FILE_HANDLE                     
            ; INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE

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

            RET
    SUMMARY     ENDP

;WRITE RESERVATION TO FILE
    WRITERES    PROC
            ; MOV     AH, 3DH               ;DOS FUNCTION TO OPEN A FILE
            ; MOV     CX, 2                 ;APPEND MODE
            ; LEA     DX, RESFILE           ;LOAD THE FILENAME INTO DX
            ; INT     21H

            ; ;SET POINTER TO EOF
            ; MOV     AX, 4202H             ;DOS FUNCTION TO SET FILE POINTER
            ; MOV     BX, AX                ;FILE HANDLER
            ; MOV     CX, 0                 ;SET POINTER TO LEFT COL
            ; MOV     DX, 0                 ;SET POINTER TO TOP ROW
            ; INT     21H

            ; ;WRITE DATA TO FILE
            ; ;NAME
            ; MOV     AH, 40H                   ;DOS FUNCTION TO WRITE TO A FILE
            ; MOV     BX, AX                    ;FILE HANDLER
            ; MOV     CX, LENGTHOF SPACENAME    ;LENGTH OF DATA TO WRITE
            ; LEA     DX, ACTUALNAME            ;ADDRESS OF DATA TO WRITE
            ; INT     21H

            ; ;PAX
            ; MOV     AH, 40H                   ;DOS FUNCTION TO WRITE TO A FILE
            ; MOV     BX, AX                    ;FILE HANDLER
            ; MOV     CX, LENGTHOF PAX          ;LENGTH OF DATA TO WRITE
            ; LEA     DX, PAX                   ;ADDRESS OF DATA TO WRITE
            ; INT     21H

            ; ;DATE
            ; MOV     AH, 40H                   ;DOS FUNCTION TO WRITE TO A FILE
            ; MOV     BX, AX                    ;FILE HANDLER
            ; MOV     CX, LENGTHOF SPACEDATE    ;LENGTH OF DATA TO WRITE
            ; LEA     DX, ACTUALDATE            ;ADDRESS OF DATA TO WRITE
            ; INT     21H

            ; ;TIME
            ; MOV     AH, 40H                   ;DOS FUNCTION TO WRITE TO A FILE
            ; MOV     BX, AX                    ;FILE HANDLER
            ; MOV     CX, LENGTHOF SPACETIME    ;LENGTH OF DATA TO WRITE
            ; LEA     DX, ACTUALTIME            ;ADDRESS OF DATA TO WRITE
            ; INT     21H

            ; ;CLOSE THE FILE
            ; MOV     AH, 3EH                                     
            ; INT     21H                   ;DOS FUNCTION TO CLOSE A FILE
            RET
    WRITERES    ENDP
;===================================END OF FUNCTIONS===================================

;===================================START OF FOOTER====================================
    EXIT:   MOV     AX, 4C00H
            INT     21H

            MAIN    ENDP

END MAIN
;====================================END OF FOOTER=====================================