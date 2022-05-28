.model small
include ..\fun\macros.asm
extrn des4:near
extrn reto:near
extrn des2:near
extrn spc:near
.486
.stack
.data
    pre_cad db 2 dup(?)
    nombre_archivo db 20 dup(00h)  
	bufer db 0fffh dup(?);el buffer es un espacio de memoria para poner temporalmente los datos  
    fid dw ?            ;Identidificador del archivo
.code 

main:	mov ax,@data
		mov ds,ax
		mov es,ax
		;primero posicionar cursor para que se quede siempre en alto 
		
  mostrar_menu:
		call posicionar_cursor_menu
		call menu ;llamar el  menu
		;ahora esta en dl la opcion selecionada en menu
		cmp dl,31h;comparacion para saber que hacer 
		je opcion1;salta a crear archivo
		
		cmp dl,32h
		je opcion2;salta a imprimir archivo
		
		cmp dl,33h
		je opcion3;salta a guardar archivo
		
		cmp dl,34h
		je opcion4;salta a abrir archivo
		
		cmp dl,1Bh;compara si es ESC
		je salida1;salida 
		
		
		;si no es ninguna de estas opciones entonces esta escribiendo en pantalla y eso hay que escribirlo
		;Entonces crear un nuevo archivo pero con un nombre default
		;Escribir en el lo que esta poniendo
		
		
		jmp mostrar_menu
		;ahora con las opciones:
 opcion1:call reto ;opcion1 es de crear un archivo por el momento se pone un nombre y se crea luego se cierra
         print"nombre archivo: "
         call leerelnombredelarchivo;poner nombre de archivo
         call crear_archivo
		 print"Archivo creado"
         call cerrar_archivo
        jmp mostrar_menu
 opcion2:;imprimir un archivo
		print"Nombre archivo: "
        call leerelnombredelarchivo;poner nombre de archivo
		call imprimir_archivo
		;llamar a editar
		mov ah,01;si no es 1Bh
		int 21h
		cmp al,1Bh
		je mostrar_menu
        
		call cerrar_archivo
 opcion3:
		jmp mostrar_menu
 opcion4:
		jmp mostrar_menu
 salida1:
	    .exit 0
	  
	  ;En caso de error para saber si el error es facil
error:  mov dx,ax
        call des4
        .exit 1

;funcion del menu
menu:	
		;con funcion 06 se puede limpiar pantall
		mov ah,06h
		mov bh,0Fh;color
		mov cx,0000h
		mov dx,184fh;hasta donde acaba la pantalla 
		int 10h;con 10h se puede hacer todo lo demas s
		call reto
        print "|1=Crear archivo |"
        print " |2=Imprimir archivo|"
		call reto
        print "|3=Guardar archivo|"
        print " |4=Modificar archivo|"
		print " |5=Borrar archivo|"
        print " |ESC=Salir|"
		call reto
		
		;leer la opcion del usuario
		mov ah,01
		int 21h
		;regresar en dx la opcion
		mov ah,0
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
	
posicionar_cursor_menu:
	 mov ah,02h
	 mov bh,00h
	 mov dh,0000;fila 12 en decimal
	 mov dl,0000;columna 40 en decimal
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
		
end 
		