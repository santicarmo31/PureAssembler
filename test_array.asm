section .data
global meses
salto_linea db 0x0A
meses:
  db "Ene"
  db "Feb"
  db "Mar"
  db "Abr"
  db "May"
  db "Jun"
  db "Jul"
  db "Ago"
  db "Sep"
  db "Oct"
  db "Nov"
  db "Dic"

section .bss ; Se guarda las variables que no se inician

argumento: resb 15
argumento2: resb 15

section .text
global _start

_start:

pop eax
pop eax
pop eax
mov [argumento],eax
call _miFuncion
 mov eax, 1
 mov ebx, 0
 int 0x80
_miFuncion:
   _reiniciarContador:
     mov ecx, -1

   _buscarLongitud:
     inc ecx
     cmp byte[eax + ecx],0
     jne _buscarLongitud
     
   _imprimir:
     mov edx, ecx
     mov ecx, eax
     mov eax, 4
     mov ebx, 1 
     int 0x80
     mov eax, 4
     mov ebx, 1
     mov ecx, salto_linea
     mov edx, 1 
     int 0x80 
ret 
   







