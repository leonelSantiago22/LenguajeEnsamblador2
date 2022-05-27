.model small
include ..\fun\macros.asm
extrn reto:near
.386
.stack
.data
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
		
		cmp dl,31h
		je opcion3;salta a guardar archivo
		
		cmp dl,31h
		je opcion4;salta a abrir archivo
		
		cmp dl,1Bh;compara si es ESC
		je salida1;salida 
		
		jmp mostrar_menu
		;ahora con las opciones:
 opcion1:
        jmp mostrar_menu
 opcion2:
		jmp mostrar_menu
 opcion3:
		jmp mostrar_menu
 opcion4:
		jmp mostrar_menu
 salida1:
	  .exit 0

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
        print " |4=Abrir archivo|"
        print " |ESC=Salir|"
		call reto
		
		;leer la opcion del usuario
		mov ah,01
		int 21h
		;regresar en dx la opcion
		mov ah,0
		mov dx,ax


ret 		
posicionar_cursor_menu:
	 mov ah,02h
	 mov bh,00h
	 mov dh,0000;fila 12 en decimal
	 mov dl,0000;columna 40 en decimal
	 int 10h
ret 
		
end 
		