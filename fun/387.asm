;calcular el area de un circulo
.model small
.386
.387
    
    extrn desdec:near
    extrn des1:near
.stack
.data
    ;DatoFlo dd 13.99 ;Flotante de 32 bits.
    entero  dd ?
    diez   dd 10
    medio   dd 0.5
.code
;Recibir el dato por la pila
desflo: mov ax,@data
        mov ds,ax
        ;mov es,ax
        ;Datoen ax
        ;pila : dato xxxx xxxx
        ;la pila del coprocesador tiene 8 posiciones
        ;Trabajar sobre una copia 
        fld st(0)       ;pila contiene dato xxx xxx
;1. Extraer la parte entera
        fld ST(0)   ;metemos una copia del numero  dato dato dato : xxx xxx 
        fld medio   ;pila: 0.5 dato dato dato xxx xxx 
        fsub        ;Al restar la pila: dato-0.5 dato dato xxx xxx 
        fistp entero    ;pila: dato dato xxx xxx 
        ;extrar la parte entera 
        ;desplegar
        fwait
        mov bx,offset entero
        mov dx,[bx]
        call desdec
        mov dl,'.'
        mov ah,02h
        int 21h

        fild entero ;pila: entero dato dato xxx xxx
        fsub        ;pila: dato-entero dato xxx xxx
        ;reptir 4 veces
        mov cx,4

ciclo:  fild diez   ;pila: 10.0 dato-entero dato xxx xxx
        fmul        ;pila: 10*(dato-entero) dato xxx xxx
        ;4.2 extraer parte entera
        fld ST(0)   ;pila: datorestante datorestante dato xxx xxx 

        fld medio   ;pila:0.5 datorestnate datorestante dato xxx xxx
        fsub        ; pila: datorestante-0.5 datorestante dato xxx xxx
        fistp entero ;pila: datorestante dato xxx xxx
        fwait ;subiendo a la memoria un dato
        ;desplegar la parte entera
        mov bx,offset entero
        mov dx,[bx]
        call des1
        fild entero ;entero datorestante dato xxx xxx
        fsub        ;datorestante-entero dato xxx xxx
        loop ciclo      ;Hay basura en la pila, retirarla
                        ;datoresntate dato xxx xxx
        fistp entero    ;dato xxx xxx ;justo como cuando entro la funcion
        ;Extraerlo de la pila
        ; Todas las intrucciones con f las mandan al coprosecador
        ;fld Radio para en 2.0
        ret
end