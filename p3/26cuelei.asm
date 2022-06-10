;calcular pi
.model small
.386
.387
    extrn leeflo:near
    extrn desflo:near
    extrn reto:near
.stack
    
.data
    uno     dd  1.0
    divisor   dd  3.0
    dos     dd  2.0
    cuatro dd  4.0
    acumulador  dd 1
    picua dd ?
    preci dd 0.0001
.code
main:   mov ax,@data
        mov ds,ax
        finit
        fldpi 
        fld cuatro
        fdiv
        fstp picua
        fld dos
        fld1                ;1.0
        fld divisor      ;3.0 1.0
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


        fld st(1)           ; acum div acum 2 
        fld picua           ; picua acum div acum 2
        fsub
        fabs 
        fld preci 
        fcompp              ;Compara y vacía la pila.
        fstsw ax
        fwait
        and ah,45h
        cmp ah,00
        je result
        
        loop serie2

result: fxch st(1)
        fld cuatro
        fmul
        call desflo
        call reto
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