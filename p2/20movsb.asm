;copiando arreglos con movsb y movsw 
.model small 
extrn des4:near
extrn spc:near
.stack 
.data
    origen dw 1,2,3,4
    destino dw 4 dup(?)
.code
;DI: registro apuntador a bloque 'destination', es decir, destino, en el segmento EXTRA 
main:   mov ax,@data
        mov ds,ax
        mov es,ax ;Sean ambos el mismo segmento.
        cld
        mov si,offset origen        ;en donde se encuestra la cadena 
        mov di,offset destino       ;donde se va a copiar la cadena 
        mov cx,4
        rep movsw                   ;rep nos ayuda como si fuera un loop y se reduce el numero de ciclos de reloj
        mov destino[9],24h
        call desarr
        int 21h
        .exit

desarr: cld
        mov si,offset destino    ;le agrea 3 posiciones al arrglo
        mov cx,5
ciclo:  lodsw
        mov dx,ax 
        call des4
        call spc 
        loop ciclo
        ret 
end