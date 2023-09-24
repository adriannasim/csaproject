;TITLE
TITLE   ASSIGNMENT  MAINPROGRAM

.MODEL  SMALL
.STACK  64
.DATA

;-------------------------------------------------------------------------------------
;START OF VARIABLES DECLARATION
;=================================READ FILE VARIABLES=================================
;EVENT RESERVATION MENU
EVENTMENU   DB      "eventres.txt", 0       ;FILENAME
EMBUFFER    DB      900 DUP(?)              ;BUFFER TO STORE FILE CONTENT

;================================WRITE FILE VARIABLES=================================
RESFILE     DB      "resfile.txt", 0        ;FILENAME
RFLENGTH    DW      ?                       ;FILE SIZE

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
TIMEMSG     DB      "ENTER RESERVATION TIME (HH:MM)> $"
;MEMBER
MEMBERMSG   DB      "MEMBER? > $"
;TABLE
TABLEMSG    DB      "ENTER NO. OF TABLES: $"

;FOR DISPLAY 
;INVALID
INVALIDMSG  DB      "INVALID INPUT. PLEASE ENTER AGAIN", LF, CR, "$"
;SUMMARY
EVENTDIS    DB      "FUNCTION RESERVED: $"
TABLEDIS    DB      "NO. OF TABLES: $"
NAMEDIS     DB      "CUSTOMER NAME: $"
PAXDIS      DB      "PAX: $"
DATEDIS     DB      "DATE: $"
TIMEDIS     DB      "TIME: $"
TOTALDIS    DB      "TOTAL: USD $"

;======================================CHAR INPUT=====================================
CHOICE      DB      ?
MEMBER      DB      ?
PAX         DB      ?
ORDSET      DB      ?
INTABLE     DB      ?
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
MAXTIME     DB      6
ACTUALTIME  DB      ?
SPACETIME   DB      6 DUP(' ')

;DISPLAY FULL NAME FOR EVENT
WEDDIS      DB      "WEDDING$"
EVTDIS      DB      "EVENT$"
;=====================================CONSTANTS=======================================
;NEW LINE
CR          EQU     0DH                     ;CARRIAGE RETURN SHORT FORM
LF          EQU     0AH                     ;LINE FEED SHORT FORM

;EVENT PRICE
EPRICE      DW      45
WPRICE      DW      50

;SST AND SERVICE CHARGE
SST         DW      106
SRVC        DW      105

;SCALING FACTOR
SCALE       DW      10000

;CONCAT
CONCAT      DB      '~'
;==============================VARIABLES FOR CALCULATION===============================
TOTALSTR    DB      7 DUP (' ')
INTEGER     DW      ?
DECIMAL     DW      ?
TOTAL       DW      ?
QUOTIENT    DW      ?
REMAINDER   DW      ?
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
    EVENTRES:        CALL    CLEARSCR
                    ; MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
                    ; MOV     AL, 0                               ;READ-ONLY MODE
                    ; LEA     DX, EVENTMENU                        ;LOAD THE FILENAME INTO DX
                    ; INT     21H

                    ; ;READ THE FILE CONTENT
                    ; MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
                    ; MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
                    ; MOV     BX, FILE_HANDLE                     ;FILE HANDLE
                    ; MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
                    ; LEA     DX, EMBUFFER                        ;BUFFER TO STORE THE CONTENT
                    ; INT     21H

                    ; ;DISPLAY THE FILE CONTENT
                    ; MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
                    ; LEA     DX, EMBUFFER                        ;LOAD THE BUFFER ADDRESS
                    ; INT     21H

                    ; ;CLOSE THE FILE
                    ; MOV     AH, 3EH                             
                    ; MOV     BX, FILE_HANDLE                     
                    ; INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE
    CALL NEWLINE

        ;GET USER CHOICE INPUT
        ECHOOSE:     MOV	    AH, 09H                             ;DOS FUNCTION TO DISPLAY STRING
                        LEA	    DX, CHOICEMSG
                        INT	    21H

                        MOV	    AH, 01H
                        INT	    21H			                        ;GET USER CHAR INPUT

                        MOV     CHOICE, AL                          ;MOVE USER INPUT FROM AL TO STORE IN CHOICE

                        CALL    NEWLINE

        ETYPE:  CMP     CHOICE, '1'                         ;CHECK IF USER INPUT IS 1
                MOV     ORDSET, 'E'                          ;STORE EVENT TYPE AS E
                JE      EV                                  ;JUMP TO SET A

                CMP     CHOICE, '2'                         ;CHECK IF USER INPUT IS 2
                MOV     ORDSET, 'W'                          ;STORE EVENT TYPE AS W
                JE      WED                                 ;JUMP TO SET B

                CMP     CHOICE, '3'                         ;CHECK IF USER INPUT IS 3
                ;JE 	    MAKERES                             ;RETURN BACK TO MAIN MENU

        CALL    INVALID
        JMP     EVENTRES                           ;JUMP TO PRINT EVENT RESERVATION PAGE

        EV:     CALL    GETTAB                  ;GET TABLE QTY
                
                MOV     AH, 0
                MUL     EPRICE
                MOV     TOTAL, AX

                CALL    NEWLINE
                CALL    DETAILS                 ;CALL DETAILS FUNCTION TO GET RESERVATION DETAILS       
                CALL    CHKMEM                  ;CALL FUNCTION TO CHECK FOR MEMBER STATUS AND CALCULATE FINAL TOTAL

        WED:    CALL    GETTAB                  ;GET TABLE QTY
                
                MOV     AH, 0
                MUL     WPRICE
                MOV     TOTAL, AX

                CALL    NEWLINE
                CALL    DETAILS                 ;CALL DETAILS FUNCTION TO GET RESERVATION DETAILS       
                CALL    CHKMEM                  ;CALL FUNCTION TO CHECK FOR MEMBER STATUS AND CALCULATE FINAL TOTAL
        
        CALL    CLEARSCR
        ;DISPLAY SUMMARY
        CALL    SUMMARY                 ;CALL SUMMARY FUNCTION
        ;CALL    WRITERES                  ;CALL WRITE FILE FUCTION

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
            CALL    CLEARSCR
            RET
    INVALID     ENDP

;GET TABLE QTY
    GETTAB      PROC
            MOV     AX, 0                   ;CLEAR AX  
            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, TABLEMSG
            INT     21H

            MOV	    AH, 01H
            INT	    21H			            ;GET USER PAX INPUT
            MOV     INTABLE, AL             ;STORE USER INPUT IN PAX
            SUB     AL, 30H                 ;CONVERT ASCII TO REAL VALUE

            CMP     AL, 1
            JL      INVALIDTAB
            CMP     AL, 9
            JG      INVALIDTAB

            RET
    GETTAB      ENDP
    
;INVALID TABLE QTY
    INVALIDTAB      PROC
            CALL    NEWLINE
            CALL    INVALID                 ;CALL INVALID MSG
            JMP     ETYPE                   ;GO BACK TO ASKING FOR TABLE QTY
    INVALIDTAB      ENDP

;GET DETAILS
    DETAILS    PROC
            ;NAME
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
                CMP     ORDSET, 'E'             ;COMPARE ORDSET WITH E
                JE      EVTDISC                 ;IF YES, JUMP TO CALEVT
                CMP     ORDSET, 'W'             ;COMPARE ORDSET WITH W
                JE      EVTDISC                 ;IF YES, JUMP TO CALEVT
                
                SUB     AX, 5                   ;SUBTRACT 5 AS A DISCOUNT
                JMP     CALTOTAL                ;IF NOT, JUMP TO CALTOTAL
    
    EVTDISC:    SUB     AX, 15                  ;SUBTRACT 15 AS A DISCOUNT
                JMP     CALTOTAL                ;JUMP TO CALTOTAL

    ;NO MEMBER
    NOMEM:      MOV     AX, TOTAL               ;MOVE TOTAL TO AX FOR CALCULATIONS

    CALTOTAL:   MUL     SST                     ;MULTIPLY AX WITH SST            
                MUL     SRVC                    ;MULTIPLY AX WITH SST
                DIV     SCALE                   ;DIVIDE WITH SCALING FACTOR

                MOV     INTEGER, AX             ;STORE THE QUOTIENT TO INTEGER
                MOV     DECIMAL, DX             ;STORE THE REMAINDER TO DECIMAL

                CALL    CLEARSCR

                RET
    CHKMEM      ENDP

;PRINT SUMMARY
    SUMMARY     PROC
            ;SPASH SCREEN
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

            MOV     AX, 0                   ;CLEAR AX
            ;NAME
            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, NAMEDIS
            INT     21H

            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, SPACENAME
            INT     21H

            CALL   NEWLINE                  ;NEXT LINE

            CMP     ORDSET, 'E'                 ;CHECK IF ORDSET IS E
            JE      PRTEVT                      ;JUMP TO PRTEVT
            CMP     ORDSET, 'W'                 ;CHECK IF ORDSET IS E
            JE      PRTEVT                      ;JUMP TO PRTEVT
            
            ;INDIVIDUAL RESERVATION
            ;PAX
            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, PAXDIS
            INT     21H

            MOV     DX, 0                   ;CLEAR DX
            MOV     AH, 02H                 ;DOS FUNCTION FOR DISPLAY CHAR
            MOV     DL, PAX
            INT     21H

            CALL    NEWLINE

            ;ORDERED SET
            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, SETDIS
            INT     21H

            MOV     DX, 0                   ;CLEAR DX
            MOV     AH, 02H                 ;DOS FUNCTION FOR DISPLAY CHAR
            MOV     DL, ORDSET
            INT     21H

            JMP     CONTDIS
            ;EVENT RESERVATION
            ;RESERVED EVENT
            PRTEVT:     ;PAX
                        MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                        LEA     DX, TABLEDIS
                        INT     21H
                        
                        MOV     AX, 0                   ;CLEAR AX
                        MOV     AH, 02H                 ;DOS FUNCTION FOR DISPLAY CHAR
                        MOV     DL, INTABLE
                        INT     21H

                        CALL    NEWLINE

                        MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                        LEA     DX, EVENTDIS
                        INT     21H

                        CMP     ORDSET, 'E'
                        JE      SUME
    
                        MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                        LEA     DX, WEDDIS
                        INT     21H
                        JMP     CONTDIS

            SUME:       MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                        LEA     DX, EVTDIS
                        INT     21H

            CONTDIS:
            CALL    NEWLINE

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
            ;STORE INTEGER
            NOROUND:    MOV     AX, INTEGER             ;STORE INTEGER INTO AX
                        MOV     SI, 0                   ;DECLARE SI AS INDEX
                        MOV     DX, 0                   ;CLEAR DX
                        MOV     BX, 10                  ;STORE 10 IN BX FOR DIVISION
                        DIV     BX                      ;AX/10, QUOTIENT IS STORED IN AX AND REMAINDER IS STORE IN DX
                        CMP     AX, 9                   ;COMPARE AX WITH 9
                        JG      THREEINT                ;JUMP TO THREE INTEGER IF THERE'S 3 INT

                        ADD     AL, 30H                 ;CONVERT VALUE TO ASCII
                        MOV     TOTALSTR[SI], AL        ;MOVE INTEGER INTO ARRAY FOR TWO INT
                        INC     SI                      ;STORE TO NEXT INDEX
                        ADD     DL, 30H                 ;CONVERT VALUE TO ASCII
                        MOV     TOTALSTR[SI], DL        ;STORE SECOND INDEX
                        INC     SI                      ;STORE TO NEXT INDEX
                        MOV     TOTALSTR[SI], '.'       ;STORE DOT IN THE 3RD INDEX
                        JMP     STOREDECIMAL            ;JUMP TO STORE DECIMAL

            THREEINT:   ADD     DL, 30H                 ;CONVERT VALUE TO ASCII
                        MOV     TOTALSTR[2], DL         ;IF 3 INTS, STORE DIGIT INTO 3RD INDEX FIRST
                        MOV     DX, 0                   ;CLEAR DX
                        MOV     BX, 10                  ;STORE 10 IN BX FOR DIVISION
                        DIV     BX                      ;AX/10, QUOTIENT IS STORED IN AX AND REMAINDER IS STORE IN DX
                        ADD     AL, 30H                 ;CONVERT VALUE TO ASCII
                        MOV     TOTALSTR[SI], AL        ;MOVE INTEGER INTO 1ST INDEX IN ARRAY
                        INC     SI                      ;STORE TO NEXT INDEX
                        ADD     DL, 30H                 ;CONVERT VALUE TO ASCII
                        MOV     TOTALSTR[SI], DL        ;STORE SECOND INDEX
                        MOV     SI, 3                   ;START FROM THE 4TH INDEX
                        MOV     TOTALSTR[SI], '.'       ;STORE DOT IN THE 4TH INDEX

            ;STORE DECIMAL
            STOREDECIMAL:   MOV     AX, DECIMAL         ;STORE THE DECIMAL BACK TO AX
                            MOV     DX, 0               ;CLEAR DX
                            MOV     BX, 10              ;STORE 10 IN BX FOR DIVISION
                            DIV     BX                  ;AX/10, QUOTIENT IS STORED IN AX AND REMAINDER IS STORE IN DX
                            INC     SI
                            ADD     AL, 30H             ;CONVERT VALUE TO ASCII
                            MOV     TOTALSTR[SI], AL    ;STORE FIRST DECIMAL
                            INC     SI
                            ADD     DL, 30H             ;CONVERT VALUE TO ASCII
                            MOV     TOTALSTR[SI], DL    ;STORE SECOND DECIMAL
                            INC     SI
                            MOV     TOTALSTR[SI], '$'   ;TERMINATE THE STRING
            
            MOV     AX, 0                   ;CLEAR AX
            ;DISPLAY TOTAL
            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, TOTALDIS
            INT     21H

            MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            LEA     DX, TOTALSTR
            INT     21H
            
            RET             ;RETURN ONCE DONE DISPLAYING      
    SUMMARY     ENDP

;WRITE RESERVATION TO FILE
    WRITERES    PROC
            ; MOV     AH, 3CH               ;DOS FUNCTION TO CREATE A FILE
            ; MOV     CX, 2                 ;APPEND MODE
            ; LEA     DX, SPACENAME         ;LOAD THE FILENAME INTO DX
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
            ; MOV     CX, 20                    ;LENGTH OF DATA TO WRITE
            ; LEA     DX, ACTUALNAME            ;ADDRESS OF DATA TO WRITE
            ; INT     21H

           ; ;SET ORDERED
        ;     MOV     AH, 40H                   ;DOS FUNCTION TO WRITE TO A FILE
        ;     MOV     BX, AX                    ;FILE HANDLER
        ;     MOV     CX, LENGTHOF ORDSET       ;LENGTH OF DATA TO WRITE
        ;     LEA     DX, ORDSET                ;ADDRESS OF DATA TO WRITE
        ;     INT     21H

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
    WRITEEVT    ENDP
;===================================END OF FUNCTIONS===================================

;===================================START OF FOOTER====================================
    EXIT:   MOV     AX, 4C00H
            INT     21H

            MAIN    ENDP

END MAIN
;====================================END OF FOOTER=====================================