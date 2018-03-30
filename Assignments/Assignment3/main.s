/*
  Brayden Fidler (bfidler)
  CPSC 2310 Section 1
  Assignment 3
  April 2, 2018

  Description: This program reads a number N, then computes and prints the 
  next 5 squares using a loop
*/

.include "square.s"

fmt_str_prompt:
    .ascii   "Enter an integer greater than 0: \000"

    .text
    .align   2
    .global  main
    
fmt_str_loop:
    .ascii   "  %d^2 = %d\012\000"

    .text
    .align   
    .global  main
    
rdfmt:
    .ascii   "%d"

    .text
    .align   2
    .global  main
    


main:

  push {lr}                    /*Save lr*/
    
  add sp, sp, #-4              /*Making room on stack for an integer*/
  
  ldr r0, =fmt_str_prompt      /*Printing prompt for number*/
  bl printf
  
  ldr r0, =rdfmt               /*Scanning a number N from user*/
  mov r1, sp                   /*Address of first parameter in r1*/
  bl scanf                     /*Scanning value into memory*/
             
  ldr r0, [sp]                 /*Getting N from stack, saving in r0*/
  mul r1, r0, r0			   /*r1 = N^2*/	
  
  mov r4, #1                   /*i = 1*/
  mov r5, #0				   /*intializing r5, r6*/
  mov r6, #0
  
  loop:
    cmp r4, #5				   /*i <= 5*/
    bgt done
    
    add r5, r0, #1			   /*saving N+1 to r5*/	
    
    bl nextsquare			   /*N is in r0, N^2 in r1 already*/	
    
    mov r1, r5				   /*moving N+1 to r1*/
    mov r2, r0				   /*moving next square to r2*/
    mov r6, r0				   /*also saving next square to r6*/	
    ldr r0, =fmt_str_loop	   /*print string %d^2 = %d*/
    
    bl printf
       
    mov r0, r5				   /*moving new N to r0 for next loop*/
    mov r1, r6				   /*moving new N^2 to r1 for next loop*/
    add r4, r4, #1			   /*i++*/
    
    bal loop
    
  done: 
    
  add	sp, sp, #4             /*Making room on stack for a integer*/
  pop {pc}                     /*Popping lr to stack*/
