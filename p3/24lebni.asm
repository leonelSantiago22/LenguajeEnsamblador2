;calcular pi
.model small
    extrn leeflo:near
    extrn desflo:near
    
.stack
    
.data
    uno     dd  1.0
    divisor   dd  3.0
    dos     dd  2.0
    cuatro dd  4.0
    acumulador  dd 1
.code
main:   mov ax,@data
        mov ds,ax
        finit
        fld dos
        fld1                ;1.0
        fld divisor      ;3.0 1.0
        mov cx,10h
serie1: push cx  
        mov cx,0ffffh
serie2: ;fld divisor           ; div acum
        fld st(0)           ;   div div acum
        fld1                ;1.0 div div acum
        fdivr               ;1.0/div div acum     
        fxch st(1)          ;div 1/div acum
        fxch st(2)          ;acum 1/div div 
        fsubr               ;acum-1/div div
        fxch st(1)          ;div acum
        ;fld dos             ;2.0 div acum
        fld st(2)
        fadd                ;2.0+div acum
        fld st(0)
        fld1                ;1/div+2 div acum
        fdivr
        fxch st(1)          ;div 1/div acum
        fxch st(2)          ;acum 1/div div 
        fadd               ;acum+1/div div
        fxch st(1)          ;div acum
        ;fld dos 
        fld st(2)
        fadd
        ;fstp divisor
        fwait
        loop serie2
        pop cx 
        loop serie1
        ;deplegar acumulador
        fxch st(1)
        fld cuatro
        fmul
        call desflo
        .exit 0
end

AlgoritmosLeibniz()
   1. Definir numero de vueltas
   2. Inicial acumulador=1, divisor =3
   3. repetir por el numero de bueltas
       3.1 obtener 1/ divisor
       3.2 restar a acumulador
       3.3 obtener 1/  (divisor + 2)
       3.4 sumar a acumulador
       3.5 sumar 4 a divisor
   4. desplegar acumulador