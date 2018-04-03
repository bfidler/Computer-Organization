/* Brayden Fidler (bfidler)
  CPSC 2311 - Section 4
  Lab 9
*/  

box_init:
        push {lr}
        sub sp, sp, #12
        
        str r1, [sp]
        str r2, [sp, #4]
        str r3, [sp, #8]
        
        ldmia sp, {r1, r2, r3}
        stmia r0, {r1, r2, r3}
        
        add sp, sp, #12
        pop {pc}

init:
        push  {lr}
        sub   sp, sp, #8

        str   r1, [sp]
        str   r2, [sp, #4]

        ldmia sp, {r1, r2}
        stmia r0, {r1, r2}

        add   sp, sp, #8
        pop   {pc}

zero:
        push  {lr}
        sub   sp, sp, #8

        mov   r3, #0
        str   r3, [sp]
        str   r3, [sp, #4]

        ldmia sp, {r1, r2}
        stmia r0, {r1, r2}

        add   sp, sp, #8
        pop   {pc}

.global main
main:
        push   {lr}
        sub    sp, sp, #8   @ make room for the point struct
        sub    sp, sp, #12  @ make room for the box struct
        
        mov    r0, sp
        mov    r1, #34
        mov    r2, #-3
        bl     init

        ldr    r0, =fmtstr1
        ldr    r1, [sp]
        ldr    r2, [sp, #4]
        bl     printf

        mov    r0, sp
        bl     zero

        ldr    r0, =fmtstr1
        ldr    r1, [sp]
        ldr    r2, [sp, #4]
        bl     printf
        
        mov r4, sp			@setting up stack pointer for box			
        add r4, r4, #8
        
        mov r0, r4			@moving box stack pointer into r0 
        mov r1, #45			@moving other params into r1, r2, r3
        mov r2, #17
        mov r3, #3
        bl box_init			

		ldr r0, =fmtstr2	@loading box string and box vars (must shift)
		ldr r1, [sp, #8]
		ldr r2, [sp, #12]
		ldr r3, [sp, #16]
		bl printf

        add    sp, sp, #12	@deallocating box space
        add    sp, sp, #8	@deallocating point space
        pop    {pc}

fmtstr1:
        .ascii "The members of the structure dot are %d, %d\012\000"

fmtstr2:
		.ascii "The members of the structute box are %d, %d, %d\012\000"
	
