;Creacion de archivos 
.model small
extrn des4:near
extrn reto:near
.stack 
.data   
    narchivo db "texto2.txt",0h
    contenido db "odio a todos y todas jeje", 0dh, 0ah, 24h
    otrocontenido db "como estan?",24h
    fid dw ? ;aqui guradamos el identificador que nos retorna el sistema operativo
.code
escribir macro tam, identificador, cadena
        mov ah,40h      ;Código para escribir en archivo.
        mov bx,identificador      ;Identificador.
        mov cx,tam       ;Tamaño de datos.
        mov dx,offset cadena ;Dirección búfer.
        int 21h         ;Escribir.
        jc error       ;Saltar en caso de error.
        mov dx,ax
        call des4
        call reto 
endm
main:   mov ax,@data
        mov ds,ax
        mov es,ax 
                
        ;crear y abrir el archivo
        ;Crear y abrir
        ;fid=fopen( "texto.txt", "w" );
        mov ah,3Ch      ;Código para crear archivo.
        mov cx,0        ;Archivo normal.
        mov dx,offset narchivo ;Dirección del nombre.
        int 21h         ;Crear y abrir, devuelve ident.
        jc error        ;Saltar en caso de error.
        mov fid,ax      ;guardar identificador en variable.
        ;Escribir en el archivo
        ;fwrite( &contenido, srtlen( contenido ), 1, fid );
        Escribir 28 fid contenido
        ;Segunda escritura
        Escribir 11 fid otrocontenido
        ;Cerrar archivo
        ;fclose( fid );
        mov ah,3Eh      ;Código para cerrar archivo
        mov bx,fid      ;Identificador.
        int 21h         ;Cerrar archivo
        jc error        ;Saltar en caso de error
        jmp salida
        error: mov dx,ax ;Desplegar código de error
        call des4
        .exit 1         ;Y salir indicando que hubo error
        salida:.exit 0  ;Salir sin indicar error 
end