;busqueda de datos en arreglos 
.MODEL SMALL
include ..\fun\macros.asm
.STACK
.DATA 
arreglo db "BBBBBBBBEB"
.code
main:       mov ax,@data
            mov ds,ax
            mov es,ax
            mov al,'E' ;Carácter que se busca.
            mov cx,10 ;Número de veces a buscar .
            cld ;Búsqueda ascendente.
            mov di,offset arreglo
            repne scasb ;Repetir mientras CX>0 y el dato
            ; sea diferente a lo de AL.
            jne noen ;Saltar si la última comparación hecha
            ; con scasb no dio “igual”.
            print "encontrado" ;Uso del macro para imprimir.
            jmp fin
noen:       print "no encontrado"
fin:        .exit 0
end 
