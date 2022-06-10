.MODEL small 
.STACK 256 ; STACK

;==============================================================================
; DATA
;==============================================================================
.DATA
    ROW       DB     00
    COL       DB     00
    Ltop      DB     00
    InKey     DB     00           ; Keep the status of insert key
    LO        DW     0

	;---------------------------------------
	; boundary for right, left, down, top
	;---------------------------------------
    Rlimit    EQU    79
    Llimit    EQU    00
    Dlimit    EQU    21
    Tlimit    EQU    02
    CHlimit   EQU    79
	;------------------------------------

    Str1      DB     8000 DUP(20H), 20H ; Buffer for content
    LIST      LABEL  BYTE
    MAX_L     DB     21
    LEN       DB     ?
    INDATA1   DB     23 DUP(' ')  ; Buffer for file name
    filenum   DB     0
    FILHAND   DW     ?
    ERROR     DB     '******ERROR******','$'
    NEW       DB     'FNEW.txt',0

.CODE
    MAIN    PROC    FAR
        MOV    AX, @DATA           ; Loading starting address of data segment in ax
        MOV    DS, AX              ; Initialize DS
        MOV    ES, AX              ; Initialize ES
        MOV    AX, 0600H           ; Scroll up window and clear
        CALL   ChPage              ; Scroll screen to clean

        CMP    AX, 00             ; Check show mouse cursor return value
        JE     InitialFail        ; Fail when initital moouse
		;-----------------------------------

        CALL   MENUBAR            ; Show menu bar
        CALL   First              ; Create new file

        MOV    COL, 0		      ; Set cursor column location
        MOV    ROW, 2		      ; Set cursor row location

GetKey:
        CALL   NUMCAPS            ; Check Num Lock and Caps Lock
        CALL   SETLO              ; Move cursot location according COL and ROW
        CALL   KEYIN              ; Get user input
        JMP    GetKey             ; Go back for getting user input

InitialFail:
		;-----------------------------------
		; Exit program
		;-----------------------------------
        MOV    AX, 4C00H
        INT    21H
		;-----------------------------------
    MAIN    ENDP

.386

    ;---------------------------------------
    ; Check status of Num Lock and Caps Lcok
    ;---------------------------------------
    NUMCAPS    PROC    NEAR
        PUSH   CX
        PUSH   AX
        MOV    DH, COL
        MOV    DL, ROW
        PUSH   DX	              ; Backup COL and ROW
        ; Caps Lock
        MOV    ROW, 24            ; Row location of cursor
        MOV    COL, 65            ; Column location of cursor
        CALL   SETLO              ; Move cursor to show Caps Lock information
        MOV    AH, 02H
        INT    16H                ; INT 16H,02H - ck
        MOV    AH, 02H            ; INT 21H,02H - write character to STDOUT
        JNZ    CAPSON             ; Jump short if not zero (ZF=0)
        MOV    CX, 04
        MOV    DL, 20H            ; Set the character writen to STDOUT to spcae 
CAPSOFF:
        INT    21H
        LOOP   CAPSOFF            ; Loop to clean Caps Lock information
        JMP    num
CAPSON: MOV    DL, 'C'            ; Show CAPS
        INT    21H
        MOV    DL, 'a'
        INT    21H
        MOV    DL, 'p'
        INT    21H
        MOV    DL, 's'
        INT    21H
num:    ; Num Lock
        MOV    COL, 70            ; Column location of cursor
        CALL   SETLO              ; Move cursor to show Num Lock information
		MOV    AH, 12H
        INT    16H                ; INT 16H,12H - query extended keyboard shift status
        AND    AL, 00100000B      ; Check Num Lock)
        MOV    AH, 02H
        JNZ    NUMON              ; Jump short if not zero (ZF = 0)
        MOV    CX, 03
        MOV    DL, 20H            ; Set the character writen to STDOUT to spcae 
NUMOFF:
        INT    21H
        LOOP   NUMOFF             ; Loop to clean Num Lock information
        JMP    FINISH
NUMON:  MOV    DL, 'N'            ; Show NUM
        INT    21H
        MOV    DL, 'u'
        INT    21H
        MOV    DL, 'm'
        INT    21H

FINISH:
        POP    DX                 ; Restore COL and ROW
        MOV    COL, DH
        MOV    ROW, DL
        POP    AX
        POP    CX
        RET
    NUMCAPS    ENDP
    ;---------------------------------------
    ; End of check status of Num Lock and Caps Lcok
    ;---------------------------------------

	;---------------------------------------
	; Create new file
	;---------------------------------------
    First    PROC    NEAR
        MOV    AH, 3CH
        MOV    CX, 00             ; Normal file
        LEA    DX, NEW            ; File name
        INT    21H                ; INT 21,3C - Create file using handle
        JC     CREATEFAIL         ; Check create condition
        MOV    FILHAND, AX        ; Save file handle
        JMP    CREATESUCCESS
CREATEFAIL:
        LEA    DX, ERROR          ; Show error message
        MOV    AH, 09H
        INT    21H        
CREATESUCCESS:
        RET
    First    ENDP
	;---------------------------------------
	; End of create new file
	;---------------------------------------

	;---------------------------------------
	; Create new file or open an exist file
	;---------------------------------------
    File    PROC    NEAR
        PUSH   CX
        PUSH   AX
        CMP    filenum, 05        ; Maximum number of files opened at the same time
        JAE    tooMany
        CLC                       ; Clear carry flag
        MOV    ROW, 24
        MOV    COL, 9
        CALL   SETLO              ; Move cursor location for input file name
        CALL   FILENAME           ; Input file name
        POP    AX
        MOV    AL, 00
        MOV    CX, 00             ; Normal file
        LEA    DX, INDATA1        ; File name
        INT    21H
        JC     FILEEROR
        MOV    FILHAND, AX        ; Save file handle
        JMP    FILEOK
FILEEROR:        
        MOV    ROW, 24
        MOV    COL, 9
        CALL   SETLO              ; Move cursor location
        LEA    DX, ERROR          ; Error message
        MOV    AH, 09H
        INT    21H                ; INT21,09H - show error message

FILEOK:
        ;-----------------------------------
		; Move cursot back
		; ToDo: orginal location
		;-----------------------------------
        MOV    ROW, 00
        MOV    COL, 00
        CALL   SETLO              ; Move cursor location
        POP    CX
        RET
tooMany:
        POP    AX
        JMP    FILEEROR
    File    ENDP
	;---------------------------------------
	; End of create new file or open an exist file
	;---------------------------------------

	;---------------------------------------
	; Save file
	;---------------------------------------
    write    PROC    NEAR
        CLC
        MOV    AH, 40H
        MOV    BX, FILHAND        ; Acquire file handle
        MOV    CX, 8000           ; Number of bytes to write
        LEA    DX, Str1           ; Data for write
        INT    21H                ; INT 21,40H - write a file
        JNC    SAVEOK
        LEA    DX, ERROR          ; Show error message if save fail
        MOV    AH, 09H
        INT    21H
SAVEOK: RET
    write    ENDP
	;---------------------------------------
	; End of save file
	;---------------------------------------

	;---------------------------------------
	; Open a file
	;---------------------------------------
    read    PROC    NEAR
        MOV    AH, 3FH
        MOV    BX, FILHAND        ; file handle
        MOV    CX, 8000           ; Number of bytes to read
        LEA    DX, Str1           ; Data space
        INT    21H                ; INT 21,3FH - read a file
        JC     NEWFAIL            ; Error check
        JMP    NEWOK
NEWFAIL:
        LEA    DX, ERROR          ; Show error message if save fail
        MOV    AH, 09H
        INT    21H        
NEWOK:  RET
    read    ENDP
	
    close    PROC    NEAR
        MOV   BX, FILHAND         ; file handle
        MOV   AH, 3EH
        INT   21H                 ; INT 21,3EH - close file
        RET
    close    ENDP
	;---------------------------------------
	; End of close file
	;---------------------------------------

	;---------------------------------------
	; Acquire file name
	;---------------------------------------
    FILENAME    PROC    NEAR
        PUSH   AX
        PUSH   CX
        MOV    ROW, 24
        MOV    COL, 9
        CALL   SETLO              ; Move cursor location

		;-----------------------------------
		; clean up input space
		;-----------------------------------
        MOV    CX,25
        MOV    AL,20H
EMPTY:  CALL   aChar
        LOOP   EMPTY

        MOV    ROW,24
        MOV    COL,9
        CALL   SETLO

        ;-----------------------------------
		; clean up input buffer
		;-----------------------------------
        MOV    CX, 23
        MOV    SI, 0000
CLEAN:  MOV    INDATA1[SI], 20H
        INC    SI
        LOOP   CLEAN

        ;-----------------------------------
		; Input
		;-----------------------------------
        MOV    AH, 0AH
        LEA    DX, LIST
        INT    21H
        MOVZX  BX, LEN
        MOV    INDATA1[BX], 00H

        POP    CX
        POP    AX
        RET
    FILENAME    ENDP
	;---------------------------------------
	; End of acquire file name
	;---------------------------------------

	;---------------------------------------
	; Show menu bar and status bar
	;---------------------------------------
    MENUBAR    PROC    NEAR
        MOV    AX, 0600H
        MOV    BH, 71H    
        MOV    CX, 0000H
        MOV    DX, 184FH
        INT    10H
        CALL   SETLO
        MOV    AH, 02H
        MOV    DL, 'C'   
        INT    21H
        MOV    DL, 'r'
        INT    21H
        MOV    DL, 'e'
        INT    21H
        MOV    DL, 'a'
        INT    21H
        MOV    DL, 't'
        INT    21H
        MOV    DL, 'e'
        INT    21H
        MOV    DL, ' '
        INT    21H
        MOV    DL, 'O'
        INT    21H
        MOV    DL, 'p'
        INT    21H
        MOV    DL, 'e'
        INT    21H
        MOV    DL, 'n'
        INT    21H
        MOV    DL, ' '
        INT    21H
        MOV    DL, 'S'
        INT    21H
        MOV    DL, 'a'
        INT    21H
        MOV    DL, 'v'
        INT    21H
        MOV    DL, 'e'
        INT    21H
        MOV    DL, ' '
        INT    21H
        MOV    DL, 'W'
        INT    21H
        MOV    DL, 'i'
        INT    21H
        MOV    DL, 'n'
        INT    21H
        MOV    DL, 'd'
        INT    21H
        MOV    DL, 'o'
        INT    21H
        MOV    DL, 'w'
        INT    21H
        MOV    DL, ' '
        INT    21H
        MOV    DL, 'E'
        INT    21H
        MOV    DL, 'x'
        INT    21H
        MOV    DL, 'i'
        INT    21H
        MOV    DL, 't'
        INT    21H
        MOV    ROW, 1
        CALL   SETLO
        MOV    CX, 80
LINE1:  MOV    DL, '='
        INT    21H
        LOOP   LINE1

        MOV    ROW, 23
        CALL   SETLO
        MOV    CX, 80
LINE2:  MOV    DL, '='
        INT    21H
        LOOP   LINE2
        MOV    ROW, 24
        MOV    COL, 0
        CALL   SETLO
        MOV    AH, 02H
        MOV    DL, 'F'
        INT    21H
        MOV    DL, 'i'
        INT    21H
        MOV    DL, 'l'
        INT    21H
        MOV    DL, 'e'
        INT    21H
        MOV    DL, 'n'
        INT    21H
        MOV    DL, 'a'
        INT    21H
        MOV    DL, 'm'
        INT    21H
        MOV    DL, 'e'
        INT    21H
        MOV    DL, ':'
        INT    21H
        MOV    DL, 'F'
        INT    21H
        MOV    DL, 'N'
        INT    21H
        MOV    DL, 'E'
        INT    21H
        MOV    DL, 'W'
        INT    21H
        MOV    DL, '.'
        INT    21H
        MOV    DL, 't'
        INT    21H
        MOV    DL, 'x'
        INT    21H
        MOV    DL, 't'
        INT    21H
        MOV    ROW, 2
        RET
    MENUBAR    ENDP
	;---------------------------------------
	; End of show menu bar and status bar
	;---------------------------------------

    ;---------------------------------------
	; User input
	;---------------------------------------
    KEYIN    PROC    NEAR
        MOV    AH, 10H            ; Request user input
        INT    16H
        CMP    AH, 01H            ; is ESC?
        JE     isESC
        CMP    AL, 00H            ; Function Key?
        JE     FunKey            
        CMP    AL, 0E0H           ; Function Key?
        JE     FunKey
        CALL   inChar
        JMP    AllNot             ; leave
Funkey:
        CMP    AH, 47H            ; Home Key?
        JNE    ENDKey
        CALL   toHome             ; toHome
        JMP    AllNot
ENDKey: CMP    AH, 4FH            ; End Key?
        JNE    Arrdown
        CALL   toEND              ; toEND
        JMP    AllNot             ; leave
Arrdown:
        CMP    AH, 50H            ; Down arrow?
        JNE    Arrup
        CALL   toDown             ; toDown
        JMP    AllNot             ; leave

Arrup:  CMP    AH, 48H            ; Up arrow?
        JNE    ArrR
        CALL   toUp               ; toUp
        JMP    AllNot             ; leave

ArrR:   CMP    AH, 4DH            ; Right arrow?
        JNE    ArrL
        CALL   toR                ; toR
        JMP    AllNot             ; leave

ArrL:   CMP    AH, 4BH            ; Left arrow?
        JNE    InsKey
        CALL   toL                ; toL
        JMP    AllNot             ; leave

InsKey: CMP    AH, 52H            ; Insert?
        JNE    PUKey
        CALL   toIns              ; toIns
        JMP    AllNot             ; leave

PUKey:  CMP    AH, 49H            ; Page UP?
        JNE    PDKey
        CALL   toPUP              ; toPUP
        JMP    AllNot             ; leave

PDKey:  CMP    AH, 51H            ; Page Down?
        JNE    DELKey
        CALL   toPDO              ; toPDO
        JMP    AllNot             ; leave

DELKey: CMP    AH, 53H            ; Delete key?
        JNE    AllNot             ; leave
        CALL   DELETE             ; call DELETE

AllNot: RET
isESC:  CALL   toESC
        RET
    KEYIN    ENDP
	;---------------------------------------
	; End of user input
	;---------------------------------------

	;---------------------------------------
	; Function of home key
	;---------------------------------------
    toHome    PROC    NEAR
        MOV    COL, 00            ; Set column to zero
        RET
    toHome    ENDP
	;---------------------------------------
	; End of function of home key
	;---------------------------------------

	;---------------------------------------
	; Function of page up key
	;---------------------------------------
    toPUP    PROC    NEAR
        MOV    CX, 19             ; Move up 19 times
REUP:   CALL   toUp               ; Up
        CALL   SETLO              ; Move cursor location
        LOOP   REUP
        RET
    toPUP    ENDP
	;---------------------------------------
	; End of function of page up key
	;---------------------------------------

	;---------------------------------------
	; Function of page down key
	;---------------------------------------
    toPDO    PROC    NEAR
        MOV    CX, 19             ; Move down 19 times
REDOWN: CALL   toDown             ; Down
        CALL   SETLO              ; Move cursor location
        LOOP   REDOWN
        RET
    toPDO    ENDP
	;---------------------------------------
	; End of function of page down key
	;---------------------------------------

	;---------------------------------------
	; Switch between menu bar and editor space
	;---------------------------------------
    toESC    PROC    NEAR
        MOV    COL, 00
        CMP    ROW, 00
        JNE    TOZ
        MOV    ROW, 02            ; Editor space
        RET
TOZ:    MOV    ROW, 00            ; Menu bar
        MOV    COL, 2
        RET
    toESC    ENDP
	;---------------------------------------
	; End of switch between menu bar and editor space
	;---------------------------------------

	;---------------------------------------
	; End key
	;---------------------------------------
    toEND    PROC    NEAR
        MOV    COL, Rlimit        ; Move cursor location to last
        RET
    toEND    ENDP
	;---------------------------------------
	; End of end key
	;---------------------------------------

	;---------------------------------------
	; Down arrow
	;---------------------------------------
    toDown    PROC    NEAR
        CMP    ROW, 00
        JE     isMenu             ; Skip action when in menu bar
        CMP    ROW, Dlimit        ; Down limit?
        JAE    scrU
        INC    ROW                ; Next row
isMenu: RET
        ;-----------------------------------
	    ; Scroll up if at buttom of editor sapce
	    ;-----------------------------------
scrU:   CMP    Ltop, CHlimit
        JAE    isMenu
        MOV    AX, 0601H        
        CALL   Chpage             ; Scroll up
        INC    Ltop         
        CALL   SCR1
        JMP    isMenu             ; Leave
    toDown    ENDP
	;---------------------------------------
	; End of down arrow
	;---------------------------------------

	;---------------------------------------
	; Deal with contents when scroll one line
	;---------------------------------------
    SCR1    PROC    NEAR
        PUSH   CX
        MOV    DH, ROW            ; Save current cursor location
        MOV    DL, COL
        PUSH   DX
        MOV    COL, 0
        CALL   Now                ; Judge cursor location
        CALL   SETLO              ; Move cursor location
        MOV    BX, LO
        LEA    SI, [Str1+BX]
de:     MOV    AL, [SI]           ; Move the character to AL for print
        INC    SI
        CALL   aChar              ; print
        CMP    COL, Rlimit
        JB     de

		;-----------------------------------
		; Last character
		;-----------------------------------
        CALL   Now
        MOV    BX, LO
        MOV    AL, [Str1+BX]
        MOV    AH, 09H
        MOV    BH, 0
        MOV    BL, 71H
        MOV    CX, 01
        INT    10H
        POP    DX                 ; Recover saved cursor location
        MOV    ROW, DH
        MOV    COL, DL
        POP    CX
        RET
    SCR1    ENDP
	;---------------------------------------
	; End of deal with contents when scroll one line
	;---------------------------------------

	;---------------------------------------
	; Up arrow
	;---------------------------------------
    toUp    PROC    NEAR
        CMP    ROW, 00
        JE     skipMune           ; Skip menu bar
        CMP    ROW, Tlimit        ; Top limit?
        JBE    scrD
        DEC    ROW                ; Decrease one row
skipMune:
        RET
		;-----------------------------------
		; Scroll down one row when reach top limit
		;-----------------------------------
scrD:   CMP    Ltop, 01
        JB     skipMune
        MOV    AX, 0701H        
        CALL   ChPage             ; INT 10H,07H - scroll down
        DEC    Ltop
        CALL   SCR1
        JMP    skipMune
    toUp    ENDP
	;---------------------------------------
	; End of up arrow
	;---------------------------------------

	;---------------------------------------
	; Right arrow
	;---------------------------------------
    toR    PROC    NEAR
        CMP    COL, Rlimit        ; Right limit?
        JAE    nextL
        INC    COL                ; Increase column
        RET
nextL:
        ;-----------------------------------
		; Move to next row when reach right limit
		;-----------------------------------
        CMP    Ltop, CHlimit
        JB     rightest
        RET
rightest:
        CALL   toHome
        CALL   toDown
        RET
    toR    ENDP
	;---------------------------------------
	; End of right arrow
	;---------------------------------------

	;---------------------------------------
	; Left arrow
	;---------------------------------------
    toL    PROC    NEAR
        CMP    COL, Llimit        ; Left limit?
        JBE    up
        DEC    COL                ; Decrease column
        RET
up:
        ;-----------------------------------
		; Move to up row when reach left limit
		;-----------------------------------
        CALL   toEND
        CALL   toUp
        RET
    toL    ENDP
	;---------------------------------------
	; End of left arrow
	;---------------------------------------

	;---------------------------------------
	; Delete key
	;---------------------------------------
    DELETE    PROC    NEAR
        MOV    BH, COL
        MOV    BL, ROW
        PUSH   BX                 ; Save column and row
		;-----------------------------------
		; Move data
		;-----------------------------------
        CALL   Now
        MOV    BX, LO
        LEA    DI, [Str1+BX]
        LEA    SI, [Str1+BX+1]
reMove: MOV    AL, [SI]
        MOV    [DI], AL
        INC    SI
        INC    DI
        CALL   aChar
        CMP    COL, Rlimit        ; Complete the movement?
        JB     reMove
		;-----------------------------------
		; Set last character to space
		;-----------------------------------
        CALL   Now
        MOV    BX,LO
        MOV    [Str1+BX], 20H
        MOV    AL, 20H
        MOV    AH, 09H
        MOV    BH, 0
        MOV    BL, 71H
        MOV    CX, 01
        INT    10H

        POP    BX                 ; Recover saved cursor location
        MOV    COL, BH
        MOV    ROW, BL
        RET
    DELETE    ENDP
	;---------------------------------------
	; End of delete key
	;---------------------------------------

	;---------------------------------------
	; Insert key
	;---------------------------------------
    toIns    PROC    NEAR
        MOV    DH, COL
        MOV    DL, ROW
        PUSH   DX
        PUSH   CX
        PUSH   AX
        xor    InKey, 1111B       ; Convert insert key status
        MOV    ROW, 24
        MOV    COL, 75
        CALL   SETLO
        MOV    AH, 02H
        CMP    InKey, 0000B
        JNE    INSERTON
        MOV    CX, 03
INSERTOFF:
        MOV    DL, 20H
        INT    21H
        LOOP   INSERTOFF
        JMP    INSERTEND
INSERTON:
        MOV    DL, 'I'
        INT    21H
        MOV    DL, 'N'
        INT    21H
        MOV    DL, 'S'
        INT    21H
INSERTEND:
        POP    AX
        POP    CX
        POP    DX
        MOV    COL, DH
        MOV    ROW, DL
        RET
    toIns    ENDP
	;---------------------------------------
	; End of insert key
	;---------------------------------------

	;---------------------------------------
	; Deal with input data
	;---------------------------------------
    inChar    PROC    NEAR
        CMP    AL, 0DH            ; Enter
        JE     Ent
        CMP    ROW, 00
        JE     NOChar
        CMP    AL, 08H            ; Back Space?
        JE     BACKSPACE
        CMP    AL, 09H            ; Tab?
        JE     Tab
        CMP    AL, 20H            ; Out of range?
        JB     NOChar
        CMP    AL, 7EH            ; Out of range?
        JA     NOChar            
        CMP    InKey, 00
        JNE    IN_ON
        CALL   toChar             ; Save to Str1
        CALL   aChar              ; Write character
NOChar:        RET

BACKSPACE:
        ;-----------------------------------
		; Back space
		;-----------------------------------
        CMP    COL, 00            ; Left limit?
        JBE    NOChar
        DEC    COL                ; Decrease one column
        CALL   SETLO              ; Move cursor location
        CALL   DELETE             ; DELETE
        RET
Tab:
        ;-----------------------------------
		; Insert 6 space for tab
		;-----------------------------------
        MOV    AL, 20H            ; Space
        MOV    CX, 06             ; 6 times
repeatSpace:
        CALL   toChar             ; Save content into buffer
        CALL   aChar              ; Show space
        LOOP   repeatSpace
        RET

IN_ON:  CALL    INData            ; Insert
        RET

Ent:    CALL    toENTER
        RET
    inChar    ENDP
	;---------------------------------------
	; End of deal with input data
	;---------------------------------------

	;---------------------------------------
	; Enter key
	;---------------------------------------
    toENTER    PROC    NEAR
		;-----------------------------------
		; Create
		;-----------------------------------
        CMP    ROW, 00
        JNE    Lout
        CMP    COL, 05
        JA     isOPEN
        MOV    AX, 0600H          ; Set to scroll and clean
        CALL   ChPage             ; Scroll
        MOV    AH, 3CH            ; Create new file
        CALL   File               ; Create new file
        JMP    Lout

isOPEN:
        ;-----------------------------------
		; Open
		;-----------------------------------
		CMP    COL, 07
        JB     isSAVE
        CMP    COL, 10
        JA     isSAVE
        MOV    AX, 0600H          ; Set to scroll and clean
        CALL   ChPage             ; Scroll
        MOV    AH, 3DH            ; Open file
        CALL   File               ; Open file
        CALL   read               ; Read file content
        JMP    Lout

isSAVE:
        ;-----------------------------------
		; Save
		;-----------------------------------
        CMP    COL, 12
        JB     isWINDOW
        CMP    COL, 15
        JA     isWINDOW
        CALL   write              ; Save content
        JMP    Lout

isWINDOW:
        ;-----------------------------------
		; Window
		;-----------------------------------
        CMP    COL, 17
        JB     EXIT
        CMP    COL, 22
        JA     EXIT
        JMP    Lout

EXIT:   
        ;-----------------------------------
		; Exit
		;-----------------------------------
		CMP    COL, 24
        JB     Lout
        CMP    COL, 27
        JA     Lout
        CALL   close              ; Close file
        MOV    AX, 4C00H          ; Exit program
        INT    21H

        RET
Lout:   CALL   toHome
        CALL   todown
        RET
    toENTER    ENDP

	;---------------------------------------
	; Deal with data in insert mode
	;---------------------------------------
    INData    PROC    NEAR
		;-----------------------------------
		; Move data
		;-----------------------------------
        CALL   Now
        MOV    CX, 8000
        LEA    SI, Str1+7998
        LEA    DI, Str1+7999
L1:     MOV    DH, [SI]
        MOV    [DI], DH
        DEC    SI
        DEC    DI
        DEC    CX
        CMP    CX, LO             ; Complete the movement?
        JA     L1

        CALL   aChar              ; Write character
        CALL   toChar             ; Save to Str1
        
        MOV    BH, COL
        MOV    BL, ROW
        PUSH   BX                 ; Save column and row
        CALL   Now
        MOV    BX, LO
        MOV    DH, Ltop
        PUSH   DX
        MOV    Ltop, 00
        CALL   Now
        MOV    CX, LO

        LEA    DI, Str1
		;-----------------------------------
		; Show moved character
		;-----------------------------------
L2:     MOV    AL, [DI+BX]    
        INC    BX        
        INC    CX
        CALL   aChar        
        CMP    CX, 1598        
        JBE    L2
		;-----------------------------------
		; The character in last column last row
		;-----------------------------------
        MOV    AL, Str1+1599        
        MOV    AH, 09H            
        MOV    BH, 0            
        MOV    BL, 71H            
        MOV    CX, 01            
        INT    10H
        POP    DX
        MOV    Ltop, DH        
        POP    BX                 ; Recover save column and row
        MOV    COL, BH
        MOV    ROW, BL

        RET
    INData    ENDP
	;---------------------------------------
	; End of deal with data in insert mode
	;---------------------------------------

	;---------------------------------------
	; Save data into buffer Str1
	;---------------------------------------
    toChar    PROC    NEAR
        PUSH   AX
        CALL   Now                ; Calculate index for save
        MOV    BX, LO             ; Move index to BX
        LEA    DI, Str1
        MOV    [DI+BX], AL        ; Move input date to Str1
        POP    AX
        RET
    toChar    ENDP
	;---------------------------------------
	; End of save data into buffer Str1
	;---------------------------------------

	;---------------------------------------
	; Judge current cursor location
	;---------------------------------------
    Now    PROC    NEAR
        PUSH   CX
        PUSH   DX

        MOV    LO, 00             ; Reset LO
        MOVZX  CX, ROW
        DEC    CX
        DEC    CX
        MOVZX  DX, Ltop           ; Scroll times
        ADD    CX, DX
        CMP    CX, 01             ; First row?
        JB     addCOL

addROW: add    LO, 80             ; Add 80 for additional row
        LOOP   addROW
        
addCOL: MOVZX  DX, COL            ; Add column number
        add    LO, DX

        POP    DX
        POP    CX
        RET
    Now    ENDP
	;---------------------------------------
	; End of judge current cursor location
	;---------------------------------------

	;---------------------------------------
	; Write character
	;---------------------------------------
    aChar    PROC    NEAR
        PUSH   AX
        PUSH   CX
        MOV    AH, 09H
        MOV    BH, 0              ; video page number
        MOV    BL, 71H            ; attribute
        MOV    CX, 1
        INT    10H                ; INT 10H,09H - write character to cursor location

OK:     CALL   toR                ; Move right
        CALL   SETLO              ; Move cursor location
        POP    CX
        POP    AX
        RET
    aChar    ENDP
	;---------------------------------------
	; End of write character
	;---------------------------------------

	;---------------------------------------
	; Move cursor location
	;---------------------------------------
    SETLO    PROC    NEAR
        MOV    AH, 02H
        MOV    BH, 00
        MOV    DH, ROW
        MOV    DL, COL
        INT    10H                ; INT 10H,02H -  Set cursor location
        RET
    SETLO    ENDP
	;---------------------------------------
	; End of move cursor location
	;---------------------------------------

	;---------------------------------------
	; Deal with screen according to AH which is setted before call
	;---------------------------------------
    ChPage    PROC    NEAR    
        PUSH   CX                
        MOV    BH, 71H            ; Color
        MOV    CX, 0200H          ; Top-Left
        MOV    DX, 164FH          ; Right-Down
        INT    10H
        POP    CX
        RET                
    ChPage    ENDP
	;---------------------------------------
	; End of deal with screen according to AH which is setted before call
	;---------------------------------------
; End of segment
END ; End of program