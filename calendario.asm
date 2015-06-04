;Se define la funcion macro para imprimir en pantalla
%macro print_Some 2
  	mov edx, %2
    mov ecx, %1
    mov eax, 4
    mov ebx, 1
    int 80h
	%endmacro

section .data

salto_linea db "",0x0A
string_uno db "-y",0
string_dos db "-d",0
tres db 3
pInt db 16
nulo db "Sin argumentos"
lenNulo equ $ - nulo
isYear db "Se pasaron parametros por ano"
lenIsYear equ $ - isYear
isDate db "Se pasaron parametros por fecha"
lenIsDate equ $ - isDate
numb dq 2014
notCol db "Lastimosamente para acceder a nuestro calendario necesitas estar en Colombia"
lenNotCol equ $ - notCol
isCol db "Su timeZone es: "
lenIsCol equ $ - isCol
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,,,,,
ln:	db "",0xa
	lenLn:	equ $-ln		; "$" means "here"
							; len is a value, not an address
	date db __DATE__,0ax, 0xD
	lenDate: equ $-date

	nParams: db "",0xa
	dParam: db "-d",0
	lenD: equ $-dParam
	yParam: db "-y",0
	lenY: equ $-yParam

	array: times 373 db 20
	lenArray: equ $-array
	tArr: db 0,3,2,5,0,3,5,1,4,6,2,4
	header: db "D    L    M    W    J    V    S", 0xa
	lenHeader: equ $-header
	spaceNull: db "     ", 0
	lenSpaceN: equ $-spaceNull
	spaceSimple: db " ",0
	lenSpaceS: equ $-spaceSimple
	spaceDouble: db "  ",0
	lenSpaceD: equ $-spaceDouble
	spaceTriple: db "   ",0
	lenSpaceT: equ $-spaceTriple
	spaceQuad: db "    ",0
	lenSpaceQ: equ $-spaceQuad
	fChar: db "F ", 0
	lenFChar: equ $-fChar

	january: db "Enero",0xa
	lenJanuary: equ $-january
	february: db "Febrero",0xa
	lenFebruary: equ $-february
	march: db "Marzo",0xa
	lenMarch: equ $-march
	april: db "Abril",0xa
	lenApril: equ $-april
	may: db "Mayo",0xa
	lenMay: equ $-may
	june: db "Junio",0xa
	lenJune: equ $-june
	july: db "Julio",0xa
	lenJuly: equ $-july
	august: db "Agosto",0xa
	lenAugust: equ $-august
	september: db "Septiembre",0xa
	lenSeptember: equ $-september
	october: db "Octubre",0xa
	lenOctober: equ $-october
	november: db "Noviembre",0xa
	lenNovember: equ $-november
	december: db "Diciembre",0xa
	lenDecember: equ $-december	



;Se guarda las variables que no se inicializan
section .bss 
arg resb 4
timeZone: resb 8 ; Se reserva una variable con el tamaño de un entero para guardar la zona de colombia = 300
timeStamp: resb 4; se reserva una variable para almacenar el time date = segundos desde el 1 de enero de 1970
digit: resb 16
years: resb 4   ; Reservo un entero para el año
days: resb 4    ; Reservo un entro para los dias
months: resb 4  ; Reservo un entero para los meses
daysLeftMonth: resb 4
isB: resb 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
div4 resd 1
	div100 resd 1
	div400 resd 1
	y resd 1
	m resd 1
	d resd 1
	dayofweek resd 1
	i resd 1
	j resd 1
	a resd 1
	b resd 1
	c resd 1
	e resd 1
	f resd 1
	g resd 1
	h resd 1
	k resd 1
	l resd 1
	n resd 1
	monthOfEaster resd 1
	dayOfEaster resd 1
	last resd 1
	index resd 1
	res resd 1
	lenType resd 1
	lenParam resd 1
	year resd 1
	month resd 1
	day resd 1
	lenPrint resd 1
	type: resb 32
	param: resb 32
        countNil: resd 1

	%macro syscall_exit 0
		mov eax, 01h    ; exit()
		xor ebx, ebx    ; exit code ---- 0=normal
		int 80h					; interrupt 80 hex, call kernel
	%endmacro











;Se utilizara .indicador para saber cuales son indicadores
;Se utilizara _funcion para saber cuales son las funciones
section .text
global _start

_start:

pop eax
mov [nParams], eax       ;Se saca del stack el valor de argc (#de argumentos)
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
  call _saltoLinea
  mov eax, 78             ;Se llama la instruccion del sistema que trae una estructura con la zona horaria getTimeOfday
  mov ebx,timeStamp            ; Se mueve a ebx el timeval de la estructura del llamado al sistema
  mov ecx,timeZone
  int 0x80
  mov eax, [timeZone]       ;Muevo a eax el valor de el timezone
  cmp eax, 300
  jne .isNotCol  
  mov edx,0
  mov eax, [timeStamp]

  mov ecx, 31556926   ; La cantidad de segundos que tiene un año
  div ecx
  add eax, 1970
  mov [years], eax      
  mov [year], eax
  call CalcCalendar
  call holidaysOfYear
  call printCalendar
  jmp .halt


;isYear imprimer en pantalla que se le pasaron argumentos por año
.isYear: 
   ;pop eax
   ;pop eax
   ;pop ebx	
   ;mov [param], ebx
   ;mov edi, ebx
   ;call Length
   ;print_Some ebx, ecx
   ;print_Some ln, lenLn

   ;mov edx, [param]
   ;call _convStringToInt
   ;mov [year], eax
   ;call CalcCalendar
   ;call holidaysOfYear
   ;call printCalendar
    ; jmp .halt
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
   mov eax, [timeZone] 
   mov edi, digit
   call _intToString              ;Si estoy en colombia imprimo el entero
   print_Some isCol, lenIsCol     ;Imprimo el mensaje de su timezone es: 
   print_Some digit, pInt         ;imprimo el entero de la zona horari
   call _saltoLinea               
   jmp .continue


.continue:
   mov edx,0
   mov eax, [timeStamp]
   mov ecx, 31556926   ; La cantidad de segundos que tiene un año
   div ecx
   add eax, 1970
   mov [years], eax
   pop eax
   pop eax
   pop ebx
   mov [param], ebx
   mov edi, ebx
   call Length
   print_Some ebx, ecx
   print_Some ln, lenLn
   mov edx, [param]
   call _convStringToInt
   mov [year], eax
   call CalcCalendar
   call holidaysOfYear
   call printCalendar

;mov edi, digit
;call _intToString
;print_Some digit, pInt
mov eax, edx
xor edx,edx
mov ecx,86400
div ecx
mov [days], eax

 ; EN EAX ESTAN LOS DIAS PASARON DESDE EL 01 ENER ANO ACTUAL

mov esi, 0 ; Contador de mes
mov edi, eax ; Contador para los dias

.dateLoop:

mov edx, 0
mov eax, esi
mov ecx, 7
div ecx

; Modulo 2 del resultado del mes
mov eax, edx
mov edx, 0
mov ecx, 2
div ecx
mov eax, edx

cmp esi, 1 
je .isFeb
cmp eax, 0 ; compara si es par tiene 31 dias el mes
je .isPar ; Si es par se le resta 31 dias
   
mov dword[daysLeftMonth], 30
sub edi, 30 ; Se le restan 30 dias al contador para los dias
jmp .isParEnd

.isPar:
mov dword[daysLeftMonth], 31
sub edi, 31
jmp .isParEnd

; FebNormal le resta 28 dias al contador de dias
.isFeb:
   mov eax, [years]
   call _isB
   mov eax, [isB]
   cmp eax, 1
   je .isFebB ; Salta a febrero bisiesto

   mov dword[daysLeftMonth], 28
   sub edi, 28
   jmp .isParEnd


.isFebB: ; Como es bisiesto se le resta 29 dias.
   mov dword[daysLeftMonth], 29
   sub edi, 29

.isParEnd:
add esi,1 ; Incremento el contador de meses

   ; Comparamos si la fecha es negativa salimos del ciclo
cmp edi, 0
jge .dateLoop ; Si el contandor de dias que falta es mayor que 0 vuelve a hacer el loop
add edi, [daysLeftMonth] ; Sumo dias que se restaron al ultimo mes
mov [days], edi
mov [months], esi

;mov eax, [day]
;mov edi, digit
;call _intToString
;print_Some digit, pInt
;call _saltoLinea
;mov eax, [month]
;mov edi, digit
;call _intToString
;print_Some digit, pInt
;call _saltoLinea
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
    mov   edx, 0
    mov [digit], edx
    ;push 0x0a  ;End of line \n

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


write_digit:
    push eax
    push ebx
	push ecx
	push edx
	mov eax, 4                  ; system call ;4 = sys_write
	mov ebx, 1                  ; file descriptor 1 = stdout
	mov ecx, digit              ; store *address* of digit into ecx
	mov edx, 16                 ; byte size of 16
	int 80h
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

_convStringToInt:
	xor eax, eax ; zero a "result so far"
	.top:
	movzx ecx, byte [edx] ; get a character
	inc edx ; ready for next one
	cmp ecx, '0' ; valid?
	jb .done
	cmp ecx, '9'
	ja .done
	sub ecx, '0' ; "convert" character to number
	imul eax, 10 ; multiply "result so far" by ten
	add eax, ecx ; add in current digit
	jmp .top ; until done
	.done:
	cmp ecx, 0
	ret


strcmp:
	cmp ecx, edx
	jnz .lengths
	; mueve a esi el str1 [eax]
	mov esi, eax
	; mueve a edi el str2 [ebx]
	mov edi, ebx

	; se limpia el flag de direccion de strings
	cld

	; el flag de ZERO se setea si ambos str son iguales o se limpia si no
	repe cmpsb ; va comparando bytes en memoria, hasta el caracter NULL

	jecxz .strcmpSame

	.lengths:
	mov eax, 1 ; movemos 1 a eax, es decir no son iguales
	jmp .strcmpExit ; retorna el resulatado [EAX]

	.strcmpSame:
		mov eax, 0 ; movemos 0 a eax, es decir son iguales

	.strcmpExit:
	  ret

Length:
	sub	ecx, ecx
	sub	al, al
	not	ecx
	cld
	repne	scasb
	not	ecx
	;dec	ecx
	ret

dow:
	;EAX IS STORED Y
	;EBX IS STORED M
	;ECX IS STORED D
	mov [y], eax
	mov [m], ebx
	mov [d], ecx
	;lea esi, [tArr]
	mov eax, [m]
	cmp eax, 3
	jge .return
	mov eax, [y]
	sub eax, 1
	mov [y], eax
	.return:
	xor edx, edx
	mov eax, [y]
	mov ebx, 4
	div ebx
	mov [div4], eax
	xor edx, edx
	mov eax, [y]
	mov ebx, 100
	div ebx
	mov [div100], eax
	xor edx, edx
	mov eax, [y]
	mov ebx, 400
	div ebx
	mov [div400], eax
	mov ebx, [m]
	sub ebx, 1
	mov eax, [y]
	add eax, [div4]
	sub eax, [div100]
	add eax, [div400]
	mov ecx, [d]
	add eax, ecx
	movzx ecx, byte [tArr+ebx]
	add eax, ecx
	;mov eax, [tArr+ebx*4] ;Times position because a doubleword has 4 bytes
	;movzx eax, byte [tArr+ebx] ;Mov a byte from the array to a register
	xor edx, edx
	mov ebx, 7
	div ebx
	mov eax, edx
	;Return in EDX or EAX
	ret



; Calcula si el año es bisiesto
_isB:

mov edx,0
mov eax,[years]
mov ecx, 4
div ecx
cmp edx, 0 ;Comparo si el año es divisible por 4
je .stepTwo
jmp .stepFive

.stepTwo:
mov eax, [years]
mov edx, 0
mov ecx, 100
div ecx
cmp edx, 0 ; Comparo si es divisible por 100
je .stepThree
jmp .stepFour

.stepThree:

mov eax, [years]
mov edx, 0
mov ecx, 400
div ecx
cmp edx, 0 
je .stepFour
jmp .stepFive

;El año es bisiesto y tiene 366 dias
.stepFour:
mov dword[isB], 1 ; 1 si es bisiesto

.stepFive:
mov dword[isB], 0 ; 0 Si no es bisiesto

ret



CalcCalendar:
	;year = []
  ;year << nil
	mov eax, 1
	mov [index], eax
	mov eax, [year]
	mov ebx, 1
	mov ecx, 1

	call dow
	mov [dayofweek], edx

	mov ecx, 0
	mov [i], ecx
	.fori:
	mov ecx, [i]
	inc ecx
	mov [i], ecx
	cmp ecx, 12
	jg .exitFori
	mov ebx, 0
	mov [j], ebx
	.forj:
	mov ebx, [j]
	inc ebx
	mov [j], ebx
	cmp ebx, 31
	jg .exitForj

	;_If gigant
	mov eax, [i]
	cmp eax, 1
	jz .entry
	mov eax, [i]
	cmp eax, 3
	jz .entry
	mov eax, [i]
	cmp eax, 5
	jz .entry
	mov eax, [i]
	cmp eax, 7
	jz .entry
	mov eax, [i]
	cmp eax, 8
	jz .entry
	mov eax, [i]
	cmp eax, 10
	jz .entry
	mov eax, [i]
	cmp eax, 12
	jz .entry
	jmp .else

	.entry:
	mov ebx, [index]
	;mov al, 5
	mov al, [dayofweek]
	mov [array+ebx], al
	inc ebx
	mov [index], ebx
	mov eax, [dayofweek]
	add eax, 1
	mov ecx, 7
	xor edx, edx
	div ecx
	mov [dayofweek], edx

	jmp .otherIf

	.else:
	mov eax, [i]
	cmp eax, 2
	jnz .exitIf1
	mov eax, [j]
	cmp eax, 28
	jg .exitIf2
	mov ebx, [index]
	mov al, [dayofweek]
	mov [array+ebx], al
	inc ebx
	mov [index], ebx
	mov eax, [dayofweek]
	add eax, 1
	mov ecx, 7
	xor edx, edx
	div ecx
	mov [dayofweek], edx

	.exitIf2:
	mov eax, [year]
	mov ecx, 4
	xor edx, edx
	div ecx
	mov eax, edx
	cmp eax, 0
	jnz .else2
	mov eax, [year]
	mov ecx, 100
	xor edx, edx
	div ecx
	mov eax, edx
	cmp eax, 0
	jz .otherWay
	jmp .entry2

	.otherWay:
	mov eax, [year]
	mov ecx, 400
	xor edx, edx
	div ecx
	mov eax, edx
	cmp eax, 0
	jnz .else2

	.entry2:
	mov eax, [j]
	cmp eax, 29
	jnz .exitIf3
	mov ebx, [index]
	mov al, [dayofweek]
	mov [array+ebx], al
	inc ebx
	mov [index], ebx
	mov eax, [dayofweek]
	add eax, 1
	mov ecx, 7
	xor edx, edx
	div ecx
	mov [dayofweek], edx

	.exitIf3:
	mov eax, [j]
	cmp eax, 30
	jz .entry3
	mov eax, [j]
	cmp eax, 31
	jnz .exitElse2

	.entry3:
	mov eax, [index]
	inc eax
	mov [index], eax
	jmp .exitElse2

	.else2:
	mov eax, [j]
	cmp eax, 29
	jz .entry4
	mov eax, [j]
	cmp eax, 30
	jz .entry4
	mov eax, [j]
	cmp eax, 31
	jnz .exitElse2

	.entry4:
	mov eax, [index]
	inc eax
	mov [index], eax

	.exitElse2:

	.exitIf1:

	.otherIf:
	mov eax, [i]
	cmp eax, 4
	jz .entry5
	mov eax, [i]
	cmp eax, 6
	jz .entry5
	mov eax, [i]
	cmp eax, 11
	jz .entry5
	mov eax, [i]
	cmp eax, 9
	jz .entry5
	jmp .exitIf4

	.entry5:
	mov eax, [j]
	cmp eax, 30
	jg .else3
	mov ebx, [index]
	mov al, [dayofweek]
	mov [array+ebx], al
	inc ebx
	mov [index], ebx
	mov eax, [dayofweek]
	add eax, 1
	mov ecx, 7
	xor edx, edx
	div ecx
	mov [dayofweek], edx
	jmp .exitIf4

	.else3:
	mov ebx, [index]
	inc ebx
	mov [index], ebx

	.exitIf4:
	jmp .forj

	.exitForj:
	jmp .fori

	.exitFori:
	ret

printArray:
	mov ebx, 0
	mov [index], ebx
	.for:
	mov ebx, [index]
	cmp ebx, lenArray
	jge .exitFor
	movzx eax, byte[array+ebx]
	mov edi, digit
	call _intToString
	call write_digit
	inc ebx
	mov [index], ebx
	jmp .for
	.exitFor:
	ret

holidaysOfYear:
;1 de enero - Año Nuevo
;Jueves Santo
;Viernes Santo
;1 de mayo – Día del Trabajo
;20 de julio – Independencia Nacional 7 de agosto – Batalla de Boyacá
;8 de diciembre - Inmaculada Concepción 25 de diciembre - Navidad

; 1 de enero
mov ebx, 1
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[1] *= -1

;1 de mayo
mov ebx, 125     ;4*31+1
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[4*31 + 1] *= -1

;20 de julio
mov ebx, 206     ;6*31+20
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[6*31 + 20] *= -1

;8 de diciembre
mov ebx, 349     ;11*31+8
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[11*31 + 8] *= -1

;7 de agosto
mov ebx, 224     ;7*31+7
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[7*31 + 7] *= -1

;25 de diciembre
mov ebx, 366     ;11*31+25
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[11*31 + 25] *= -1

; 6 de enero - Epifanía del Señor
; 19 de marzo - Día de San José
; !!Ascensión del Señor (Sexto domingo después de Pascua)
; !!Corpus Christi (Octavo domingo después de Pascua)
; !!Sagrado Corazón de Jesús (Noveno domingo después de Pascua)
; !!jueves y viernes santo (semana anterior a pascua)
; 29 de Junio San Pedro y San Pablo
; 15 de agosto - Asunción de la Virgen!
; 12 de octubre - Día de la Raza
; 1 de noviembre - Todos los Santos
; 11 de noviembre - Independencia de Cartagena.

; ;6 de enero
mov eax, 8
movzx ebx, byte[array+6]
sub eax, ebx
mov ecx, 7
xor edx, edx
div ecx
mov eax, edx
add eax, 6
mov ebx, eax
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[((7 - y[6] + 1) % 7) + (6)] *= -1

; ;19 de marzo
mov eax, 8
movzx ebx, byte[array+81]
sub eax, ebx
mov ecx, 7
xor edx, edx
div ecx
mov eax, edx
add eax, 81
mov ebx, eax
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[((7 - y[2*31 + 19] + 1) % 7) + (2*31 + 19)] *= -1


; ;29 de Junio
mov eax, 9
movzx ebx, byte[array+184]
sub eax, ebx
mov ecx, 8
xor edx, edx
div ecx
mov eax, edx
add eax, 184
mov ebx, eax
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[((7 - y[5*31 + 29] + 1) % 7) + (5*31 + 29)] *= -1

; ;15 de agosto
mov eax, 8
movzx ebx, byte[array+232]
sub eax, ebx
mov ecx, 7
xor edx, edx
div ecx
mov eax, edx
add eax, 232
mov ebx, eax
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[((7 - y[7*31 + 15] + 1) % 7) + (7*31 + 15)] *= -1

; ;12 de octubre
mov eax, 8
movzx ebx, byte[array+291]
sub eax, ebx
mov ecx, 7
xor edx, edx
div ecx
mov eax, edx
add eax, 291
mov ebx, eax
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[((7 - y[9*31 + 12] + 1) % 7) + (9*31 + 12)] *= -1

; ;1 de noviembre
mov eax, 8
movzx ebx, byte[array+311]
sub eax, ebx
mov ecx, 7
xor edx, edx
div ecx
mov eax, edx
add eax, 311
mov ebx, eax
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[((7 - y[10*31 + 1] + 1) % 7) + (10*31 + 1)] *= -1

; ;11 de noviembre
mov eax, 8
movzx ebx, byte[array+321]
sub eax, ebx
mov ecx, 7
xor edx, edx
div ecx
mov eax, edx
add eax, 321
mov ebx, eax
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[((7 - y[10*31 + 11] + 1) % 7) + (10*31 + 11)] *= -1

; ;Calculo del domingo de pascua
;a = anio % 19
mov eax, [year]
mov ebx, 19
xor edx, edx
div ebx
mov [a], edx
;b = anio / 100
mov eax, [year]
mov ebx, 100
xor edx, edx
div ebx
mov [b], eax
;c = anio % 100
mov eax, [year]
mov ebx, 100
xor edx, edx
div ebx
mov [c], edx
;d = b / 4
mov eax, [b]
mov ebx, 4
xor edx, edx
div ebx
mov [d], eax
;e = b % 4
mov eax, [b]
mov ebx, 4
xor edx, edx
div ebx
mov [e], edx
;f = (b + 8) / 25
mov eax, [b]
add eax, 8
mov ebx, 25
xor edx, edx
div ebx
mov [f], eax
;g = (b - f + 1) / 3
mov eax, [b]
inc eax
sub eax, [f]
mov ebx, 3
xor edx, edx
div ebx
mov [g], eax
;h = (19*a + b - d - g + 15) % 30
mov eax, [a]
mov ebx, 19
mul ebx
add eax, [b]
sub eax, [d]
sub eax, [g]
add eax, 15
mov ebx, 30
xor edx, edx
div ebx
mov [h], edx
;i = c / 4
mov eax, [c]
mov ebx, 4
xor edx, edx
div ebx
mov [i], eax
;k = c % 4
mov eax, [c]
mov ebx, 4
xor edx, edx
div ebx
mov [k], edx
;l = (32 + 2*e + 2*i - h - k) % 7
mov eax, [e]
mov ebx, 2
mul ebx
add eax, 32
mov ecx, eax
mov eax, [i]
mov ebx, 2
mul ebx
add eax, ecx
sub eax, [h]
sub eax, [k]
mov ebx, 7
xor edx, edx
div ebx
mov [l], edx
;m = (a + 11*h + 22* l) / 451
mov eax, [h]
mov ebx, 11
mul ebx
add eax, [a]
mov ecx, eax
mov eax, [l]
mov ebx, 22
mul ebx
add eax, ecx
mov ebx, 451
xor edx, edx
div ebx
mov [m], eax
;n = h + l - 7*m + 144
mov eax, [m]
mov ebx, 7
mul ebx
mov ecx, eax
mov eax, [h]
add eax, [l]
sub eax, ecx
add eax, 144
mov [n], eax
;monthOfEaster = n / 31
mov eax, [n]
mov ebx, 31
xor edx, edx
div ebx
dec eax
mov [monthOfEaster], eax
;dayOfEaster = 1 + (n % 31)
mov eax, [n]
mov ebx, 31
xor edx, edx
div ebx
mov eax, edx
add eax, 2
mov [dayOfEaster], eax
;monthOfEaster -= 1
;dayOfEaster += 1

;y[(monthOfEaster - 1)*31 + dayOfEaster - 2] *= -1 ;viernes santo
mov eax, [monthOfEaster]
dec eax
mov ebx, 31
mul ebx
mov ecx, eax
mov eax, [dayOfEaster]
sub eax, 2
add eax, ecx
mov ebx, eax
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[(monthOfEaster - 1)*31 + dayOfEaster - 3] *= -1 ; jueves santo
mov eax, [monthOfEaster]
dec eax
mov ebx, 31
mul ebx
mov ecx, eax
mov eax, [dayOfEaster]
sub eax, 3
add eax, ecx
mov ebx, eax
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al

;dia de la ascencion
	mov eax, [monthOfEaster]
	dec eax
	mov ebx, 31
	mul ebx
	mov ecx, eax
	mov eax, [dayOfEaster]
	add eax, 42
	add eax, ecx
	mov [index], eax
	movzx eax, byte[array+eax]
	mov ebx, 7
	sub ebx, eax
	inc ebx
	mov eax, ebx
	mov ecx, 7
	xor edx, edx
	div ecx
	mov ebx, edx
	add ebx, [index]
	movzx eax, byte[array+ebx]
	mov ecx, 10
	add eax, ecx
	mov [res], eax
	mov al, [res]
	mov [array+ebx], al

	;y[((7 - y[(monthOfEaster - 1)*31 + dayOfEaster + 42] + 1) % 7) + ((monthOfEaster - 1)*31 + dayOfEaster + 42)] *= -1

	;corpus Christi
	mov eax, [monthOfEaster]
	dec eax
	mov ebx, 31
	mul ebx
	mov ecx, eax
	mov eax, [dayOfEaster]
	add eax, 63
	add eax, ecx
	mov [index], eax
	movzx eax, byte[array+eax]
	mov ebx, 7
	sub ebx, eax
	inc ebx
	mov eax, ebx
	mov ecx, 7
	xor edx, edx
	div ecx
	mov ebx, edx
	add ebx, [index]
	movzx eax, byte[array+ebx]
	mov ecx, 10
	add eax, ecx
	mov [res], eax
	mov al, [res]
	mov [array+ebx], al
	;y[((7 - y[(monthOfEaster - 1)*31 + dayOfEaster + 63] + 1) % 7) + ((monthOfEaster - 1)*31 + dayOfEaster + 63)] *= -1
;;SAgrado corazoncito

;sagrado corazon
mov eax, [monthOfEaster]
dec eax
mov ebx, 31
mul ebx
mov ecx, eax
mov eax, [dayOfEaster]
add eax, 70
add eax, ecx
mov [index], eax
movzx eax, byte[array+eax]
mov ebx, 7
sub ebx, eax
inc ebx
mov eax, ebx
mov ecx, 7
xor edx, edx
div ecx
mov ebx, edx
add ebx, [index]
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[((7 - y[(monthOfEaster - 1)*31 + dayOfEaster + 70] + 1) % 7) + ((monthOfEaster - 1)*31 + dayOfEaster + 70)] *= -1

ret

printCalendar:
	mov eax, 0
	mov [dayofweek], eax
;	resetRow
	mov ebx, 0
	mov [index], ebx
	mov ecx, 0
	mov [i], ecx
	.forMonths:
	mov ecx, [i]
	inc ecx
	mov [i], ecx
	cmp ecx, 12
	jg .exitForMonths
	cmp ecx, 1
	jnz .next1
	print_Some january, lenJanuary
	jmp .format
	.next1:
	cmp ecx, 2
	jnz .next2
	print_Some february, lenFebruary
	jmp .format
	.next2:
	cmp ecx, 3
	jnz .next3
	print_Some march, lenMarch
	jmp .format
	.next3:
	cmp ecx, 4
	jnz .next4
	print_Some april, lenApril
	jmp .format
	.next4:
	cmp ecx, 5
	jnz .next5
	print_Some may, lenMay
	jmp .format
	.next5:
	cmp ecx, 6
	jnz .next6
	print_Some june, lenJune
	jmp .format
	.next6:
	cmp ecx, 7
	jnz .next7
	print_Some july, lenJuly
	jmp .format
	.next7:
	cmp ecx, 8
	jnz .next8
	print_Some august, lenAugust
	jmp .format
	.next8:
	cmp ecx, 9
	jnz .next9
	print_Some september, lenSeptember
	jmp .format
	.next9:
	cmp ecx, 10
	jnz .next10
	print_Some october, lenOctober
	jmp .format
	.next10:
	cmp ecx, 11
	jnz .next11
	print_Some november, lenNovember
	jmp .format
	.next11:
	cmp ecx, 12
	jnz .forMonths
	print_Some december, lenDecember

	.format:
	print_Some header, lenHeader
	mov ebx, 1
	mov [j], ebx
	.whilej:
	mov ebx, [j]
	cmp ebx, 31
	jg .exitWhilej
	mov eax, [i]
	dec eax
	mov ecx, 31
	mul ecx
	add eax, [j]
	mov [res], eax
	mov ebx, [res]
	movzx eax, byte[array+ebx]
	cmp eax, 20
	jz .elseNull
	mov ebx, [res]
	movzx eax, byte[array+ebx]
	mov ecx, 10
	xor edx, edx
	div ecx
	mov eax, edx
	cmp eax, [dayofweek]
	jnz .elseNoHoly
	mov ebx, [res]
	movzx eax, byte[array+ebx]
	cmp eax, 0
	jz .isHoly
	mov ebx, [res]
	movzx eax, byte[array+ebx]
	cmp eax, 10
	jb .isNormal

	.isHoly:
	print_Some fChar, lenFChar
	mov eax, [j]
	mov [last], eax
	cmp eax, 10
	jb .addSpaceHoly
	mov edi, digit
	call _intToString
	call write_digit
	print_Some spaceSimple, lenSpaceS
	.contine2:
	mov ebx, [index]
	inc ebx
	mov [index], ebx
	jmp .continue

	.addSpaceHoly:
	mov eax, [j]
	mov edi, digit
	call _intToString
	call write_digit
	print_Some spaceDouble, lenSpaceD
	jmp .contine2

	.isNormal:
	mov ebx, [res]
	movzx eax, byte[array+ebx]
	cmp eax, 0
	jbe .continue
	mov eax, [j]
	mov [last], eax
	cmp eax, 10
	jb .addSpaceNormal
	mov edi, digit
	call _intToString
	call write_digit
	print_Some spaceTriple, lenSpaceT
	.continue3:
	mov ebx, [index]
	inc ebx
	mov [index], ebx

	.continue:
	mov eax, [dayofweek]
	inc eax
	mov ecx, 7
	xor edx, edx
	div ecx
	mov [dayofweek], edx
	mov ebx, [j]
	inc ebx
	mov [j], ebx
	jmp .newRow

	.addSpaceNormal:
	mov eax, [j]
	mov edi, digit
	call _intToString
	call write_digit
	print_Some spaceQuad, lenSpaceQ
	jmp .continue3

	.elseNoHoly:
		print_Some spaceNull, lenSpaceN
		mov eax, -1
		mov [last], eax
		mov ebx, [index]
		inc ebx
		mov [index], ebx
		mov eax, [dayofweek]
		inc eax
		mov ecx, 7
		xor edx, edx
		div ecx
		mov [dayofweek], edx

		.newRow:
		mov eax, [index]
		cmp eax, 7
		jz .newLine
		mov ebx, [last]
		cmp ebx, 31
		jz .newLine
		;row[row.count - 1] == 31
		jmp .exitElseNull

		.newLine:
		print_Some ln, lenLn
		mov ebx, 0
		mov [dayofweek], ebx
		mov [index], ebx
		jmp .exitElseNull

		.elseNull:
		print_Some ln, lenLn
		mov ebx, 0
		mov [dayofweek], ebx
		mov [index], ebx
		mov ecx, 32
		mov [j], ecx

		.exitElseNull:
		jmp .whilej

		.exitWhilej:
		print_Some ln, lenLn
		print_Some ln, lenLn
		mov ebx, 0
		mov [index], ebx

		jmp .forMonths

		.exitForMonths:
		ret

Error:

Exit:
	syscall_exit
