;Operaciones con directorios 
.model small
extrn reto:near
extrn   des4:near
.stack
.data
    ndir db 164 dup(0)
.code
main:   mov ax,@data
        mov ds,ax
        mov es,ax
        mov dl,0            ;unidad actual
        mov si,offset ndir  ;ds:si buffer
        mov ah,47h          ;Código para obtener ruta
        int 21h             ;Obtener ruta
        jc erro             ;Saltar en caso de error
        ;desplegar directorio actual
        push offset ndir
        call despc
        add sp,02       ;Restauramos pila
        call reto
erro:   mov dx,ax
        call des4
        .exit 0
;Función para desplegar una cadena terminada en 0
; Recibe dirección de cadena mediante la pila.
despc:  push bp
        mov bp,sp
        mov ah,02h
        cld
        mov si,[bp+4]
dcl:    lodsb           ;Carga en AL, incrementa SI
        cmp al,0        ;Si ya llegó al 0, salir.
        je dcs
        mov dl,al
        int 21h
        jmp dcl
dcs:    mov sp,bp
        pop bp
        ret
end