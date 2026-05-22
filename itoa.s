// Entradas:
//		r0 DEBE contener en int para ser convertido
//		r1 DEBE contener la direccion de memoria a la variable donde va a ser almacenado el resultado
//		r3 DEBE contener la base a la cual queremos traducir el numero

// Salida:
//		La direccion de memoria a la cual r1 apunta, va a ser actualizada con el resultado 


.global itoa

itoa:
	
	push	{r0-r5, r7, r10, lr}
	mov     r4, #0         // Inicializar el multiplicador a 1
	udiv    r5, r0, r3
	

	mul r4, r5, r3
	sub  r4, r0, r4 // Se encuentra el residuo 
	cmp     r5, #0
	beq finalizeItoa

	ldrb r4, [r10,r4]
	strb r4,[r1,r2]

	sub r2,#1
	
	mov r0, r5
	
	b itoa

finalizeItoa:
	ldrb r4, [r10,r4]
	strb r4,[r1,r2]
	pop		{r0-r5, r7, r10, lr}
	bx lr

.end
