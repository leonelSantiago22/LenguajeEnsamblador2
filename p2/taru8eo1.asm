;Tarea 28/04/2022
.MODEL SMALL
.386
include ..\fun\macros.asm
extrn des4:near
extrn desdec:near
.STACK
.DATA
    cadena db "hola bb como estas?$"       ;inicializamos la cadena
.CODE
conteo  macro  direc,tam            ;definicion del macro
local retorno,salida                ;Declarams como locales las variables para que no causen problemas
            mov si,direc            ;apuntamos a la direccion de la cadena  que se recibio 
            mov bx,0000h            ;inicializamos el apuntador
            mov cx,50               ;ponemos como maximo de caracteres 50 caracteres
retorno:    cmp byte ptr[si],24h    ;byte ptr nos ayuda a anivelar con 8 bits 
            je salida               ;salta si es igual
            inc si                  ;incrementamos la posicion del apuntador
            inc bx                  ;incrementamos nuestro contador
            loop retorno            ;loopeamos la funcion con maximo de 50 caracteres
salida:     mov tam,bx              ;movemos nuestro contador a una direcion que en este caso es ax donde sera recibida
endm                                ;fin del macro
main:   mov ax,@data
        mov ds,ax
        mov es,ax                   ;habilitacion del extra segment
        mov ax, offset cadena       ;cargamos la direcion de la cadena
        conteo ax ax                ;mandamos a llamar el macro con la direcion de la cadena y la direcion donde recibiremos el dato
        mov dx,ax                   ;desplegamos el resultado
        call desdec                 ;mandamos a llamar el desdec
        .exit 0
end