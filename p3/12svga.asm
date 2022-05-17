.model small
.stack
.data
.code
main: ;Obtener configuración de pantalla y guardarla en la pila .
        mov ax,4f03h
        int 10h
        push bx
        ;definir pantalla 1024x768, 256 colores.
        mov ax,4f02h
        mov bx,105h ;Código del modo.
        int 10h
        ;desplegar algo
        mov cx,0200 ;Coordenada X.
        mov al,0Ah ;Amarillo.
        mov ah,0Ch ;Funcion escribir punto.
cic:    mov dx,0200 ;Coordenada Y.
        int 10h 
        ;Esperar usuario (para que no termine sin poder ver)
        inc cx
        cmp cx,0400
        jle cic
        ;esperar usuario
        mov ah,00h
        int 16h
        ;restaurar pantalla
        pop bx
        mov ax,4f02h
        int 10h
fin:    .exit 0 
end