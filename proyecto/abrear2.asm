
;Ejercicio: Hacer un programa que lea un archivo de tamaño arbitrario, y despliegue en pantalla su
;contenido.
.model small
.386
extrn des4:near
extrn desdec:near
extrn reto:near
.stack
.data
narchivo db "uno.txt",0h
bufer 	 db 0ffh dup(?);el buffer es un espacio de memoria para poner temporalmente los datos 
fid 	 dw ?
.code
		main: mov ax,@data
		mov ds,ax
		mov es,ax
		;Abrir para lectura
		;fid=fopen( "texto.txt", "r" );
		mov ah,3Dh ;Código para abrir archivo
		mov al,0 ;Modo lectura
		mov dx,offset narchivo ;Dirección del nombre
		int 21h ;Abrir, devuelve ident
		jc error ;En caso de error, saltar
		mov fid,ax ;guardar identificador
		;Leer el archivo
		;fread( &contenido, srtlen( contenido ), 1, fid );
		;dentro de un ciclo
		
cic:	mov ah,3Fh ;Código para leer archivo
		mov bx,fid ;Identificador
		mov cx,10h ;Tamaño deseado
		mov dx,offset bufer ;Dirección búfer
		int 21h ;Leer archivo
		jc error ;Si hubo error, procesar
		;salir si ya no hay mas
		
		;Colocar símbolo $ al final de cadena leída
		cmp ax,0
		je cierr
		mov bx,ax;nos dice cuanto leyo
		add bx,offset bufer
		mov byte ptr[bx],'$'
		;Desplegar cadena leída
		mov dx,offset bufer
		mov ah,09h
		int 21h
		
		jmp cic
		
		;Cerrar archivo
cierr:	mov ah,3Eh
		mov bx,fid
		int 21h
		jc error
		jmp salida
 error: mov dx,ax
		call des4
		.exit 1
salida:.exit 0
end