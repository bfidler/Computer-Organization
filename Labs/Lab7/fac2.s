	.global	fact
fact:
	mov   r1, #1       @ r1 = 1

here:
	cmp   r0, #1       @ r0 - 1 sets flags
	beq   there        @ branc there if = 0

	mul   r1, r0, r1   @ r1 = r0 * r1
	sub   r0, r0, #1   @ r0--
	b     here         @ branch to here

there:
	mov   r0, r1       @ r0 = r1

	bx    lr

	.size	fact, .-fact

	.align   2
	.section .rodata
fmt_str:
	.ascii  "The factorial of %d is %d\012\000"

	.text
	.align  2
	.global main
main:
	push  {lr}

	@ MAIN CODE GOES HERE
 
	mov r0, #0            @ int i, j
  mov r1, #0
      
  add r0, r0, #10       @ i = 10
  
  bl fact               @ j = fact (i)
  
	mov r2, r0			      @ printf("The factorial of %d is %d\n", i, j);	
	ldr r0, =fmt_str
	mov r1, #10
	
  bl printf 

	pop  {pc}

	.size    main, .-main
	.ident   "GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
	.section .note.GNU-stack,"",%progbits
