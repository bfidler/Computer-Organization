/*
  Brayden Fidler (bfidler)
  CPSC 2310 Section 1
  Assignment 3
  April 2, 2018

  Description: 
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
  
  add r0, sp, #0               /*Retriving value from memory*/
  ldr r1, [r0]                 /*Placing N in r1
  
  mov r2, #0                   /*Calculating N^2 and placing it in r2*/
  mul r2, r1, r1
  
  mov r4, #1                   /*i = 1*/
  
  loop:
    cmp r4, #5
    bgt done
    
    bl nextsquare
    mov r2, r0
    add r1, r1, #1
    
    push {r1, r2}
    ldr r0, =fmt_str_loop
    bl printf    
    pop {r1, r2}    
    
    add r4, r4, #1
    bal loop
    
  done: 
    
  add	sp, sp, #4               /*Making room on stack for a integer*/
  pop {pc}                     /*Popping lr to stack*/
  
  