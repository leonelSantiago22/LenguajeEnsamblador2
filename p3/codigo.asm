.model small
extrn lee1:near
extrn des2:near
extrn reto:near
.stack
.data
.code
main:   call lee1
        call reto
        mov dl,al 
        call des2
        call reto
        .exit 0

end