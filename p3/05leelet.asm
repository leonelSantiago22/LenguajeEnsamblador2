;Lectura y aprtura de arcivos
.model small
.386
    include ..\fun\macros.asm
    extrn des4:near
    extrn desdec:near
    extrn reto:near 
.stack
.data 
    narchivo db "TEXTO.TXT",0h
    bufer db 0ffh dup(0)
    fid dw ? 
    subcad db  "estan",0
    var dw ?
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
        cld
        mov bx, offset bufer
        ;fread( &contenido, srtlen( contenido ), 1, fid );
cic:    mov ah,3Fh ;Código para leer archivo
        mov bx,fid ;Identificador
        mov cx,1h ;Tamaño deseado
        mov dx,offset bufer ;Dirección búfer
        int 21h ;Leer archivo
        jc error ;Si hubo error, procesar
        ;Colocar símbolo $ al final de cadena leída
        ;salir si ya no hay mas
        ;Desplegar cadena leída
        mov bx,ax 
        add bx,offset bufer
        mov byte ptr[bx],0
        
sigue:  jmp cic
        call reto       
error:  mov dx,ax
        call des4
        .exit 1
salida:;Cerrar archivo 
        mov ah,3Eh
        mov bx,fid
        int 21h
        mov dx,var
        call desdec
        
        .exit 0
end