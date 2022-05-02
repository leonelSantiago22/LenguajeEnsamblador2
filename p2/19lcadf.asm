.MODEL SMALL
extrn des2:near
extrn spc:near
extrn reto:near
extrn  des4:near
.STACK
.DATA
    arreglo db ?,?
    ;cadmax db ?
    ;tamcad db ?
    cadena db 18
.CODE
main:   mov ax,@data 
        mov ds,ax
        mov es,ax       ;habilitacion del segmento de datos extra
        mov dx,offset cadena
        mov cl,20
        ;lo vamos a pasar por registro 
        call leecad     ;leer cadena 
        ;mov bx,dx
       
        call desarr
        call reto 
        mov bl, tamcad
        mov bh,0
        mov cadena[bx],24h
        call desarr
        call reto
        mov dx, offset cadena
        mov ah,09h
        int 21h
        .exit 0
desarr: cld
        mov si,offset arreglo    ;le agrea 3 posiciones al arrglo
        mov cx,20
ciclo:  lodsb
        mov dl,al 
        call des2
        call spc 
        loop ciclo
        ret 
;recibe como parametros: dx como direccion, y cl: tamano maximo
leecad: mov bx,dx ;vamos a usar bx como apuntador
        mov [bx-2],cl
        mov cadena[0],cl
        mov ah,0Ah                  ;ya esta en dx el offset del arreglo 
        int 21h 
        call reto
        ret
end