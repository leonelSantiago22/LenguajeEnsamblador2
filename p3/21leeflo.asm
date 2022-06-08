.model small
extrn reto:near
extrn des1:near
extrn lee1:near
extrn desflo:near
extrn leeflo:near
.stack 
        ;uno db 1
.data 
.code 
main:   mov ax,@data
        mov ds,ax
        mov ax,0    ;acumulador
        mov cx,0    ;contador
        mov bx,10   ;divisor

        finit
;1.- inicializar acumulador=0, contador =0, dividor = 10 ;
                                     ;pila: xxx yyy
        call leeflo
;4. devolver acumulador en la pila ST(0)
            ;recibe el dato que esta en la pila
        call desflo             
        call reto
        .exit 0

end