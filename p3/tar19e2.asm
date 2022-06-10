.model small
    extrn leeflo:near
    extrn desflo:near
    extrn reto:near
.386
.387
.stack
.data
    grados dd 180
.code
;fcos calcula el coseno del valor en %st(0) en radianes, guarda el resultado en st(0)
main:   mov ax,@data
        mov ds,ax 
        finit
        call leeflo ;magnitud
        call leeflo ;grados magnitud
        fldpi       ;pi grados magnitus
        fild grados ;180 pi grado magnitud
        fdiv        ;pi/180 grado magnitud
        fmul        ;grado*(pi/180) magnitud
        fsincos        ;sin (teta) cos(grado*(pi/180)) magnitud
        ;fwait       
        fld st(2)   ;magnitud sin(teta) cos(teta) magnitus
        fmul        ;magnitud*sin(teta)
        call desflo ;y cos(teta) magnitus
        fxch st(2)  ;magnitud cos(teta) y
        fmul        
        call reto
        call desflo
        fmul       ;
        ;solo esto para x 
        .exit 0
end 

;magnitud grados pi 180 / * cos *
;x = magnitus cos(teta) ejemplo x= 30*cos(47) = 20.45
;y = magnitud sen(teta) ejemplo y = 30*sen(teta) = 21.94