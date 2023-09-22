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
TIMEMSG     DB      "ENTER RESERVATION TIME (HH:MM)> $"
;MEMBER
MEMBERMSG   DB      "MEMBER? > $"

;FOR DISPLAY 
;INVALID
INVALIDMSG  DB      "INVALID INPUT. PLEASE ENTER AGAIN", LF, CR, "$"
;SUMMARY
SETMSG      DB      "SET ORDERED: $"
NAMEDIS     DB      "CUSTOMER NAME: $"
PAXDIS      DB      "PAX: $"
DATEDIS     DB      "DATE: $"
TIMEDIS     DB      "TIME: $"
TOTALDIS    DB      "TOTAL: $"

;======================================CHAR INPUT=====================================
CHOICE      DB      ?
MEMBER      DB      ?
PAX         DB      ?
ORDSET      DB      ?
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
MAXTIME     DB      5
ACTUALTIME  DB      ?
SPACETIME   DB      5 DUP(' ')

;=====================================CONSTANTS=======================================
;NEW LINE
CR          EQU     0DH                     ;CARRIAGE RETURN SHORT FORM
LF          EQU     0AH                     ;LINE FEED SHORT FORM

;SET MENU PRICE
ASET        DW      5
BSET        DW      10
CSET        DW      20

;SST AND SERVICE CHARGE
SST         DW      106
SRVC        DW      105

;SCALING FACTOR
SCALE       DW      10000

;==============================VARIABLES FOR CALCULATION===============================

COVDEC      DB      ?, ?
INTEGER     DW      ?
DECIMAL     DW      ?
TOTAL       DW      15
QUOTIENT    DW      ?
REMAINDER   DW      ?

LEADNO      DB      ?
MULTIPLIER  DW      ?
CONSTANT    DW      10
STRTOTAL    DB      7 DUP(' ')
;END OF VARIABLES DECLARATION
;-------------------------------------------------------------------------------------
;==================================START OF HEADER====================================
.CODE                                       ;DEFINE CODE SEGMENT

    MAIN    PROC FAR                        ;MAIN PROCEDURE START

    MOV     AX, @DATA
    MOV     DS, AX                          ;SET ADDRESS OF DATA SEGMENT IN DS
;====================================END OF HEADER====================================

;===========================START OF INDIVIDUAL RESERVATION===========================        
    ;HAS MEMBER
        MOV     AX, TOTAL               ;MOVE TOTAL TO AX FOR CALCULATIONS

        MUL     SST                     ;MULTIPLY AX WITH SST            
        MUL     SRVC                    ;MULTIPLY AX WITH SST
        DIV     SCALE                   ;DIVIDE WITH SCALING FACTOR

        SUB     AX, 5                   ;SUBTRACT 5 AS A DISCOUNT

        MOV     TOTAL, AX

            CALL    NEWLINE

        MOV LEADNO, 0H ; set to false
        MOV MULTIPLIER, 10000D
        MOV SI, 0
        TOSTRING:
            MOV DX, 0
            MOV AX, TOTAL
            MOV TOTAL, DX
            ; quotient in ax & remainder in dx

            CMP AL, 0H
            JNZ STORE
            CMP LEADNO, 0H
            JMP SKIPSTORE

            STORE:
            MOV LEADNO, 1H
            ADD AL, 30H
            MOV STRTOTAL[SI], AL
            INC SI
            
            SKIPSTORE:
            MOV DX, 0
            MOV AX, MULTIPLIER
            DIV CONSTANT
            MOV MULTIPLIER, AX

            CMP MULTIPLIER, 10D
            JNZ SKIPDOT
            MOV STRTOTAL[SI], 2EH
            INC SI

            SKIPDOT:
            CMP MULTIPLIER, 0H
            JNZ TOSTRING

        MOV STRTOTAL[SI], '$'

        MOV AH, 09H
        LEA DX, STRTOTAL
        INT 21H

        ; CALL STRTOTAL
        ; SUB SI, 2 ;get the value to determine to round up or round down
        ; ;round off
        ; MOV AL, [SI]
        ; CMP AL, '5'
        ; JGE ROUND_UP
        ; ROUND_DOWN:
        ;     JMP RETURN_ROUND_OFF_FUNCTION
        ; ROUND_UP:
        ;     MOV AL,'0'
        ;     MOV [SI], AL
        ;     DEC SI
        ;     MOV AL, [SI]
        ;     INC AL
        ;     CMP AL, 3AH
        ;     JE ADD_DIGIT_INFRONT_ONE
        ;     MOV [SI],AL
        ;     JMP RETURN_ROUND_OFF_FUNCTION

        ;     ADD_DIGIT_INFRONT_ONE:
        ;         MOV AL,'0'
        ;         MOV [SI], AL
        ;         DEC SI
        ;         MOV AL, [SI]
        ;         INC AL
        ;         CMP AL, 3AH
        ;         JE ADD_DIGIT_INFRONT_ONE
        ;     MOV [SI],AL
            ; ;TOTAL AMOUNT
            ; MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
            ; LEA     DX, TOTALDIS
            ; INT     21H

            ; ;CHECK IF TOTAL NEEDS ROUNDING
            ; MOV     DX, 0                   ;CLEAR DX
            ; MOV     AX, DECIMAL             ;MOVE DECIMAL TO AX
            ; MOV     BX, 100                 ;STORE 10 IN BX FOR DIVISION
            ; DIV     BX                      ;AX/100, QUOTIENT IN AX, REMAINDER IN DX
            ; CMP     DX, 50                  ;COMPARE DX(3RD DECIMAL PLACE) TO 50
            ; JAE     ROUNDUP                 ;IF MORE THAN 50, GO TO ROUND UP

            ; ROUNDUP:    INC     AL                      ;AL(SECOND DECIMAL)++
            ;             CMP     AX, 100                 ;CHECK IF THE DECIMAL NEEDS TO CARRY TO THE INTEGER
            ;             JAE     CARRYTOINT              ;JUMP TO CARRYTOFIRST
            ;             MOV     DECIMAL, AX
            ;             JMP     NOROUND                 ;IF NO CARRY

            ; CARRYTOINT:     MOV     AX, 00H             ;CHANGE AX TO 00
            ;                 MOV     DECIMAL, AX         ;CHANGE VALUE IN DECIMAL TO 0
            ;                 MOV     CX, INTEGER         ;STORE INTEGER TO CX
            ;                 ADD     CX, 1               ;CX++
            ;                 MOV     INTEGER, CX         ;STORE CX BACK TO INTEGER
            ;                 JMP     NOROUND             ;GO TO DISPLAY

            ; ;NO NEED ROUNDING UP
            ; ;DIPLAY INTEGER
            ; NOROUND:    MOV     AX, INTEGER             ;STORE INTEGER INTO AX
            ;             MOV     SI, 3
            ;             INTEGERLOOP:    MOV     DX, 0           ;CLEAR DX
            ;                             MOV     BX, 10          ;STORE 10 IN BX FOR DIVISION
            ;                             DIV     BX              ;AX/10, QUOTIENT IS STORED IN AX AND REMAINDER IS STORE IN DX
            ;                             MOV     REMAINDER, AX   ;STORE REMAINDER
            ;                             MOV     COVINT[SI], DL  ;MOVE INTEGER INTO ARRAY

            ;                             MOV     AX, REMAINDER   ;MOVE UNDISPLAYED VALUE TO AX
            ;                             DEC     SI              ;NEXT INT
            ;                             CMP     AX, 0           ;SEE IF IT HAS UNDISPLAYED VALUE
            ;                             JNZ     INTEGERLOOP     ;JUMP TO INTEGERLOOP IF YES

            ;             MOV     SI, 0
            ;             MOV     CX, 3
            ;             DISINT:         MOV     AH, 02H         ;DOS FUNCTION TO DISPLAY CHAR
            ;                             MOV     DL, COVINT[SI]  ;MOVE INT TO DL TO BE DISPLAYED
            ;                             ADD     DL, 30H         ;CONVERT VALUE TO ASCII
            ;                             INT     21H             ;DISPLAY ASCII VALUE
            ;                             INC     SI
            ;                             LOOP    DISINT

            ;             ;DISPLAY DECIMAL
            ;             MOV     AH, 02H                 ;DOS FUNCTION TO DISPLAY CHAR
            ;             MOV     DL, '.'                 ;DISPLAY DECIMAL DOT
            ;             INT     21H

            ;             MOV     AX, DECIMAL             ;STORE THE DECIMAL BACK TO AX
            ;             MOV     SI, 2
            ;             MOV     DI, 0
            ;             DECIMALLOOP:    MOV     DX, 0           ;CLEAR DX
            ;                             MOV     BX, 10          ;STORE 10 IN BX FOR DIVISION
            ;                             DIV     BX              ;AX/10, QUOTIENT IS STORED IN AX AND REMAINDER IS STORE IN DX
            ;                             MOV     REMAINDER, DX   ;STORE REMAINDER
            ;                             MOV     COVDEC[DI], AL
                                        
            ;                             MOV     AH, 02H         ;DOS FUNCTION TO DISPLAY CHAR
            ;                             MOV     DL, COVDEC[DI]
            ;                             ADD     DL, 30H         ;CONVERT VALUE TO ASCII
            ;                             INT     21H             ;DISPLAY CHAR

            ;                             INC     DI
            ;                             DEC     SI              ;SI--
            ;                             JNZ     DECIMALLOOP     ;LOOP BACK IF NOT FINISH
            
            CALL    NEWLINE
    ;NEW LINE
    NEWLINE     PROC
            MOV     AH, 02H
            MOV     DL, LF
            INT     21H
            MOV     DL, CR
            INT     21H
            RET  
    NEWLINE   ENDP
;===================================START OF FOOTER====================================
    EXIT:   MOV     AX, 4C00H
            INT     21H

            MAIN    ENDP

END MAIN
;====================================END OF FOOTER=====================================