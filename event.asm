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
RFBUFFER    EQU      100                    ;BUFFER TO STORE FILE CONTENT

;=================================PRINTING VARIABLES==================================
;FOR USER INPUT
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
EVENTDIS    DB      "SET ORDERED: $"
EVENT       DB      "EVENT$"
EVENTMEM    DB      "70.25$"
EVENTXMEM   DB      "70.25$"
NAMEDIS     DB      "CUSTOMER NAME: $"
PAXDIS      DB      "PAX: $"
DATEDIS     DB      "DATE: $"
TIMEDIS     DB      "TIME: $"
TOTALDIS    DB      "TOTAL: USD $"

;======================================CHAR INPUT=====================================
CHOICE      DB      ?
MEMBER      DB      ?
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
MAXTIME     DB      5
ACTUALTIME  DB      ?
SPACETIME   DB      5 DUP(' ')

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

        CALL    EDETAILS                 ;CALL DETAILS FUNCTION TO GET RESERVATION DETAILS       
        CALL    CHKEMEM                  ;CALL FUNCTION TO CHECK FOR MEMBER STATUS AND CALCULATE FINAL TOTAL
        
        
        ;DISPLAY SUMMARY
        
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

;GET EVENT DETAILS
    EDETAILS    PROC
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
    EDETAILS    ENDP

;CHECK MEMBER FOR EVENT
    CHKEMEM      PROC
    MEMLOOP:    MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, MEMBERMSG
                INT     21H

                MOV	    AH, 01H
                INT	    21H			            ;GET USER CHAR INPUT

                MOV     MEMBER, AL              ;STORE USER INPUT TO MEMBER

                CALL    NEWLINE

                ;IF CUSTOMER IS A MEMBER
                CMP     MEMBER, 'Y'
                JE      GOTEMEM                  ;JUMP TO CALCULATION WITH MEMBER DISCOUNT
                CMP     MEMBER, 'y'
                JE      GOTEMEM                  ;JUMP TO CALCULATION WITH MEMBER DISCOUNT

                ;IF CUSTOMER IS A MEMBER
                CMP     MEMBER, 'N'
                JE      NOEMEM                   ;JUMP TO CALCULATION WITH MEMBER DISCOUNT
                CMP     MEMBER, 'n'
                JE      NOEMEM                   ;JUMP TO CALCULATION WITH MEMBER DISCOUNT

                ;INVALID INPUT
                MOV     AH, 09H                 ;IF INVALID CHOICE, PRINT INVALIDMSG
                LEA     DX, INVALIDMSG
                INT     21H
                CALL    NEWLINE
                JMP     MEMLOOP                 ;JUMP TO MEMLOOP

    ;HAS MEMBER
    GOTEMEM:    CALL    CLEARSCR
                CALL    ESUMMARY                 ;CALL SUMMARY FUNCTION
                ;TOTAL
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, EVENTMEM
                INT     21H 
                RET

    ;NO MEMBER
    NOEMEM:     CALL    CLEARSCR
                CALL    ESUMMARY                 ;CALL SUMMARY FUNCTION
                ;TOTAL
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, EVENTXMEM
                INT     21H 
                RET
    CHKEMEM      ENDP

;PRINT EVENT SUMMARY
    ESUMMARY     PROC
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
            
            RET             ;RETURN ONCE DONE DISPLAYING      
    ESUMMARY     ENDP

;WRITE RESERVATION TO FILE
    WRITEEVT    PROC
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