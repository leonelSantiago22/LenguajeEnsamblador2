.model small
include ..\fun\macros.asm
.stack 
.data
    cadena1 db  "Estaba don gato sentado en una silla de palo"
    cadena2 db  "una"
.code 
main:   mov ax,@data
        mov ds,ax 
        mov es,ax
        mov si,offset cadena1
        mov di,offset cadena2
        mov dl,0000h
        mov cl,0000h
ini:    cmp si[dl], di[cl]
        je iguales
        inc dl
        jmp ini 
iguales: inc cl
        cmp cl,3
        je equals
        jmp ini 
        print 'no se encontro'
        jmp salida
equals: print 'se encontro' 

salida: .exit 0
end