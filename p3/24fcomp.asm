.model small
.386
.387
    include ..\fun\macros.asm
    extrn reto:near
    extrn des2:near
    extrn reto:near
.stack
.data
    num1 dd 1.2
    num2 dd 1.1
.code
main:   mov ax,@data
        mov ds,ax
        mov es,ax
        finit
        fld num1
        fld num2
        fcompp ;Compara y vacía la pila.
        fstsw ax ;AX tiene palabra de estado.
        and ah,45h ;Aplicar máscara:01000101 a parte alta.
        mov dl,ah ;Sólo interesa la parte alta.
        cmp ah,00
        je Mayor
        cmp ah,01
        je Menor
        cmp ah,40
        je Iguales
        cmp ah,45
        je no_compatibles
        ;call des2 ;Desplegar resultado y comparar con los
        ; siguientes valores.
        ;> 00 Mayor
        ;< 01 Menor
        ;= 40 Iguales
        ;! 45 Valores no comparables
Mayor:  print "Es mayor"
        jmp salida
Menor:  print "Menor"
        jmp salida
Iguales:print "Iguales"
        jmp salida
no_compatibles: print "Valores no no_compatibles"
salida: call reto
        call des2
.exit 0
end