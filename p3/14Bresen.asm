.model small
.486
.stack
.data
color	db	0Fh
.code
pixel	macro x,y	;usar CX y DX como registro para pasar dato
	pusha
	
	mov bx,480	;para invertir orientaci�n de y
	sub bx,y
	mov y,bx
	
	mov bx,offset color
	mov al,[bx]
	mov ah,0Ch	;funcion escribir punto
	mov cx,x
	mov dx,y
	int 10h
	popa
endm

mbre	macro x1,y1,x2,y2
	mov ax,x1
	push ax
	mov ax,y1
	push ax
	mov ax,x2
	push ax
	mov ax,y2
	push ax
	call bre
	add sp,08
endm

main:	;leer configuraci�n de pantalla y guardarla en la pila
	mov ax,@data
	mov ds,ax

	mov ah,0fh
	int 10h
	push ax

	;definir pantalla 640x480, 16 colores
	mov ah,0
	mov al,12h
	int 10h
 	mov color,0001b
 	mbre 0 0 640 480
	mbre 0 480 640 0
 	mov color,0Bh
 	mbre 200 200 100 200
 	mbre 200 200 100 150
 	mbre 200 200 100 100
 	mbre 200 200 150 100
 	mbre 200 200 200 100
 	mbre 200 200 250 100
 	mbre 200 200 300 100
 	mbre 200 200 300 150
 	mov color,0Ah
 	mbre 200 200 300 200
	mbre 200 200 300 250
 	mbre 200 200 300 300
 	mbre 200 200 250 300
 	mbre 200 200 200 300
 	mbre 200 200 150 300
 	mbre 200 200 100 300
 	mbre 200 200 100 250
 	mbre 200 200 100 200
	
	;esperar usuario
	mov ah,00h
	int 16h
	;restaurar pantalla
	pop ax
	mov ah,0
	int 10h
	
fin:	.exit 0
	
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

;             +10  +8  +6  +4
;function bre( xa, ya, xb, yb )
;{
;	var i, dx, dy, x, y, xEnd, yEnd, p, temp,paso=1, inver=0;
;	   -2  -4  -6 -8 10  -12   -14  -16  -18   -20     -22
bre:	push bp
	mov bp,sp
	sub sp,22
	pusha
	;word palabra de 16 bits
	mov word ptr [bp-20],1
	mov word ptr [bp-22],0
	;//si es vertical o tiene pendiente mayor a 1, invertir x y y
	;if( xb-xa == 0 || Math.abs( (yb-ya)/(xb-xa) ) >= 1 )
	;{
	;	temp=yb; yb=xb; xb=temp;
	;	temp=ya; ya=xa; xa=temp;
	;	inver=1;
	;}
	mov ax,[bp+6]	;xb
	cmp ax,[bp+10]	;xa
	jz rinver
	
	mov ax,[bp+4]	;yb
	sub ax,[bp+8]	;yb-ya
	mov cx,100
	
	imul cx		;ax = (yb-ya)*100
	mov cx,ax
	
	mov ax,[bp+6]	;xb
	sub ax,[bp+10]	;xb-xa

	mov bx,ax
	mov ax,cx
	mov dx,0	;en caso de ser positivo, corresponde ampliar con 0's
	and cx,1000000000000000b
	jz bre01
	mov dx,0FFFFh	;si es negativo, ampliar con F's
 bre01:
	idiv bx		;ax = yb-ya/xb-xa * 100
	call vabs	;ax = | yb-ya/xb-xa * 100 |
	
	cmp ax,100
	jge rinver
	; print "no invertido "
	jmp bre02
	
	;temp=yb; yb=xb; xb=temp;
 rinver:
 	; print "invirtiendo "
 	mov ax,[bp+4]	;yb
 	mov bx,[bp+6]	;xb
 	mov [bp+4],bx	;yb
 	mov [bp+6],ax	;xb
 	;temp=ya; ya=xa; xa=temp;
 	mov ax,[bp+8]	;ya
 	mov bx,[bp+10]	;xa
 	mov [bp+8],bx	;ya
 	mov [bp+10],ax	;xa
	;inver=1
	mov word ptr [bp-22],1	;inver

 bre02:
 	 ;mov dx,[bp-22]	;inver
 	 ;call desp4
 	 ;call reto
	;dx = Math.abs( xa - xb );
	mov ax,[bp+10]	;xa
	sub ax,[bp+6]	;xa-xb
	call vabs	; |xa-xb|
	mov [bp-4],ax	;dx
	
	;dy = Math.abs( ya - yb );
	mov ax,[bp+8]	;ya
	sub ax,[bp+4]	;yb
	call vabs	; |ya-yb|
	mov [bp-6],ax	;dy
	
	;p  = 2 * dy - dx;
	mov ax,[bp-6]	;dy
	shl ax,1	;dy*2
	sub ax,[bp-4]	;dy*2 - dx
	mov [bp-16],ax	;p
	;if( xa > xb )
	;{
	;	x = xb;
	;	y = yb;
	;	xEnd = xa;
	;	yEnd = ya;
	;} else {
	;	x = xa;
	;	y = ya;
	;	xEnd = xb;
	;	yEnd = yb;
	;}
	mov ax,[bp+10]
	cmp ax,[bp+6]
	jle bre04
	
 bre03:	mov ax,[bp+6]	;xb
 	mov [bp-8],ax	;x
 	mov ax,[bp+4]	;yb
 	mov [bp-10],ax	;y
 	mov ax,[bp+10]	;xa
 	mov [bp-12],ax	;xEnd
 	mov ax,[bp+8]	;ya
 	mov [bp-14],ax	;yEnd
 	jmp bre05
	
 bre04:	mov ax,[bp+10]	;xa
 	mov [bp-8],ax	;x
 	mov ax,[bp+8]	;ya
 	mov [bp-10],ax	;y
 	mov ax,[bp+6]	;xb
 	mov [bp-12],ax	;xEnd
 	mov ax,[bp+4]	;yb
 	mov [bp-14],ax	;yEnd

	;if( y>yEnd )
	;    paso=-1;
 bre05: mov ax,[bp-10]	;y
 	cmp ax,[bp-14]	;yEnd
 	jle bre06
 	mov word ptr [bp-20],-1	;paso
 	
 bre06:
	;setPixel( inver?y:x, inver?x:y );
	
	mov cx,[bp-8]	;x
	mov dx,[bp-10]	;y
	mov ax,[bp-22]	;inver
	cmp ax,1	;si inver==1
	jne bre07
	xchg cx,dx	;invertir coordenadas lo que es cx se convierte en dx y lo de dx en cx
 bre07:	pixel cx,dx
	;while( x < xEnd )
	;{
	;	x = x + 1;
	;	if( p<0 )
	;	    p = p + 2 * dy;
	;	else {
	;	    y = y + paso;
	;	    p = p + 2 * (dy - dx);
	;	}
	;	setPixel( inver?y:x, inver?x:y );
	;}	
;    +10  +8  +6  +4
;bre( xa, ya, xb, yb )
;var i, dx, dy, x, y, xEnd, yEnd, p, temp,paso=1, inver=0;
;   -2  -4  -6 -8 10  -12   -14  -16  -18   -20     -22
	
 brewh:	mov ax,[bp-8]	;x
	cmp ax,[bp-12]	;xEnd
	jge bres	;salir del ciclo si x<xEnd
	
	mov ax,[bp-8]	;x
	inc ax
	mov [bp-8],ax	;x
	
	mov ax,[bp-16]	;p
	cmp ax,0
	jge bre08	;p>=0 salta
	mov bx,[bp-6]	;dy
	shl bx,1
	add ax,bx	;p + 2*dy
	mov [bp-16],ax	;p
	jmp bre09
	
 bre08: mov bx,[bp-10]	;y
 	add bx,[bp-20]	;paso
 	mov [bp-10],bx	;y
 	
	mov bx,[bp-6]	;dy
	sub bx,[bp-4]	;dy- dx
	shl bx,1	;(dy-dx)*2
	add ax,bx	;p + 2*(dy-dx)
	mov [bp-16],ax	;p
	
 bre09:	mov cx,[bp-8]	;x
	mov dx,[bp-10]	;y
	mov ax,[bp-22]	;inver
	cmp ax,1	;si inver==1
	jne bre10
	xchg cx,dx	;invertir coordenadas
 bre10:	pixel cx,dx
	jmp brewh	;repetir para ciclo while
	
 bres: ;preparar salida
;}
	mov sp,bp
	pop bp
	ret
;-------------------------------------
;funci�n para obtener valor absoluto de dato en AX, devuelve en AX
vabs:	;dato en ax
	push bx
	mov bx,ax
	and bx,1000000000000000b
	jz vabss
	not ax
	inc ax
 vabss:	pop bx
 	ret
end