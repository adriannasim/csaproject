TITLE   ASSIGNMENT  TEST MENU

.MODEL  SMALL
.STACK  64
.DATA

MSG1    DB      "HELLO WORLD$"
CR      EQU     0DH                 ;CARRIAGE RETURN SHORT FORM
LF      EQU     0AH                 ;LINE FEED SHORT FORM

;-------------------------------------------------------------------------
;START OF HEADER
.CODE                               ;DEFINE CODE SEGMENT

    MAIN    PROC FAR                ;MAIN PROCEDURE START

    MOV     AX, @DATA
    MOV     DS, AX                  ;SET ADDRESS OF DATA SEGMENT IN DS
;END OF HEADER

;START OF MAIN MENU
    MOV     AH, 09H
    LEA     DX, MSG1
    INT     21H
;END OF MAIN MENU

;START OF FOOTER
    MOV     AX, 4C00H
    INT     21H

    MAIN    ENDP

END MAIN
;END OF FOOTER