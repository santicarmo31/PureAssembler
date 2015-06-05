;Se define la funcion macro para imprimir en pantalla
%macro print_Some 2
  	mov edx, %2
    mov ecx, %1
    mov eax, 4
    mov ebx, 1
    int 80h 			;Se hace el llamado al sistema (Linux)
	%endmacro

;En esta seccion se definen las variables constantes que se utilizaran a lo largo de la practica
;db carga en memoria una serie de bytes y les asigna un valor
section .data

salto_linea db "",0x0A    ;salto_linea se utiliza para llamar un salto de linea ;0Ah es un LF en ASCII
string_uno db "-y",0 	  ;string_uno se le asigna -y como parametro para anos
string_dos db "-d",0 	  ;string_dos se le asigna -d como parametro para dias
tres db 3  				
pInt db 16 				  ;pInt es la longitud a la hora de convertir los enteros
nulo db "Sin argumentos"  ;Se utiliza para imprimir el mensaje cuando solo se le pasa el argumento calendar
lenNulo equ $-nulo        ;lenNulo es la longitud de la variable nulo
esAno db "Se pasaron parametros por ano"   ;Se utiliza para imprimir el mensaje cuando se le pasa el argumento calendar -y
lenEsAno equ $-esAno 			;lenEsAno es la longitud de la variable esAno
esFecha db "Se pasaron parametros por fecha" ;Se utiliza para imprimir el mensaje cuando se le pasa el argumento calendar -d
lenEsFecha equ $-esFecha 	;lenEsFecha es la longitud de la variable esFecha
numb dq 2014
noCol db "Lastimosamente para acceder a nuestro calendario necesitas estar en Colombia"
lenNoCol equ $-noCol 						;lenNoCol es la longitud de la variable noCol
esCol db "Su timeZone es: "			;Se utiliza para imprimir el mensaje del timeZone donde estamos (Colombia)
lenEsCol equ $-esCol 						;lenEsCol es la longitud de la variable esCol
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ln:	db "",0xa
	lenLn:	equ $-ln		   	;"$" means "here" ;len es un valor, no una direccion
	date db __DATE__,0ax, 0xD  	;date es la variable que captura la fecha
	lenDate: equ $-date 	   	  ;lenDate es la longitud de la variable date

	nParams: db "",0xa  	  ;nParams es el numero de parametros
	dParam: db "-d",0 			;dParam es el parametro para la fecha (-d)
	lenD: equ $-dParam 			;lenD es la longitud del parametro -d
	yParam: db "-y",0 			;yParam es el parametro para el ano (-y)
	lenY: equ $-yParam 			;lenY es la longitud del parametro -y

	array: times 373 db 20
	lenArray: equ $-array
	tArr: db 0,3,2,5,0,3,5,1,4,6,2,4  					        ;Tamano del arreglo
	cabecera: db "D    L    M    M    J    V    S", 0xa ;Dias de la semana por sus iniciales
	lenCabecera: equ $-cabecera
	espacioNulo: db "     ", 0 							;Espacio nulo para la impresion del calendario
	lenEspacioN: equ $-espacioNulo
	espacioSimple: db " ", 0  							;Espacio simple para la impresion del calendario
	lenEspacioS: equ $-espacioSimple
	espacioDoble: db "  ", 0 							  ;Espacio doble para la impresion del calendario
	lenEspacioD: equ $-espacioDoble
	espacioTriple: db "   ", 0 							;Espacio triple para la impresion del calendario
	lenEspacioT: equ $-espacioTriple
	espacioCuad: db "    ", 0 							;Espacio cuadru para la impresion del calendario
	lenEspacioC: equ $-espacioCuad
	caracterF: db "F ", 0 									;Caracter F para indicar si es Festivo o no
	lenCaracterF: equ $-caracterF

	enero: db "Enero",0xa  								  ;Declaracion del mes Enero
	lenEnero: equ $-enero 							
	febrero: db "Febrero",0xa 							;Declaracion del mes Febrero
	lenFebrero: equ $-febrero
	marzo: db "Marzo",0xa 								  ;Declaracion del mes Marzo
	lenMarzo: equ $-marzo
	abril: db "Abril",0xa 								  ;Declaracion del mes Abril
	lenAbril: equ $-abril
	mayo: db "Mayo",0xa 								    ;Declaracion del mes Mayo
	lenMayo: equ $-mayo
	junio: db "Junio",0xa 								  ;Declaracion del mes Junio
	lenJunio: equ $-junio
	julio: db "Julio",0xa 								  ;Declaracion del mes Julio
	lenJulio: equ $-julio
	agosto: db "Agosto",0xa 							  ;Declaracion del mes Agosto
	lenAgosto: equ $-agosto
	septiembre: db "Septiembre",0xa 			  ;Declaracion del mes Septiembre
	lenSeptiembre: equ $-septiembre
	octubre: db "Octubre",0xa 							;Declaracion del mes Octubre
	lenOctubre: equ $-octubre
	noviembre: db "Noviembre",0xa 					;Declaracion del mes Noviembre
	lenNoviembre: equ $-noviembre
	diciembre: db "Diciembre",0xa 					;Declaracion del mes Diciembre
	lenDiciembre: equ $-diciembre	

;Se guarda las variables que no se inicializan
section .bss 

arg resb 4
timeZone: resb 8  ;Se reserva una variable con el tamaño de un entero para guardar el timeZone de colombia = 300
timeStamp: resb 4 ;Se reserva una variable para almacenar el time date = segundos desde el 1 de enero de 1970
digito: resb 16 
anos: resb 4     		    ;Reservo un entero para el ano
meses: resb 4           ;Reservo un entero para los meses
dias: resb 4      		  ;Reservo un entero para los dias
diasFaltanMes: resb 4  	;Reservo un entero para los dias que faltan
esB: resb 4 			      ;Reservo un entero para los Bisiestos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
div4 resd 1 			;resd para reservar palabras dobles
div100 resd 1
div400 resd 1
y resd 1 				
m resd 1 				
d resd 1 				
diaDeLaSemana resd 1 	;dia de la semana
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
mesDePascua resd 1 	;mes de Pascua
diaDePascua resd 1 	;dia de Pascua
ultimo resd 1
indice resd 1
res resd 1
lenType resd 1
lenParam resd 1
ano resd 1 			    ;ano
mes resd 1 			    ;mes
dia resd 1 				  ;dia
lenPrint resd 1 		
type: resb 32 			;tipo
param: resb 32 			;parametro
countNil: resd 1

;Se define la funcion macro para llamar a la salida del sistema
	%macro syscall_exit 0
		mov eax, 01h    ;exit()
		xor ebx, ebx    ;exit code ---- 0=normal
		int 80h			;llamada a la interrupccion del sistema 80 hex, call kernel
	%endmacro


;Se utilizara .indicador para saber cuales son indicadores
;Se utilizara _funcion para saber cuales son funciones
;Seccion de codigo
section .text

global _start
_start:

pop eax
mov [nParams], eax       ;Se saca del stack el valor de argc (# de argumentos)
cmp eax, 1               ;Se compara si el numero de argumentos es > 1
je .nulo                 ;Si viene sin argumentos salta al indicador .nulo
mov eax, [esp + 4]       ;Muevo el Stack pointer para acceder al primer argumento
mov ebx, string_uno 	 
mov ecx, 3
mov edx, 3
call _stringCompare      ;Llamo a la funcion para saber si el argumento que me pasaron es -y
cmp eax, 0               ;Si la funcion retorna 0 entonces salta al indicador para imprimir lo que se paso por el argumento ano
je .esAno                ;Si viene con argumento -y salta al indicador .esAno
mov eax, [esp + 4]       ;Vuelvo a setear los parametros de la funcion para comparar si el parametro es -d
mov ebx, string_dos      
mov ecx, 3
mov edx, 3
call _stringCompare
cmp eax, 0               ;Si da 0 quiere decir que se paso el argumento por -d y deberia imprimir que se le paso el argumento por fecha
je .esFecha 				     ;Si viene con argumento -d salta al indicador .esFecha
jmp .halt 				       ;Salta a halt cuando termina

;.nulo imprime el ano actual, ya que no se le pasan parametros (unicamente calendar)
.nulo:
mov eax, 4
mov ebx, 1
mov ecx, nulo
mov edx, lenNulo
int 0x80 				      ;Se hace el llamado al sistema (Linux)
call _saltoLinea 		  ;Llamo a la funcion para realizar un salto de linea
mov eax, 78           ;Se llama la instruccion del sistema que trae una estructura con la zona horaria getTimeOfday
mov ebx, timeStamp    ;Se mueve a ebx el timeval de la estructura del llamado al sistema
mov ecx, timeZone
int 0x80 				      ;Se hace el llamado al sistema (Linux)
mov eax, [timeZone]   ;Muevo a eax el valor del timeZone
cmp eax, 300 			    ;Comparo el valor del timeZone con 300 (timeZone de Colombia)
jne .noEsCol   		    ;Salto al indicador .noEsCol si no estoy en Colombia
mov edx, 0
mov eax, [timeStamp]

mov ecx, 31556926   	;Esta es la cantidad de segundos que tiene un año
div ecx 				      ;Divido para obtener la cantidad de anos desde 1970
add eax, 1970 		    ;Suma la cantidad de la division anterior con 1970 para obtener el ano actual
mov [anos], eax      
mov [ano], eax
call CalcularCalendario 	  
call festivosDelAno 	      ;Llamo a la funcion para los calcular los Festivos del Ano
call imprimirCalendario 	  ;Llamo a la funcion para imprimir el calendario
jmp .halt 			            ;Salta a halt cuando termina


;esAno imprime en pantalla el ano que se le paso como argumentos 
.esAno: 
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
   ;mov [ano], eax
   ;call CalcularCalendario
   ;call festivosDelAno
   ;call imprimirCalendario
   ;jmp .halt
   print_Some esAno, lenEsAno
   call _saltoLinea             
   jmp .esCol

;esFecha imprime en pantalla la fecha que se le paso como argumentos
.esFecha:
   print_Some esFecha, lenEsFecha
   call _saltoLinea           ;Llama la funcion del salto de linea
   jmp .esCol

;Determina si la zona horaria es de colombia
.esCol:
   call _getTime              ;Llamo a la funcion para setear el timezone de mi laptop
   mov eax, [timeZone]        ;Muevo a eax el valor del timeZone
   cmp eax, 300               ;Comparo el valor del timeZone con 300 (timeZone de Colombia)
   jne .noEsCol               ;Me interrumpe la ejecucion del programa si no estoy en colombia
   mov eax, [timeZone] 
   mov edi, digito
   call _intToString          ;Si estoy en colombia imprimo el entero
   print_Some esCol, lenEsCol ;Imprimo el mensaje de: "Su timezone es: " 
   print_Some digito, pInt    ;Imprimo el entero de la zona horaria
   call _saltoLinea           ;Llamo a la funcion para realizar un salto de linea
   jmp .continue 			        ;Si ando en Colombia salto al indicador .continue para continuar

;continue continua con la ejecucion del calendario, pues estamos en Colombia
.continue:
   mov edx, 0
   mov eax, [timeStamp]
   mov ecx, 31556926   		  ;La cantidad de segundos que tiene un año
   div ecx
   add eax, 1970
   mov [anos], eax
   pop eax
   pop eax
   pop ebx
   mov [param], ebx
   mov edi, ebx
   call Length
   print_Some ebx, ecx
   print_Some ln, lenLn
   mov edx, [param]
   call _convStringToInt 	 ;Llamo a la funcion para convertir el String que capture como param en entero
   mov [ano], eax
   call CalcularCalendario
   call festivosDelAno 		 ;Llamo a la funcion para los calcular Festivos del Ano
   call imprimirCalendario ;Llamo a la funcion para imprimir el calendario
   ;mov edi, digito
   ;call _intToString
   ;print_Some digito, pInt
   mov eax, edx
   xor edx, edx
   mov ecx, 86400
   div ecx
   mov [dias], eax    	;EN EAX ESTAN LOS DIAS QUE PASARON DESDE EL 01 DE ENERO DEL ANO ACTUAL
   mov esi, 0    			  ;Contador de mes
   mov edi, eax  			  ;Contador para los dias

;dateLoop es un indicador que hace un ciclo para recorrer las fechas
.dateLoop:
mov edx, 0
mov eax, esi
mov ecx, 7
div ecx

;Modulo 2 del resultado del mes
mov eax, edx
mov edx, 0
mov ecx, 2
div ecx
mov eax, edx

cmp esi, 1 
je .esFeb
cmp eax, 0   ;Compara si es par tiene 31 dias el mes
je .esPar    ;Si es par se le resta 31 dias
   
mov dword[diasFaltanMes], 30
sub edi, 30  ;Se le restan 30 dias al contador para los dias
jmp .esParEnd

;esPar si el mes es de 31 dias
.esPar:
mov dword[diasFaltanMes], 31
sub edi, 31
jmp .esParEnd

;FebNormal le resta 28 dias al contador de dias
.esFeb:
mov eax, [anos]
call _esB
mov eax, [esB]
cmp eax, 1
je .esFebB   ;Salta a Febrero bisiesto

mov dword[diasFaltanMes], 28
sub edi, 28
jmp .esParEnd

;FebB le resta 29 dias al contador de dias, ya que es bisiesto
.esFebB: 
mov dword[diasFaltanMes], 29
sub edi, 29

.esParEnd:
add esi,1    ;Incremento el contador de meses

;Comparamos si la fecha es negativa, salimos del ciclo
cmp edi, 0
jge .dateLoop            ;Si el contandor de dias que falta es mayor que 0 vuelve a hacer el loop
add edi, [diasFaltanMes] ;Sumo dias que se restaron al ultimo mes
mov [dias], edi
mov [meses], esi

;mov eax, [dia]
;mov edi, digito
;call _intToString
;print_Some digito, pInt
;call _saltoLinea
;mov eax, [mes]
;mov edi, digito
;call _intToString
;print_Some digito, pInt
;call _saltoLinea
jmp .halt    ;Salta a halt cuando termina

;Nos dice si no estamos en Colombia
.noEsCol:
mov eax, 4
mov ebx, 1
mov ecx, noCol
mov edx, lenNoCol
int 0x80    ;Se hace el llamado al sistema (Linux)
call _saltoLinea
jmp .halt   ;Salta a halt cuando termina

;halt para terminar la ejecucion.
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
     
;Compara dos Strings haciendo uso de los llamados ESI:EDI del 
;procesador que permiten la operacion con strings en memoria
;(cmpsb) o (cmosw para comparar de a 2 bytes)
;
;Parametros:
;	EAX => char * [Direccion SRC]
;   EBX => char * [Direccion DES]
;   ECX => int [Length SRC]
;   EDX => int [Length DES]
;
;Retorno:
;   EAX => 0 si son iguales; 1 si no son iguales
;
_stringCompare:
    mov esi, eax 	;Mueve a esi el str1 [eax]
    mov edi, ebx 	;Mueve a edi el str2 [ebx]
    cld 			;Se limpia el flag de direccion de strings
    ;El flag de ZERO se setea si ambos str son iguales o si no se limpia
    repe cmpsb  	;Va comparando bytes en memoria, hasta el caracter NULL
    jecxz .stringCompareDifferent
    mov eax, 1 		;Movemos 1 a eax, es decir No son iguales
    jmp .stringCompareExit ;Retorna el resulatado [EAX]

.stringCompareDifferent:
    mov eax, 0  	;Movemos 0 a eax, es decir son iguales

.stringCompareExit:
    ret

;Funcion para realizar un salto de linea
_saltoLinea:
    mov eax, 4
    mov ebx, 1
    mov ecx, salto_linea
    mov edx, 1
    int 0x80
ret

;Funcion para obtener el timeZone
_getTime:
    mov eax, 78             ;Se llama la instruccion del sistema que trae una estructura con la zona horaria getTimeOfday
    mov ebx, timeStamp      ;Se mueve a ebx el timeval de la estructura del llamado al sistema
    mov ecx, timeZone
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
    mov [digito], edx
    ;push 0x0a  ;End of line \n

 .pushDigits:
    xor edx, edx        ;Zero-extend eax
    div ecx             ;Divide by 10; now edx = next digit
    add edx, 30h        ;Decimal value + 30h => ascii digit
    push edx            ;Push the whole dword, cause that's how x86 rolls
    test eax, eax       ;Leading zeros suck
    jnz .pushDigits

 .popDigits:
    pop eax
    stosb               ;Don't write the whole dword, just the low byte
    cmp esp, ebp        ;If esp == ebp, we've popped all the digits
    jne .popDigits
    xor eax, eax        ;Add trailing nul
    stosb
    mov eax, edi
    pop ebp
    pop edi
    pop ecx
    pop edx
    sub eax, edi        ;Return number of bytes written
    ret

write_digito:
  push eax
  push ebx
	push ecx
	push edx
	mov eax, 4       	   ;System call, 4 = sys_write
	mov ebx, 1         	 ;File descriptor 1 = stdout
	mov ecx, digito      ;Store *address* of digit into ecx
	mov edx, 16          ;Byte size of 16
	int 80h
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

;Funcion que convierte un String en Entero
_convStringToInt:
	xor eax, eax 		  ;Zero a "result so far"
	.top:
	movzx ecx, byte [edx] ;Get a character
	inc edx 			  ;Ready for next one
	cmp ecx, '0' 		  ;Valid?
	jb .done
	cmp ecx, '9'
	ja .done
	sub ecx, '0' 		  ;"convert" character to number
	imul eax, 10 		  ;Multiply "result so far" by ten
	add eax, ecx  		  ;Add in current digit
	jmp .top              ;Until done
	.done:
	cmp ecx, 0
	ret

strcmp:
	cmp ecx, edx
	jnz .lengths
	mov esi, eax     	  ;Mueve a esi el str1 [eax]
	mov edi, ebx 		  ;Mueve a edi el str2 [ebx]
	cld  				  ;Se limpia el flag de direccion de strings
	; el flag de ZERO se setea si ambos str son iguales o si no se limpia
	repe cmpsb       	  ;Va comparando bytes en memoria, hasta el caracter NULL
	jecxz .strcmpSame
	.lengths:
	mov eax, 1  		  ;Movemos 1 a eax, es decir No son iguales
	jmp .strcmpExit  	  ;Retorna el resulatado [EAX]

	.strcmpSame:
	mov eax, 0  		  ;Movemos 0 a eax, es decir son iguales

	.strcmpExit:
	  ret

Length:
	sub	ecx, ecx
	sub	al, al
	not	ecx
	cld
	repne scasb
	not	ecx
	;dec ecx
	ret

dow:
	;EAX ESTA GUARDADO Y
	;EBX ESTA GUARDADO M
	;ECX ESTA GUARDADO D
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
	;mov eax, [tArr+ebx*4]      ;Times position because a doubleword has 4 bytes
	;movzx eax, byte [tArr+ebx] ;Mov a byte from the array to a register
	xor edx, edx
	mov ebx, 7
	div ebx
	mov eax, edx
	;Returna en EDX o EAX
	ret

; Calcula si el año es bisiesto
_esB:
mov edx, 0
mov eax, [anos]
mov ecx, 4
div ecx
cmp edx, 0  	;Comparo si el año es divisible por 4
je .stepTwo
jmp .stepFive

.stepTwo:
mov eax, [anos]
mov edx, 0
mov ecx, 100
div ecx
cmp edx, 0 		;Comparo si es divisible por 100
je .stepThree
jmp .stepFour

.stepThree:
mov eax, [anos]
mov edx, 0
mov ecx, 400
div ecx
cmp edx, 0 
je .stepFour
jmp .stepFive

;El año es bisiesto y tiene 366 dias
.stepFour:
mov dword[esB], 1  		;1 Si es bisiesto

.stepFive:
mov dword[esB], 0  		;0 Si No es bisiesto

ret

CalcularCalendario:
	;ano = []
  ;ano << nil
	mov eax, 1
	mov [indice], eax
	mov eax, [ano]
	mov ebx, 1
	mov ecx, 1

	call dow
	mov [diaDeLaSemana], edx
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
	mov ebx, [indice]
	;mov al, 5
	mov al, [diaDeLaSemana]
	mov [array+ebx], al
	inc ebx
	mov [indice], ebx
	mov eax, [diaDeLaSemana]
	add eax, 1
	mov ecx, 7
	xor edx, edx
	div ecx
	mov [diaDeLaSemana], edx

	jmp .otherIf

	.else:
	mov eax, [i]
	cmp eax, 2
	jnz .exitIf1
	mov eax, [j]
	cmp eax, 28
	jg .exitIf2
	mov ebx, [indice]
	mov al, [diaDeLaSemana]
	mov [array+ebx], al
	inc ebx
	mov [indice], ebx
	mov eax, [diaDeLaSemana]
	add eax, 1
	mov ecx, 7
	xor edx, edx
	div ecx
	mov [diaDeLaSemana], edx

	.exitIf2:
	mov eax, [ano]
	mov ecx, 4
	xor edx, edx
	div ecx
	mov eax, edx
	cmp eax, 0
	jnz .else2
	mov eax, [ano]
	mov ecx, 100
	xor edx, edx
	div ecx
	mov eax, edx
	cmp eax, 0
	jz .otherWay
	jmp .entry2

	.otherWay:
	mov eax, [ano]
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
	mov ebx, [indice]
	mov al, [diaDeLaSemana]
	mov [array+ebx], al
	inc ebx
	mov [indice], ebx
	mov eax, [diaDeLaSemana]
	add eax, 1
	mov ecx, 7
	xor edx, edx
	div ecx
	mov [diaDeLaSemana], edx

	.exitIf3:
	mov eax, [j]
	cmp eax, 30
	jz .entry3
	mov eax, [j]
	cmp eax, 31
	jnz .exitElse2

	.entry3:
	mov eax, [indice]
	inc eax
	mov [indice], eax
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
	mov eax, [indice]
	inc eax
	mov [indice], eax

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
	mov ebx, [indice]
	mov al, [diaDeLaSemana]
	mov [array+ebx], al
	inc ebx
	mov [indice], ebx
	mov eax, [diaDeLaSemana]
	add eax, 1
	mov ecx, 7
	xor edx, edx
	div ecx
	mov [diaDeLaSemana], edx
	jmp .exitIf4

	.else3:
	mov ebx, [indice]
	inc ebx
	mov [indice], ebx

	.exitIf4:
	jmp .forj

	.exitForj:
	jmp .fori

	.exitFori:
	ret

printArray:
	mov ebx, 0
	mov [indice], ebx
	.for:
	mov ebx, [indice]
	cmp ebx, lenArray
	jge .exitFor
	movzx eax, byte[array+ebx]
	mov edi, digito
	call _intToString
	call write_digito
	inc ebx
	mov [indice], ebx
	jmp .for
	.exitFor:
	ret

festivosDelAno:
;Festivos inamovibles
;1 de Enero - Ano Nuevo
;Jueves Santo
;Viernes Santo
;1 de Mayo - Dia del Trabajo
;20 de Julio - Independencia Nacional 
;7 de Agosto - Batalla de Boyaca
;8 de Diciembre - Inmaculada Concepcion 
;25 de Diciembre - Navidad

;1 de Enero
mov ebx, 1       ;1
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[1] *= -1

;1 de Mayo
mov ebx, 125     ;4*31+1
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[4*31 + 1] *= -1

;20 de Julio
mov ebx, 206     ;6*31+20
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[6*31 + 20] *= -1

;7 de Agosto
mov ebx, 224     ;7*31+7
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[7*31 + 7] *= -1

;8 de Diciembre
mov ebx, 349     ;11*31+8
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[11*31 + 8] *= -1

;25 de Diciembre
mov ebx, 366     ;11*31+25
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[11*31 + 25] *= -1

;Festivos cobijados por la ley
;;6 de Enero - Epifania del Senor
;;19 de Marzo - Dia de San Jose
;;Ascension del Senor (Sexto Domingo despues de Pascua)
;;Corpus Christi (Octavo Domingo despues de Pascua)
;;Sagrado Corazon de Jesus (Noveno Domingo despues de Pascua)
;;!!jueves y viernes santo (semana anterior a pascua)
;;29 de Junio - San Pedro y San Pablo
;;15 de Agosto - Asuncion de la Virgen
;;12 de Octubre - Dia de la Raza
;;1 de Noviembre - Todos los Santos
;;11 de Noviembre - Independencia de Cartagena

;;6 de Enero
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

;;19 de Marzo
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

;;29 de Junio
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

;;15 de Agosto
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

;;12 de Octubre
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

;;1 de Noviembre
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

;;11 de Noviembre
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

;;Calculo del Domingo de Pascua
;a = ano % 19
mov eax, [ano]
mov ebx, 19
xor edx, edx
div ebx
mov [a], edx
;b = ano / 100
mov eax, [ano]
mov ebx, 100
xor edx, edx
div ebx
mov [b], eax
;c = ano % 100
mov eax, [ano]
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
;mesDePascua = n / 31
mov eax, [n]
mov ebx, 31
xor edx, edx
div ebx
dec eax
mov [mesDePascua], eax
;diaDePascua = 1 + (n % 31)
mov eax, [n]
mov ebx, 31
xor edx, edx
div ebx
mov eax, edx
add eax, 2
mov [diaDePascua], eax
;mesDePascua -= 1
;diaDePascua += 1

;y[(mesDePascua - 1)*31 + diaDePascua - 2] *= -1 ;viernes santo
mov eax, [mesDePascua]
dec eax
mov ebx, 31
mul ebx
mov ecx, eax
mov eax, [diaDePascua]
sub eax, 2
add eax, ecx
mov ebx, eax
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[(mesDePascua - 1)*31 + diaDePascua - 3] *= -1 ; jueves santo
mov eax, [mesDePascua]
dec eax
mov ebx, 31
mul ebx
mov ecx, eax
mov eax, [diaDePascua]
sub eax, 3
add eax, ecx
mov ebx, eax
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al

;;Dia de la ascencion
mov eax, [mesDePascua]
dec eax
mov ebx, 31
mul ebx
mov ecx, eax
mov eax, [diaDePascua]
add eax, 42
add eax, ecx
mov [indice], eax
movzx eax, byte[array+eax]
mov ebx, 7
sub ebx, eax
inc ebx
mov eax, ebx
mov ecx, 7
xor edx, edx
div ecx
mov ebx, edx
add ebx, [indice]
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[((7 - y[(mesDePascua - 1)*31 + diaDePascua + 42] + 1) % 7) + ((mesDePascua - 1)*31 + diaDePascua + 42)] *= -1

;;Corpus Christi
mov eax, [mesDePascua]
dec eax
mov ebx, 31
mul ebx
mov ecx, eax
mov eax, [diaDePascua]
add eax, 63
add eax, ecx
mov [indice], eax
movzx eax, byte[array+eax]
mov ebx, 7
sub ebx, eax
inc ebx
mov eax, ebx
mov ecx, 7
xor edx, edx
div ecx
mov ebx, edx
add ebx, [indice]
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[((7 - y[(mesDePascua - 1)*31 + diaDePascua + 63] + 1) % 7) + ((mesDePascua - 1)*31 + diaDePascua + 63)] *= -1

;;Sagrado Corazon
mov eax, [mesDePascua]
dec eax
mov ebx, 31
mul ebx
mov ecx, eax
mov eax, [diaDePascua]
add eax, 70
add eax, ecx
mov [indice], eax
movzx eax, byte[array+eax]
mov ebx, 7
sub ebx, eax
inc ebx
mov eax, ebx
mov ecx, 7
xor edx, edx
div ecx
mov ebx, edx
add ebx, [indice]
movzx eax, byte[array+ebx]
mov ecx, 10
add eax, ecx
mov [res], eax
mov al, [res]
mov [array+ebx], al
;y[((7 - y[(mesDePascua - 1)*31 + diaDePascua + 70] + 1) % 7) + ((mesDePascua - 1)*31 + diaDePascua + 70)] *= -1

ret

imprimirCalendario:
	mov eax, 0
	mov [diaDeLaSemana], eax
	;ReajustarFila
	mov ebx, 0
	mov [indice], ebx
	mov ecx, 0
	mov [i], ecx
	.paraMeses:
	mov ecx, [i]
	inc ecx
	mov [i], ecx
	cmp ecx, 12
	jg .exitParaMeses
	cmp ecx, 1
	jnz .proximo1
	print_Some enero, lenEnero
	jmp .formato
	.proximo1:
	cmp ecx, 2
	jnz .proximo2
	print_Some febrero, lenFebrero
	jmp .formato
	.proximo2:
	cmp ecx, 3
	jnz .proximo3
	print_Some marzo, lenMarzo
	jmp .formato
	.proximo3:
	cmp ecx, 4
	jnz .proximo4
	print_Some abril, lenAbril
	jmp .formato
	.proximo4:
	cmp ecx, 5
	jnz .proximo5
	print_Some mayo, lenMayo
	jmp .formato
	.proximo5:
	cmp ecx, 6
	jnz .proximo6
	print_Some junio, lenJunio
	jmp .formato
	.proximo6:
	cmp ecx, 7
	jnz .proximo7
	print_Some julio, lenJulio
	jmp .formato
	.proximo7:
	cmp ecx, 8
	jnz .proximo8
	print_Some agosto, lenAgosto
	jmp .formato
	.proximo8:
	cmp ecx, 9
	jnz .proximo9
	print_Some septiembre, lenSeptiembre
	jmp .formato
	.proximo9:
	cmp ecx, 10
	jnz .proximo10
	print_Some octubre, lenOctubre
	jmp .formato
	.proximo10:
	cmp ecx, 11
	jnz .proximo11
	print_Some noviembre, lenNoviembre
	jmp .formato
	.proximo11:
	cmp ecx, 12
	jnz .paraMeses
	print_Some diciembre, lenDiciembre

	.formato:
	print_Some cabecera, lenCabecera
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
	cmp eax, [diaDeLaSemana]
	jnz .elseNoFestivo
	mov ebx, [res]
	movzx eax, byte[array+ebx]
	cmp eax, 0
	jz .esFestivo
	mov ebx, [res]
	movzx eax, byte[array+ebx]
	cmp eax, 10
	jb .esNormal

	.esFestivo:
	print_Some caracterF, lenCaracterF
	mov eax, [j]
	mov [ultimo], eax
	cmp eax, 10
	jb .addEspacioFestivo
	mov edi, digito
	call _intToString
	call write_digito
	print_Some espacioSimple, lenEspacioS
	.continue2:
	mov ebx, [indice]
	inc ebx
	mov [indice], ebx
	jmp .continue

	.addEspacioFestivo:
	mov eax, [j]
	mov edi, digito
	call _intToString
	call write_digito
	print_Some espacioDoble, lenEspacioD
	jmp .continue2

	.esNormal:
	mov ebx, [res]
	movzx eax, byte[array+ebx]
	cmp eax, 0
	jbe .continue
	mov eax, [j]
	mov [ultimo], eax
	cmp eax, 10
	jb .addEspacioNormal
	mov edi, digito
	call _intToString
	call write_digito
	print_Some espacioTriple, lenEspacioT
	.continue3:
	mov ebx, [indice]
	inc ebx
	mov [indice], ebx

	.continue:
	mov eax, [diaDeLaSemana]
	inc eax
	mov ecx, 7
	xor edx, edx
	div ecx
	mov [diaDeLaSemana], edx
	mov ebx, [j]
	inc ebx
	mov [j], ebx
	jmp .nuevaFila

	.addEspacioNormal:
	mov eax, [j]
	mov edi, digito
	call _intToString
	call write_digito
	print_Some espacioCuad, lenEspacioC
	jmp .continue3

	.elseNoFestivo:
	print_Some espacioNulo, lenEspacioN
	mov eax, -1
	mov [ultimo], eax
	mov ebx, [indice]
	inc ebx
	mov [indice], ebx
	mov eax, [diaDeLaSemana]
	inc eax
	mov ecx, 7
	xor edx, edx
	div ecx
	mov [diaDeLaSemana], edx

	.nuevaFila:
	mov eax, [indice]
	cmp eax, 7
	jz .nuevaLinea
	mov ebx, [ultimo]
	cmp ebx, 31
	jz .nuevaLinea
	;row[row.count - 1] == 31
	jmp .exitElseNull

	.nuevaLinea:
	print_Some ln, lenLn
	mov ebx, 0
	mov [diaDeLaSemana], ebx
	mov [indice], ebx
	jmp .exitElseNull

	.elseNull:
	print_Some ln, lenLn
	mov ebx, 0
	mov [diaDeLaSemana], ebx
	mov [indice], ebx
	mov ecx, 32
	mov [j], ecx

	.exitElseNull:
	jmp .whilej

	.exitWhilej:
	print_Some ln, lenLn
	print_Some ln, lenLn
	mov ebx, 0
	mov [indice], ebx
	jmp .paraMeses

	.exitParaMeses:
	ret

Error:

Exit:
	syscall_exit
