/*
  Brayden Fidler (bfidler)
  CPSC 2310 Section 1
  Assignment 3
  April 2, 2018

  Description: This function take params N and N^2 and computes nextsquare
*/

/*
  function name: nextsquare

  Description: This function take params N and N^2 and computes nextsquare

  input parameters:
    r0 - N
	r1 - N^2

  return value:
	(N+1)^2

*/

nextsquare:

  push {lr}           /*Saving lr*/
  
  mov r2, #0          /*Next = 0*/
  add r2, r0, r1      /*Next = N + N^2*/
  add r2, r2, r0      /*Next = Next + N*/
  add r2, r2, #1	  /*Next = Next +1*/
  mov r0, r2		  /*Move Next to r0 to be returned*/
  
  pop {pc}            /*Popping lr to stack*/
  
