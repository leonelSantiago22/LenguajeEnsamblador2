; Haga un programa que lea los archivos "uno.txt" y "dos.txt" y copie el contenido a "todo.txt"
.model small
.386
    extrn des4:near
    extrn desdec:near
    extrn reto:near 
.stack
.data 
    narchivo1 db "uno.txt",0h
    narchivo2 db "dos.txt",0h
    archivodestino db "todo.txt",0h
    buferuno db 0ffh dup(?), 0dh, 0ah, 24h
    buferdos db 0ffh dup(?), 0dh, 0ah, 24h
    fid dw ?    ;identificador que nos retorna el sistema 
    fidmacro dw ?
    fidm2 dw ?
.code
leerm macro nombre, identificador, destino, tam 
local error2, salida

        mov ah,3Dh
        mov al,0 
        mov dx,offset nombre
        int 21h
        jc error2
        mov identificador,ax
        mov ah,3Fh 
        mov bx,identificador
        mov cx,tam
        mov dx,offset destino   ;direccion del destino 
        int 21h 
        jc error2
        ;Colocar símbolo $ al final de cadena leída
        
        ;desplegar cadena leida 
        mov dx,offset destino
        mov ah,09h
        int 21h
        call reto
        ;Cerrar archivo
        mov ah,3Eh
        mov bx,identificador
        int 21h
        jc error2
        jmp salida
error2: mov dx,ax
        call des4
        .exit 1
salida: 
        endm
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
        ;leemos lo que contiene el primer archiv
        leerm narchivo1 fidmacro buferuno 0FFh
        ;leermos lo que contiene el segundo archivo
        leerm narchivo2 fidm2 buferdos 0FFh
        
        ;iniciamos con la creacion del archivo donde se guardaran los datos leidos de los archivos de texto
        mov ah,3Ch      ;Código para crear archivo.
        mov cx,0        ;Archivo normal.
        mov dx,offset archivodestino ;Dirección del nombre.
        int 21h         ;Crear y abrir, devuelve ident.
        jc error        ;Saltar en caso de error.
        mov fid,ax      ;guardar identificador en variable.
        ;Escribir en el archivo
        ;fwrite( &contenido, srtlen( contenido ), 1, fid );
        Escribir 35 fid  buferuno   ;macro que nos permite escribir dentro del archivo de texto
        ;Segunda escritura
        Escribir 33 fid  buferdos
         mov ah,3Eh      ;Código para cerrar archivo
        mov bx,fid      ;Identificador.
        int 21h         ;Cerrar archivo
        jc error        ;Saltar en caso de error
        jmp salida
        error: mov dx,ax ;Desplegar código de error
        call des4
        .exit 1         ;Y salir indicando que hubo error
        salida: .exit 0
end