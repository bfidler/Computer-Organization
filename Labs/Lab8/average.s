/* Brayden Fidler (bfidler)
  CPSC 2311 - Section 4
  Lab 8
*/  
   .file "sum.s"
    .text
    .align  2
    .global main
    .type   main, %function

/* main() averages 16 values from stdin and prints the sum */
main:
    push {lr}    // save lr

	add sp, sp, #-64		//making room on the stack for 16 ints
	mov r4,sp				//r4 will hold the stack pointer	
	mov r5, #1  			//i = 1
    
	loopA:
		cmp r5, #16			//i <= 16
		bgt doneA

		ldr r0, =rdfmt		//scanf statement
		mov r1, r4			//moving sp to r1
		bl scanf			//calling scanf

		add r4, r4, #4		//updating stack pointer
		add r5, r5, #1		//i++
		bal loopA
	doneA:

	mov r4, sp				//r4 is at the bottom of the stack again
	mov r5, #1				//i = 1
	mov r6, #0 				//avg = 0

	loopB:
		cmp r5, #16			//i <= 16
		bgt doneB		

		ldr r0, [r4]		//retreving the element pointed to by r4
		add r6, r6, r0		//avg = avg + r0

		add r4, r4, #4		//updating stack pointer
		add r5, r5, #1		//i++
		bal loopB
	doneB:

	ldr r0, = prtfmt		//loading print statement
	lsr r6, #4				//dividing initial sum by 16(lsr 2^4) to get avg
	mov r1, r6				//moving avg to parameter r1
	bl printf				//call to printf

	add sp, sp, #64			//clearing up stack

    pop {pc}         // put lr in pc    

.section    .rodata
    rdfmt:        .asciz "%d"
    prtfmt:       .asciz "Average is %d\n"
