;calcular el area de un circulo
.model small
.386
.387
    extrn desflo:near
.stack
.data
    DatoFlo dd 21.999 ;Flotante de 32 bits.
    ;entero  dd ?
    ;diez   dd 10
    ;medio   dd 0.5
.code
main:   mov ax,@data
        mov ds,ax
        mov es,ax
        ;Datoen ax
        ;la pila del coprocesador tiene 8 posiciones
        finit;inicializador del coprocesador
        ;dato en la pila 
        fld DatoFlo
        call desflo
        
        .exit 0
end