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
    posX           db ? ;dh = posX -> controlar filas
    posY           db ? ;dl = posY -> controlar columnas para el puntero 
    pre_cad        db 2     dup(?)
    nombre_archivo db 20    dup(00h)  
	bufer 	       db 0fffh dup('$');el buffer es un espacio de memoria para poner temporalmente los datos  
    bufer2         db "Hola buenas"
    fid            dw ?            ;Identidificador del archivo
    espacio        dw ?
    vec            db 50    dup('$')
	numpan         db ?; variable para saber el numero de pantalla 
	punpan         db ? ;variable para que podamos mover el puntero en las diferentes pantallas
	posp           db ? ;variable para ver si se ingreso una flecha del teclado
.code 

main:	mov ax,@data
		mov ds,ax
		mov es,ax
		
a:		call editor
		jmp s
	   ;En caso de error para saber si el error es faci
error:  call reto
		print "Error de archivo:"
		mov dx,ax
        call des4
		mov ah,01
		int 21h
		jmp a
		
s:	    .exit 0
	  
		
editor:	
;iniciamos con mostrar menu 	
  mostrar_menu:
		 
       ;Si se llama a mostrar en menu nos vamos  a la pantalla de menu que es la principal (0)
		mov numpan,0
		call cambiar_pantalla
		;limpiar la pantalla con un color azul y letras blancas
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
		je abrir;salta a cargar archivo
		
		cmp dl,33h
		je borrar;salta a borrar archivo
		
		cmp dl,1Bh;compara si es ESC
		je salida1;salida 
		;si no es ninguna de estas opciones entonces esta escribiendo en pantalla y eso hay que escribirlo
		;Entonces crear un nuevo archivo pero con un nombre default
		;Escribir en el lo que esta poniendo
		jmp mostrar_menu
	
	
	;ahora con las opciones:
 crear:  ;crear un nuevo archivo
         mov numpan,1;se para a numpan 1 para irnos a la pagina 1 que es la de crear archivo
		 call cambiar_pantalla
		 call borrar_pantalla
		 call posicionar_cursor_inicio;el cursor al inicio
		 print"Escribe algo: "
		 call reto
         call insertar_archivo
         call cerrar_archivo
		 call borrar_pantalla
         jmp mostrar_menu
 abrir:;imprimir un archivo
        mov numpan,2;se para a numpan 1 para irnos a la pagina 2 que es la de cargar archivo
		call cambiar_pantalla
		call borrar_pantalla
		call posicionar_cursor_inicio;el cursor al inicio
		print"Nombre archivo: "
        call leerelnombredelarchivo;poner nombre de archivo
		call imprimir_archivo
		mov punpan,2;se manda el 2 al punpan por que es necesario indicar que el puntero debe estar en pagina 2
		call mov_pun;funcion de mover el puntero
		call cerrar_archivo
		jmp mostrar_menu
        
 borrar:;opcion de borrar un archivo
        mov numpan,3;se para a numpan 3 para irnos a la pagina 3 que es la de borrar archivo
		call cambiar_pantalla
		call borrar_pantalla
		call posicionar_cursor_inicio;el cursor al inicio
		print "Borrar Archivo"
		call reto
		print "nombre del archivo a borrar :"
		call leerelnombredelarchivo
        call borrar_archivo
		jmp mostrar_menu 
 salida1:;call cerrar_archivo
		ret 

;funcion del menu 
menu:	
		;poner el menu 
		mov ah,02h
		mov bh,0
		mov dh,01;fila
		mov dl,15;columna
		int 10h 
		print "----------------"
		print "EDITOR DE TEXTO 1.1"
		print "----------------"
		mov ah,02h;este codigo es solo para posicionar los letreros
		mov bh,0
		mov dh,10;fila
		mov dl,29;columna
		int 10h 
        print "|1=Crear archivo |"
		mov ah,02h;este codigo es solo para posicionar los letreros
		mov bh,0
		mov dh,11
		mov dl,29
		int 10h
        print " |2=Cargar archivo|"
		mov ah,02h
		mov bh,0;este codigo es solo para posicionar los letreros
		mov dh,12
		mov dl,29
		int 10h
		print " |3=Borrar archivo|"
		mov ah,02h;este codigo es solo para posicionar los letreros
		mov bh,0
		mov dh,13
		mov dl,29
		int 10h
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
;funcion para poder posicionar el cursor en el inicio de la pantalla
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
		
;funcion de borrar archivo
borrar_archivo:
        mov ah,41h
        mov dx, offset nombre_archivo
        int 21h
        jc error
ret

;funcion para poder mover el puntero con las flechas del teclado
mov_pun:
       
inicio: 
        mov ah,00h ;funcion 00 para poder leer caracter del teclado y devuelve lo leido en el registro AH
        int 16h  ;la interupcion 16h nos permite usar el teclado
		mov posp,ah;Se mueve e posp lo que se leyo del teclado para luego compararlo si es alguna de las flechas
        cmp posp,01; comparar si es ESC
        je sal1;si es esc sale
		call pos_cursor;si no es esc entonces se obtiene la posicion actual del puntero
		mov ah,02h;luego poner en la pantalla que  estamos el puntero
		mov bh,punpan
		int 10h
		;comparar con posp si es una flecha o no 
		;Se tiene que guardar en posp por que si no al momento de establecer la pantalla se utiliza AH ,borrando lo que tenia 
		;y sin poder saber que tecla se habia leido
		cmp posp,48h  ;cursor arriba
		je movArr
		cmp posp,4Bh  ;cursor izquierda
		je movIzq
		cmp posp,4Dh ;cursor derecha
		je movDer
		cmp posp,50h  ;cursor abajo
		je movAbajo
		jmp inicio
 movDer:;mover el cursor a la derecha
		mov dl, posX
		mov dh, posY    
		inc dl ; posX ++
		mov posX, dl
		;poner el cursor a donde se quizo mover 
		mov ah,02h
		mov bh,punpan
		int 10h
		jmp inicio

 movIzq:;mover el cursor a la izquierda
		mov dl, posX    
		mov dh, posY     
		dec dl ; posX -- 
		mov posX, dl 
		mov ah,02h
		mov bh,punpan
		int 10h
		jmp inicio

 movArr: ;mover el cursor a arriba 
	    mov dl, posX     
		mov dh, posY     
		dec dh ; posY -- 
		mov posY, dh     
		mov ah,02h
		int 10h
		jmp inicio

 movAbajo:  ;mover el cursor hacia abajo 
		mov dl, posX     ;
		mov dh, posY     
		inc dh ; posY ++
		mov posY, dh     
		mov ah,02h
		mov bh,punpan
		int 10h        
		jmp inicio
sal1:  mov posp,0

ret 

;funcion para obtener la poscion actual del puntero
pos_cursor:
		mov ah,03h;funcion que no spermite obtener la poscion
		mov bh,punpan;en punpan se tiene el numero de pantalla en donde se va a usar el puntero,
		;depende de cual es por ejemplo si estamos en la pantalla 2 ,numpan debe ser 2 para que el puntero funcione en esa pagina
	    int 10h
		
		; devuelve en dh renglon, dl:columna
		mov posX,dl;lo que nos devolvio se guarda en la variable posX  y posY para luego poder mainpularlo mediante las flechas 
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
pre_de: call reto
        print "estas seguro que quieres hacer estos cambios? S/N"
        mov ah,01h
        int 21h
        cmp al,6eh
        je mostrar_menu
		cmp al,'s'
		jne pre_de
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

;funcion para cambiar de pantalla
cambiar_pantalla:
        mov ah,05;funcion de cambiar pantalla
        mov al,numpan;en la pagina donde se quiere cambiar ,depende de numpan
		int 10h
ret
		
;borrar la pantalla con 06h		
borrar_pantalla:
        mov ah,06h 
		mov cx,0000h   ; inicia en las cooordenadas de origen
        mov dx,184fh   ; finaliza en las ultimas coordenadas de la pantalla
        int 10h
ret  
end 
		