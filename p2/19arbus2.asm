;necesitamos encontrar todas las Aes que estan en un arreglo 
.MODEL SMALL
include ..\fun\macros.asm
extrn desdec:near
extrn spc:near
extrn reto:near
.STACK
.DATA 
arreglo db "BBFBFBBBB"
.code
main:       mov ax,@data
            mov ds,ax
            mov es,ax
            mov al,'F' ;Carácter que se busca.
            mov cx,10 ;Número de veces a buscar.
            mov bx,0
            cld ;Búsqueda ascendente.
            mov di,offset arreglo
ini:        repne scasb ;Repetir mientras CX>0 y el dato
            ; sea diferente a lo de AL.
            jne noen ;Saltar si la última comparación hecha
            ; con scasb no dio “igual”.
            call reto
            print "encontrado en posicion:" ;Uso del macro para imprimir.
            call spc
            mov dx,10
            sub dx,cx
            call desdec
            inc bx
            cmp cx,0
            jg ini
            jmp fin
noen:       call reto
            cmp bx,0
            jg fin
            print "no encontrado"
fin:        .exit 0
end 