.global _start

	.equ	SVC_CALL,	0
	.equ	STDIN,		0
	.equ	FILL_VALUE,	0
	.equ	STDOUT,		1
	.equ	READ,		3
	.equ	WRITE,		4
	.equ	INPUT_SIZE,	11
	
.data
	sum:					 .asciz	"00000000000000000000000000000000"
	lensum= . - sum
	res:					 .asciz	"00000000000000000000000000000000"
	lenres= . - res
	divi:					 .asciz	"00000000000000000000000000000000"
	lendivi= . - divi
	multi:					 .asciz	"00000000000000000000000000000000"
	lenmulti= . - multi
	multiBajo:				 .asciz	"00000000000000000000000000000000"
	lenmultiBajo= . - multiBajo
	salto:  				 .asciz	"\n"
	negativo:  				 .asciz	"-"
	input:     		.space      2500
	variable1: 		.space		5
	variable2:		.space		5
	variable3:		.space		5
	variable4:		.space		5
	variable5:		.space		5
	variable6:		.space		5
	variable7:		.space		5
	variable8:		.space		5
	variable9:		.space		5
	variable10:		.space		5
	numVariable1:	.space		10
	numVariable2:	.space		10
	numVariable3:	.space		10
	numVariable4:	.space		10
	numVariable5:	.space		10
	numVariable6:	.space		10
	numVariable7:	.space		10
	numVariable8:	.space		10
	numVariable9:	.space		10
	numVariable10:	.space		10
	numLen1:        .space      10
	numLen2:        .space      10
	numLen3:        .space      10
	numLen4:        .space      10
	numLen5:        .space      10
	numLen6:        .space      10
	numLen7:        .space      10
	numLen8:        .space      10
	numLen9:        .space      10
	numLen10:       .space      10	
	contador:       .space      10
	index1:     	.space      10
	index2: 	    .space      10
	num1:			.space		10
	num2:			.space		10 
	resultado:		.space		10
	resultAscii:    .space      10
	token:			.space      2 
	saveIndexTok:	.space		10
	indexParentesis1: .space    10
	indexParentesis2: .space    10
	newExpression:  .space		2500
	finalExpression:  .space    2500 
	
	msgInput: .asciz "Escriba la expresion a evaluar: "
	msgError: .asciz "Operación inválida. Desea intentar nuevamente (s) o finalizar? (cualquier otra letra): "
	msgLimiteCaracteres: .asciz "La expresion no puede exceder los 1024 caracteres \n"
	msgLimiteCapacidad: .asciz "La operación excede la capacidad permitida\n"
	msgInvalidCharacter: .asciz "La operacion tiene un caracter invalido \n"
	msgExcessVariable: .asciz "No pueden usarse mas de 10 variables \n"
	msgIncorrectExp: .asciz "La expresion esta mal escrita y no se puede desarrollar \n"
	digits: .asciz "0123456789ABCDEF"
	
.text

.global _start

restartVariable:
	push	{r0-r7, r10, lr}
	cmp r2,#9
	beq finalRestartVariable
	mov r7,#0
	strb r7,[r1,r2]
	add r2,#1
			
	b restartVariable
			
			
finalRestartVariable:
		mov r7,#0
		strb r7,[r1,r2]
		add r2,#1
		pop		{r0-r7, r10, lr}
		bx lr

obtenerEntrada:
	mov 	r0, #STDIN
	ldr 	r1, =input
	mov 	r2, #2500
	mov 	r7, #READ
	svc		SVC_CALL
	bx lr
	
maxCaract:
	push {r1}
	ldr r1,=msgLimiteCaracteres
	bl print
	pop {r1}
	b exit
	
invalidCharacter:
	push {r1}
	ldr r1,=msgInvalidCharacter
	bl print
	pop {r1}
	b exit
	
nextIndex:
	add r1,#1
	add r11,#1
	b validateExpression
	
nextIndex2:
	add r1,#1
	b validateVariables
	
nextIndex3:
	add r1,#1
	b saveVariableNum
	
comprobeLetter:
	cmp r4,#65
	blt invalidCharacter
	
	cmp r4,#90
	bgt comprobeLetter2
	
comprobeLetter2:
	cmp r4,#97
	blt invalidCharacter
	
saveVariable:
	cmp r2,#1 @r2 se usa para llevar control de la cantidad de variables usadas
	beq chooseVariable1      
	
	cmp r2,#2
	beq chooseVariable2
	
	cmp r2,#3
	beq chooseVariable3
	
	cmp r2,#4
	beq chooseVariable4
	
	cmp r2,#5
	beq chooseVariable5
	
	cmp r2,#6
	beq chooseVariable6
	
	cmp r2,#7
	beq chooseVariable7
	
	cmp r2,#8
	beq chooseVariable8
	
	cmp r2,#9
	beq chooseVariable9

	cmp r2,#10
	beq chooseVariable10

excessVariable:
	push {r1}
	ldr r1,=msgExcessVariable
	bl print
	pop {r1}
	b exit	
	
chooseVariable1:
	ldr r0,=variable1
	b loadVariable

chooseVariable2:
	ldr r0,=variable2
	b loadVariable

chooseVariable3:
	ldr r0,=variable3
	b loadVariable

chooseVariable4:
	ldr r0,=variable4
	b loadVariable

chooseVariable5:
	ldr r0,=variable5
	b loadVariable

chooseVariable6:
	ldr r0,=variable6
	b loadVariable

chooseVariable7:
	ldr r0,=variable7
	b loadVariable
  
chooseVariable8:
	ldr r0,=variable8
	b loadVariable

chooseVariable9:
	ldr r0,=variable9
	b loadVariable

chooseVariable10:
	ldr r0,=variable10
	
loadVariable:
	str r4,[r0]
	add r2,#1
	add r1,#1
	add r11,#1
	b validateExpression
	
saveVariableNum:
	ldrb r4,[r1]
	
	cmp r4,#61 @si es = pasa al siguiente caracter
	beq nextIndex3
	
	cmp r4,#57 @si no es un numero pasa al siguiente caracter (deberia hacer que revise si es una letra)
	bgt nextIndex3
	
	cmp r4,#47 @si es un numero lo guarda
	bgt saveNum   
	
	add r1,#1
	b saveVariableNum
	
@funcion para guardar el numero obtenido
saveNum:
	ldrb r4,[r1]
	
	@si se acaba la expresion o encuentra una , deja de buscar el numero
	cmp r4,#0
	beq endSaveNum

	cmp r4,#44
	beq endSaveNum
	
	strb r4,[r0,r5]@se guarda caracter por caracter el numero en la variable  
	
	add r1,#1
	add r5,#1
	b saveNum
	
endSaveNum:
	sub r5,#1
	str r5, [r3] 
	ldr r3, [r3] @se guarda en la variable que esta en r3 la longitud 
	add r1,#1 @se pasa al siguiente caracter
	add r6,#1 @se aumenta la cantidad de variables revisadas
	b validateVariables
	
@Funcion que recorre la expresion buscando un parentesis
checkParentesisEnd:
	push {r1}
	ldrb r4,[r1]
	
	cmp r4,#41
	beq theresParentesis
	
	@si llega al final de la expresion y no encuentra un parentesis final envia un error
	cmp r4,#44
	beq incorrectExpression
	
	cmp r4,#0
	beq incorrectExpression
	
	add r1,#1
	b checkParentesisEnd
	
theresParentesis:
	pop {r1}
	add r1,#1
	add r11,#1
	b validateExpression
	
incorrectExpression:
	push {r1}
	ldr r1,=msgIncorrectExp
	bl print
	pop {r1}
	b exit	
	
@esta funcion es para comprobar que la expresion este bien escrita
checkNum:
	push {r1}
	ldrb r4,[r1]
	
	cmp r4,#47
	bgt comprobeNum
	
	cmp r4,#44
	beq incorrectExpression
	
	cmp r4,#0
	beq incorrectExpression
	
	add r1,#1
	b checkNum
	
comprobeNum:
	cmp r4,#57
	bgt incorrectExpression
	
@Sigo esta funcion luego

checkVariable:
	mov r5,#0 @r5 sera el indice del numero que se insertara en la variable

	cmp r6,#1
	beq selectNum1

	cmp r6,#2
	beq selectNum2
	
	cmp r6,#3
	beq selectNum3
	
	cmp r6,#4
	beq selectNum4
	
	cmp r6,#5
	beq selectNum5
	
	cmp r6,#6
	beq selectNum6
	
	cmp r6,#7
	beq selectNum7
	
	cmp r6,#8
	beq selectNum8
	
	cmp r6,#9
	beq selectNum9
	
	cmp r6,#10
	beq selectNum10
	
	
selectNum1:
	mov r3,#0
	ldr r0,=numVariable1
	ldr r3,=numLen1
	ldr r9,[r3]
	b changeVariable
	
selectNum2:
	mov r3,#0
	ldr r0,=numVariable2
	ldr r3,=numLen2
	ldr r9,[r3] 
	b changeVariable
	
selectNum3:
	mov r3,#0
	ldr r0,=numVariable3
	ldr r3,=numLen3
	ldr r9,[r3]
	b changeVariable
	 
selectNum4:
	mov r3,#0
	ldr r0,=numVariable4
	ldr r3,=numLen4
	ldr r9,[r3]
	b changeVariable
	
selectNum5:
	mov r3,#0
	ldr r0,=numVariable5
	ldr r3,=numLen5
	ldr r9,[r3]
	b changeVariable
	
selectNum6:
	mov r3,#0
	ldr r0,=numVariable6
	ldr r3,=numLen6
	ldr r9,[r3] 
	b changeVariable
	
selectNum7:
	mov r3,#0
	ldr r0,=numVariable7
	ldr r3,=numLen7
	ldr r9,[r3]
	b changeVariable
	
selectNum8:
	mov r3,#0
	ldr r0,=numVariable8
	ldr r3,=numLen8
	ldr r9,[r3]
	b changeVariable
	
selectNum9:
	mov r3,#0
	ldr r0,=numVariable9
	ldr r3,=numLen9
	ldr r9,[r3]
	b changeVariable

selectNum10:
	mov r3,#0
	ldr r0,=numVariable10
	ldr r3,=numLen10
	ldr r9,[r3]
	
changeVariable: 
	cmp r9,r5
	beq endChangeVariable
	
	ldrb r8,[r0,r5] @r8 guarda byte por byte del numero a cambiar

	strb r8,[r7,r11]
	
	add r11,#1
	add r5,#1
	b changeVariable 
	
endChangeVariable:  
	add r10,#1
	add r6,#1
	b changeExpression

_start:
	mov r0,#0
	ldr r1,=numLen1
	str r0,[r1]
	ldr r1,=numLen2
	str r0,[r1]
	ldr r1,=numLen3
	str r0,[r1]
	ldr r1,=numLen4
	str r0,[r1]
	ldr r1,=numLen5
	str r0,[r1]
	ldr r1,=numLen6
	str r0,[r1]
	ldr r1,=numLen7
	str r0,[r1]
	ldr r1,=numLen8
	str r0,[r1]
	ldr r1,=numLen9
	str r0,[r1]
	ldr r1,=numLen10
	str r0,[r1]

	mov r0,#0
	mov r1,#0
	ldr r1,=msgInput
	bl print
	bl obtenerEntrada
	ldr r1,=input
	mov r10,#1024
	mov r2,#1
	 
@Valida la operacion matematica hasta la coma
validateExpression:

	cmp r11,r10 @r11 tiene el contador de caracteres
	bgt maxCaract
	
	ldrb r4,[r1] @r4 tiene el caracter y r1 la expresion
	
	cmp r4,#10 @r4 es un enter, pasa al sigueinte caracter
	beq nextIndex
	
	cmp r4,#32 @r4 es un espacio, pasa al siguiente caracter
	beq nextIndex
	
	cmp r4,#32 @r4 es menor de 32 pero no un enter o espacio
	blt invalidCharacter
	
	cmp r4,#44 @si r4 es una , acaba la subrutina
	beq endExpression
	
	########### signos de operaciones #############
	cmp r4,#40
	beq checkParentesisEnd @si encuentra un parentesis chequea que se cierre, de lo contrario da error
	
	cmp r4,#41
	beq nextIndex
	
	cmp r4,#42
	beq nextIndex
	
	cmp r4,#43
	beq nextIndex
	
	cmp r4,#45
	beq nextIndex
	
	cmp r4,#47
	beq nextIndex

	###############################################
	
	cmp r4,#47
	blt invalidCharacter 	@si es menor y ninguno de los anteriores es un error
	
	cmp r4,#57 				@si es mayor de 57 comprueba que sea una letra
	bgt comprobeLetter
	
	add r1,#1		
	add r11,#1
	b validateExpression
	
endExpression:
	add r1,#1
	mov r6,#1 @r6 funciona como contador de veces que tiene que buscar una variable

@Valida y guarda el valor asignado a las variables
validateVariables: 
	mov r5,#0 @r5 servira como indice para la variable que almacena el numero
	
	cmp r4,#32 @si es un espacio pasa al siguiente caracter
	beq nextIndex2
	
	cmp r6,r2	@r2 guarda el valor de la cantidad de variables que hay
	beq endValidateVariables
	
	@Las siguientes funciones asignan a los registros las variables a guardar
	
	cmp r6,#1
	beq searchVariable1
	
	cmp r6,#2
	beq searchVariable2
	
	cmp r6,#3
	beq searchVariable3
	
	cmp r6,#4
	beq searchVariable4
	
	cmp r6,#5
	beq searchVariable5
	
	cmp r6,#6
	beq searchVariable6
	
	cmp r6,#7
	beq searchVariable7
	
	cmp r6,#8
	beq searchVariable8
	
	cmp r6,#9
	beq searchVariable9
	
	cmp r6,#10
	beq searchVariable10
	
searchVariable1:
	mov r3,#0
	ldr r0,=numVariable1 @r0 contiene el numero segun el orden en que se encontraron las variables
	ldr r3,=numLen1  @r3 contiene la longitud de ese numero

	b saveVariableNum
	
searchVariable2:
	mov r3,#0
	ldr r0,=numVariable2
	ldr r3,=numLen2
	b saveVariableNum
	
searchVariable3:
	mov r3,#0
	ldr r0,=numVariable3
	ldr r3,=numLen3
	b saveVariableNum
	
searchVariable4:
	mov r3,#0
	ldr r0,=numVariable4
	ldr r3,=numLen4
	b saveVariableNum
	
searchVariable5:
	mov r3,#0
	ldr r0,=numVariable5
	ldr r3,=numLen5
	b saveVariableNum
	
searchVariable6:
	mov r3,#0
	ldr r0,=numVariable6
	ldr r3,=numLen6
	b saveVariableNum
	
searchVariable7:
	mov r3,#0
	ldr r0,=numVariable7
	ldr r3,=numLen7
	b saveVariableNum
	
searchVariable8:
	mov r3,#0
	ldr r0,=numVariable8
	ldr r3,=numLen8
	b saveVariableNum
	
searchVariable9:
	mov r3,#0
	ldr r0,=numVariable9
	ldr r3,=numLen9
	b saveVariableNum
	
searchVariable10:
	mov r3,#0
	ldr r0,=numVariable10
	ldr r3,=numLen10
	b saveVariableNum
	
endValidateVariables:
	@se vuelven algunos registros a su estado original y se guarda en r7 la nueva expresion
	mov r4,#0
	mov r6,#1
	ldr r7,=newExpression
	mov r11,#0 @r11 va a ser el indice de la nueva variable
	mov r1,#0
	ldr r1,=input
	mov r10,#0
	
@Funcion que cambia variables por su respectivo valor en la expresion original
changeExpression:
	ldrb r4,[r1,r10]
	
	cmp r4,#44 @acaba cuando r4 sea una ,
	beq startReadOperation
	
	cmp r4,#64 @si es mayor de 64 revisa que sea una variable
	bgt checkVariable
	
	strb r4,[r7,r11] @r7 tiene la nueva variable @si no es una variable se pasa el valor a r7
	
	add r10,#1
	add r11,#1
	b changeExpression
	
@Se comienza el algoritmo para realizar las operaciones
startReadOperation:
	mov r0,#0
	mov r2,#0
	mov r3,#0
	mov r4,#0
	mov r5,#0
	mov r6,#0
	mov r7,#0
	mov r8,#0
	mov r9,#0
	mov r10,#0
	mov r11,#0
	ldr r1,=newExpression
	
@funcion que busca un parentesis 
findParentesis:
	ldrb r4,[r1,r2] @r2 es el indice para recorrer la expresion
	
	cmp r4,#40
	beq saveParentesis1 @si encuentra un parentesis guarda su posicion 
	
	cmp r4,#0
	beq noParentesis
	
	add r2,#1
	b findParentesis
	
saveParentesis1:
	ldr r3,=indexParentesis1
	str r2,[r3]
	
solutionParentesis:
	ldrb r4,[r1,r2]
	
	@Si hay operaciones mueve el indice a la posicion del parentesis y comienza a operar
	cmp r4,#42
	beq stillOperation
	
	cmp r4,#43
	beq stillOperation
	
	cmp r4,#45
	beq stillOperation
	
	cmp r4,#47
	beq stillOperation
	
	cmp r4,#41
	beq deleteParentesis 
	
	add r2,#1
	b solutionParentesis
	
stillOperation: 
	mov r2,r3
	b solution
	
deleteParentesis:
	mov r2,#0
	ldr r6,=finalExpression
	mov r5,#0

startDeleting:
	ldrb r4,[r1,r2]
	
	cmp r4,#0
	beq restart
	
	cmp r2,r3
	beq jumpParentesis
	
	cmp r4,#41
	beq jumpParentesis
	
	strb r4,[r6,r5]
	
	add r5,#1
	add r2,#1
	b startDeleting
	
jumpParentesis:
	add r2,#1
	b startDeleting
	
restart:
	mov r2,#0
	str r6,[r1]
	b solution
	
@si no hay parentesis reinicia el indice de la variable
noParentesis:
	mov r2,#0
	ldr r1,=newExpression	
	
############### inicio de las funciones para resolver la operacion ###############
solution:
	ldrb r4,[r1,r2]
	
	cmp r4,#47
	bgt saveIndex1
	
	add r2,#1
	b solution

saveIndex1:
	ldr r0,=index1
	str r2,[r0]
	ldr r3,=num1

saveNum1:
	ldrb r4,[r1,r2]
	 
	cmp r4,#32
	beq endSaveNum1
	 
	strb r4,[r3,r5]@r5 es el indice de la variable
	
	add r2,#1
	add r5,#1
	b saveNum1 
	
endSaveNum1:
	mov r5,#0
	add r2,#1
	 
searchToken:
	ldrb r4,[r1,r2]
	
	cmp r4,#0
	beq endSolution
	
	########## si es una multiplicacion o division la hace automaticamente ########
	cmp r4,#42
	beq saveToken
	
	cmp r4,#47
	beq saveToken
	
	######### si es una suma o resta se guarda la posicion y se revisa el resto de la expresion ########## 
	
	cmp r4,#43
	beq saveOperationIndex
	
	cmp r4,#45
	beq saveOperationIndex
	
	add r2,#1
	b searchToken 
	
saveToken:
	ldr r6,=saveIndexTok
	str r2,[r6]  
	ldr r3,=token
	str r4,[r3] 
	ldr r3,=num2 
	add r2,#2
	b saveNum2
	
saveNum2:
	ldrb r4,[r1,r2]
	 
	cmp r4,#32
	beq endSaveNum2
	
	cmp r4,#47
	blt incIndex
	 
	strb r4,[r3,r5]@r5 es el indice de la variable
	
	add r2,#1
	add r5,#1
	b saveNum2
	
endSaveNum2:
	ldr r0,=index2
	str r2,[r0] 
	b convertNumber

saveOperationIndex:
	ldr r6,=saveIndexTok
	str r2,[r6]
	
@Esta funcion se encarga de buscar una operacion con mayor prioridad
@Si la encuentra incrementa el indice y comienza a buscar, si no lo hace realiza la operacion inicial
searchPriority:
	ldrb r4,[r1,r2]
	
	cmp r4,#42
	beq incIndex
	
	cmp r4,#47
	beq incIndex
	
	cmp r4,#0
	beq endSearch
	
	add r2,#1
	b searchPriority
	
	ldr r2,=saveIndexTok 
	add r2,#1
	b solution 

incIndex:
	mov r2,r6
	add r2,#1
	b solution
	
endSearch:
	mov r2,r6
	ldr r3,=token
	str r4,[r3] 
	ldr r3,=index2
	add r2,#2
	
@convierte las variables a numeros
convertNumber:
	push {r1}
	ldr r1,=num1
	bl atoi
	ldr r10,[r1]
hola:
	ldr r1,=num2
	bl atoi
	pop {r1}
	
@revisa el token guardado y realiza la operacion
checkToken:
	ldr r6,=token
	ldr r3,[r6]

	cmp r3,#42
	beq makeMul
	
	cmp r3,#43
	beq makeAdd
	
	cmp r3,#45
	beq makeSub
	
	cmp r3,#47
	beq makeDiv
	
makeMul:
	ldr r6,=num1
	ldr r10,[r6]
	ldr r7,=num2
	ldr r11,[r7]
	mul r8, r7, r6
	ldr r9,=resultado
	str r8,[r9]
	b makeAscii
	
makeAdd:
	push {r1}
	ldr r1,=resultado
	pop {r1}
	ldr r6,=num1
	ldr r7,=num2
	add r8, r7, r6
	ldr r9,=resultado
	str r8,[r9]
	b makeAscii
	
makeDiv:
	push {r1}
	ldr r1,=resultado
	pop {r1}
	ldr r6,=num1
	ldr r7,=num2
	udiv r8, r7, r6
	ldr r9,=resultado
	str r8,[r9]
	b makeAscii
	
makeSub:
	push {r1}
	ldr r1,=resultado
	pop {r1}
	ldr r6,=num1
	ldr r7,=num2
	sub r8, r7, r6
	ldr r9,=resultado
	str r8,[r9]
		
@convierte el resultado obtenido a ascii
makeAscii:
	push {r0,r1,r2,r3,r9,r10}
	ldr r1,=resultAscii
	mov r2,#9
	mov r3,#10
	ldr r10,=digits
	mov r0,r9
	bl itoa
	push {r0,r1,r2,r3,r9,r10}
	mov r2,#0
	mov r5,#0
	ldr r0,=index1
	ldr r3,=index2
	ldr r6,=finalExpression
	ldr r7,=resultAscii
	mov r9,#0
	
	push {r1}
	ldr r1,=resultAscii
	bl print
	pop {r1}
	
	
################### Rescribe la operacion con el nuevo resultado ############
reWriteExpression:
	ldrb r4,[r1,r2]
	
	cmp r4,r0
	beq writeResult
	
	cmp r4,#0
	beq endReWrite
	
	strb r4,[r6,r5] @r6 tiene la variable final y r5 es el indice
	
	add r5,#1
	add r2,#1
	b reWriteExpression

@esta funcion escribe el valor del resultado en la nueva variable y en la variable anterior salta al punto
@donde continua esa expresion	
writeResult:
	mov r2,r3
	
	cmp r9,#10
	beq incrementIndex
	
	ldrb r8,[r7,r9]
	
	str r8,[r6,r5]
	
	add r5,#1
	add r9,#1
	b writeResult
	
######################################
	
incrementIndex:
	add r2,#1
	b reWriteExpression
	
@al acabar reinicia los registros utilizados y regresa al inicio de la evaluacion
endReWrite:
	bl restartVariable
	
	str r6,[r1]
	mov r2,#0
	mov r5,#0
	b solution
	
endSolution:
	bl print
	
exit:
	mov		r0, #0
	mov		r7, #1
	svc		0

.end
