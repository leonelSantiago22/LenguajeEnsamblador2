.model small
extrn reto:near
;extrn despc:near
extrn des4:near
extrn spc:near
.stack
.data
    patron  db "*.asm*",0   ;solo con direecion asm
    DTA     db 21 dup(0)    ;Directory Table Alocation
    attr    db 0
    time    dw 0
    date    dw 0
    sizel   dw 0
    sizeh   dw 0
    fname   db 13 dup(0)
.code
main:   mov ax,@data
        mov ds,ax
        mov es,ax
    ;establecer posición de DTA
        mov ah,1Ah
        mov dx,offset DTA
        int 21h
    ;Preparar lectura de directorio y mostra primer archivo
        mov dx,offset patron ;patrón de búsqueda
        mov cx,0 ;Archivos normales
        mov ah,4Eh ;Buscar primer archivo que cumpla
        int 21h
        jc sale
    ;Desplegar nombre (también se podrían desplegar otros datos)
        push offset fname 
        call despc
        add sp,02   ;retorno la pila
        call reto
    ;Mostrar el resto de los archivos
nf:     mov ah,4Fh
        int 21h
        jc sale
        mov dx,sizeh
        call des4
        mov dx,sizel
        call des4
        call spc
        push offset fname
        call despc
        add sp,02
        call reto
        jmp nf
 sale: .exit 0
 erro: .exit 1
 
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