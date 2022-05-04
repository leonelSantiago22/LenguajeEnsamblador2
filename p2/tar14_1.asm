.MODEL SMALL
extrn reto:near
extrn leecad:near
.STACK
.DATA
    pre_cad db 2 dup(?)
    cadena db 40        ;declaracion de la cadena
.CODE
main:   mov ax,@data
        mov ds,ax 
        mov es,ax 
        mov dx, offset cadena   ;desplegamos la cadena
        mov cl,40               ;agregamos el tamano de la cadena  
        call leecad             ;mandamos a llamar a la funcion
        call reto
        mov bl,al               ;en al recibe el ultimo tamano de la cadena
        mov bh,0
        mov cadena[bx],24h      ;ingresa al final de la cadena el fin de cadena
        mov dx,offset cadena    ;desplegamos la cadena
        mov ah,09h
        int 21h
        .exit 0
;para leer cadena
;leecad: mov bx,dx ;vamos a usar bx como apuntador
;        sub dx,2
;        mov [bx-2],cl       ;ponemos donde apunta dx el tamano de la cadena
;        mov ah,0Ah                  ;ya esta en dx el offset del arreglo 
;        int 21h 
;        call reto
;        mov al, [bx-1]          ;aqui pone realemente el tamano que leyo
;        ret
end