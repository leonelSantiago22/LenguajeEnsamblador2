.MODEL SMALL
extrn reto:near
extrn leecad:near
.STACK
.DATA
    pre_cad db 2 dup(?)
    cadenita db 18
.CODE
mleecad macro cadena,tamano
    mov dx, offset cadena       ;deplegamos la cadena
    mov cl,tamano               ;movemos el tamano de la cadena
    call leecad                 ;mandamos a llamar a la funcion0
    call reto
    mov bl,al                   ;recibimos donde se encuentra el final de la cadena
    mov bh,0                
    mov cadena[bx], 24h         ;agregamos el final de la cadena
endm
main:   mov ax,@data
        mov ds,ax 
        mov es,ax
        mleecad cadenita 18     ;mandamos a llamar al macro
        mov dx, offset cadenita ;desplegamos el contenido de la cadena
        mov ah,09h
        int 21h
        .exit 0
end