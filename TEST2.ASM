;TITLE
TITLE   ASSIGNMENT  MAINPROGRAM

.MODEL  SMALL
.STACK  64
.DATA

;-------------------------------------------------------------------------------------
;START OF VARIABLES DECLARATION
;=================================READ FILE VARIABLES=================================
;CHECK RESERVATION MENU
CHKMENU     DB      "checkres.txt", 0       ;FILENAME
CHKBUFFER   DB      900 DUP(?)              ;BUFFER TO STORE FILE CONTENT
FILE_HANDLE DW      ?                       ;FILE HANDLE
BYTESREAD   DW      0
;================================WRITE FILE VARIABLES=================================
RESFILE     DB      "resfile.txt", 0        ;FILENAME
RFBUFFER    DB      900 DUP(?)              ;BUFFER TO STORE FILE CONTENT
;=================================NEW LINE VARIABLES==================================
CR          EQU     0DH                     ;CARRIAGE RETURN SHORT FORM
LF          EQU     0AH                     ;LINE FEED SHORT FORM
NL          DB      13, 10, "$"             ;NEW LINE FOR FILE
;=================================PRINTING VARIABLES==================================
CHOICEMSG   DB      "INPUT YOUR CHOICE > $"
INVALIDMSG  DB      "INVALID CHOICE. PLEASE ENTER AGAIN", LF, CR, "$"
RETURNMSG   DB      "ENTER '#' TO RETURN TO FOOD MENU > $"

CUSTNO      DB      "CUSTOMER NO. $"

;SUMMARY
EVENTDIS    DB      "FUNCTION RESERVED: $"
SETDIS      DB      "SET ORDERED: $"
NAMEDIS     DB      "CUSTOMER NAME: $"
PAXDIS      DB      "PAX: $"
TABLEDIS    DB      "NO. OF TABLES: $"
DATEDIS     DB      "DATE: $"
TIMEDIS     DB      "TIME: $"
TOTALDIS    DB      "TOTAL: USD $"

;======================================CHAR INPUT=====================================
CHOICE      DB      ?

;==================================STRING VARIABLES===================================
;DISPLAY FULL NAME FOR EVENT
WEDDIS      DB      "WEDDING$"
EVTDIS      DB      "EVENT$"

;END OF VARIABLES DECLARATION
;-------------------------------------------------------------------------------------
;==================================START OF HEADER====================================
.CODE                                       ;DEFINE CODE SEGMENT

    MAIN    PROC FAR                        ;MAIN PROCEDURE START

    MOV     AX, @DATA
    MOV     DS, AX                          ;SET ADDRESS OF DATA SEGMENT IN DS
;====================================END OF HEADER====================================

;=============================START OF CHECK RESERVATION==============================
    ;PRINT CHECK RESERVATION MENU
    PRTCHK:         MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
                    MOV     AL, 0                               ;READ-ONLY MODE
                    LEA     DX, CHKMENU                         ;LOAD THE FILENAME INTO DX
                    INT     21H

                    ;READ THE FILE CONTENT
                    MOV     FILE_HANDLE, AX                     ;STORE THE FILE HANDLE
                    MOV     AH, 3FH                             ;DOS FUNCTION TO READ FROM A FILE
                    MOV     BX, FILE_HANDLE                     ;FILE HANDLE
                    MOV     CX, 900                             ;NUMBER OF BYTES TO READ AT A TIME
                    LEA     DX, CHKBUFFER                       ;BUFFER TO STORE THE CONTENT
                    INT     21H

                    ;DISPLAY THE FILE CONTENT
                    MOV     AH, 09H                             ;DOS FUNCTION TO DISPLAY A STRING
                    LEA     DX, CHKBUFFER                       ;LOAD THE BUFFER ADDRESS
                    INT     21H

                    ;CLOSE THE FILE
                    MOV     AH, 3EH                             
                    MOV     BX, FILE_HANDLE                     
                    INT     21H                                 ;DOS FUNCTION TO CLOSE A FILE

    CALL NEWLINE

    CALL PRTCHKRES

    ;GET USER CHOICE INPUT
    MOV     AH, 09H             ; DOS FUNCTION TO DISPLAY STRING
    LEA     DX, RETURNMSG
    INT     21H

    MOV     AH, 01H             ; READ CHARACTER FROM INPUT
    INT     21H

    MOV     CHOICE, AL          ; MOVE USER INPUT FROM AL TO CHOICE

    CMP     CHOICE, '#'         ; CHECK INPUT = '#'
    ;JE      RESERVATION 		;JUMP TO RESERVATION

    MOV     AH, 09H                             ;IF INVALID CHOICE, PRINT INVALIDMSG
    LEA     DX, INVALIDMSG
    INT     21H
    CALL    CLEARSCR
    JMP     PRTCHK                         ;JUMP TO PRINT MAIN PAGE

;===============================END OF CHECK RESERVATION===============================

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

;INVALID MSG
    INVALID     PROC
            MOV     AH, 09H                 ;IF INVALID CHOICE, PRINT INVALIDMSG
            LEA     DX, INVALIDMSG
            INT     21H

            MOV     AX, 0                   ;CLEAR AX

            CALL    LOADING
            RET
    INVALID     ENDP

;PRINT ALL RESERVATIONS
PRTCHKRES   PROC NEAR
    ;PRINT FILE CONTENT
    MOV     AH, 3DH                             ;DOS FUNCTION TO OPEN A FILE
    MOV     AL, 0                               ;READ-ONLY MODE
    LEA     DX, RESFILE                         ;LOAD THE FILENAME INTO DX
    INT     21H

    MOV     BX, FILE_HANDLE                     ;FILE HANDLE

    ;READ FILE LOOP
    MOV     SI, 1                   ;DECLARE SI TO DISPLAY CUST NO
    
    MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
    LEA     DX, CUSTNO
    INT     21H

    MOV     AH, 02H                 ;DOS FUNCTION FOR DISPLAY CHAR
    MOV     DX, SI                  ;DISPLAY CUST NO
    ADD     DL, 30H                 ;CONVERT TO HEX
    INT     21H
    INC     SI

    CALL    NEWLINE
    ;NAME
    MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
    LEA     DX, NAMEDIS
    INT     21H
                
    NAMELOOP:   MOV     AH, 3FH                 ;DOS FUNCTION TO READ FROM FILE
                MOV     CX, 1                   ;READ ONE CHAR
                LEA     DX, RFBUFFER            ;BUFFER TO STORE THE CONTENT
                INT     21H
                
                ;CHECK FOR CONCAT CHAR
                CMP     BYTE PTR [RFBUFFER], '~';CHECK FOR CONCAT
                JE      ORDER                   ;JUMP TO PRINT RESERVERED TYPE
                
                ;DISPLAY THE CHAR
                MOV     AH, 02H                 ;DOS FUNCTION TO DISPLAY A STRING
                MOV     DL, RFBUFFER            ;LOAD THE BUFFER ADDRESS
                INT     21H
                JMP     NAMELOOP

    ;ORDER
    ORDER:      CALL    NEWLINE
    ORDERLOOP:  MOV     AH, 3FH                 ;DOS FUNCTION TO READ FROM FILE
                MOV     CX, 1                   ;READ ONE CHAR
                LEA     DX, RFBUFFER            ;BUFFER TO STORE THE CONTENT
                INT     21H

                CMP     BYTE PTR [RFBUFFER], 'E';CHECK IF IS EVENT
                JE      DISPLAYE                ;JUMP TO DISPLAY EVENT 
                CMP     BYTE PTR [RFBUFFER], 'W';CHECK IF IS WEDDING
                JE      DISPLAYW                ;JUMP TO DISPLAY WEDDING 
                
                ;CHECK FOR CONCAT CHAR
                CMP     BYTE PTR [RFBUFFER], '~';CHECK FOR CONCAT
                JE      PAX                     ;JUMP TO PRINT RESERVERED TYPE
                 
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, SETDIS
                INT     21H

                ;DISPLAY THE CHAR
                MOV     AH, 02H                 ;DOS FUNCTION TO DISPLAY A STRING
                MOV     DL, RFBUFFER            ;LOAD THE BUFFER ADDRESS
                INT     21H
                JMP     ORDERLOOP    
    
    ;PAX
    PAX:        CALL    NEWLINE
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, PAXDIS
                INT     21H
                
    PAXLOOP:    MOV     AH, 3FH                 ;DOS FUNCTION TO READ FROM FILE
                MOV     CX, 1                   ;READ ONE CHAR
                LEA     DX, RFBUFFER            ;BUFFER TO STORE THE CONTENT
                INT     21H
                
                ;CHECK FOR CONCAT CHAR
                CMP     BYTE PTR [RFBUFFER], '~';CHECK FOR CONCAT
                JE      DATE                    ;JUMP TO PRINT RESERVERED TYPE
                
                ;DISPLAY THE CHAR
                MOV     AH, 02H                 ;DOS FUNCTION TO DISPLAY A STRING
                MOV     DL, RFBUFFER            ;LOAD THE BUFFER ADDRESS
                INT     21H
                JMP     PAXLOOP

    ;EVENTS
    DISPLAYE:   CALL    NEWLINE
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, EVENTDIS
                INT     21H

                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, EVTDIS
                INT     21H
                CALL    NEWLINE
                JMP     TABLE
                 
    DISPLAYW:   MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, EVENTDIS
                INT     21H

                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, WEDDIS
                INT     21H
                CALL    NEWLINE
    
    ;TABLE QTY
    TABLE:      MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, TABLEDIS
                INT     21H
    TABLELOOP:  MOV     AH, 3FH                 ;DOS FUNCTION TO READ FROM FILE
                MOV     CX, 1                   ;READ ONE CHAR
                LEA     DX, RFBUFFER            ;BUFFER TO STORE THE CONTENT
                INT     21H
                
                ;CHECK FOR CONCAT CHAR
                CMP     BYTE PTR [RFBUFFER], '~';CHECK FOR CONCAT
                JE      DATE                    ;JUMP TO PRINT RESERVERED TYPE
                
                ;DISPLAY THE CHAR
                MOV     AH, 02H                 ;DOS FUNCTION TO DISPLAY A STRING
                MOV     DL, RFBUFFER            ;LOAD THE BUFFER ADDRESS
                INT     21H
                JMP     TABLELOOP    
    
    ;DATE
    DATE:       CALL    NEWLINE
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, DATEDIS
                INT     21H

    DATELOOP:   MOV     AH, 3FH                 ;DOS FUNCTION TO READ FROM FILE
                MOV     CX, 1                   ;READ ONE CHAR
                LEA     DX, RFBUFFER            ;BUFFER TO STORE THE CONTENT
                INT     21H
                
                ;CHECK FOR CONCAT CHAR
                CMP     BYTE PTR [RFBUFFER], '~';CHECK FOR CONCAT
                JE      TIME                    ;JUMP TO PRINT RESERVERED TYPE
                
                ;DISPLAY THE CHAR
                MOV     AH, 02H                 ;DOS FUNCTION TO DISPLAY A STRING
                MOV     DL, RFBUFFER            ;LOAD THE BUFFER ADDRESS
                INT     21H
                JMP     DATELOOP    

    ;TIME
    TIME:       CALL    NEWLINE
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, TIMEDIS
                INT     21H

    TIMELOOP:   MOV     AH, 3FH                 ;DOS FUNCTION TO READ FROM FILE
                MOV     CX, 1                   ;READ ONE CHAR
                LEA     DX, RFBUFFER            ;BUFFER TO STORE THE CONTENT
                INT     21H
                
                ;CHECK FOR CONCAT CHAR
                CMP     BYTE PTR [RFBUFFER], '~';CHECK FOR CONCAT
                JE      TOTAL                   ;JUMP TO PRINT RESERVERED TYPE
                
                ;DISPLAY THE CHAR
                MOV     AH, 02H                 ;DOS FUNCTION TO DISPLAY A STRING
                MOV     DL, RFBUFFER            ;LOAD THE BUFFER ADDRESS
                INT     21H
                JMP     TIMELOOP    

    ;TOTAL
    TOTAL:      CALL    NEWLINE
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, TOTALDIS
                INT     21H

    TOTALLOOP:  MOV     AH, 3FH                 ;DOS FUNCTION TO READ FROM FILE
                MOV     CX, 1                   ;READ ONE CHAR
                LEA     DX, RFBUFFER            ;BUFFER TO STORE THE CONTENT
                INT     21H

                ;CHECK FOR CONCAT CHAR
                CMP     BYTE PTR [RFBUFFER], '~';CHECK FOR NEXT LINE
                JE      EOL                     ;JUMP TO PRINT RESERVERED TYPE

                ;DISPLAY THE CHAR
                MOV     AH, 02H                 ;DOS FUNCTION TO DISPLAY A CHAR
                MOV     DL, RFBUFFER            ;LOAD THE BUFFER ADDRESS
                INT     21H
                JMP     TOTALLOOP

    ;DISPLAY NEXT RESERVATION
    EOL:        MOV     AH, 3FH                 ;DOS FUNCTION TO READ FROM FILE
                MOV     CX, 2                   ;READ 2 CHAR
                LEA     DX, RFBUFFER            ;BUFFER TO STORE THE CONTENT
                INT     21H

                CALL    NEWLINE
                CALL    NEWLINE

                MOV     AH, 3FH                 ;DOS FUNCTION TO READ FROM FILE
                MOV     CX, 1                   ;READ 1 CHAR
                LEA     DX, RFBUFFER            ;BUFFER TO STORE THE CONTENT
                INT     21H

                CMP     AX, 0                   ;CHECK IF IS EOF
                JE      DONEDIS                 ;JUMP TO DONEDIS IF EOF

                ;IF NOT EOF
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, CUSTNO
                INT     21H

                MOV     AH, 02H                 ;DOS FUNCTION FOR DISPLAY CHAR
                MOV     DX, SI                  ;DISPLAY CUST NO
                ADD     DL, 30H                 ;CONVERT TO HEX
                INT     21H
                INC     SI

                CALL    NEWLINE
                ;NAME
                MOV     AH, 09H                 ;DOS FUNCTION FOR DISPLAY STRING
                LEA     DX, NAMEDIS
                INT     21H

                MOV     AH, 02H                 ;DOS FUNCTION TO DISPLAY A CHAR
                MOV     DL, RFBUFFER            ;LOAD THE BUFFER ADDRESS
                INT     21H
                JMP     NAMELOOP


    DONEDIS:    ;CLOSE THE FILE
                MOV     AH, 3EH                             
                MOV     BX, FILE_HANDLE                     
                INT     21H                     ;DOS FUNCTION TO CLOSE A FILE

                RET
    PRTCHKRES   ENDP
;===================================END OF FUNCTIONS===================================

;===================================START OF FOOTER====================================
    EXIT:   MOV     AX, 4C00H
            INT     21H

            MAIN    ENDP

END MAIN
;====================================END OF FOOTER=====================================