.model small
include ..\fun\macros.asm
.stack
.data
arr1 db "monina"
arr2 db "minina"
.code
main:   mov ax,@data
        mov ds,ax
        cld
        mov es,ax ;Sean ambos el mismo segmento.
        mov si,offset arr1
        mov di,offset arr2
        mov cx,6
        repe cmpsb ;Se detendrá en dos posibles casos:
        ; -encontró una diferencia
        ; -CX llegó a 0.
        jne difer ;Son diferentes si está apagada
        ; la bandera del cero.
        print 'son iguales'
        ;Aquí la acción a realizar por ser iguales
        jmp salida
difer:  print 'no son iguales'
        ;Aquí la acción a realizar por ser diferentes
salida:.exit 0
end
