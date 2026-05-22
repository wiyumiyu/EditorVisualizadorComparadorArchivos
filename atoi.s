// Input:
//		r1 DEBE contener la direccion de memoria del string que queremos convertir 

// Output:
//		r1 contendra el valor convertido


.global atoi

atoi:
	push	{r0, r2-r11, lr}

	mov		r2, #0
	mov		r3, #10
	mov		r4, #1

	ldrb	r0, [r1], #1
	cmp		r0, #'-'
	moveq	r4, #-1
	subne	r1, #1

loop:
	ldrb	r0, [r1], #1
	sub		r0, #'0'
	cmp		r0, #0
	blt		exit
	mla		r2, r3, r2, r0
	b		loop

exit:
	mul		r2, r4, r2
	str		r2, [r1]

	pop		{r0, r2-r11, lr}
	bx		lr

.end
