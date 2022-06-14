.model small
    ;extrn retardo:near
.stack
.data
    cadena db "              Boing ", 0dh, 24h
.code 
main:   mov ax,@data
        mov ds,ax 
        mov es,ax 
        mov cx,4 
cero:   push cx 
        mov cx,13
        mov dx, offset cadena
        add dx,14
        mov ah,09h
ciclo1: int 21h
        dec dx
        call retardo
        call retardo
        call retardo
        loop ciclo1
        mov cx,14
        ;mov dx,offset cadena
        ;add dx,0
        mov ah,09h
ciclo2: int 21h
        inc dx
        call retardo
        call retardo
        call retardo
        loop ciclo2
        pop cx 
        loop cero
        .exit 0


retardo:    push cx 
            mov cx,0ffffh
    r_cic:  loop r_cic
            pop cx
        ret
end
