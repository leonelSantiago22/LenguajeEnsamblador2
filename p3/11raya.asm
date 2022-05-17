.model small
.stack
.data
.code
main: ;Leer configuración de pantalla y guardarla en la pila
        mov ah,0fh ;Función leer modo.
        int 10h
        push ax ;Guardar modo en la pila.
        ;Definir pantalla 640x480, 16 colores
        mov ah,0 ;Función establecer modo.
        mov al,12h
        int 10h
        mov cx,0200 ;Coordenada X.
        ;Desplegar algo
        mov al,0Bh ;Amarillo.
        mov ah,0Ch ;Función escribir punto 
cic:    
        
        mov dx,0200 ;Coordenada Y.
        int 10h 
        ;Esperar usuario (para que no termine sin poder ver)
        inc cx
        inc si
        cmp cx,0300
        jle cic
        mov ah,00h
        int 16h 
        ;Restaurar pantalla
        pop ax ;Modo original en la pila.
        mov ah,0 ;Función establecer modo
        int 10h ;Establecer. Queda como al principio.
fin:    .exit 0
end