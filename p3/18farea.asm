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
.code
main:   mov ax,@data
        mov ds,ax
        mov es,ax
        ;Datoen ax
        ;la pila del coprocesador tiene 8 posiciones
        call leedec
        mov bx, offset RADIO
        mov [bx],ax
        mov word ptr [bx+2],0h
        ; Todas las intrucciones con f las mandan al coprosecador
        finit
        ;fld Radio para en 2.0
        fild RADIO       ;Carga radio.
        ; Pila: 2.0
        ; ST = el stack
        fmul ST,ST(0)   ;Multiplica tope de pila consigo mismo.
        ; Pila: 4.0
        fldpi           ;Carga PI.
        ; Pila: 3.1416 4.0
        fmul            ;Multiplica elementos superiores.
        ; Pila: 12.5664
        fst AREA        ;Guardar resultado en variable,
        ; sin extraer de la pila.
        fild MIL        ;Cargar 1000. si cargas un entero a la pila cuando lo cargas a la pila lo convierte a flotante
        fmul            ; Pila: 12566.3706
        fistp AREAINT   ;Guardar resultado por 1000,
        ; como entero de 32 bits.
        fwait           ;Esperar al coprocesador.
        mov bx,offset AREAINT
        mov dx,[bx]     ;Cargar en DX (16 bits) parte baja
        ; del resultado.
        ;call des4
        call desdec     ;Desplegar como entero base 10.
        call reto
        .exit 0
end