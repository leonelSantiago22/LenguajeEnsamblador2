.MODEL SMALL
extrn reto:near
extrn leecad:near
.STACK
.DATA
    pre_cad db 2 dup(?)
    cadenita db 18
.CODE
mleecad macro cadena,tamano
    mov dx, offset cadena
    mov cl,tamano
    call leecad
    call reto
    mov bl,al 
    mov bh,0
    mov cadena[bx], 24h 
endm
main:   mov ax,@data
        mov ds,ax 
        mov es,ax 
        mleecad cadenita 18
        mov dx, offset cadenita
        mov ah,09h
        int 21h
        .exit 0
end