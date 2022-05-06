;Creacion de archivos 
.model small
extrn des4:near
extrn reto:near
.stack 
.data   
    narchivo db "texto.txt",0h
    contenido db "Hola, Mundo$"
    fid dw ? ;aqui guradamos el identificador que nos retorna el sistema operativo
.code
main:   mov ax,@data
        mov ds,ax
        mov es,ax 
                
        ;crear y abrir el archivo
        ;Crear y abrir
        ;fid=fopen( "texto.txt", "w" );
        mov ah,3Ch ;Código para crear archivo.
        mov cx,0 ;Archivo normal.
        mov dx,offset narchivo ;Dirección del nombre.
        int 21h ;Crear y abrir, devuelve ident.
        jc error ;Saltar en caso de error.
        mov fid,ax ;guardar identificador en variable.
        ;Escribir en el archivo
        ;fwrite( &contenido, srtlen( contenido ), 1, fid );
        mov ah,40h ;Código para escribir en archivo.
        mov bx,fid ;Identificador.
        mov cx,12 ;Tamaño de datos.
        mov dx,offset contenido ;Dirección búfer.
        int 21h ;Escribir.
        jc error ;Saltar en caso de error.
        mov dx,ax
        call des4
        call reto ;Desplegar cuántos se escribieron
        ;Cerrar archivo
        ;fclose( fid );
        mov ah,3Eh ;Código para cerrar archivo
        mov bx,fid ;Identificador.
        int 21h ;Cerrar archivo
        jc error ;Saltar en caso de error
        jmp salida
        error: mov dx,ax ;Desplegar código de error
        call des4
        .exit 1 ;Y salir indicando que hubo error
        salida:.exit 0 ;Salir sin indicar error 
end
