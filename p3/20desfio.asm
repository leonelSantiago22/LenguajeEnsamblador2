;calcular el area de un circulo
.model small
.386
.387
    extrn spc:near
    extrn des2:near
    extrn reto:near
    extrn desdec:near
    extrn des4:near
    extrn leedec:near
    extrn des1:near
.stack
.data
    DatoFlo dd 13.99 ;Flotante de 32 bits.
    entero  dd ?
    diez   dd 10
    medio   dd 0.5
.code
main:   mov ax,@data
        mov ds,ax
        mov es,ax
        ;Datoen ax
        ;la pila del coprocesador tiene 8 posiciones
        finit
        ;dato en la pila 
        fld DatoFlo
        fld ST(0)   ;metemos una copia del numero
        fld medio
        fsub
        fistp entero
        ;extrar la parte entera 
        ;desplegar
        fwait
        mov bx,offset entero
        mov dx,[bx]
        call desdec
        mov dl,'.'
        mov ah,02h
        int 21h

        fild entero
        fsub
        ;reptir 4 veces
        mov cx,4

ciclo:  fild diez
        fmul 
        fld ST(0)
        fld medio
        fsub
        fistp entero
        fwait ;subiendo a la memoria un dato
        mov bx,offset entero
        mov dx,[bx]
        call des1
        ;call spc
        fild entero
        fsub
        loop ciclo
        ; Todas las intrucciones con f las mandan al coprosecador
        
        ;fld Radio para en 2.0
        
        .exit 0
end