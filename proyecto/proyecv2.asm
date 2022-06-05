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
    posx        DB     00
    posy        DB     00
    Ltop        DB     00
    InKey       DB     00           ;estado de la tecla de insercion
    locacion    DW     0            ;saber en que columa estamos


    limite_derecho    EQU    79
    limite_izquierdo    EQU    00
    limite_inferior    EQU    21
    limite_superior    EQU    02
    limite_pantalla   EQU    79

    buffer      DB     8000 DUP(20H), 20H ; Buffer for content
    LIST      LABEL  BYTE
    MAX_L     DB     21
    LEN       DB     ?
    nombre_archivo   DB     23 DUP(' ')  ; Buffer for crear_archivo2 name
    numero_archivo   DB     0
    fid   DW     ?
    ERROR     DB     '******ERROR******','$'
    archivo_temo       DB     'temp.txt',0 ;el archivo temporal nos ayuda mientras le pone un nombre al archivo
    ;color db 71H    ;color del fondo

.CODE
main:
        mov    ax, @DATA           
        mov    ds, ax              
        mov    es, ax              

        ;limpiar pantalla
        mov    ax, 0600H           ; movemos hasta arriba la pantalla
        call   limpiar_pantalla    ;funcion que limpia la pantatta

        call   Menu                 ;menu
        call   crear_archivo        ;creamos un nuevo archivo

        mov    posy, 0		      ; posicionamos el cursos para que pueda empezar a escribir
        mov    posx, 2		      

cic_main:
        call   tipo_captura                ;comprobamos si esta activo el bloq mayus 
        call   cursor_posicion          ;esta funcion nos permite mandas la posicion en la que se encuentra el cursor 
        call   entrada_del_usuarios     ;Entrada del usuario
        jmp    cic_main 
        ;salida del programa
        .exit 0
.386

tipo_captura:
        push   cx
        push   ax
        mov    dh, posy
        mov    dl, posx
        push   dx	              ;respaldamos las pos x y y 
        mov    posx, 24            ;posicion x del cursor 
        mov    posy, 65            ; posy locacion del cursor para escribir 
        call   cursor_posicion     ; movemos el cursor para saber si estamos en como captura
        mov    ah, 02H
        int    16H                ; int 16H,02H - ck
        mov    ah, 02H            ; int 21H,02H - escribe el caracter de salida
        jnz    CAPSON             ; salta si no es cero o error
        mov    cx, 04
        mov    dl, 20H            ; Set the character writen to STDOUT to spcae 
cic1_tipo_captura:
        int    21H
        loop   cic1_tipo_captura            ; loop to clean Caps Lock information
        jmp    num
CAPSON: mov    dl, 'C'            ; Show CAPS
        int    21H
        mov    dl, 'a'
        int    21H
        mov    dl, 'p'
        int    21H
        mov    dl, 's'
        int    21H
num:    ; Num Lock
        mov    posy, 70            ; posyumn location of cursor
        call   cursor_posicion              ; move cursor to show Num Lock information
		mov    ah, 12H
        int    16H                ; int 16H,12H - query extended keyboard shift status
        and    al, 00100000B      ; Check Num Lock)
        mov    ah, 02H
        JNZ    NUMON              ; Jump short if not zero (ZF = 0)
        mov    cx, 03
        mov    dl, 20H            ; Set the character writen to STDOUT to spcae 
NUMOFF:
        int    21H
        loop   NUMOFF             ; loop to clean Num Lock information
        jmp    sal_tipo_captura
NUMON:  mov    dl, 'N'            ; Show NUM
        int    21H
        mov    dl, 'u'
        int    21H
        mov    dl, 'm'
        int    21H

sal_tipo_captura:
        pop    dx                 ; restauramos la posicion x y y
        mov    posy, DH
        mov    posx, dl
        pop    ax
        pop    cx
        ret
error_manejo:   call reto
                mov dx,ax
                call des4
;creamos el archivo temporal
crear_archivo:
        mov    ah, 3CH
        mov    cx, 00             ; Normal crear_archivo2
        LEA    dx, archivo_temo            ; archivo_temporal
        int    21H                
        jc     error_manejo       ; Check create condition
        mov    fid, ax        ; Save crear_archivo2 handle
        jmp    salida        
salida:
        ret

;nos permite crear un archivo nuevo
crear_archivo2:   
        push   cx
        push   ax
        clc                                     ;bandera de acarreo limpiar
        mov    posx, 24
        mov    posy, 9
        call   cursor_posicion                  ; move cursor location for input crear_archivo2 name
        call   extraer_nombre_archivo           ; llamamos a llamar el nombre
        pop    ax
        mov    al, 00
        mov    cx, 00                           ; abrimos el arhivo en normal
        lea    dx, nombre_archivo            ; nombre del archivo 
        int    21H
        jc     eror_archivo
        mov    fid, ax                      ; mandamos el nombre del archivo al identificador
        jmp    sal_archivo
eror_archivo:        
        mov    posx, 24
        mov    posy, 9
        call   cursor_posicion                  ;locacion del sursor para imprimir el mismo eh imprimir el mensaje de error
        mov    dx,ax                        ; 
        call des4                            ;desplegamos el mendaje de error
sal_archivo:
        ;restablecemos el cursor
        mov    posx, 00
        mov    posy, 00
        call   cursor_posicion              ; move cursor location
        pop    cx
        ret
        pop    ax       ;restauramos la pila
        jmp    eror_archivo




	;---------------------------------------
	; Save crear_archivo2
	;---------------------------------------
escribir_archivo:
        CLC
        mov    ah, 40H
        mov    BX, fid              ; extraemo el  handle del archivo (identificador)
        mov    cx, 8000             ;numero de datos a escribir
        LEA    dx, buffer         
        int    21H               
        JNC    sal_escribirarchivo
        LEA    dx, ERROR          ; Show error message if save fail
        mov    ah, 09H
        int    21H
sal_escribirarchivo: ret

	;---------------------------------------
	; End of save crear_archivo2
	;---------------------------------------

;lectura de los archivos
leer: 
        mov    ah, 3FH
        mov    BX, fid              ; handle del archivo
        mov    cx, 8000             ;numero de datos a leer
        LEA    dx, buffer           ;espacio de guarda
        int    21H                  ; int 21,3FH - leer a crear_archivo2
        jc     NEWFAIL              ; Error check
        jmp    NEWOK
NEWFAIL:
        LEA    dx, ERROR          ; Show error message if save fail
        mov    ah, 09H
        int    21H        
NEWOK:  ret
	;---------------------------------------
	; End of open a crear_archivo2
	;---------------------------------------

	;---------------------------------------
	; Close crear_archivo2
	;---------------------------------------
close: 
        mov   BX, fid         ; crear_archivo2 handle
        mov   ah, 3EH
        int   21H                 ; int 21,3EH - close crear_archivo2
        ret
	;---------------------------------------
	; End of close crear_archivo2
	;---------------------------------------

	;---------------------------------------
	; Acquire crear_archivo2 name
	;---------------------------------------
extraer_nombre_archivo:
        push   ax
        push   cx
        mov    posx, 24
        mov    posy, 9
        call   cursor_posicion              ; move cursor location

		;-----------------------------------
		; clean up input space
		;-----------------------------------
        mov    cx,25
        mov    al,20H
EMPTY:  call   escribir_caracter
        loop   EMPTY

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
        loop   CLEAN

        ;-----------------------------------
		; Input
		;-----------------------------------
        mov    ah, 0ah
        LEA    dx, LIST
        int    21H
        movZX  BX, LEN
        mov    nombre_archivo[BX], 00H

        pop    cx
        pop    ax
        ret
	;---------------------------------------
	; End of acquire crear_archivo2 name
	;---------------------------------------

	;---------------------------------------
	; Show menu bar and status bar
	;---------------------------------------
Menu:
        mov    ax, 0600H
        mov    BH, 07H          ;fondo blanco sobre azul    
        mov    cx, 0000H
        mov    dx, 184FH
        int    10H
        call   cursor_posicion
        mov    ah, 02H
        mov    posx, 1
        call   cursor_posicion

        mov    posx, 23
        call   cursor_posicion
        
        mov    posx, 24
        mov    posy, 0
        call   cursor_posicion
        mov    ah, 02H
        mov    dl, 'F'
        int    21H
        mov    dl, 'i'
        int    21H
        mov    dl, 'l'
        int    21H
        mov    dl, 'e'
        int    21H
        mov    dl, 'n'
        int    21H
        mov    dl, 'a'
        int    21H
        mov    dl, 'm'
        int    21H
        mov    dl, 'e'
        int    21H
        mov    dl, ':'
        int    21H
        mov    dl, 'F'
        int    21H
        mov    dl, 'N'
        int    21H
        mov    dl, 'E'
        int    21H
        mov    dl, 'W'
        int    21H
        mov    dl, '.'
        int    21H
        mov    dl, 't'
        int    21H
        mov    dl, 'x'
        int    21H
        mov    dl, 't'
        int    21H
        mov    posx, 2
        ret

entrada_del_usuarios:
        mov    ah, 10H            ;esperamos los datos de entrada
        int    16H
        cmp    ah, 01H              ;	Obtener el estado del buffer del teclado
        je     sal_en               ;si es esc salimos de la lectura de datos den entrada
        cmp    al, 00H              ;si no hubo errores
        je     FunKey            
        cmp    al, 0E0H             ;es una tecla de funcion extendida como las flecas
        je     FunKey
        call   comprobar_caracter   ;comprobamos que los datos de entrada sean un caracter
        jmp    salida_entrada_usuarios             ; leave
Funkey:
        cmp    ah, 47H            ; tecla de inicio?
        JNE    salto1               ;si no es la tecla de terminar
        call   restablecer_posicion_inicial ; restablecer_posicion_inicial
        jmp    salida_entrada_usuarios
salto1: cmp    ah, 4FH            ; busca el siguiente
        JNE    salto2
        call   limite_y              ; si si para llamar a brincar al final
        jmp    salida_entrada_usuarios             ; salir
salto2:
        cmp    ah, 50H            ; abajo de la posicon de X 
        jne    salto3
        call   para_abajo             ; para_abajo
        jmp    salida_entrada_usuarios             ; salir

salto3:  cmp    ah, 48H            ; arriba
        JNE    ArrR
        call   toUp               ; toUp
        jmp    salida_entrada_usuarios             ; leave

ArrR:   cmp    ah, 4DH            ; flcha derecha
        JNE    ArrL
        call   mover_derecha                ; mover_derecha
        jmp    salida_entrada_usuarios             ; leave

ArrL:   cmp    ah, 4BH            ;flecha izquierda
        JNE    tecla_enter
        call   limite_izquierdo_tecla                ; limite_izquierdo
        jmp    salida_entrada_usuarios             ; salir

tecla_enter: cmp    ah, 52H            ; es insertar?
        jne    tecla_arriba
        call   tecla_insertar              ; tecla_insertar
        jmp    salida_entrada_usuarios             ; leave

tecla_arriba:  cmp    ah, 49H            ; flecha arriba
        JNE    tecla_abajo
        call   subir_pagina              ; subir_pagina
        jmp    salida_entrada_usuarios             ; leave

tecla_abajo:  cmp    ah, 51H        ; flecha abajo
        JNE    tecla_borrar
        call   bajar_pagina              ; bajar_pagina
        jmp    salida_entrada_usuarios             ; leave

tecla_borrar: cmp    ah, 53H            ; borrar_caracter 
        JNE    salida_entrada_usuarios             ; salir
        call   borrar_caracter             ; call borrar_caracter

salida_entrada_usuarios: ret
sal_en:  call   esc_escribir
        ret

restablecer_posicion_inicial:
        mov    posy, 00            ; pos 00
        ret

	; funcion de tecla hacia arriba
subir_pagina:
        mov    cx, 19             ; move up 19 times
cic_subir:   call   toUp               ; Up
        call   cursor_posicion              ; move cursor location
        loop   cic_subir
        ret

;funcion que nos permitte bajar la pagina
bajar_pagina:
        mov    cx, 19                   ;mover  19 veces hacia abajo
cic_bajar: call   para_abajo               ;bajar
        call   cursor_posicion          ; move cursor location
        loop   cic_bajar
        ret


;nos permite cambiar entre la pantalla de menu y la pantalla de editar
esc_escribir:
        mov    posy, 00
        cmp    posx, 00
        jne    reestablecer_esc
        mov    posx, 02            ; Editor space
        jmp sal_esc
reestablecer_esc:   
        mov    posx, 00            ; Menu bar
        mov    posy, 2
sal_esc: ret


limite_y:
        mov    posy, limite_derecho        ; move cursor location to last
        ret

para_abajo:
        cmp    posx, 00
        je     sal_abajo             ; saltamos si es una accion dentro del menu
        cmp    posx, limite_inferior        ; limite de x 
        JAE    scrU
        INC    posx                ; siguiente posicion de x

	    ; Desplácese hacia arriba si está en la parte inferior del espacio del editor
scrU:   cmp    Ltop, limite_pantalla
        JAE    sal_abajo
        mov    ax, 0601H        
        call   limpiar_pantalla             ; hacia arriba
        INC    Ltop
        call   SCR1
        jmp    sal_abajo             ; Leave
sal_abajo: ret 


; Tratar con los contenidos cuando se desplaza una línea

SCR1:
        push   cx
        mov    DH, posx            ;salvamos las posiciones del curo
        mov    dl, posy
        push   dx
        mov    posy, 0
        call   cursor                ; juzgar la ubicación del cursor
        call   cursor_posicion        ;movemos en donde se encuentra el cursor
        mov    BX, locacion         ;locacion del cursor la movemos a bx
        LEA    SI, [buffer+BX]      ;nos movemos en el bufer dependiendo del contenido
de:     mov    al, [SI]           ; movemos o desplazamos el caracter para imprimir
        INC    SI
        call   escribir_caracter    ;imprimirmos el caracter
        cmp    posy, limite_derecho         ;revisamos si estamos en el limite derecho
        JB     de

		;ultimo caracter
        call   cursor
        mov    BX, locacion         ;nuevamente volvemos a obtener la locacion
        mov    al, [buffer+BX]
        mov    ah, 09H              ;imprimimos el contenido
        mov    BH, 0
        mov    BL, 07H              ;;Atributo de relleno
        mov    cx, 01
        int    10H
        pop    dx                 ; restauramos las posiciones anteriormente guardadas
        mov    posx, DH             ;cambiamos por las nuevas posiciones
        mov    posy, dl
        pop    cx
        ret

toUp:
        cmp    posx, 00
        je     salida_tra           ; Skip menu bar
        cmp    posx, limite_superior        ;estamos en el limitesuperior?
        JBE    scrD
        DEC    posx                ; decrementamos la posicion de lo contrario
;Desplácese hacia abajo una posx cuando alcance el límite superior
scrD:   cmp    Ltop, 01
        JB     salida_tra
        mov    ax, 0701H        
        call   limpiar_pantalla             ; int 10H,07H - scroll down
        DEC    Ltop
        call   SCR1
        
salida_tra:
        ret


mover_derecha:
        cmp    posy, limite_derecho        ; Right limit?
        JAE    linea_siguiente
        INC    posy                ; Increase posyumn
        ret
linea_siguiente:
		; pasar a la siguiente posx cuando alcance el límite derecho
        cmp    Ltop, limite_pantalla
        JB     mas_derecha
        jmp sal_derecha
mas_derecha:    ;nos movemos a la posicion inicial de la derecha
        call   restablecer_posicion_inicial
        call   para_abajo
sal_derecha:ret
	;---------------------------------------
	; End of right arposx
	;---------------------------------------


limite_izquierdo_tecla:
        cmp    posy, limite_izquierdo        ; Left limit?
        JBE    up
        DEC    posy                ; Decrease posyumn
        ret
up:
        ;-----------------------------------
		; move to up posx when reach left limit
		;-----------------------------------
        call   limite_y
        call   toUp
        ret
	;---------------------------------------
	; End of left arposx
	;---------------------------------------

;tecla borrar
borrar_caracter:
        mov    BH, posy             ;obtenmos las posiciones 
        mov    BL, posx
        push   BX                 ;salvamos las posisciones
        call   cursor               ;imprimirmos lo que tenemis
        mov    BX, locacion         ;ahora referemos en que posicion estamos
        LEA    DI, [buffer+BX]      ;guardamos la posicion del arrelo
        LEA    SI, [buffer+BX+1]    ;cuando escriba de nuevo ponerlo adelante del caracter borrado
borrar_c: mov    al, [SI]
        mov    [DI], al
        INC    SI                   ;cada que escriba nos movemos a la siguiente posicion
        INC    DI
        call   escribir_caracter        ;escribimos el caracter leido
        cmp    posy, limite_derecho        ;si ya estamos en el limite de la pantalla
        JB     borrar_c

        call   cursor                       ;mandamos a taer el cursor
        mov    BX,locacion                  ;referimos la locacion del mismo
        mov    [buffer+BX], 20H         ;final de los caracteres de modo grafico
        mov    al, 20H                  ;movemos el final de cadena en al 
        mov    ah, 09H                  ;
        mov    BH, 0                    ;bloque a leer 
        mov    BL, 07H                  ;numero de bytes por caracter
        mov    cx, 01                   ;numero de caracteres a cambiar 
        int    10H

        pop    BX                 ;regresamos los datos originales 
        mov    posy, BH
        mov    posx, BL
        ret

tecla_insertar:
        mov    DH, posy
        mov    dl, posx
        push   dx
        push   cx
        push   ax
        xor    InKey, 1111B       ; Convert insert key status
        mov    posx, 24
        mov    posy, 75
        call   cursor_posicion
        mov    ah, 02H
        cmp    InKey, 0000B
        JNE    INSERTON
        mov    cx, 03
INSERTOFF:
        mov    dl, 20H
        int    21H
        loop   INSERTOFF
        jmp    INSERTEND
;colocamos en la esquina inferior derecha que estamos en modo de insercion
INSERTON:
        mov    dl, 'I'
        int    21H
        mov    dl, 'N'
        int    21H
        mov    dl, 'S'
        int    21H
INSERTEND:
        pop    ax
        pop    cx
        pop    dx
        mov    posy, DH
        mov    posx, dl
        ret

;comprobar que los datos de entrada son un caracter
comprobar_caracter:
        cmp    al, 0DH            ; Enter
        je     Ent
        cmp    posx, 00
        je     NOChar
        cmp    al, 08H            ; Back Space?
        je     BACKSPACE
        cmp    al, 09H            ; Tab?
        je     Tab
        cmp    al, 20H            ; Out of range?
        JB     NOChar
        cmp    al, 7EH            ; Out of range?
        JA     NOChar            
        cmp    InKey, 00
        JNE    IN_ON
        call   salvar             ; Save to buffer
        call   escribir_caracter              ; Write character
NOChar:        ret

BACKSPACE:
        ;-----------------------------------
		; Back space
		;-----------------------------------
        cmp    posy, 00            ; Left limit?
        JBE    NOChar
        DEC    posy                ; Decrease one posyumn
        call   cursor_posicion              ; move cursor location
        call   borrar_caracter             ; borrar_caracter
        ret
Tab:
        ;-----------------------------------
		; Insert 6 space for tab
		;-----------------------------------
        mov    al, 20H            ; Space
        mov    cx, 06             ; 6 times
repeatSpace:
        call   salvar             ; Save content into buffer
        call   escribir_caracter              ; Show space
        loop   repeatSpace
        ret

IN_ON:  call    insertar_archivo            ; Insert
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
        call   limpiar_pantalla             ; Scroll
        mov    ah, 3CH            ; Create new crear_archivo2
        call   crear_archivo2               ; Create new crear_archivo2
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
        call   limpiar_pantalla             ; Scroll
        mov    ah, 3DH            ; Open crear_archivo2
        call   crear_archivo2               ; Open crear_archivo2
        call   leer               ; leer crear_archivo2 content
        jmp    Lout

isSAVE:
        ;-----------------------------------
		; Save
		;-----------------------------------
        cmp    posy, 12
        JB     isWINDOW
        cmp    posy, 15
        JA     isWINDOW
        call   escribir_archivo              ; Save content
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
        call   close              ; Close crear_archivo2
        mov    ax, 4C00H          ; Exit program
        int    21H

        ret
Lout:   call   restablecer_posicion_inicial
        call   para_abajo
        ret

;datos en modo insercion del archivo 
insertar_archivo:
        call   cursor
        mov    cx, 8000
        lea    SI, buffer+7998  ;seteamos los contadores en las ultimas posiciones del bufer
        lea    DI, buffer+7999
L1:     mov    DH, [SI]
        mov    [DI], DH
        DEC    SI
        DEC    DI
        DEC    cx
        cmp    cx, locacion             ; completamos el movimiento
        ja     L1                       ;Salta si está arriba o si es igual o salta si no está abajo.
        call   escribir_caracter                ; Wescribirmos el caracter
        call   salvar                           ;salvamos lo que tiene escrito en el buffer
        mov    BH, posy
        mov    BL, posx
        push   BX                       ;respladamos en pila las posiciones
        call   cursor                   ;llamamos el cursor
        mov    BX, locacion             ;llamamos la locacion del cursor
        mov    DH, Ltop                ;mocemos lo que tenemos en dh que en este caso es el lo que tiene el buffer en SI que es el contador
        push   dx
        mov    Ltop, 00             ;seteamos el tope izquiero como 00 para volver iniciar en la siguiente linea
        call   cursor
        mov    cx, locacion         ;obtenemos la locacion
        LEA    DI, buffer           ;movemos lo que tiene el bufer a di 
	;mostrar y mover el caracter
L2:     mov    al, [DI+BX]    
        INC    BX                   ;incrementamos bx ambas posiciones tanto x como y
        INC    cx                   ;incrementamos cx la locacion
        call   escribir_caracter        
        cmp    cx, 1598        
        JBE    L2
        ;el caracter esta en la ultima posicion de x
        mov    al, buffer+1599  ;pongo el 1599       
        mov    ah, 09H            
        mov    BH, 0            
        mov    BL, 07H            
        mov    cx, 01            
        int    10H
        pop    dx
        mov    Ltop, DH        
        pop    BX                 ; Recover save posyumn and posx
        mov    posy, BH
        mov    posx, BL
        ret


;salvar los datos bufer bufer
salvar:
        push   ax
        call   cursor             ; Calculate index for save
        mov    BX, locacion             ; move index to BX
        LEA    DI, buffer
        mov    [DI+BX], al        ; move input date to buffer
        pop    ax
        ret

;ubicacion actual del cursor
cursor:
        push   cx
        push   dx

        mov    locacion, 00             ; Reset locacion
        movZX  cx, posx
        DEC    cx
        DEC    cx
        movZX  dx, Ltop           ;movzx es para tranferir un dato agregando ceros
        ADD    cx, dx
        cmp    cx, 01             ; First posx?
        JB     agregar_posy

agregar_posx: add   locacion, 80             ;agregamos 80 posiciones adicionales a X 
        loop   agregar_posx
        
agregar_posy: movZX  dx, posy           ;tranferimos un dato agregando ceros
        add    locacion, dx

        pop    dx
        pop    cx
        ret
        
;escribimos el caracter
escribir_caracter:
        push   ax
        push   cx
        mov    ah, 09H
        mov    bh, 0              ; numero de caracter
        mov    bl, 07H            ; atributo de fondo blanco sobre azul
        mov    cx, 1
        int    10H                ; int 10H,09H - escribir el caracter en la locacion designada
        call   mover_derecha                ; mover a la derecha para ir a la siguiente posicion
        call   cursor_posicion              ; move cursor a la posicion
        pop    cx
        pop    ax
        ret


;mever el cursor a la locacion
cursor_posicion:
        mov    ah, 02H
        mov    bh, 00
        mov    dh, posx
        mov    dl, posy
        int    10H                ; int 10H,02H - setear el cursor en la locacion
        ret

limpiar_pantalla:   
        push   cx                
        mov    BH, 07H            ; posyor
        mov    cx, 0200H          ; Top-Left
        mov    DX, 164FH          ; Right-Down
        int    10H
        pop    cx
        ret                

END ;fin del programa