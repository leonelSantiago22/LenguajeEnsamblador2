;Autor Marco Azpurua
;URL 

; Autor: MARCO AZPURUA AUYANET. UNEFA - MARACAY VENEZUELA.
span style="color: #000000; font-weight: bold;"> model small
.stack 64h
.data

  cadena1 db 50 dup(' '),'$'; llena las cadenas con espacio
  
  msj1 db 'El numero de caracteres es:$'
  msj2 db 'Hola este programa cuenta caracteres de la cadena: $'

.code
.startup

 mov ah,06h         ; peticion de recorrido de la pantalla
 mov al,00h         ; indica la pantalla completa
 mov bh,17h         ; attributos de color y fondo 7 blanco 0 negro    
 mov cx,0000h       ; esquina superior izquierda renglon columna
 mov dx,184fh       ; esquina inferior derecha renglon columna
 int 10h            ; llamada a la interrupcion de video BIOS

mov ah,02
 mov dx,0402h
 mov bh,00
 int 10h

 mov ah,09 ;    Escribir cadena
 mov dx,offset msj2
 int 21h

 mov bx,0000h
 lea SI,cadena1 ; llena a SI con la direccion del primer caracter de  la cadena1
 mov cx,50      ; inicio el registro del contador en 10 
 regresa:
    mov ah,07h ; Recoje por teclado un carater y lo coloca en AL sin eco
    int 21h    ; ejecuta la funcion del DOS    
    cmp al,13  ; Compara al con enter
    je termina ; salta solo si la tecla oprimida es enter
    mov [SI],al; copia el contenido de AL en el registro cuya direccion es igual al contenido de SI
    inc SI     ; Incrementa en 1 el contenido de SI
    inc bx
    mov dl,al  ; compia el contenido de dl en al
    mov ah,02h ; Funcion de mostrar por pantalla el contenido de dl
    int 21h    ; ejecuta la funcion del DOS
    loop regresa ; En contenido de CX disminuye en 1 y salta a regresa

 termina:
 
 
 mov al,bl
 and ax,000fh
 and bx,00f0h
 shr bx,01
 mov ah,bl
 cmp al,0ah
 jb dejar
 daa
 inc ah
 
 dejar:
 mov bl,al
 mov al,ah
 cmp al,0ah
 jb decena
 daa
 mov dx,31h
 
 decena:
 mov bh,al
 and bx,0f0fh
 or bx,3030h
 mov cx,bx
        
 mov ah,02
 mov dx,0702h
 mov bh,00
 int 10h

 mov ah,09 ;    Escribir cadena
 mov dx,offset msj1
 int 21h
 
 mov ah,02
 mov dx,071eh
 mov bh,00
 int 10h
 
 mov dl,ch
 mov dh,cl
 
 mov ah,02
 mov cx,01
 int 21h
 mov ch,dh
 mov dl,ch
 int 21h
  

.exit
end
	
	
Lo más popularcomparacionMenusuma,resta,multiplicacion y dividecalculadora basicaLee Cadena y la muestra en una coordenada especificaBinario a DecimalFactorialSuma dos numeros sin importar el acarreoCuenta caracteresCaptura CadenaLos 10 mas visitadossuma,resta,multiplicacion y divideMenuSuma dos numeros sin importar el acarreoBinario a DecimalLee Cadena y la muestra en una coordenada especificaFactorialensambladorcomparacionUltimos 10 agregadosrealizar un margenMenuduplicar palabracrear carpetasuma,resta,multiplicacion y divideposiciones del cursor en cualquier momentocomparacionCaptura Cadenarotabit o kit de 16 bits	


