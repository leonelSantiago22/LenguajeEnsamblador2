.MODEL SMALL
extrn reto:near
extrn leecad:near
.STACK
.DATA
    pre_cad db 2 dup(?)
    cadena db 40
.CODE
main:   mov ax,@data
        mov ds,ax 
        mov es,ax 
        mov dx, offset cadena
        mov cl,40
        call leecad
        call reto
        mov bl,al 
        mov bh,0
        mov cadena[bx],24h
        mov dx,offset cadena
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