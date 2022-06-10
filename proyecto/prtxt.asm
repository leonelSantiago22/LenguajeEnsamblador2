.model small
.stack
.data
    nombre_archivo db "TEXTO.TXT",0h
    contador db 0
    buffer db 800 dup(20h)
.code
main:   mov ax,@data
        mov ds,ax 
        call leer_buffer
        lea dx, buffer
        mov ah,09H
        int 21h
        .exit 0
escribir_archivo:
        mov ah,3ch 
        ret
crear_archivo:
        mov ah,3Ch
        mov cx,0
        mov dx,offset nombre_archivo
        int 21H
        jc error
        ret
leer_buffer:
        mov dx,buffer
        mov ah,
        int 2fh
        ret
error:  mov dx,ax 
        call des4

end