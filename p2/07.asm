;Multiplicar 5 x 8 con IMUL.
.model small
extrn desdec:near
.stack
.data
.code
main:   mov ax,@data
        mov ds,ax
        mov es,ax 
        ;inicio del codigo 
        ;uso de imul 
        mov al,8
        mov bl,5
        mul bl
        mov dx,ax
        call desdec
        .exit 0
end