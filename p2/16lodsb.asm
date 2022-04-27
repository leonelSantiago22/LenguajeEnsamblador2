;Tema nuevo
;Carca con instrucciones LODSB o LODSW
;
.MODEL SMALL
extrn des2:near
extrn spc:near
extrn reto:near
extrn  des4:near
.STACK
.DATA
    array dw 4 dup(?)
.CODE
main:   mov ax,@data 
        mov ds,ax
        mov es,ax       ;habilitacion del segmento de datos extra
        mov di,offset array
        cld 
        mov cx,4
        mov ax,0041h
        rep stosw
        call desarr
        .exit 0
desarr: cld
        mov si,offset [array]     ;le agrea 3 posiciones al arrglo
        mov cx,04h
ciclo:  lodsw
        mov dx,ax 
        call des4
        call spc 
        loop ciclo
        ret
end