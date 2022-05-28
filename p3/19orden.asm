;calcular el area de un circulo
.model small
.386
.387
    extrn des4:near
    extrn reto:near
    extrn desdec:near
    extrn des4:near
    extrn leedec:near
.stack
.data
    RADIO dd ? ;Flotante de 32 bits.
    AREA dd ? ;32 bits.
    MIL dd 1000 ;Entero 32 bits
    AREAINT dd ? ;Resultado entero por 1000
    tresdos dd 3.2
    cuacinc dd 4.5
    dosuno  dd  2.1
.code
main:   mov ax,@data
        mov ds,ax
        mov es,ax
        ;Datoen ax
        ;la pila del coprocesador tiene 8 posiciones
        
        ; Todas las intrucciones con f las mandan al coprosecador
        finit
        ;fld Radio para en 2.0
        fld tresdos
        fld cuacinc
        fld dosuno
        ;fld RADIO       ;Carga radio.
        fadd
        fild MIL
        fmul 
        fistp AREAINT
        fwait           ;Esperar al coprocesador.
        mov bx,offset AREAINT
        mov dx,[bx]     ;Cargar en DX (16 bits) parte baja
        ; del resultado.
        ;call des4
        call desdec     ;Desplegar como entero base 10.
        call reto
        .exit 0
end