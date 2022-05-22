;animacion
.model small
.386
.stack
.data
color	db	0Fh
offx	dw	0h	;Offset para x y y, para desplazar figura a voluntad, se usa con macro pixelo
offy	dw	0h
equis	dw	?
ye	dw	?
incx	dw	?
incy	dw	?

.code
pixel	macro x,y	;usar CX y DX como registro para pasar dato
	pusha
	
	;mov bx,480	;para invertir orientaci�n de y
	;sub bx,y
	;mov y,bx
	
	mov bx,offset color
	mov al,[bx]
	mov ah,0Ch	;funcion escribir punto
	mov cx,x
	mov dx,y
	int 10h
	popa
endm

pixelo	macro x,y	;usar CX y DX como registro para pasar dato
	pusha
	
	;mov bx,480	;para invertir orientaci�n de y
	;sub bx,y
	;mov y,bx
	
	mov bx,offset color
	mov al,[bx]
	mov ah,0Ch	;funcion escribir punto
	mov cx,x
	add cx,offx
	mov dx,y
	add dx,offy
	cmp cx,640
	jg plos
	cmp cx,0
	jl plos 
	cmp dx,480
	jg plos
    cmp dx,0
    jl plos
	int 10h
plos:	popa
endm

main:	mov ax,@data
	mov ds,ax
	
	;leer configuraci�n de pantalla y guardarla en la pila
	mov ah,0fh
	int 10h
	push ax

	;definir pantalla 640x480, 16 colores
	mov ah,0
	mov al,12h
	int 10h
	
	mov cx,100
 ciclo:	push cx
 	
	;ROMBO
	mov color,3
	mov equis,100
	mov ye,300
	
	mov incx,1
	mov incy,-1
	call lrombo
	mov incx,1
	mov incy,1
	call lrombo
	mov incx,-1
	mov incy,1
	call lrombo
	mov incx,-1
	mov incy,-1
	call lrombo

 	
 	call retardo
 	;esperar usuario
	;mov ah,00h
	;int 16h
	
	call borra
	;detectar teclaso
        mov ah,06h       ;
        mov dl,0FFh        ;Si pongo 0ffh es para leer peroo si acsii es para escribir
        int 21h
        jz sigue                ;si no hubo teclazo brincate a sigue
        ;hubo teclaso dato en al
        cmp al,1Bh
        je fin
sigue:  
	
	inc offx
	inc offy
 	pop cx
 	loop ciclo
 
 	
	;esperar usuario
	;mov ah,00h
	;int 16h
	
	;restaurar pantalla
fin:	pop ax
	    mov ah,0
	    int 10h
	    .exit 0
        
lrombo:	mov cx,150
 l_r:	pixelo equis ye
 	mov ax,incx
	add equis,ax
	mov ax,incy
	add ye,ax
	loop l_r
	ret

;---------------
borra:	;mov ah,0
	;mov al,12h
	;int 10h

	mov ah,06
	mov al,0
	mov bh,0
	mov cx,0000h
	mov dx,8080h
	int 10h
	ret


retardo:
	push cx
	mov cx,0100h
 r_c1:	
 	push cx
 	mov cx,0200h
 r_c2:	loop r_c2
 
 	pop cx
 
 
 	loop r_c1
 	pop cx
 	ret
	
;HEX    BIN        COLOR
;0      0000      black
;1      0001      blue
;2      0010      green
;3      0011      cyan
;4      0100      red
;5      0101      magenta
;6      0110      brown
;7      0111      light gray
;8      1000      dark gray
;9      1001      light blue
;A      1010      light green
;B      1011      light cyan
;C      1100      light red
;D      1101      light magenta
;E      1110      yellow
;F      1111      white

end