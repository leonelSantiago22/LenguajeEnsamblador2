;((1.2 + 3.45)* 8.12)/(1.5+3)
;1.2 3.45 + *8.12 1.5 3 + /
.model small
    extrn reto:near
    extrn leeflo:near
    extrn desflo:near
.stack
.data
.code
main:   mov ax,@data
        mov ds,ax 
        ;inicializamos el co-procesador
        finit
        call leeflo
        call leeflo
        fadd
        call leeflo
        fmul
        call leeflo
        call leeflo
        fadd
        fdiv
        call desflo
        call reto
        .exit 0
end