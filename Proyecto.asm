;ESTABLECE EL MODO VIDEO
org 100h
mov ah,00h
mov al,03h                  
int 10h                        

;inicializacion  
call dibujar_ventana    

;inicializa impresora
;mov ah,01h
;mov dx,01h
;int 17h

mov ah,02h
mov dh,6
mov dl,2
int 10h

push ax
push di
push si
mov ax,0b800h 
mov es,ax
mov di,4
lea si,titulo
call escribe  ;muestra titulo
pop si
pop di
pop ax 

buffer db 12000 dup(00h) ;aca va 12000
buffer_copy db 12000 dup(00h)  ;para los archivos  
banderas db 10 dup(00h) 
nombreArchivo db 200 dup(00h)
nombreArchivo2 db 200 dup(00h) 
mensaje db 100 dup(00h);"Nombre Archivo:",'$'
mensajeError DB "Error$"  
handle dw ? 
                                                
;aca inicializo "mensaje" porque no me deja ponerlo como esta comentado arriba :/
push si
lea si,mensaje
mov [si],4eh
add si,2
mov [si],6fh
add si,2
mov [si],6dh
add si,2
mov [si],62h
add si,2
mov [si],72h
add si,2
mov [si],65h
add si,2
mov [si],20h
add si,2  
mov [si],64h
add si,2
mov [si],65h
add si,2
mov [si],20h
add si,2
mov [si],61h
add si,2
mov [si],72h
add si,2
mov [si],63h
add si,2
mov [si],68h
add si,2
mov [si],69h
add si,2
mov [si],76h
add si,2
mov [si],6fh
add si,2
mov [si],3ah  
add si,2
mov [si],24h
pop si
                                                

mov ax,0b800h ;memoria de video
mov es,ax
;mov di,802    ;posicion columna 1 fila 5
lea si,buffer

push di  
lea di,banderas
mov [di],si ;puntero al comienzo de pagina                                                
add di,4 
push ax
mov ax,0h
mov [di],ax  ; con 0 usa puntero a pagina, con 1 usa puntero a nombreArchivo
pop ax
pop di             

;inicializa mouse          
mov ax,00h
int 33h   
mov ax,01h
int 33h

call leer_archivo_ayuda
;fin inicializacion              
              
inicio:
    call barra
    call actualizar_memoria      
    mov ah,02h   ;establece la posicion del cursor
    int 10h  
    call mouse 
    mov ah,01h
    int 16h
    je inicio    
    mov ah,0h
    int 16h
    
    call identificar_puntero
   inicio2:  
    call leer_tecla_funcion_barra
    jmp tecla_barra
ret 
   inicio3:   
    call leer_flechas  
    call leer_tecla_funcion 
    ;otra tecla
    jmp tecla
fin:     
ret         
   
identificar_puntero:
    push di
    lea di,banderas
    add di,4
    cmp [di],0h
    je inicio31
    pop di
    jmp inicio2                       
  inicio31:
    pop di
    jmp inicio3  

mouse:       
    push ax
    push bx
    push cx
    push dx     
    push di
    push si                       
    
    ;leo la posicion del cursor (en pixeles): cx=coordenada X ; dx=coordenada Y
    mov ax,03h
    int 33h  
    cmp bx,01h
    jne endd2
    
    ;calculo columna
    mov ax,cx
    mov cl,8           
    div cl   ;en al me queda el cociente y en ah el residuo
    mov ch,al
    
    ;calculo fila
    mov ax,dx          
    div cl   ;en al me queda el cociente y en ah el residuo
    mov cl,al
    
    mov dh,cl
    mov dl,ch
    
    ;barra superior
    cmp dh,1       
    jl sec_texto      ;si la fila es menor a 1
    cmp dh,3      
    jg sec_texto      ;si la fila es mayor a 3                         
    cmp dl,2       
    jl sec_texto      ;si la columna es menor a 2
    cmp dl,77      
    jg sec_texto      ;si la columna es mayor a 77
    push di
    lea di,banderas
    add di,2
    mov si,[di] 
    add di,2  
    mov ax,1h
    mov [di],ax
    pop di
         
    mov dh,2
    mov dl,21  
    
    lea si,nombreArchivo2
   bnm:
    cmp dl,77
    je hjkl
    cmp [si],00h
    je hjkl
    add si,2
    add dl,1
    jmp bnm
   
    ;sector texto
    sec_texto:
    ;las siguientes restricciones las hago porque no me funciona
    ;la interrupcion que limita el dezplasamiento del mouse dentro ç
    ;del marco donde va el texto
    cmp dh,6       
    jl endd2      ;si la fila es menor a 6
    cmp dh,20      
    jg endd2      ;si la fila es mayor a 20                         
    cmp dl,2       
    jl endd2      ;si la columna es menor a 2
    cmp dl,77      
    jg endd2      ;si la columna es mayor a 77  
    
    ;verifica memoria de video
    push dx
    mov di,964 ;comienzo de pagina
    sub dl,2
    push dx 
    mov dh,0
    add di,dx 
    add di,dx
    pop dx
    sub dh,6
    mov ax,80
    mov dl,dh
    mov dh,0   
    mul dx
    add di,ax 
    add di,ax
    pop dx   
                            
    ;mueve el puntero a memoria       
    mov ah,6    ;primer fila
    mov al,2    ;primer columna
    push di 
    lea di,banderas  
    mov si,[di]  ;comienzo de pagina
    add di,4 
    push ax 
    mov ax,0h
    mov [di],ax
    pop ax
    pop di   
    
 bucle12:  
    cmp ax,dx
    jg endd2  
    cmp ax,dx      ;si llegue a la posicion del cursor entonces salgo del bucle
    je final_mov
    cmp al,77
    jne sig_mov 
    add si,2
    mov al,2
    add ah,1
    jmp bucle12
 sig_mov:
    cmp [si],0dh ;si es enter
    jne sig_mov2
    add si,2
    mov al,2
    add ah,1
    jmp bucle12 
 sig_mov2:   
    add si,2
    add al,1
    jmp bucle12 
    
 final_mov:
    cmp [si],0dh   ;si es enter posiciona el cursor igual (en mem. de video es null)
    je hjkl      
    ;si hay null en memoria pero el anterior no es null (ultimo renglon en memoria)
    ;posiciona igual el cursor
    cmp [si],00h   
    jne hjkl
    push di
    mov di,si
    sub di,2
    cmp [di],00h
    jne ghjkl
    pop di          
    ;si en video hay null y en memoria no es enter entonces no posiciona el cursor
    cmp es:[di],00h 
    je endd21  
    jmp hjkl
 ghjkl:
    pop di
 hjkl:  
    mov di,si         
    pop si      
    mov si,di
    pop di    
    mov ax,dx
    pop dx   
    mov dx,ax
    pop cx
    pop bx
    pop ax
ret         
  endd21:
    cmp dh,6
    jne endd2
    cmp dl,2
    je hjkl   
  endd2:  
    pop si
    pop di
    pop dx   
    pop cx
    pop bx
    pop ax
ret  

casi_mouse:       
    push ax
    push bx
    push cx
    push dx     
    push di
    push si                       
        
    ;barra superior
    cmp dh,1       
    jl sec_texto2      ;si la fila es menor a 1
    cmp dh,3      
    jg sec_texto2      ;si la fila es mayor a 3                         
    cmp dl,2       
    jl sec_texto2      ;si la columna es menor a 2
    cmp dl,77      
    jg sec_texto2      ;si la columna es mayor a 77
    push di
    lea di,banderas
    add di,2
    mov si,[di] 
    add di,2  
    mov ax,1h
    mov [di],ax
    pop di
         
    mov dh,2
    mov dl,21  
    
    lea si,nombreArchivo2
   bnm2:
    cmp dl,77
    je hjkl2
    cmp [si],00h
    je hjkl2
    add si,2
    add dl,1
    jmp bnm2
    
    
    
    ;sector texto
    sec_texto2:  
    
    ;verifica memoria de video
    push dx
    mov di,964 ;comienzo de pagina
    sub dl,2
    push dx 
    mov dh,0
    add di,dx 
    add di,dx
    pop dx
    sub dh,6
    mov ax,80
    mov dl,dh
    mov dh,0   
    mul dx
    add di,ax 
    add di,ax
    pop dx   
                            
    ;mueve el puntero a memoria       
    mov ah,6    ;primer fila
    mov al,2    ;primer columna
    push di 
    lea di,banderas  
    mov si,[di]  ;comienzo de pagina
    add di,4 
    push ax 
    mov ax,0h
    mov [di],ax
    pop ax
    pop di   
    
 bucle122:  
    cmp ax,dx
    jg endd22  
    cmp ax,dx      ;si llegue a la posicion del cursor entonces salgo del bucle
    je final_mov2
    cmp al,77
    jne sig_mov22 
    add si,2
    mov al,2
    add ah,1
    jmp bucle122
 sig_mov22:
    cmp [si],0dh ;si es enter
    jne sig_mov222
    add si,2
    mov al,2
    add ah,1
    jmp bucle122 
 sig_mov222:   
    add si,2
    add al,1
    jmp bucle122 
    
 final_mov2:
    cmp [si],0dh   ;si es enter posiciona el cursor igual (en mem. de video es null)
    je hjkl2      
    ;si hay null en memoria pero el anterior no es null (ultimo renglon en memoria)
    ;posiciona igual el cursor
    cmp [si],00h   
    jne hjkl2
    push di
    mov di,si
    sub di,2
    cmp [di],00h
    jne ghjkl2
    pop di          
    ;si en video hay null y en memoria no es enter entonces no posiciona el cursor
    cmp es:[di],00h 
    je endd212  
    jmp hjkl2
 ghjkl2:
    pop di
 hjkl2:  
    mov di,si         
    pop si      
    mov si,di
    pop di    
    mov ax,dx
    pop dx   
    mov dx,ax
    pop cx
    pop bx
    pop ax
ret         
  endd212:
    cmp dh,6
    jne endd22
    cmp dl,2
    je hjkl2   
  endd22:  
    pop si
    pop di
    pop dx   
    pop cx
    pop bx
    pop ax
ret
    
                           
actualizar_memoria:   
    push si
    push di
    push ax
    push dx 
    
   ; ;barra  
    lea si,mensaje 
    mov di,324
  bucle_barra: 
    cmp [si],24h ;$
    je nombre_ar 
    mov al,[si]
    mov es:[di],al
    add si,2
    add di,2
    jmp bucle_barra
 nombre_ar:    
    mov di,362
    lea si,nombreArchivo2
    mov dl,21
 bucle_barra2:   
    cmp dl,77
    je act_txt 
    mov al,[si]
    mov es:[di],al
    add si,2
    add di,2
    add dl,1
    jmp bucle_barra2    
    
    ;texto
    act_txt:
    mov di,964 
    mov dh,6
    mov dl,2  
    call verificar_comienzo_lectura     
 ff:                     
    call validar_fila
    call validar_columna 
    mov al,[si] 
    cmp al,0dh
    je verificar_mostrar_enter 
    mov es:[di],al
    cmp di,3354 ;esquina inferior de la ventana (donde va el texto)
    jne incrementar  
  pos_invalida:  
    pop dx
    pop ax 
    pop di
    pop si   
ret        

verificar_comienzo_lectura:
    push di
    lea di,banderas
    mov si,[di]
    pop di
ret   

verificar_mostrar_enter:
    cmp dh,20 ;verifico si estoy en el ultimo renglon
    jne mostrar_enter
  ooo:
    push ax
    mov al,00h
    mov es:[di],al
    pop ax
    add dl,1
    add di,2
    cmp dl,78
    jne ooo
    jmp pos_invalida
         
mostrar_enter:
  oo:
    push ax
    mov al,00h
    mov es:[di],al
    pop ax
    add dl,1
    add di,2
    cmp dl,78
    jne oo
    call validar_columna
    sub di,2
    mov dl,1 
    jmp incrementar
   
incrementar:
    add di,2
    add si,2  
    add dl,1
    jmp ff 
    
validar_columna:
    cmp dl,78
    je  fin_columna
ret

fin_columna:
    mov dl,2
    add dh,1
    add di,8
    jmp validar_columna   
   
validar_fila:
    cmp dh,21
    je  pos_invalida
ret     
    
leer_flechas:     
    ;flecha izquierda
    cmp ah,4bh
    je flecha_izquierda 
    ;flecha derecha
    cmp ah,4dh
    je flecha_derecha
    ;flecha arriba
    cmp ah,48h
    je flecha_arriba
    ;flecha abajo
    cmp ah,50h
    je flecha_abajo    
ret                     
   
leer_tecla_funcion:
    ;enter
    cmp ah,1ch
    je enter 
    cmp ah,47h
    je home
    cmp ah,4fh
    je endl 
    cmp ah,53h
    je supr 
    cmp ah,0eh
    je borrar 
    cmp ah,3fh
    je escribir_archivo 
    cmp ah,3ch
    je vaciar_documento
    cmp ah,3dh       
    je f3 ;imprimir
    ;cmp ah,3eh
    ;je f4
    cmp ah,0fh
    je saltar_a_texto_de_barra 
    cmp ah,01h
    je fin 
    cmp al,1bh
    je fin         
ret

f3: 
    ;inicializa impresora
    push ax
    push dx
    mov ah,01h
    mov dx,00h
    int 17h
    pop dx
    pop ax 
    
    push dx
    push di
    push ax
    mov dx,00h
    lea di,buffer    
 ff12: 
    mov ah,00h
    mov al,[di]
    cmp al,0dh
    je new_enter
    int 17h
    jmp new_enter2
    
 new_enter:
    mov al,0ah
    int 17h
 
 new_enter2:      
    add di,2
    
    cmp [di],00h ;fin de memoria (null)
    jne ff12 
    
    mov ah,00h
    mov al,0ah
    int 17h   
    
    pop ax
    pop di
    pop dx    
jmp inicio

vaciar_documento:
    push cx
    push di      
    lea di,buffer
    vaciar_documento1:
        mov [di],0h
        inc di
        inc cx
        cmp cx,12000d
        jne vaciar_documento1
        
    pop di
    pop cx
    
    mov dh,6
    mov dl,2
    call casi_mouse
    jmp inicio 

leer_tecla_funcion_barra:
    ;flecha izquierda
    cmp ah,4bh
    je inicio 
    ;flecha derecha
    cmp ah,4dh
    je inicio  
    ;flecha arriba
    cmp ah,48h
    je inicio
    ;flecha abajo
    cmp ah,50h
    je inicio 
    cmp ah,0eh
    je borrar_barra  
    cmp ah,40h
    je leer_archivo 
    cmp ah,3fh
    je escribir_archivo 
    cmp ah,0fh
    je saltar_a_texto
    cmp ah,01h
    je fin
    cmp al,1bh
    je fin       
ret

saltar_a_texto:
    mov dh,6
    mov dl,2
    call casi_mouse
    jmp inicio
    
saltar_a_texto_de_barra:
    mov dh,2
    mov dl,21
    call casi_mouse
    jmp inicio         
                    
borrar_barra: 
    cmp dl,21
    je inicio
    sub dl,1  
    sub si,2
    mov [si],00h
    jmp inicio 
    
tecla_barra:
    cmp dl,77
    je inicio
    mov [si],al 
    add si,2
    add dl,1
    jmp inicio                       

home:
    push ax
    cmp dl,2
    je inicio
    dec dl
    push dx
    mov dh,0h
    sub si,dx
    sub si,dx
    add si,2
    pop dx
    mov dl,2
    pop ax 
    jmp inicio

endl:
    push ax
    
end1: cmp dl,77
      je end2
      cmp [si],0h
      je end2
      cmp [si],0Dh
      jne desplazamiento_enter
              
end2: pop ax 
      jmp inicio      

desplazamiento_enter:
    add si,2
    inc dl     
    jmp end1 

supr:
    call mover_un_lugar_en_memoria_atras
    jmp inicio  
    
borrar: 
    push si                 
    sub si,2
    call mover_un_lugar_en_memoria_atras
    pop si
    call verificar_izquierda            
    jmp inicio

   
flecha_izquierda:  
    mov ah,03h   ;lee la posicion del cursor
    int 10h
    call verificar_izquierda 
    jmp inicio
          
flecha_derecha:
    mov ah,03h   ;lee la posicion del cursor
    int 10h
    call verificar_derecha 
    jmp inicio         

flecha_arriba:
    mov ah,03h   ;lee la posicion del cursor
    int 10h
    call verificar_arriba 
    jmp inicio

flecha_abajo:
    mov ah,03h   ;lee la posicion del cursor
    int 10h
    call verificar_abajo 
    jmp inicio
                
tecla:
    cmp al,1bh
    je fin  
    cmp ah,52h
    je inicio  ;si es insert, vuelvo a inicio
    cmp ah,45h
    je inicio
    
    push ax 
    mov ah,02h
    int 16h   
    shr al,8        ;veo si esta activado el insert
    pop ax    
    jc teclaInsert         
    cmp [si],00h
    jne  caracter_no_nulo      
   cnl:    
    mov [si],al         
    inc dl   
    cmp dl,78
    jne xx
    mov dl,2
    inc dh  
    cmp dh,21
    jne xx
    mov dh,20
    call bajar_un_renglon    
    xx:
    add si,2  
    jmp inicio    
    
teclaInsert:
    cmp dl,77
    je cnl
    cmp [si],0Dh
    je caracter_no_nulo
    ;je mover_un_lugar_en_memoria 
    jmp cnl       
    
caracter_no_nulo:
    call mover_un_lugar_en_memoria                                               
    jmp cnl  
    
bajar_un_renglon:                  
    cmp si,11998  ;ultima posicion en la memoria del buffer
    je inicio
    push si 
    push dx      
    call verificar_comienzo_lectura
    mov dl,2
   vv:
    cmp dl,77
    je fin_de_linea
    cmp [si],0dh
    je fin_de_linea
    add si,2
    add dl,1
    jmp vv
    
fin_de_linea:
    add si,2 
    push di
    lea di,banderas
    mov [di],si
    pop di
    pop dx
    pop si
    ret   
                                                                      
enter: 
    cmp [si],00h
    jne no_nulo
   kkk: 
    add dh,1
    mov dl,2                          
    mov [si],al
    cmp dh,21 
    jne gg
    call bajar_renglon
    gg:
    add si,2  
    jmp inicio     
    
bajar_renglon:
  mov dh,20
  jmp bajar_un_renglon    
                                            
no_nulo:
    call mover_un_lugar_en_memoria                                               
    jmp kkk:
               
mover_un_lugar_en_memoria:
    cmp si,11998 ;ultimo caracter de la memoria
    je inicio 
    push di
    push ax   
    lea di,buffer
    add di,11996 ;posicion del anteultimo caracter de la memoria
    ttt: 
       push si
       mov si,di
       add si,2
       mov al,[di]
       mov [si],al
       sub di,2
       pop si
       cmp di,si
       jge ttt
    pop ax
    pop di 
ret             

mover_un_lugar_en_memoria_atras:
    push di
    push ax   
    push si 
    ttt1: 

       mov di,si
       add di,2
       mov al,[di]
       mov [si],al
       add si,2
       cmp [si],0h
       jne ttt1
    pop si
    pop ax
    pop di 
ret 
                          
verificar_izquierda:
    push di
    lea di,buffer
    cmp di,si
    jne mm
    pop di
    jmp inicio
    mm:
    pop di 
    cmp dl,2  ;verifica columna
    je  verificar_fila_ini
    sub dl,1
    sub si,2
ret

verificar_fila_ini:
    cmp dh,6
    je subir_ventana_un_renglon 
    jmp buscar_caracter_arriba 
    
buscar_caracter_arriba:
    push si
    call buscar_caracter_up
    pop si                   
    sub si,2  
    sub dh,1
    jmp inicio   
    
subir_ventana_un_renglon: 
    push si     
    push di
    call buscar_caracter_up 
    lea si,banderas
    mov [si],di
    pop di
    pop si                   
    sub si,2 
    jmp inicio     
    
buscar_caracter_up:   ;posiciona el cursor arriba   
    sub si,2
    mov dl,2  
    lea di,buffer
 bucle:     
    cmp di,si 
    je fin_buscar
    cmp [di],0dh
    jne incr
    mov dl,1
 incr:
    cmp dl,77
    jne re
    mov dl,1
    re:
    add dl,1
    add di,2
    jmp bucle
 fin_buscar:  
    push dx 
    sub dl,2
    mov dh,0
    sub di,dx
    sub di,dx
    pop dx
ret                                
   
verificar_derecha:
    cmp [si],0dh
    je  verificar_fila_der
    cmp dl,77   ;verifica la columna
    je  verificar_fila_der
    cmp [si],00h
    je inicio    
    add dl,1              
    add si,2
ret 
       
verificar_fila_der:
    cmp dh,20 ;verifica fila
    je call verificar_memoria_abajo
    add dh,1
    mov dl,2
    add si,2
    jmp inicio

verificar_memoria_abajo:
    call bajar_un_renglon
    mov dl,2 
    add si,2
    ret
   
verificar_arriba:
    cmp dh,6
    jne solo_subir_renglon   
    push di 
    push si
    lea di,buffer  
    lea si,banderas
    cmp [si],di
    je no_hacer_nada
    pop si
    pop di
    jmp subir_renglon_y_ventana

no_hacer_nada: 
    pop si
    pop di
    jmp inicio                                  
                                 
solo_subir_renglon:
    push cx
    mov ch,0
    mov cl,dl
    push dx
    mov dh,0
    sub si,dx
    sub si,dx
    pop dx
    add si,4  
    sub dh,1
    push di
    call buscar_caracter_up
    pop di 
    push dx
    mov dh,0
    cmp cl,dl
    jg fin_up
    sub si,dx
    sub si,dx
    add si,cx
    add si,cx
    pop dx
    mov dl,cl
    pop cx
    jmp inicio
  fin_up:
    pop dx
    pop cx
    jmp inicio
    
            
subir_renglon_y_ventana:
    push cx
    mov ch,0
    mov cl,dl
    push dx
    mov dh,0
    sub si,dx
    sub si,dx
    pop dx
    add si,4 
    push di
    call buscar_caracter_up 
    push si
    lea si,banderas
    mov [si],di
    pop si
    pop di 
    push dx
    mov dh,0
    cmp cl,dl
    jg fin_up2
    sub si,dx
    sub si,dx
    add si,cx
    add si,cx
    pop dx
    mov dl,cl
    pop cx
    jmp inicio
  fin_up2:
    pop dx
    pop cx
    jmp inicio     
                        
verificar_abajo:     
    cmp dh,20
    jne solo_bajar_renglon 
    push di 
    push dx
    mov di,si 
    bucle1234:
    cmp [di],00h
    je volver_inicio2
    cmp [di],0dh
    je ddff
    cmp dl,76
    je ddff
    add di,2
    add dl,1      
    jmp bucle1234
    ddff: 
    pop dx
    pop di
    call bajar_un_renglon
    jmp  solo_bajar_renglon
    jmp inicio
 
volver_inicio2:
    pop dx
    pop di
    jmp inicio 
        
solo_bajar_renglon:
    push cx
    push dx 
    push di 
    mov di,si
    mov ch,0
    mov cl,dl
  bucle123:
    cmp [di],00h
    je volver_inicio   
    cmp [di],0dh
    je buscar_abajo_fin
    cmp dl,76
    je buscar_abajo_fin
    add di,2
    add dl,1      
    jmp bucle123  
    
volver_inicio:
    pop di 
    pop dx
    pop cx
    jmp inicio    
          
buscar_abajo_fin:
    add di,2
    mov dl,2
 bucle11:
    cmp [di],00h
    je fin_busqueda11   
    cmp [di],0dh
    je fin_busqueda11
    cmp dl,76
    je fin_busqueda11
    add di,2
    add dl,1      
    jmp bucle11    

fin_busqueda11:
    mov si,di
    pop di   
    cmp cl,dl
    jl bajar_derecho 
    mov cl,dl
    jmp termina          

bajar_derecho:
   bucle45:
    cmp cl,dl
    je termina
    sub dl,1
    sub si,2
    jmp bucle45
 termina:
    pop dx
    mov dl,cl
    add dh,1
    pop cx
    cmp dh,21
    jne inicio
    sub dh,1 
    jmp inicio   
    
barra:     
    push ax
    push dx
    push di
    push si
    
    mov ax,0b800h
    mov es,ax      
    
    mov ah,12h   ;leo estados del teclado extendido
    int 16h
                     
    mov di,3684  ;me posiciono en "barra de estados"

    push ax
    call clear   ;borra barra de estados
    pop ax
    
    mov di,3684
    
    call divi1
    call divi2
    jmp estado6                

barra1:    
    pop si            
    pop di
    pop dx
    pop ax  
ret

divi1:   
    push ax 
    push dx    
    mov al,dh 
    sub al,6  
    mov bx,10d
    mov dx,0h
    div bx
    
    add al,30h
    add dl,30h
     
    mov es:[di],al   
    add di,2          
    mov es:[di],dl
    add di,2 
    mov es:[di],'/'
    add di,2 
    mov es:[di],' '
    pop dx   
    pop ax
ret     

divi2:    
    push ax
    push dx       
    mov al,dl 
    sub al,2  
    mov bx,10d
    mov dx,0h
    div bx
    
    add al,30h
    add dl,30h
     
    mov es:[di],al   
    add di,2          
    mov es:[di],dl
    add di,2 
    mov es:[di],' '
    add di,2 
    mov es:[di],'-'
    add di,2 
    mov es:[di],' ' 
    add di,2
    pop dx  
    pop ax
ret

estado1:         ;insert
    push ax
    shr al,8
    jc es1
    shr ah,8
    jc es1
    pop ax
    jmp barra1

es1:pop ax
    push ax       
    lea si,e1 
    call escribe 
    pop ax 
    jmp barra1

estado2:        ;mayus
    push ax
    shr al,7
    jc es2 
    shr ah,7
    jc es2
    pop ax 
    jmp estado1  

es2:pop ax    
    push ax       
    lea si,e2 
    call escribe 
    pop ax     
    jmp estado1  
    
estado3:           ;scroll
    push ax
    shr al,6
    jc es3 
    shr ah,6
    jc es3 
    pop ax
    jmp estado2   
  
es3:pop ax
    push ax       
    lea si,e3 
    call escribe 
    pop ax
    jmp estado2
    
estado4:           ;scroll
    push ax
    shr al,5
    jc es4
    push si
    lea si,banderas
    add si,2
    mov [si],0
    pop si 
    shr ah,5
    jc es4 
    pop ax
    jmp estado3   
  
es4:pop ax
    push ax       
    lea si,e4 
    call escribe
    push si
    lea si,banderas
    add si,2
    mov [si],1
    pop si 
    pop ax
    jmp estado3
    
estado5:           ;scroll
    push ax
    shr al,2
    jc es5 
    shr ah,2
    jc es5 
    pop ax
    jmp estado4   
  
es5:pop ax
    push ax       
    lea si,e5 
    call escribe 
    pop ax
    jmp estado4    
    
estado6:           ;mayus
    push ax
    shr al,1
    jc es6 
    shr ah,1
    jc es6 
    pop ax
    jmp estado5   
  
es6:pop ax
    push ax       
    lea si,e6 
    call escribe 
    pop ax
    jmp estado5    

escribe:
    mov al,[si]
    mov es:[di],al   
    add si,1
    add di,2          
    cmp [si],24h
    jne escribe 
ret  
    
clear:
    mov al,0h   
clear1:    mov es:[di],al 
           add di,2
           cmp di,3836
           jne clear1
ret

escribir_archivo:
    push cx
    push dx
    
    call leer_nombre_archivo
    
    call borrar_archivo
    
    call crear_archivo 
    
    call escribeAr   
    
    pop dx
    pop cx 
    
    cmp dh,2
    jne escribe_aux1
    mov dh,6
    mov dl,2
    
    escribe_aux1:
        call casi_mouse
    
    jmp inicio   
        


escribeAr: ;escribo el archivo

push ax 
push bx  
push di
push es 
push dx
push si
  

mov ah,3dh                    ;SERVICIO DE APERTURA DE ARCHIVO
mov dx, offset nombreArchivo  ;SE SETEA EL NOMBRE DEL ARCHIVO
mov al, 1h                    ;MODO SOLO ESCRITURA
int 21h                       ;SE ABRE EL FICHERO PARA TRABAJAR

call copiar_buffer

mov bx,ax   ;PONGO EL HANDLE QUE DEVUELVE EL SERVICIO ANTERIOR EN BX

;EL HANDLE ES COMO UN IDENTIFICADOR DEL ARCHIVO DENTRO DEL PROGRAMA
;ESTE SE NECESITA PARA LAS DEMAS OPERACIONES 
 
;call cuenta ;CARGA EN CX EL TAMANIO DEL MENSAJE

mov ah,40h                  ;SERVICIO PARA ESCRIBIR MENSAJE
;mov cx,12000d               ;SETEO TAMANIO DE MENSAJE
mov dx,offset buffer_copy   ;PONGO EL MENSAJE QUE SE VA A ESCRIBIR
int 21h                     ;SE GUARDA EL MENSAJE
jc error                    ;SI HUBO ERROR MUESTRA "ERROR"

mov ah,3eh      ;SERVICIO QUE CIERRA FICHERO
mov bx,handle   ;HANDLE DEL FICHERO
int 21h         ;CLAUSURA DE FICHERO

pop si
pop dx       
pop es 
pop di      
pop bx
pop ax
        
ret

error:      ;SI HUBO ERROR MUESTRA MENSAJE
push si
push di 
lea si,mensajeError
salto5:
    mov al,[si]
    mov es:[di],al
    add si,1  
    add di,2
    cmp [si],24h ;fin de linea "$"
    jne salto5
pop di
pop si
ret 

leer_archivo: ;leo el archivo

push ax 
push bx  
;push es 
;push dx
;push si  
push di

call leer_nombre_archivo
       
mov ah, 3dh                     ;servicio apertura fichero
mov dx, offset nombreArchivo    ;nombre del fichero a abrir
mov al, 0h                      ;abre en modo lectura
int 21h                 

call vaciar_buffer
call vaciar_buffer_copy

push dx
mov bx,ax                   ;pongo el handle que devuelve el servicio anterior en bx
mov dx, offset buffer_copy  ;donde quiero guardar lo que se lee
mov ah,3fh                  ;servicio de lectura
mov cx,12000d               ;cuantos caracteres voy a leer
int 21h                     ;leo el archivo
pop dx                     

call copiar_a_buffer

mov ah, 3eh     ;servicio clausura fichero
mov bx, handle  ;handle a cerrar
int 21h         ;se cierra el fichero

;lea di,buffer
;mov di,0h                       
;call mover_cursor_al_final

mov dh,6
mov dl,2
call casi_mouse

pop di 

;mov di,0h
                      
;pop si
;pop dx       
;pop es       
pop bx
pop ax

jmp inicio      
        
ret   

leer_archivo_ayuda: ;leo el archivo

push ax 
push bx  
push di
       
mov ah, 3dh                     ;servicio apertura fichero
mov dx, offset ayuda    ;nombre del fichero a abrir
mov al, 0h                      ;abre en modo lectura
int 21h                 

call vaciar_buffer
call vaciar_buffer_copy

push dx
mov bx,ax                   ;pongo el handle que devuelve el servicio anterior en bx
mov dx, offset buffer_copy  ;donde quiero guardar lo que se lee
mov ah,3fh                  ;servicio de lectura
mov cx,12000d               ;cuantos caracteres voy a leer
int 21h                     ;leo el archivo
pop dx                     

call copiar_a_buffer

mov ah, 3eh     ;servicio clausura fichero
mov bx, handle  ;handle a cerrar
int 21h         ;se cierra el fichero 

mov dh,6
mov dl,2
call casi_mouse

pop di       
pop bx
pop ax     
        
ret

mover_cursor_al_final:
    push di
    push cx
    ;push si
    
    lea si,buffer    
  
    mover_cursor_al_final1:  
        cmp [si],0dh
        je hay_enter
          
        inc cx
        add si,2
         
        cmp [si],0h   
        jne mover_cursor_al_final1
        call cambiar_cursor_inicio_pagina 
    
    ;pop si
    pop cx
    pop di
ret

hay_enter:
    mov cx,0h
    add si,2
    jmp mover_cursor_al_final1
    

cambiar_cursor_inicio_pagina: 
    push di
    ;push si
    ;push dx
    push ax
    push bx
       
    sub si,cx
    sub si,cx 
    
    push si
    cambiar_cursor_inicio_pagina1:
        add si,2
        mov ah,[si]
        sub si,2
        mov [si],ah
        add si,2
        cmp [si],0h
        jne cambiar_cursor_inicio_pagina1
    pop si
    
    lea di,banderas
    mov [di],si  
    
    ;add cx,1
    
    mov dl,cl
    mov dh,6
    mov ah,02h
    mov bh,01h
    int 10h
    
    pop bx
    pop ax
    ;pop dx
    ;pop si
    pop di
ret


copiar_buffer:
  push di
  push si
  push ax
  mov cx,0h
  lea si,buffer_copy
  lea di,buffer    
  
  copiar_buffer1:    
    
    inc cx
    
    mov al,[di]
    
    mov [si],al
    
    add si,1
    add di,2       
   
    cmp [di],0h   
    jne copiar_buffer1 
  
  pop ax  
  pop si
  pop di  

ret    

copiar_a_buffer:
  push di
  push si
  push ax
  mov cx,0h
  lea si,buffer_copy
  lea di,buffer
  copiar_a_buffer1:    
    inc cx
    
    mov al,[si]
    cmp al,0ah
    je reemplaza_enter
    
    mov [di],al
    
    copiar_a_buffer2:
    add si,1
    add di,2
     
    cmp [si],0h   
    jne copiar_a_buffer1 
  
  pop ax  
  pop si
  pop di  

ret  
  
reemplaza_enter:
mov al,0h
sub di,2
jmp copiar_a_buffer2  
  
leer_nombre_archivo: 
    push di
    push si       
    push ax
    mov di,362d   
    lea si,nombreArchivo
    
    leer_nombre_archivo1: 
       mov al,es:[di]
       mov [si],al
       
       add di,2
       add si,1
       
       cmp es:[di],0h
       jne leer_nombre_archivo1
    pop ax
    pop si
    pop di   
ret      


borrar_archivo:
   mov ah,41h
   mov dx, offset nombreArchivo
   int 21h

ret          

crear_archivo:
    mov ah, 3ch                   ;SERVICIO DE CREACION DE ARCHIVO
    mov cx, 0                     ;MODO DE CREACION NORMAL
    mov dx, offset nombreArchivo  ;NOMBRE DEL ARCHIVO CREADO
    int 21h
    jc error
    ;mov handle, ax 
ret    

vaciar_buffer:
    push cx
    push di      
    lea di,buffer
    vaciar_buffer1:
        mov [di],0h
        inc di
        inc cx
        cmp cx,12000d
        jne vaciar_buffer1
        
    pop di
    pop cx

ret 

vaciar_buffer_copy:
    push cx
    push di      
    lea di,buffer_copy
    vaciar_buffer_copy1:
        mov [di],0h
        inc di
        inc cx
        cmp cx,12000d
        jne vaciar_buffer_copy1
        
    pop di
    pop cx

ret 
   
e1 db "Insert $"      
e2 db "Bloq. Mayus. - $"  
e3 db "Bloq. Num. - $" 
e4 db "Bloq. Despl. - $"
e5 db "Mayus. - $"
e6 db "Mayus. - $"

titulo db " Editor de Texto V2.2 $" 
ayuda db "ayuda.bin",0       
   
 
;DIBUJA VENTANA 
dibujar_ventana: 
;dibujo horizontales
    push cx   
    push ax
    mov cx,1   
    mov bh,0h 
    mov dh,0
    mov dl,0 
    call posicionar_cursor    
    mov al,0c9h  
    call dibujar         
    mov dl,1 
    call posicionar_cursor          
    mov al,0cdh  
    call dibujar_78
    mov dl,79 
    call posicionar_cursor                             
    mov al,0bbh 
    call dibujar     
    mov dh,4
    mov dl,0 
    call posicionar_cursor
    mov al,0cch
    call dibujar
    mov dl,1                   
    call posicionar_cursor
    mov al,0cdh  
    call dibujar_78 
    mov dl,79
    call posicionar_cursor
    mov al,0b9h  
    call dibujar
    mov dh,22
    mov dl,0                   
    call posicionar_cursor
    mov al,0cch  
    call dibujar
    mov dl,1
    call posicionar_cursor 
    mov al,0cdh  
    call dibujar_78 
    mov dl,79
    call posicionar_cursor
    mov al,0b9h  
    call dibujar       
    mov dh,24
    mov dl,0 
    call posicionar_cursor
    mov al,0c8h  
    call dibujar
    mov dl,1
    call posicionar_cursor
    mov al,0cdh  
    call dibujar_78
    mov dl,79
    call posicionar_cursor               
    mov al,0bch 
    call dibujar
;dibujo verticales    
    push di
    mov dh,1
    ggp:
    mov dl,0 
    call posicionar_cursor 
    mov al,0bah
    call dibujar
    mov dl,79 
    call posicionar_cursor
    mov al,0bah
    call dibujar 
    inc dh
    cmp dh,4
    jl ggp  ;menor que 4  
    mov dh,5 
    ggg: 
    mov dl,0 
    call posicionar_cursor         
    mov al,0bah 
    call dibujar
    mov dl,79 
    call posicionar_cursor
    mov al,0bah
    call dibujar
    inc dh
    cmp dh,22
    jl ggg
    inc dh
    mov dl,0 
    call posicionar_cursor          
    mov al,0bah
    call dibujar
    mov dl,79 
    call posicionar_cursor
    mov al,0bah 
    call dibujar
    pop di
    pop ax 
    pop cx
          
ret    
     
dibujar:
    mov ah,0ah
    int 10h
ret 

dibujar_78:
    mov cx,78
    mov ah,0ah 
    int 10h 
    mov cx,1  
ret  

posicionar_cursor:
    mov ah,02h
    int 10h
ret 