.model small
.386
.stack
.data
    var db ?
.code
pintar macro x,y,color,cant,repet,canty
local cic 
    pusha
        mov si,0000
        mov cx,x ;Coordenada X.
        mov al,color ;Amarillo.
        mov ah,0Ch ;Funcion escribir punto.
cic:    mov dx,y ;Coordenada Y.
        int 10h 
        ;Esperar usuario (para que no termine sin poder ver)
        inc cx
        cmp cx,cant
        jle cic
        add dx,canty 
        inc si
        cmp si,repet
        jle cic
    popa
endm
main: ;Obtener configuración de pantalla y guardarla en la pila .
        mov ax,4f03h
        int 10h
        push bx
        ;definir pantalla 1024x768, 256 colores.
        mov ax,4f02h
        mov bx,105h ;Código del modo.
        int 10h
        mov var,0h
        mov cx,0150 ;codenadas x 
        mov dx,0150 ;cordenadas y
        mov al,0Ch
        ;desplegar algo
        ;x y color tam
    
        pintar cx dx al 1 150 1 
        add cx,100
        add dx,150
        pintar cx dx al 1 150 -1
        ;pintar 
        ;esperar usuario
        mov ah,00h
        int 16h
        ;restaurar pantalla
        pop bx
        mov ax,4f02h
        int 10h
fin:    .exit 0 
end