// Entradas:
//		r1 TIENE que contener la direccion de memoria del string a imprimir
//		String tiene que ser asciz
.global print

.equ	SVC_CALL,	0
.equ	STDOUT,		1
.equ	WRITE,		4

print:
	push	{r0-r7, lr}

	mov		r2, #0
	mov		r3, r1

loop:
	ldrb	r0, [r3], #1
	cmp		r0, #0
	beq		print_string
	add		r2, #1
	b		loop

print_string:
	mov		r0, #STDOUT
	mov		r7, #WRITE	
	svc		SVC_CALL

exit:
	pop		{r0-r7, lr}
	bx		lr

.end
