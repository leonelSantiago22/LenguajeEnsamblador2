.model small
include ..\fun\macros.asm
extrn desdec:near
extrn reto:near
extrn des4:near
.stack 
.data
        pre_cad db 2 dup(?)
        cadena db  "Estaba bb una gato sentado bb una en silla de palo",0
        subcad db  "bb",0
.code 
main:   mov ax,@data
        mov ds,ax 
        mov es,ax
        mov ax,0000h
        mov dx,offset cadena
        call strlen     ;saber el tamo de la cadena
        push ax 
        mov dx,offset subcad
        call strlen
        mov dh,al       ;tam cadena 
        pop ax 
        mov dl,al       ;tam subcad
        call des4      ;desplegar los tamanos
        call reto
        cld 
        mov bx,offset cadena
c_sub:  cmp bx,44
        jg salida
        mov si,bx 
        mov di, offset subcad
        mov cx,2
        repe cmpsb 
        jne siguiente
        print "cadena encontrada "
        mov dx,bx
        call desdec
        inc bx
        call reto
        jmp c_sub

siguiente:inc bx
        jmp c_sub
salida: .exit 0

strlen: push bx 
        push cx 
        mov cl,0 
        mov bx,dx 
sl_c:   cmp byte ptr[bx],0
        je sl_s
        inc bx 
        inc cl 
        jmp sl_c
sl_s:   mov al,cl
        pop cx 
        pop bx
        ret
end