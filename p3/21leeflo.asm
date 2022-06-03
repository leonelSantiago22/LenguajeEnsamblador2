.model small
extrn reto:near
extrn des1:near
extrn lee1:near
extrn desflo:near
.stack 
.data 

divisor dd 10.0
diez dd 10.0
tecla dd 0
.code 
main:   mov ax,@data
        mov ds,ax
        mov ax,0    ;acumulador
        mov cx,0    ;contador
        mov bx,10   ;divisor

        finit
;1.- inicializar acumulador=0, contador =0, dividor = 10 ;
                                     ;pila: xxx yyy
            fldz                        ;pila: 0.0 xxx yyy
;2.- Repetir
lf_cic1:    
;    2.1.- Leer teclazo
            call lee1
;    2.2.- Si teclazo = enter
            cmp al,0ddh
;        2.2.1 pasar a paso 4
            je lf_sal
;     2.3 si teclazo = '.'
            cmp al,0feh
;        2.3.1 salir del ciclo
            je lf_cic2
;    2.4 multiplicar acumulador por 10
            fld diez                ;pila: 10.0 acumulador xxx yyy
            fmul                    ;pila acumulador*10 xxx yyy
;    2.5 sumar digito entero al acumulador
            mov bx,offset tecla
            mov [bx],al             ;que es lo que tiene la tecla operacion de 8 bits
            fild tecla              ;cargar el teclazo
                                    ;pila:  tecla acum*10 xx yy
            fadd                    ;tecla mas acumulador
            jmp lf_cic1
lf_cic2:
;3.Repetir
;    3.1 leer teclazo 
            call lee1
;    3.2. Si teclazo = enter
            cmp al,0ddh
;        3.2.1 saltar al paso 4
            je lf_sal
;    3.3 dividir digito entre divisor
            mov bx,offset tecla
            mov [bx],al             ;que es lo que tiene la tecla operacion de 8 bits
            fild tecla              ;cargar el teclazo
                                    ;pila: tecla cumuladot xxx yyy
            fld divisor             ;pila: divisor tecla acumulador xxx yyy
            fdiv                    ;pila: tecla/divisor acumulador xxx yyy
;    3.4 sumar al acumulador
            fadd                    ;resultado de la division se lo sumammos al acumulador
;    3.5 multiplicar divisor por 10
            ;cargamos el divisor
            fld divisor            ;pila: dividor acum xxx yyy 
            fld diez                ;pila: 10 dividor acum xxx yyy 
            fmul                    ;10*divisor acum xxx yyy
            fstp divisor            ;acum xxx yyy
            jmp lf_cic2
lf_sal:
;4. devolver acumulador
            ;recibe el dato que esta en la pila
            call desflo             
            call reto
            .exit 0

end