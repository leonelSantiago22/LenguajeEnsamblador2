;Lectura y aprtura de arcivos
.model small
.386
    extrn des4:near
    extrn desdec:near
    extrn reto:near 
.stack
.data 
    narchivo db "TEXTO.TXT",0h
    bufer db 0ffh dup(?)
    fid dw ? 
.code
main:   mov ax,@data
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
        mov ah,3Fh ;Código para leer archivo
        mov bx,fid ;Identificador
        mov cx,0FFh ;Tamaño deseado
        mov dx,offset bufer ;Dirección búfer
        int 21h ;Leer archivo
        jc error ;Si hubo error, procesar
        ;Colocar símbolo $ al final de cadena leída
        mov bx,ax
        add bx,offset bufer
        mov byte ptr[bx],'$'
        ;Desplegar cadena leída
        mov dx,offset bufer
        mov ah,09h
        int 21h
        call reto
        ;Cerrar archivo
        mov ah,3Eh
        mov bx,fid
        int 21h
        jc error
        jmp salida
error:  mov dx,ax
        call des4
        .exit 1
salida: .exit 0
end
