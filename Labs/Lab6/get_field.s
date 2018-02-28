/* Brayden Fidler (bfidler)
  CPSC 2311 - Section 4
  Lab 6
*/  

	.global main

main:
	push {r7, lr}
	sub sp, sp, #16
	add r7, sp, #0

	ldr r0, =0x12345678       /* put the source value in r0 */
	ldr r2, =0x7              /* put the location of the field's lsb in r2 */
	ldr r3, =0x8              /* put the size of field in r3 */
	
/* Beginning of your code */
	
	ldr r4, =0x0001
	lsl r4, r4, r3
	sub r4, r4, #1
	lsl r4, r4, r2
	and r1, r4, r0

/* End of your code */

/* show output on screen */
    ldr r0, =prt_line	
	bl printf
	add r7, r7, #16
	mov sp, r7
	pop {r7, pc}

	.size main, .-main
	.section .rodata

prt_line: .asciz "0x%X\n"
