.model small
.386
.stack
.data
.code
;este macro nos permite trazar lineas a travez del eje x 
pintarx macro x,y,color,cant
local cic 
    pusha
        mov cx,x ;Coordenada X.
        mov al,color ;Amarillo.
        mov ah,0Ch ;Funcion escribir punto.
cic:    mov dx,y ;Coordenada Y.
        int 10h 
        ;Esperar usuario (para que no termine sin poder ver)
        inc cx
        cmp cx,cant
        jle cic
    popa    
endm
;este macro nos permite trazar lienaeas atravez del eje y 
pintary macro x,y,color,cant
local cic 
    pusha
        mov cx,x ;Coordenada X.
        mov al,color ;Amarillo.
        mov ah,0Ch ;Funcion escribir punto.
cic:    mov dx,y ;Coordenada Y.
        int 10h 
        ;Esperar usuario (para que no termine sin poder ver)
        inc dx
        cmp dx,cant
        jle cic
    popa    
endm
;trazar lienas continuas a lo largo del eje x 
pintar macro x,y,color,cant
local cic 
    pusha
        mov cx,x ;Coordenada X.
        mov al,color ;Amarillo.
        mov ah,0Ch ;Funcion escribir punto.
cic:    mov dx,y ;Coordenada Y.
        int 10h 
        ;Esperar usuario (para que no termine sin poder ver)
        inc cx
        cmp cx,cant
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
        ;pintar cuadro con rayas 
        mov cx,0150 ;codenadas x 
        mov dx,0250 ;cordenadas y
        mov al,0Fh
        ;desplegar algo
        ;x y color tam
        mov si,0100
cic:    pintar cx dx al 0400
        inc dx 
        inc si
        cmp si,0250
        jle cic
        ;esperar usuario
        mov cx,0550 ;codenadas x 
        mov dx,0250 ;cordenadas y
        mov al,0Fh
        ;desplegar algo
        ;x y color tam
        ;mov si,0100
        pintarx cx dx al 0800
        pintary 0800 dx al 0400
        pintary cx dx al 0400
        mov dx,0400
        pintarx cx dx al 0800 


        mov ah,00h
        int 16h
        ;restaurar pantalla
        ;Pintar cuadro sin rayas

        pop bx
        mov ax,4f02h
        int 10h
fin:    .exit 0 
end