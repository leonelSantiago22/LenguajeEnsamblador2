.model small
.486
include ..\fun\macros.asm
extrn des4:near
extrn reto:near
extrn des2:near
extrn spc:near
.stack
.data
        posx db 0        ;posicion en x 
        posy    db      0       ;posicion en y
        numero_archivos db 0    ;contador de archivos
        pre_cad db 2 dup(?)
        nombre_archivo db 20 dup(00h) 
        bufer 	 db 0fffh dup('$');el buffer es un espacio de memoria para poner temporalmente los datos  
        bufer2 db 0fffh dup('$')
        fid dw ?            ;Identidificador del archivo
        espacio dw ?
        vec db 50 dup('$')
        buffer_archivo      DB     8000 DUP(20H) ;buffer para escribir en el archivo
.code 
main:   mov ax,@data
        mov ds,ax 
                
        call leerelnombredelarchivo
        call crear_archivo
        call insertar_archivo
        call cerrar_archivo
        ;call crear_archivo
        ;call leerelnombredelarchivo
        ;call imprimir_archivo
        ;call editar_archivo
        ;call borrar_archivo
        ;call cerrar_archivo
        
        .exit 0

;En caso de error para saber si el error es facil
error:  call reto
        mov dx,ax
        mov dx,offset nombre_archivo
        mov ah,09h
        int 21h
        call reto
        call des4
        ;.exit 1

leerelnombredelarchivo:
        mov dx,offset nombre_archivo
        mov cl,20
        call leecad         ;funcion que nos permite leer una cadena
        mov bl,al
        mov bh,0
        mov nombre_archivo[bx],24h
        
ret
;Desplegar el contenido del arreglo en hexadecimal
desarr: cld
        mov si,offset pre_cad    ;le agrea 3 posiciones al arrglo
        mov ch,0h
        ;mov cx,20
desarr_cic:  lodsb
        mov dl,al 
        call des2
        call spc 
        loop desarr_cic
        call reto
        ret 
;Funcion que nos permite crear el archivo puede ser con un nombre especifico 
crear_archivo:
        mov ah,3Ch ;Código para crear archivo.
        mov cx,0 ;Archivo normal.
        lea dx, nombre_archivo ;Dirección del nombre.
        int 21h ;Crear y abrir, devuelve ident.
        jc error ;Saltar en caso de error.
        mov fid,ax
ret 

;Funcion para cerral el archivo
cerrar_archivo: 
        mov ah,3Eh ;Código para cerrar archivo
        mov bx,fid ;Identificador.
        int 21h ;Cerrar archivo
        jc error ;Saltar en caso de error

ret

imprimir_archivo:
        mov ah,3Dh ;Código para abrir archivo
	mov al,0 ;Modo lectura
	mov dx,offset nombre_archivo ;Dirección del nombre
	int 21h ;Abrir, devuelve ident
	jc error ;En caso de error, saltar
	mov bx,ax ;guardar identificador
	;Leer el archivo        
	;fread( &contenido, srtlen( contenido ), 1, fid );
	;dentro de un ciclo
                cic_im:	mov ah,3Fh ;Código para leer archivo
                        mov bx,bx ;Identificador
                        mov cx,1h ;Tamaño deseado
                        mov dx,offset bufer2 ;Dirección búfer
                        int 21h ;Leer archivo
                        jc error ;Si hubo error, procesar
                        ;salir si ya no hay mas
                        
                        ;Colocar símbolo $ al final de cadena leída
                        cmp ax,0
                        je sal_im
                        mov bx,ax;nos dice cuanto leyo
                        add bx,offset bufer2
                        mov byte ptr[bx],'$'
                        mov espacio,bx  ;conocer cuantos espacios se imprimieron
                        ;Desplegar cadena leída
                        mov dx,offset bufer2
                        mov ah,09h
                        int 21h
		
		jmp cic_im
sal_im:
        ret
borrar_archivo:
        mov ah,41h
        mov dx, offset nombre_archivo
        int 21h
        jc error
ret
editar_archivo:
        push ax 
        push bx  
        push di
        push es 
        push dx
        push si
        mov si,0
pedir2: mov ah,01h
        mov bufer[si],al                ;obtenemos donde se encuentra la posicion
                                  ;Incrementamos las posiciones que agregamos
        int 21h
        inc si
        cmp al,1bh                      ;comparamos si es diferente de esc
        ;ja pedir                        ;SEgumimos pidiendo
        jne pedir2
        call reto
        mov ah,3dh                    ;SERVICIO DE APERTURA DE ARCHIVO
        mov dx, offset nombre_archivo  ;SE SETEA EL NOMBRE DEL ARCHIVO
        mov al,2                    ;MODO SOLO ESCRITURA
        int 21h                       ;SE ABRE EL FICHERO PARA TRABAJAR
        mov bx,ax
        mov ah,40h                  ;SERVICIO PARA ESCRIBIR MENSAJE
        mov cx,si               ;SETEO TAMANIO DE MENSAJE
        mov dx,offset bufer   ;PONGO EL MENSAJE QUE SE VA A ESCRIBIR
        int 21h                     ;SE GUARDA EL Mcd ENSAJE
        jc error
        pop si
        pop dx       
        pop es 
        pop di      
        pop bx
        pop ax
ret

insertar_archivo:
        clc 
                mov ah, 40H
                mov bx,fid      ;obtenemos el identificador del arhivo
                mov cx,8000     ;tamano de los caracteres a insertar
                LEA dx,buffer_archivo    ;mandamos a llamar los dator para escribir
                int 21H
                jnc guardar_ok 
                jc error
guardar_ok:
        ret



leecad: mov bx,dx ;vamos a usar bx como apuntador
        sub dx,2
        mov [bx-2],cl       ;ponemos donde apunta dx el tamano de la cadena
        mov ah,0Ah                  ;ya esta en dx el offset del arreglo 
        int 21h 
        call reto
        mov al, [bx-1]          ;aqui pone realemente el tamano que leyo
        ret

archivos_abrir:
                push cx                 ;respaldamos el conteo
                push ax 
                cmp numero_archivos,05
                jae muchos
                clc                     ;limpiamos la bandera de acarrero
                mov posx, 24            ;movemos la fila 
                mov posy,9              ;movemos columna 
                call cursor_locacion    ;locacion del cursor 
                call nombre_del_archivo
muchos:         
ret

;conocer el nombre del archivos
nombre_del_archivo:
                push ax 
                push cx 
                mov posx,24 
                mov posy,9
                call cursor_locacion

                ;limpiar el buffer de entrada 
                mov cx,20
                mov si,00000
limpiar:        mov nombre_archivo[SI],20H
                inc si
                loop limpiar

                call leerelnombredelarchivo

                pop cx 
                pop ax 
                ;entrada 


ret

escribir_caracter:
                push ax 
                push cx ;respaldo del uso de contadores 

                mov ah,09h ; escribimos el caracter
                mov bh, 0
                mov bl, 71H     ;atributo q 
                mov cx,1        ;inicializamos contador 
                int 10h         ;escribir el caracter en la locacion del cursor 
;ok
es_rep:         call mover_derecha ;movemos a la derecha 
                call cursor_locacion    ;localizacion del cursor
                pop cx 
                pop ax 
ret
;locacion del cursor
cursor_posicion:
        mov    ah, 02H
        mov    BH, 00
        mov    DH, posx
        mov    dl, posy
        int    10H                ; int 10H,02H -  Set cursor location
        ret

salvar:
        push   ax
        call   Now                ;calculamos el tamano para salvar ese tamano
        mov    BX, LO             ; movemos ese tamano a bx
        LEA    DI, buffer
        mov    [DI+BX], AL        ;movemos la entrada al bufer
        pop    ax
        ret

limpiar_pantalla:   
push   cx                
mov    BH, 71H            ; posyor
mov    cx, 0200H          ; maximo, dertcha
mov    DX, 164FH          ; arriba anajo
int    10H
pop    cx
ret

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

;escribir en el archivo
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
end