.MODEL SMALL
extrn des2:near
extrn spc:near
extrn reto:near
extrn  des4:near
.STACK
.DATA
    pre_cad db 2 dup(?)
    ;cadmax db ?
    ;tamcad db ?
    cadena db 40
.CODE
main:   mov ax,@data 
        mov ds,ax
        mov es,ax       ;habilitacion del segmento de datos extra
        mov dx,offset cadena
        mov cl,40
        ;lo vamos a pasar por registro 
        call leecad     ;leer cadena 
        call reto
        ;dato de retono en al 
        ;poner terminar cadena con '$'
        mov bl, al
        mov bh,0
        mov cadena[bx],24h
        ;desplegar el contenido del arreglo
        mov dx,offset cadena
        mov cl,bl
        add cl,2
        call desarr             ;despliega arreglo
        call reto
        mov dx, offset cadena
        mov ah,09h
        int 21h
        .exit 0
;Recine : DX: Direccion, CL: tamano a desplegar
desarr: cld
        mov si,offset pre_cad    ;le agrea 3 posiciones al arrglo
        mov ch,0h
        ;mov cx,20
desarr_cic:  lodsb
        mov dl,al 
        call des2
        call spc 
        loop desarr_cic
        call reto
        ret 
;recibe como parametros: dx como direccion, y cl: tamano maximo
;debe a ver 2 bits previo libres
leecad: mov bx,dx ;vamos a usar bx como apuntador
        sub dx,2
        mov [bx-2],cl       ;ponemos donde apunta dx el tamano de la cadena
        mov ah,0Ah                  ;ya esta en dx el offset del arreglo 
        int 21h 
        call reto
        mov al, [bx-1]          ;aqui pone realemente el tamano que leyo
        ret
end