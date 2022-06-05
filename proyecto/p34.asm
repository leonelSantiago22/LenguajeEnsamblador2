.model small
.486
include ..\fun\macros.asm
extrn des4:near
extrn reto:near
extrn des2:near
extrn spc:near
.stack 256
.data
;==============================================================================
; DATA
;==============================================================================
.DATA
    posx       DB     00
    posy       DB     00
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

    buffer      DB     8000 DUP(20H), 20H ; Buffer for content
    LIST      LABEL  BYTE
    MAX_L     DB     21
    LEN       DB     ?
    nombre_archivo   DB     23 DUP(' ')  ; Buffer for file name
    numero_archivo   DB     0
    fid   DW     ?
    ERROR     DB     '******ERROR******','$'
    archivo_temo       DB     'temp.txt',0

;==============================================================================
; CODE
;==============================================================================
.CODE
    ;---------------------------------------
	; Main procedure
    ;---------------------------------------
MAIN:
        mov    ax, @DATA           ; Loading starting address of data segment in ax
        mov    DS, ax              ; Initialize DS
        mov    ES, ax              ; Initialize ES

        ;limpiar pantalla
        mov    ax, 0600H           ; Scroll up window and clear
        call   ChPage              ; Scroll screen to clean
        
        call   Menu            ; Show menu bar
        call   crear_archivo              ; Create new file

        mov    posy, 0		      ; Set cursor posyumn location
        mov    posx, 2		      ; Set cursor posx location

cic_main:
        call   bloq_mayus                ; comprobamos si esta activo el bloq mayus 
        call   cursor_posicion          ;esta funcion nos permite mandas la posicion en la que se encuentra el cursor 
        call   entrada_del_usuarios     ;Entrada del usuario
        jmp    cic_main             ; Go back for getting user input

		;-----------------------------------
		; Exit program
		;-----------------------------------
        mov    ax, 4C00H
        int    21H
		;-----------------------------------

    ;---------------------------------------
    ; End of main procedure
    ;---------------------------------------

.386

	;---------------------------------------
	; Mouse initialization
	;---------------------------------------                      ; Initial fail
    ;---------------------------------------
    ; Check status of Num Lock and Caps Lcok
    ;---------------------------------------
bloq_mayus:
        push   cx
        push   ax
        mov    DH, posy
        mov    DL, posx
        push   dx	              ; Backup posy and posx
        ; Caps Lock
        mov    posx, 24            ; posx location of cursor
        mov    posy, 65            ; posyumn location of cursor
        call   cursor_posicion              ; move cursor to show Caps Lock information
        mov    AH, 02H
        int    16H                ; int 16H,02H - ck
        mov    AH, 02H            ; int 21H,02H - write character to STDOUT
        JNZ    CAPSON             ; Jump short if not zero (ZF=0)
        mov    cx, 04
        mov    DL, 20H            ; Set the character writen to STDOUT to spcae 
CAPSOFF:
        int    21H
        LOOP   CAPSOFF            ; Loop to clean Caps Lock information
        jmp    num
CAPSON: mov    DL, 'C'            ; Show CAPS
        int    21H
        mov    DL, 'a'
        int    21H
        mov    DL, 'p'
        int    21H
        mov    DL, 's'
        int    21H
num:    ; Num Lock
        mov    posy, 70            ; posyumn location of cursor
        call   cursor_posicion              ; move cursor to show Num Lock information
		mov    AH, 12H
        int    16H                ; int 16H,12H - query extended keyboard shift status
        AND    AL, 00100000B      ; Check Num Lock)
        mov    AH, 02H
        JNZ    NUMON              ; Jump short if not zero (ZF = 0)
        mov    cx, 03
        mov    DL, 20H            ; Set the character writen to STDOUT to spcae 
NUMOFF:
        int    21H
        LOOP   NUMOFF             ; Loop to clean Num Lock information
        jmp    FINISH
NUMON:  mov    DL, 'N'            ; Show NUM
        int    21H
        mov    DL, 'u'
        int    21H
        mov    DL, 'm'
        int    21H

FINISH:
        POP    dx                 ; Restore posy and posx
        mov    posy, DH
        mov    posx, DL
        POP    ax
        POP    cx
        ret
    ;---------------------------------------
    ; End of check status of Num Lock and Caps Lcok
    ;---------------------------------------

	;---------------------------------------
	; Create new file
	;---------------------------------------
crear_archivo:
        mov    AH, 3CH
        mov    cx, 00             ; Normal file
        LEA    dx, archivo_temo            ; File name
        int    21H                ; int 21,3C - Create file using handle
        JC     CREATEFAIL         ; Check create condition
        mov    fid, ax        ; Save file handle
        jmp    CREATESUCCESS
CREATEFAIL:
        LEA    dx, ERROR          ; Show error message
        mov    AH, 09H
        int    21H        
CREATESUCCESS:
        ret
	;---------------------------------------
	; End of create new file
	;---------------------------------------

	;---------------------------------------
	; Create new file or open an exist file
	;---------------------------------------
File:   
        push   cx
        push   ax
        cmp    numero_archivo, 05        ; Maximum number of files opened at the same time
        JAE    tooMany
        CLC                       ; Clear carry flag
        mov    posx, 24
        mov    posy, 9
        call   cursor_posicion              ; move cursor location for input file name
        call   FILENAME           ; Input file name
        POP    ax
        mov    AL, 00
        mov    cx, 00             ; Normal file
        LEA    dx, nombre_archivo        ; File name
        int    21H
        JC     FILEEROR
        mov    fid, ax        ; Save file handle
        jmp    FILEOK
FILEEROR:        
        mov    posx, 24
        mov    posy, 9
        call   cursor_posicion              ; move cursor location
        LEA    dx, ERROR          ; Error message
        mov    AH, 09H
        int    21H                ; int21,09H - show error message

FILEOK:
        ;-----------------------------------
		; move cursot back
		; ToDo: orginal location
		;-----------------------------------
        mov    posx, 00
        mov    posy, 00
        call   cursor_posicion              ; move cursor location
        POP    cx
        ret
tooMany:
        POP    ax
        jmp    FILEEROR
	;---------------------------------------
	; End of create new file or open an exist file
	;---------------------------------------

	;---------------------------------------
	; Save file
	;---------------------------------------
write:
        CLC
        mov    AH, 40H
        mov    BX, fid        ; Acquire file handle
        mov    cx, 8000           ; Number of bytes to write
        LEA    dx, buffer           ; Data for write
        int    21H                ; int 21,40H - write a file
        JNC    SAVEOK
        LEA    dx, ERROR          ; Show error message if save fail
        mov    AH, 09H
        int    21H
SAVEOK: ret

	;---------------------------------------
	; End of save file
	;---------------------------------------

	;---------------------------------------
	; Open a file
	;---------------------------------------
read: 
        mov    AH, 3FH
        mov    BX, fid        ; file handle
        mov    cx, 8000           ; Number of bytes to read
        LEA    dx, buffer           ; Data space
        int    21H                ; int 21,3FH - read a file
        JC     NEWFAIL            ; Error check
        jmp    NEWOK
NEWFAIL:
        LEA    dx, ERROR          ; Show error message if save fail
        mov    AH, 09H
        int    21H        
NEWOK:  ret
	;---------------------------------------
	; End of open a file
	;---------------------------------------

	;---------------------------------------
	; Close file
	;---------------------------------------
close: 
        mov   BX, fid         ; file handle
        mov   AH, 3EH
        int   21H                 ; int 21,3EH - close file
        ret
	;---------------------------------------
	; End of close file
	;---------------------------------------

	;---------------------------------------
	; Acquire file name
	;---------------------------------------
FILENAME:
        push   ax
        push   cx
        mov    posx, 24
        mov    posy, 9
        call   cursor_posicion              ; move cursor location

		;-----------------------------------
		; clean up input space
		;-----------------------------------
        mov    cx,25
        mov    AL,20H
EMPTY:  call   aChar
        LOOP   EMPTY

        mov    posx,24
        mov    posy,9
        call   cursor_posicion

        ;-----------------------------------
		; clean up input buffer
		;-----------------------------------
        mov    cx, 23
        mov    SI, 0000
CLEAN:  mov    nombre_archivo[SI], 20H
        INC    SI
        LOOP   CLEAN

        ;-----------------------------------
		; Input
		;-----------------------------------
        mov    AH, 0AH
        LEA    dx, LIST
        int    21H
        movZX  BX, LEN
        mov    nombre_archivo[BX], 00H

        POP    cx
        POP    ax
        ret
	;---------------------------------------
	; End of acquire file name
	;---------------------------------------

	;---------------------------------------
	; Show menu bar and status bar
	;---------------------------------------
Menu:
        mov    ax, 0600H
        mov    BH, 71H    
        mov    cx, 0000H
        mov    dx, 184FH
        int    10H
        call   cursor_posicion
        mov    AH, 02H
        mov    DL, 'C'   
        int    21H
        mov    DL, 'r'
        int    21H
        mov    DL, 'e'
        int    21H
        mov    DL, 'a'
        int    21H
        mov    DL, 't'
        int    21H
        mov    DL, 'e'
        int    21H
        mov    DL, ' '
        int    21H
        mov    DL, 'O'
        int    21H
        mov    DL, 'p'
        int    21H
        mov    DL, 'e'
        int    21H
        mov    DL, 'n'
        int    21H
        mov    DL, ' '
        int    21H
        mov    DL, 'S'
        int    21H
        mov    DL, 'a'
        int    21H
        mov    DL, 'v'
        int    21H
        mov    DL, 'e'
        int    21H
        mov    DL, ' '
        int    21H
        mov    DL, 'W'
        int    21H
        mov    DL, 'i'
        int    21H
        mov    DL, 'n'
        int    21H
        mov    DL, 'd'
        int    21H
        mov    DL, 'o'
        int    21H
        mov    DL, 'w'
        int    21H
        mov    DL, ' '
        int    21H
        mov    DL, 'E'
        int    21H
        mov    DL, 'x'
        int    21H
        mov    DL, 'i'
        int    21H
        mov    DL, 't'
        int    21H
        mov    posx, 1
        call   cursor_posicion
        mov    cx, 80
LINE1:  mov    DL, '='
        int    21H
        LOOP   LINE1

        mov    posx, 23
        call   cursor_posicion
        mov    cx, 80
LINE2:  mov    DL, '='
        int    21H
        LOOP   LINE2
        mov    posx, 24
        mov    posy, 0
        call   cursor_posicion
        mov    AH, 02H
        mov    DL, 'F'
        int    21H
        mov    DL, 'i'
        int    21H
        mov    DL, 'l'
        int    21H
        mov    DL, 'e'
        int    21H
        mov    DL, 'n'
        int    21H
        mov    DL, 'a'
        int    21H
        mov    DL, 'm'
        int    21H
        mov    DL, 'e'
        int    21H
        mov    DL, ':'
        int    21H
        mov    DL, 'F'
        int    21H
        mov    DL, 'N'
        int    21H
        mov    DL, 'E'
        int    21H
        mov    DL, 'W'
        int    21H
        mov    DL, '.'
        int    21H
        mov    DL, 't'
        int    21H
        mov    DL, 'x'
        int    21H
        mov    DL, 't'
        int    21H
        mov    posx, 2
        ret
	;---------------------------------------
	; End of show menu bar and status bar
	;---------------------------------------

    ;---------------------------------------
	; User input
	;---------------------------------------
entrada_del_usuarios:
        mov    AH, 10H            ; Request user input
        int    16H
        cmp    AH, 01H            ; is ESC?
        je     isESC
        cmp    AL, 00H            ; Function Key?
        je     FunKey            
        cmp    AL, 0E0H           ; Function Key?
        je     FunKey
        call   inChar
        jmp    AllNot             ; leave
Funkey:
        cmp    AH, 47H            ; Home Key?
        JNE    ENDKey
        call   toHome             ; toHome
        jmp    AllNot
ENDKey: cmp    AH, 4FH            ; End Key?
        JNE    Arrdown
        call   toEND              ; toEND
        jmp    AllNot             ; leave
Arrdown:
        cmp    AH, 50H            ; Down arposx?
        JNE    Arrup
        call   toDown             ; toDown
        jmp    AllNot             ; leave

Arrup:  cmp    AH, 48H            ; Up arposx?
        JNE    ArrR
        call   toUp               ; toUp
        jmp    AllNot             ; leave

ArrR:   cmp    AH, 4DH            ; Right arposx?
        JNE    ArrL
        call   toR                ; toR
        jmp    AllNot             ; leave

ArrL:   cmp    AH, 4BH            ; Left arposx?
        JNE    InsKey
        call   toL                ; toL
        jmp    AllNot             ; leave

InsKey: cmp    AH, 52H            ; Insert?
        JNE    PUKey
        call   toIns              ; toIns
        jmp    AllNot             ; leave

PUKey:  cmp    AH, 49H            ; Page UP?
        JNE    PDKey
        call   toPUP              ; toPUP
        jmp    AllNot             ; leave

PDKey:  cmp    AH, 51H            ; Page Down?
        JNE    DELKey
        call   toPDO              ; toPDO
        jmp    AllNot             ; leave

DELKey: cmp    AH, 53H            ; Delete key?
        JNE    AllNot             ; leave
        call   DELETE             ; call DELETE

AllNot: ret
isESC:  call   toESC
        ret
	;---------------------------------------
	; End of user input
	;---------------------------------------

	;---------------------------------------
	; Function of home key
	;---------------------------------------
toHome:
        mov    posy, 00            ; Set posyumn to zero
        ret
	;---------------------------------------
	; End of function of home key
	;---------------------------------------

	;---------------------------------------
	; Function of page up key
	;---------------------------------------
toPUP:
        mov    cx, 19             ; move up 19 times
REUP:   call   toUp               ; Up
        call   cursor_posicion              ; move cursor location
        LOOP   REUP
        ret
	;---------------------------------------
	; End of function of page up key
	;---------------------------------------

	;---------------------------------------
	; Function of page down key
	;---------------------------------------
toPDO:
        mov    cx, 19             ; move down 19 times
REDOWN: call   toDown             ; Down
        call   cursor_posicion              ; move cursor location
        LOOP   REDOWN
        ret
	;---------------------------------------
	; End of function of page down key
	;---------------------------------------

	;---------------------------------------
	; Switch between menu bar and editor space
	;---------------------------------------
toESC:
        mov    posy, 00
        cmp    posx, 00
        JNE    TOZ
        mov    posx, 02            ; Editor space
        ret
TOZ:    mov    posx, 00            ; Menu bar
        mov    posy, 2
        ret
	;---------------------------------------
	; End of switch between menu bar and editor space
	;---------------------------------------

	;---------------------------------------
	; End key
	;---------------------------------------
toEND:
        mov    posy, Rlimit        ; move cursor location to last
        ret
	;---------------------------------------
	; End of end key
	;---------------------------------------

	;---------------------------------------
	; Down arposx
	;---------------------------------------
toDown:
        cmp    posx, 00
        je     isMenu             ; Skip action when in menu bar
        cmp    posx, Dlimit        ; Down limit?
        JAE    scrU
        INC    posx                ; Next posx

        ;-----------------------------------
	    ; Scroll up if at buttom of editor sapce
	    ;-----------------------------------
scrU:   cmp    Ltop, CHlimit
        JAE    isMenu
        mov    ax, 0601H        
        call   Chpage             ; Scroll up
        INC    Ltop
        call   SCR1
        jmp    isMenu             ; Leave
isMenu: ret 
	;---------------------------------------
	; End of down arposx
	;---------------------------------------

	;---------------------------------------
	; Deal with contents when scroll one line
	;---------------------------------------
SCR1:
        push   cx
        mov    DH, posx            ; Save current cursor location
        mov    DL, posy
        push   dx
        mov    posy, 0
        call   Now                ; Judge cursor location
        call   cursor_posicion              ; move cursor location
        mov    BX, LO
        LEA    SI, [buffer+BX]
de:     mov    AL, [SI]           ; move the character to AL for print
        INC    SI
        call   aChar              ; print
        cmp    posy, Rlimit
        JB     de

		;-----------------------------------
		; Last character
		;-----------------------------------
        call   Now
        mov    BX, LO
        mov    AL, [buffer+BX]
        mov    AH, 09H
        mov    BH, 0
        mov    BL, 71H
        mov    cx, 01
        int    10H
        POP    dx                 ; Recover saved cursor location
        mov    posx, DH
        mov    posy, DL
        POP    cx
        ret
	;---------------------------------------
	; End of deal with contents when scroll one line
	;---------------------------------------

	;---------------------------------------
	; Up arposx
	;---------------------------------------
toUp:
        cmp    posx, 00
        je     skipMune           ; Skip menu bar
        cmp    posx, Tlimit        ; Top limit?
        JBE    scrD
        DEC    posx                ; Decrease one posx
		;-----------------------------------
		; Scroll down one posx when reach top limit
		;-----------------------------------
scrD:   cmp    Ltop, 01
        JB     skipMune
        mov    ax, 0701H        
        call   ChPage             ; int 10H,07H - scroll down
        DEC    Ltop
        call   SCR1
        
skipMune:
        ret
	;---------------------------------------
	; End of up arposx
	;---------------------------------------

	;---------------------------------------
	; Right arposx
	;---------------------------------------
toR:
        cmp    posy, Rlimit        ; Right limit?
        JAE    nextL
        INC    posy                ; Increase posyumn
        ret
nextL:
        ;-----------------------------------
		; move to next posx when reach right limit
		;-----------------------------------
        cmp    Ltop, CHlimit
        JB     rightest
        ret
rightest:
        call   toHome
        call   toDown
        ret
	;---------------------------------------
	; End of right arposx
	;---------------------------------------

	;---------------------------------------
	; Left arposx
	;---------------------------------------
toL:
        cmp    posy, Llimit        ; Left limit?
        JBE    up
        DEC    posy                ; Decrease posyumn
        ret
up:
        ;-----------------------------------
		; move to up posx when reach left limit
		;-----------------------------------
        call   toEND
        call   toUp
        ret
	;---------------------------------------
	; End of left arposx
	;---------------------------------------

	;---------------------------------------
	; Delete key
	;---------------------------------------
DELETE:
        mov    BH, posy
        mov    BL, posx
        push   BX                 ; Save posyumn and posx
		;-----------------------------------
		; move data
		;-----------------------------------
        call   Now
        mov    BX, LO
        LEA    DI, [buffer+BX]
        LEA    SI, [buffer+BX+1]
remove: mov    AL, [SI]
        mov    [DI], AL
        INC    SI
        INC    DI
        call   aChar
        cmp    posy, Rlimit        ; Complete the movement?
        JB     remove
		;-----------------------------------
		; Set last character to space
		;-----------------------------------
        call   Now
        mov    BX,LO
        mov    [buffer+BX], 20H
        mov    AL, 20H
        mov    AH, 09H
        mov    BH, 0
        mov    BL, 71H
        mov    cx, 01
        int    10H

        POP    BX                 ; Recover saved cursor location
        mov    posy, BH
        mov    posx, BL
        ret
	;---------------------------------------
	; End of delete key
	;---------------------------------------

	;---------------------------------------
	; Insert key
	;---------------------------------------
toIns:
        mov    DH, posy
        mov    DL, posx
        push   dx
        push   cx
        push   ax
        xor    InKey, 1111B       ; Convert insert key status
        mov    posx, 24
        mov    posy, 75
        call   cursor_posicion
        mov    AH, 02H
        cmp    InKey, 0000B
        JNE    INSERTON
        mov    cx, 03
INSERTOFF:
        mov    DL, 20H
        int    21H
        LOOP   INSERTOFF
        jmp    INSERTEND
INSERTON:
        mov    DL, 'I'
        int    21H
        mov    DL, 'N'
        int    21H
        mov    DL, 'S'
        int    21H
INSERTEND:
        POP    ax
        POP    cx
        POP    dx
        mov    posy, DH
        mov    posx, DL
        ret
	;---------------------------------------
	; End of insert key
	;---------------------------------------

	;---------------------------------------
	; Deal with input data
	;---------------------------------------
inChar:
        cmp    AL, 0DH            ; Enter
        je     Ent
        cmp    posx, 00
        je     NOChar
        cmp    AL, 08H            ; Back Space?
        je     BACKSPACE
        cmp    AL, 09H            ; Tab?
        je     Tab
        cmp    AL, 20H            ; Out of range?
        JB     NOChar
        cmp    AL, 7EH            ; Out of range?
        JA     NOChar            
        cmp    InKey, 00
        JNE    IN_ON
        call   toChar             ; Save to buffer
        call   aChar              ; Write character
NOChar:        ret

BACKSPACE:
        ;-----------------------------------
		; Back space
		;-----------------------------------
        cmp    posy, 00            ; Left limit?
        JBE    NOChar
        DEC    posy                ; Decrease one posyumn
        call   cursor_posicion              ; move cursor location
        call   DELETE             ; DELETE
        ret
Tab:
        ;-----------------------------------
		; Insert 6 space for tab
		;-----------------------------------
        mov    AL, 20H            ; Space
        mov    cx, 06             ; 6 times
repeatSpace:
        call   toChar             ; Save content into buffer
        call   aChar              ; Show space
        LOOP   repeatSpace
        ret

IN_ON:  call    INData            ; Insert
        ret

Ent:    call    toENTER
        ret
	;---------------------------------------
	; End of deal with input data
	;---------------------------------------

	;---------------------------------------
	; Enter key
	;---------------------------------------
toENTER:
		;-----------------------------------
		; Create
		;-----------------------------------
        cmp    posx, 00
        JNE    Lout
        cmp    posy, 05
        JA     isOPEN
        mov    ax, 0600H          ; Set to scroll and clean
        call   ChPage             ; Scroll
        mov    AH, 3CH            ; Create new file
        call   File               ; Create new file
        jmp    Lout

isOPEN:
        ;-----------------------------------
		; Open
		;-----------------------------------
		cmp    posy, 07
        JB     isSAVE
        cmp    posy, 10
        JA     isSAVE
        mov    ax, 0600H          ; Set to scroll and clean
        call   ChPage             ; Scroll
        mov    AH, 3DH            ; Open file
        call   File               ; Open file
        call   read               ; Read file content
        jmp    Lout

isSAVE:
        ;-----------------------------------
		; Save
		;-----------------------------------
        cmp    posy, 12
        JB     isWINDOW
        cmp    posy, 15
        JA     isWINDOW
        call   write              ; Save content
        jmp    Lout

isWINDOW:
        ;-----------------------------------
		; Window
		;-----------------------------------
        cmp    posy, 17
        JB     EXIT
        cmp    posy, 22
        JA     EXIT
        jmp    Lout

EXIT:   
        ;-----------------------------------
		; Exit
		;-----------------------------------
		cmp    posy, 24
        JB     Lout
        cmp    posy, 27
        JA     Lout
        call   close              ; Close file
        mov    ax, 4C00H          ; Exit program
        int    21H

        ret
Lout:   call   toHome
        call   todown
        ret

	;---------------------------------------
	; Deal with data in insert mode
	;---------------------------------------
INData:
		;-----------------------------------
		; move data
		;-----------------------------------
        call   Now
        mov    cx, 8000
        LEA    SI, buffer+7998
        LEA    DI, buffer+7999
L1:     mov    DH, [SI]
        mov    [DI], DH
        DEC    SI
        DEC    DI
        DEC    cx
        cmp    cx, LO             ; Complete the movement?
        JA     L1

        call   aChar              ; Write character
        call   toChar             ; Save to buffer
        
        mov    BH, posy
        mov    BL, posx
        push   BX                 ; Save posyumn and posx
        call   Now
        mov    BX, LO
        mov    DH, Ltop
        push   dx
        mov    Ltop, 00
        call   Now
        mov    cx, LO

        LEA    DI, buffer
		;-----------------------------------
		; Show moved character
		;-----------------------------------
L2:     mov    AL, [DI+BX]    
        INC    BX        
        INC    cx
        call   aChar        
        cmp    cx, 1598        
        JBE    L2
		;-----------------------------------
		; The character in last posyumn last posx
		;-----------------------------------
        mov    AL, buffer+1599        
        mov    AH, 09H            
        mov    BH, 0            
        mov    BL, 71H            
        mov    cx, 01            
        int    10H
        POP    dx
        mov    Ltop, DH        
        POP    BX                 ; Recover save posyumn and posx
        mov    posy, BH
        mov    posx, BL
        ret

	;---------------------------------------
	; End of deal with data in insert mode
	;---------------------------------------

	;---------------------------------------
	; Save data into buffer buffer
	;---------------------------------------
toChar:
        push   ax
        call   Now                ; Calculate index for save
        mov    BX, LO             ; move index to BX
        LEA    DI, buffer
        mov    [DI+BX], AL        ; move input date to buffer
        POP    ax
        ret
	;---------------------------------------
	; End of save data into buffer buffer
	;---------------------------------------

	;---------------------------------------
	; Judge current cursor location
	;---------------------------------------
Now:
        push   cx
        push   dx

        mov    LO, 00             ; Reset LO
        movZX  cx, posx
        DEC    cx
        DEC    cx
        movZX  dx, Ltop           ; Scroll times
        ADD    cx, dx
        cmp    cx, 01             ; First posx?
        JB     addposy

addposx: add    LO, 80             ; Add 80 for additional posx
        LOOP   addposx
        
addposy: movZX  dx, posy            ; Add posyumn number
        add    LO, dx

        POP    dx
        POP    cx
        ret
	;---------------------------------------
	; End of judge current cursor location
	;---------------------------------------

	;---------------------------------------
	; Write character
	;---------------------------------------
aChar:
        push   ax
        push   cx
        mov    AH, 09H
        mov    BH, 0              ; video page number
        mov    BL, 71H            ; attribute
        mov    cx, 1
        int    10H                ; int 10H,09H - write character to cursor location

OK:     call   toR                ; move right
        call   cursor_posicion              ; move cursor location
        POP    cx
        POP    ax
        ret
	;---------------------------------------
	; End of write character
	;---------------------------------------

	;---------------------------------------
	; move cursor location
	;---------------------------------------
cursor_posicion:
        mov    AH, 02H
        mov    BH, 00
        mov    DH, posx
        mov    DL, posy
        int    10H                ; int 10H,02H -  Set cursor location
        ret

	;---------------------------------------
	; End of move cursor location
	;---------------------------------------

	;---------------------------------------
	; Deal with screen according to AH which is setted before call
	;---------------------------------------
ChPage:   
        push   cx                
        mov    BH, 71H            ; posyor
        mov    cx, 0200H          ; Top-Left
        mov    DX, 164FH          ; Right-Down
        int    10H
        POP    cx
        ret                
	;---------------------------------------
	; End of deal with screen according to AH which is setted before call
	;---------------------------------------
; End of segment
END ; End of program