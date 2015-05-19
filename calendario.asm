section .data

msg1 db __UTC_TIME__ ,0xA,0xD ; Este el es que coge la hora global 
len1 equ $ - msg1 ; Este es el que coge la longitud del msg1
msg2 db __TIME__ ,0xA,0xD ; Este el es que coge la hora del computador 
len2 equ $ - msg2 ; Este es el que coge la longitud del msg2
salto_linea db 0x0A
string_uno db "-y",0
string_dos db "-d",0
tres db 3
nulo db "SinArgumentos"
lenNulo equ $ - nulo
isYear db "Se pasaron parametros por ano"
lenIsYear equ $ - isYear
isDate db "Se pasaron parametros por fecha"
lenIsDate equ $ - isDate
section .bss ; Se guarda las variables que no se inician
arg resb 4

section .text
global _start

_start:

;_timeZone:
;mov eax, 4
;mov ebx, 1
;mov ecx, msg1
;mov edx, len1
;int 0x80

;mov eax, 4
;mov ebx, 1
;mov ecx, msg2
;mov edx, len2
;int 0x80

;mov eax, 4
;mov ebx, 1
;mov ecx, msg1
;mov edx, 2
;int 0x80

; aca empieza lo demas
pop eax
cmp eax,1
je .nulo
mov eax, [esp + 4]
mov ebx, string_uno
mov ecx, 3
mov edx, 3
call _stringCompare
cmp eax,0
je .isYear
mov eax, [esp + 4]
mov ebx, string_dos
mov ecx, 3
mov edx, 3
call _stringCompare
cmp eax,0
je .isDate
jmp .halt
.nulo:
  mov eax, 4
  mov ebx, 1
  mov ecx, nulo
  mov edx, lenNulo
  int 0x80
  jmp .halt


.isYear: 
   mov eax, 4
   mov ebx, 1
   mov ecx, isYear
   mov edx, lenIsYear
   int 0x80
   jmp .halt

.isDate:
   mov eax, 4
   mov ebx, 1
   mov ecx, isDate
   mov edx, lenIsDate
   int 0x80
   jmp .halt

.halt:
 mov eax, 1
 mov ebx, 0
 int 0x80

;_miFuncion:
;   _reiniciarContador:
;     mov ecx, -1

;   _buscarLongitud:
;     inc ecx
;     cmp byte[eax + ecx],0
;     jne _buscarLongitud
     
;   _imprimir:
;     mov edx, ecx
 ;    mov ecx, eax
;     mov eax, 4
;     mov ebx, 1 
;     int 0x80
;     mov eax, 4
;     mov ebx, 1
;     mov ecx, salto_linea
;     mov edx, 1 
;     int 0x80 
;ret
 
; Compara dos Strings haciendo uso de los llamados ESI:EDI del 
; procesador que permiten la operacion con strings en memoria
; (cmpsb) o (cmosw para comparar de a 2 bytes)
;
; Parametros:
;   EAX => char * [Direccion SRC]
;   EBX => char * [Direccion DES]
;   ECX => int [Length SRC]
;   EDX => int [Length DES]
;
; Retorno:
;   EAX => 0 si son iguales; 1 si no son iguales
;
_stringCompare:
    ; mueve a esi el str1 [eax]
    mov esi, eax
    ; mueve a edi el str2 [ebx]
    mov edi, ebx

    ; se limpia el flag de direccion de strings
    cld
    
    ; el flag de ZERO se setea si ambos str son iguales o se limpia si no 
    repe cmpsb ; va comparando bytes en memoria, hasta el caracter NULL
    
    jecxz .stringCompareDifferent

    mov eax, 1 ; movemos 1 a eax, es decir son iguales
    jmp .stringCompareExit ; retorna el resulatado [EAX]

.stringCompareDifferent:
    mov eax, 0 ; movemos 0 a eax, es decir no son iguales

.stringCompareExit:
    ret







