.model small
include ..\fun\macros.asm
extrn des4:near
extrn reto:near
extrn des2:near
extrn spc:near
.486
;org 100h
.stack
.data
    ban1           db 0
    posX           db ?  ; dh = posX -> controlar filas
    posY           db ? ; dl = posY -> controlar columnas para el puntero 
    pre_cad        db 2 dup(?)
    nombre_archivo db 20 dup(00h)  
	bufer 	       db 0fffh dup('$');el buffer es un espacio de memoria para poner temporalmente los datos  
    bufer2         db "Hola buenas"
    fid            dw ?            ;Identidificador del archivo
    espacio        dw ?
    vec            db 50 dup('$')
.code 

main:	mov ax,@data
		mov ds,ax
		mov es,ax
		;llamar a la funcion editor en donde esta el menu y sus opcione
		mov ah,06h
		mov bh,1Fh;color
		mov cx,0000h
		mov dx,184fh;hasta donde acaba la pantalla 
		int 10h;con 10h se puede hacer todo lo dema
		call editor
	    .exit 0
	  
	  ;En caso de error para saber si el error es facil
error:  mov dx,ax
        call des4
        .exit 1
		
editor:	
;iniciamos con mostrar menu 	
  mostrar_menu:
		
		mov ah,06h
		mov bh,1Fh;color
		mov cx,0000h
		mov dx,184fh;hasta donde acaba la pantalla 
		int 10h;con 10h se puede hacer todo lo dema
		call posicionar_cursor_inicio;posicionar el cursor en las coordenadas 0000,0000 para que siempre se quede arriba el menu
		call menu ;llamar el  menu
		;ahora esta en dl la opcion selecionada en menu
		cmp dl,31h;comparacion para saber que hacer 
		je crear;salta a crear archivo
		
		cmp dl,32h
		je abrir;salta a imprimir archivo
		
		cmp dl,33h
		je editar;salta a modificar archivo
		
		cmp dl,35h
		je borrar;salta a borrar archivo
		
		cmp dl,1Bh;compara si es ESC
		je salida1;salida 
		;si no es ninguna de estas opciones entonces esta escribiendo en pantalla y eso hay que escribirlo
		;Entonces crear un nuevo archivo pero con un nombre default
		;Escribir en el lo que esta poniendo
		
	jmp mostrar_menu
		;ahora con las opciones:
 crear:  ;crear un nuevo archivo
		call reto
         call insertar_archivo
		 jmp mostrar_menu
         call cerrar_archivo
      
 abrir:;imprimir un archivo
		print"Nombre archivo: "
        call leerelnombredelarchivo;poner nombre de archivo
		call imprimir_archivo
		call mov_pun
		mov ah,01;si no es esc
		 int 21h
		 cmp al,1Bh
		 je mostrar_menu
	   
		jmp mostrar_menu
        
		;call cerrar_archivo


 editar:;opcion de modificar un archivo (llamar a editar)}
		call leerelnombredelarchivo
		call editar
		call cerrar_archivo
        jmp mostrar_menu
 borrar:;opcion de borrar un archivo
		call reto
		print "nombre del archivo a borrar :"
		call leerelnombredelarchivo
        call borrar_archivo
		jmp mostrar_menu 
 salida1:;call cerrar_archivo
		ret 

;funcion del menu
menu:	
		call reto
        print "|1=Crear archivo |"
        print " |2=Imprimir archivo|"
		call reto
        print " |3=Modificar archivo|"
		print " |4=Borrar archivo|"
        print " |ESC=Salir|"
		call reto
		
		;leer la opcion del usuario
		mov ah,01h
		int 21h
		;regresar en dx la opcion
		mov ah,0h
		mov dx,ax


ret 	

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
        mov dx,offset nombre_archivo ;Dirección del nombre.
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

leecad: mov bx,dx ;vamos a usar bx como apuntador
        sub dx,2
        mov [bx-2],cl       ;ponemos donde apunta dx el tamano de la cadena
        mov ah,0Ah                  ;ya esta en dx el offset del arreglo 
        int 21h 
        call reto
        mov al, [bx-1]          ;aqui pone realemente el tamano que leyo
        ret
	
posicionar_cursor_inicio:
	 mov ah,02h
	 mov bh,00h
	 mov dx,000h
	 int 10h
ret 

imprimir_archivo:
        mov ah,3Dh ;Código para abrir archivo
	mov al,0 ;Modo lectura
	mov dx,offset nombre_archivo ;Dirección del nombre
	int 21h ;Abrir, devuelve ident
	jc error ;En caso de error, saltar
	mov fid,ax ;guardar identificador
	;Leer el archivo
	;fread( &contenido, srtlen( contenido ), 1, fid );
	;dentro de un ciclo
     cic_im: mov ah,3Fh ;Código para leer archivo
             mov bx,fid ;Identificador
             mov cx,10h ;Tamaño deseado
             mov dx,offset bufer ;Dirección búfer
             int 21h ;Leer archivo
             jc error ;Si hubo error, procesar
             ;salir si ya no hay mas
             
             ;Colocar símbolo $ al final de cadena leída
             cmp ax,0
             je sal_im
             mov bx,ax;nos dice cuanto leyo
             add bx,offset bufer
             mov byte ptr[bx],'$'
             ;Desplegar cadena leída
             mov dx,offset bufer
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


mov_pun:
       
inicio: ;print"entro en editar"
        mov ah,0      ;<==================================
        int 16h  
        cmp al,1Bh; ESC
        je sal1;si es esc
		call pos_cursor
		mov ah,02h
		int 10h
		cmp al,36h  ;cursor arriba
		je movArr
		cmp al,37h  ;cursor izquierda
		je movIzq
		cmp al,38h ;cursor derecha
		je movDer
		cmp al,39h  ;cursor abajo
		je movAbajo
		jmp inicio
 movDer:
		mov dl, posX
		mov dh, posY    
		inc dl ; posX ++
		mov posX, dl
		mov ah,02h
		int 10h
		jmp inicio

 movIzq:
		mov dl, posX    
		mov dh, posY     
		dec dl ; posX -- 
		
		mov posX, dl 
		mov ah,02h
		int 10h
		jmp inicio

 movArr: 
	    mov dl, posX     ;<==================================
		mov dh, posY     ;<==================================
		dec dh ; posY -- 
		mov posY, dh     ;<==================================
		mov ah,02h
		int 10h
		jmp inicio

 movAbajo:   
		mov dl, posX     ;<==================================
		mov dh, posY     ;<==================================
		inc dh ; posY ++ ;<==================================
		mov posY, dh     ;<==================================
		mov ah,02h
		int 10h        
		jmp inicio
sal1:

ret 


pos_cursor:
		mov ah,03h;para obtener la posicion actual del cursor
		mov bh,00
	    int 10h
		
		; devuelve en dh renglon, dl:columna
		mov posX,dl
		mov posY,dh
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
        jne pedir
        call reto
        print "estas seguro que quieres hacer estos cambios? S/N"
        mov ah,01h
        int 21h                     
        cmp al,6eh
		je mostrar_menu;si no se regres al menu
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
        ;mov ah,3dh                    ;SERVICIO DE APERTURA DE ARCHIVO                      ;SE ABRE EL FICHERO PARA TRABAJAR    
        mov si,0
pedir:  mov ah,01h
        mov bufer[si],al                ;obtenemos donde se encuentra la posicion
                                  ;Incrementamos las posiciones que agregamos
        int 21h
        inc si
        cmp al,1bh                      ;comparamos si es diferente de esc
        ;ja pedir                        ;SEgumimos pidiendo
        jne pedir
        call reto
        print "estas seguro que quieres hacer estos cambios? S/N"
        mov ah,01h
        int 21h
        cmp al,6eh
        je mostrar_menu
        call reto
        print "Ingresa el nombre del archivo:"
        call leerelnombredelarchivo
        call crear_archivo
        mov ah,3dh
        mov al,1h  
        mov dx,offset nombre_archivo  ;SE SETEA EL NOMBRE DEL ARCHIVO                  ;MODO SOLO ESCRITURA
        int 21h                       ;SE ABRE EL FICHERO PARA TRABAJAR
        jc error
        mov bx,ax
        mov cx,si               ;SETEO TAMANIO DE MENSAJE
        mov dx,offset bufer   ;PONGO EL MENSAJE QUE SE VA A ESCRIBIR 
        mov ah,40h                  ;SERVICIO PARA ESCRIBIR MENSAJE
        int 21h                     ;SE GUARDA EL Mcd ENSAJE
        cmp cx,ax 
        jne salir_insertar
        call crear_archivo

salir_insertar:
        ret




		
end 
		