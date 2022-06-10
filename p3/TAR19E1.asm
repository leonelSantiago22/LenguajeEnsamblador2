.model small
    extrn leeflo:near
    extrn desflo:near
.stack
.data
.code
main:   mov ax,@data 
        mov ds,ax 
        finit
        fldpi       ;pi
        call leeflo ;1.17 pi
        call leeflo ;0.2 1.17 pi
        fsub        ;1.17-02 pi'km 0063
        fmul        ;resta*pi
        call leeflo ;2.1 numerador
        call leeflo ;3.1 2.1 numerador
        call leeflo ;8 3.1 2.1 numerador
        fmul        ;3.1*8 2.1 numerador
        fadd        ;2.1+mul    numerador
        fdiv        ;numerador/divisor
        call desflo
        ;3.14 1.17 0.2 - * 2.1 3.1 8 * + /
.exit 0
end