	.global	fact
fact:
    push  {r1, lr}        @ push the value of r1 and line register

    cmp   r0, #1          @ r0 - 1 sets flags
    beq   done            @ branch to done if = 0

    mov  r1, r0           @ r1 = r0
    sub  r0, r0, #1       @ r0--
    bl   fact             @ call fact again

    mul  r0, r1, r0       @ r0 = r1 * r0

done:
    pop  {r1, pc}         @ pop r1 and pc off stack
    .size    fact, .-fact

    .align   2
    .section .rodata
fmt_str:
    .ascii   "The factorial of %d is %d\012\000"

    .text
    .align   2
    .global  main
main:
    push {lr}             @ save the link register so we can jump back to 
	
    @ MAIN CODE GOES HERE
    
    mov r0, #0            @ int i, j
    mov r1, #0
        
    add r0, r0, #10       @ i = 10
    
    bl fact               @ j = fact (i)
    
    mov r2, r0
	  ldr r0, =fmt_str	    @ printf("The factorial of %d is %d\n", i, j);	
	  mov r1, #10
    bl printf             

    pop  {pc}             @ pop the top of the stack
    
    
    

	.size    main, .-main
	.ident   "GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
	.section .note.GNU-stack,"",%progbits
