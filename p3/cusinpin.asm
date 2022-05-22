;Cuadro sin pintar
.model small
.386
.stack
.data
.code
pintarx macro x,y,color,cant
local cic 
    
        mov cx,x ;Coordenada X.
        mov al,color ;Amarillo.
        mov ah,0Ch ;Funcion escribir punto.
cic:    mov dx,y ;Coordenada Y.
        int 10h 
        ;Esperar usuario (para que no termine sin poder ver)
        inc cx
        cmp cx,cant
        jle cic
        
endm
pintary macro x,y,color,cant
local cic 
    
        mov cx,x ;Coordenada X.
        mov al,color ;Amarillo.
        mov ah,0Ch ;Funcion escribir punto.
cic:    mov dx,y ;Coordenada Y.
        int 10h 
        ;Esperar usuario (para que no termine sin poder ver)
        dec cx
        cmp dx,cant
        jle cic
        
endm
main: ;Obtener configuración de pantalla y guardarla en la pila .
        mov ax,4f03h
        int 10h
        push bx
        ;definir pantalla 1024x768, 256 colores.
        mov ax,4f02h
        mov bx,105h ;Código del modo.
        int 10h
        mov cx,0150 ;codenadas x 
        mov dx,0250 ;cordenadas y
        mov al,0Fh
        ;desplegar algo
        ;x y color tam
        ;mov si,0100
        mov si,0100
cic:    pintarx cx dx al 0400
        inc dx 
        inc si
        cmp si,0250
        jle cic
        mov si,0100
cic2:   pintary cx dx al 0400
        inc dx 
        inc si
        cmp si,0250
        jle cic2
        ;esperar usuario
        mov ah,00h
        int 16h
        ;restaurar pantalla
        pop bx
        mov ax,4f02h
        int 10h
fin:    .exit 0 
end