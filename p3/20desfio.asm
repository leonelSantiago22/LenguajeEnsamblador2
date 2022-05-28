;calcular el area de un circulo
.model small
.386
.387
    extrn des2:near
    extrn reto:near
    extrn desdec:near
    extrn des4:near
    extrn leedec:near
    extrn des1:near
.stack
.data
    DatoFlo dd 30.95 ;Flotante de 32 bits.
    entero dd ?
    multi dd 10
    resta dd 0.5
.code
main:   mov ax,@data
        mov ds,ax
        mov es,ax
        ;Datoen ax
        ;la pila del coprocesador tiene 8 posiciones
        finit
        ;dato en la pila 
        fld DatoFlo
        fld st(0)   ;metemos una copia del numero
        fild resta
        fsub
        ;extrar la parte entera 
        fistp entero
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
ciclo:  
        fild multi
        fmul 
        fist entero
        fwait ;subiendo a la memoria un dato
        mov bx,offset entero
        mov dx,[bx]
        call des1
        fild entero
        fsub 
        loop ciclo
        ; Todas las intrucciones con f las mandan al coprosecador

        ;fld Radio para en 2.0
        
        .exit 0
end