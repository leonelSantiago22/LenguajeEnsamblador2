;3.1 + sqrt(2.1+(8.1 * 24.1))/ 2.7 +pi
.model small
    extrn desflo:near
    extrn leeflo:near
.stack 
.data 
.code
main:   mov ax,@data
        mov ds,ax 

        call leeflo     ;3.1 
        call leeflo     ;2.1 3.1
        call leeflo     ;8.1 2.1 3.1 
        call leeflo     ;24.1 8.1 2.1 3.1 
        fmul            ;8.1*24.1 2.1 3.1
        fadd            ;mul+2.1 3.1 
        fsqrt           ;sqrt(suma) 3.1
        fadd            ;3.1+sqrt(suma) 
        call leeflo     ;2.7 numerador
        fldpi           ;pi 2.7 numerador
        fadd            ;2.7+pi numerador
        fdiv            ;numerador/dividendo
        call desflo
        .exit 0
end