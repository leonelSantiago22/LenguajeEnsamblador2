;busqueda de datos en arreglos 
.MODEL SMALL
include ..\fun\macros.asm
extrn desdec:near
extrn spc:near
.STACK
.DATA 
arreglo db "BBABBBBBBB"
.code
main:       mov ax,@data
            mov ds,ax
            mov es,ax
            mov al,'A' ;Carácter que se busca.
            mov cx,10 ;Número de veces a buscar .
            cld ;Búsqueda ascendente.
            mov di,offset arreglo
            repne scasb ;Repetir mientras CX>0 y el dato
            ; sea diferente a lo de AL.
            jne noen ;Saltar si la última comparación hecha
            ; con scasb no dio “igual”.
            print "encontrado en posicion:" ;Uso del macro para imprimir.
            call spc
            mov dx,10
            sub dx,cx
            call desdec
            jmp fin
noen:       print "no encontrado"
fin:        .exit 0
end 
