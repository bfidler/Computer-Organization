/*
  Brayden Fidler (bfidler)
  CPSC 2310 Section 1
  Assignment 3
  April 2, 2018

  Description: 
*/


nextsquare:

  push {lr}           /*Saving lr*/
  
  mov r0, #0          /*NxtSquare = 0*/
  add r0, r2, r1      /*NxtSquare = N^2 + N + (N + 1)*/ 
  add r0, r0, r1      
  add r0, r0, #1
  
  pop {pc}            /*Popping lr to stack*/
  