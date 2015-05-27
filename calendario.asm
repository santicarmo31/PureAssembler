;Se define la funcion macro para imprimir en pantalla
%macro print_Some 2 
  mov eax, 4
  mov ebx, 1
  mov ecx, %1
  mov edx, %2
  int 0x80
%endmacro

section .data

salto_linea db "",0x0A
string_uno db "-y",0
string_dos db "-d",0
tres db 3
pInt db 16
nulo db "SinArgumentos"
lenNulo equ $ - nulo
isYear db "Se pasaron parametros por ano"
lenIsYear equ $ - isYear
isDate db "Se pasaron parametros por fecha"
lenIsDate equ $ - isDate
numb: dq 2014
notCol db "Lastimosamente para acceder a nuestro calendario necesitas estar en Colombia"
lenNotCol equ $ - notCol
isCol db "Su timeZone es: "
lenIsCol equ $ - isCol



;Se guarda las variables que no se inicializan
section .bss 
arg resb 4
timeZone: resb 4 ; Se reserva una variable con el tamaño de un entero para guardar la zona de colombia = 300
timeStamp: resb 8; se reserva una variable para almacenar el time date = segundos desde el 1 de enero de 1970
digit: resb 16

;Se utilizara .indicador para saber cuales son indicadores
;Se utilizara _funcion para saber cuales son las funciones
section .text
global _start

_start:

pop eax                  ;Se saca del stack el valor de argc (#de argumentos)
cmp eax,1                ;Se compara si el numero de argumentos es > 1
je .nulo                 ;Si viene sin argumentos sal al indicador .nulo
mov eax, [esp + 4]       ;Muevo el Stack pointer para acceder al primer argumento
mov ebx, string_uno
mov ecx, 3
mov edx, 3
call _stringCompare      ;Llamo a la funcio para saber si el argumento que me pasaron es -y
cmp eax,0                ;Si la funcion retorna 0 entonces salta al indicador para imprimir-
je .isYear               ;-que se pasaron argumentos por año 
mov eax, [esp + 4]       ;Vuelvo a setear los parametros de la funcion _stringcompare para-
mov ebx, string_dos      ;-comparar el mismo primer argumento si es -d
mov ecx, 3
mov edx, 3
call _stringCompare
cmp eax,0                ;Si da 0 quiere decir que se paso el argumento por -d y deberia imprimir-
je .isDate


               ;-que se le paso el argumento por date
jmp .halt

;.nulo termina el programa pues no se le pasaron argumentos
.nulo:
  mov eax, 4
  mov ebx, 1
  mov ecx, nulo
  mov edx, lenNulo
  int 0x80
  jmp .halt

;isYear imprimer en pantalla que se le pasaron argumentos por año
.isYear: 
   print_Some isYear, lenIsYear
   call _saltoLinea             
   jmp .isCol

;isDate imprime en pnatalla que se le pasaron argumentos por fecha
.isDate:
   print_Some isDate, lenIsDate
   call _saltoLinea               ;Llama la funcion del salto de linea
   jmp .isCol

;Determina si la zona horaria es de colombia
.isCol:

   call _getTime             ;Llamo a la funcion para setear el timezone de mi laptop
   mov eax, [timeZone]       ;Muevo a eax el valor de el timezone
   cmp eax, 300                
   jne .isNotCol                  ;Me interrumpe la ejecucion del programa pues no estoy en colombia
   mov eax, dword[timeZone] 
   mov edi, digit
   call _intToString              ;Si estoy en colombia imprimo el entero
   print_Some isCol, lenIsCol     ;Imprimo el mensaje de su timezone es: 
   print_Some digit, pInt         ;imprimo el entero de la zona horari
   call _saltoLinea               
   jmp .halt

;no esta en colombia
.isNotCol:
  mov eax, 4
  mov ebx, 1
  mov ecx, nulo
  mov edx, lenNulo
  int 0x80
  jmp .halt


;Termina la ejecucion.
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


;Realiza un salto de linea
_saltoLinea:

    mov eax,4
    mov ebx,1
    mov ecx,salto_linea
    mov edx,1
    int 0x80
ret

;Obtiene el timeZone
_getTime:
    mov eax, 78             ;Se llama la instruccion del sistema que trae una estructura con la zona horaria getTimeOfday
    mov ebx,timeStamp            ; Se mueve a ebx el timeval de la estructura del llamado al sistema
    mov ecx,timeZone
    int 0x80

;Imprime un entero

_intToString:
    push  edx
    push  ecx
    push  edi
    push  ebp
    mov   ebp, esp
    mov   ecx, 10
    push 0x0a  ;End of line \n

 .pushDigits:
    xor   edx, edx        ; zero-extend eax
    div   ecx             ; divide by 10; now edx = next digit
    add   edx, 30h        ; decimal value + 30h => ascii digit
    push  edx             ; push the whole dword, cause that's how x86 rolls
    test  eax, eax        ; leading zeros suck
    jnz   .pushDigits

 .popDigits:
    pop   eax
    stosb                 ; don't write the whole dword, just the low byte
    cmp   esp, ebp        ; if esp==ebp, we've popped all the digits
    jne   .popDigits

    xor   eax, eax        ; add trailing nul
    stosb

    mov   eax, edi
    pop   ebp
    pop   edi
    pop   ecx
    pop   edx
    sub   eax, edi        ; return number of bytes written
    ret


_write_digit:
mov             eax, 4                  ; system call #4 = sys_write
mov             ebx, 1                  ; file descriptor 1 = stdout
mov             ecx, digit              ; store *address* of digit into ecx
mov             edx, 16                 ; byte size of 16
int             80h
ret


