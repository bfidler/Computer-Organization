/*

Charles Ritter and Brayden Fidler (critte) (bfidler)
CPSC 2310 Section 1
Assignment 4
April 25, 2018

*/


.global encrypt
.global decrypt
.global prepareKey


/*
  function name:  prepareKey
 
   description: this function takes a key string and deletes repeated letters
     then fills the remaining chars of the array with unused alphabet chars
  
   input parameter(s):
     r0 - address of string
  
   return value (if any):
     e.g. 0 for error, 1 for success
     
   other output parameters:
     key has been updated to use for encode/decode
  
   typical calling sequence:
    e.g.
      put starting key address in r0 (length > 27)
      call prepareKey
  
   local register usage:
     e.g.
       r0 - original key base
       r1 - generic i
       r2 - base of array for seen alphabet chars
       r3 - base of array for newKey array
       r4 - index for newKey array
       r5 - holds random values
       r6 - holds random values
       r7 - holds random values

*/

prepareKey: 	

	key			.req r0
	i			  .req r1
	seen		.req r2
	new			.req r3
	newI		.req r4

  //save registers
	push {r4, r5, r6, r7, lr}
 
  //loading arrays
  ldr seen, =seenA
  ldr new, =newA

  //checking for empty key: key[0] = '\0'
  ldrb r5, [key]
  cmp r5, #0
  beq error

  //int i = 0
  mov i, #0
  mov r5, #0
  
  //initializing seen array to all zeroes
  init_seen:
    //i != 27
    cmp i, #27
    beq  seen_full
    
    //seen[i++] = 0
    strb r5, [seen, i]
    add i, i, #1
    b init_seen
    
  seen_full:
  
  mov i, #0
  mov newI, #0
	
  Pwhile:
    //while (key[i] != 0)
    ldrb r5, [key, i]
    cmp r5, #0
    beq end_while

    //key[i] < 'a'
    cmp r5, #97
    blt error
    
    //key[i] > 'z'
    cmp r5, #122
    bgt error
    
    //if(seen[key[i] - 97] == 0)
    sub r6, r5, #97
    ldrb r7, [seen, r6]
    cmp r7, #0
    bne is_seen
    
    //new[newIndex++] = key[i]
    strb r5, [new, newI]
    add newI, newI, #1
    
    //updating see - seen[key[i] - 97] = key[i]
    strb r5, [seen, r6]
    
    //letter has been seen, so i++ and loop back
    is_seen:
      add i, i, #1
      bal Pwhile
    
  end_while:

  mov i, #0
	
  //filling remaining chars of new
  fill_new:
    //(if newI != 26)
    cmp newI, #26
    beq fill_complete
    
    //finding the next unused letter using seen
    next_letter:
      //if(seen[i] == 0), a letter is found
      ldrb r5, [seen, i]
      cmp r5, #0
      beq found_letter
      
      add i, i, #1
      b next_letter
      
    found_letter: 
      //new[newIndex++] = i (index of seen) + 97
      add r5, i, #97
      strb r5, [new, newI]
      add newI, newI, #1
      add i, i, #1
      b fill_new  
    
  fill_complete:
  	//put null char at end of newKey
    mov r5, #0
    strb r5, [new, newI]

  mov i, #0
  
	//Copy the contents of newKey over the contents of the original key
  copy_new:
    //while(i != 27)
    cmp i, #27
    beq copied
    
    //key[i] = new[i]
    ldrb r5, [new, i]
    strb r5, [key, i]
    //i++
    add i, i, #1
    b copy_new
    
  copied:
    //return a success
    mov r0, #1
    
  exit:
  
    .unreq  key
    .unreq  i
    .unreq  seen
    .unreq  new
    .unreq  newI
  
    pop {r4, r5, r6, r7, pc}  

  error:
    mov r0, #0
    b exit
    

/*
  function name:  encode
 
   description: this function takes a string and encodes it using a key. It 
     stores this encoded message in encryp
     
   input parameter(s):
     r0 - base of a string
     r1 - base of a key
     r2 - empty encryption string
  
   return value (if any):
     none
     
   other output parameters:
     encryption reference provided is altered
  
   typical calling sequence:
    e.g.
      put any string with a null char in r0
      put a proper key in r1
      put empty encryption string in r2
      call encode
  
   local register usage:
     e.g.
       r0 - string provided
       r1 - encryption key
       r2 - empty encryption string
       r4 - generic i
       r5 - holds random values
       r6 - holds random values

*/

encrypt:
	
	mystr 		.req r0
	key 	  	.req r1
	encryp		.req r2
	i		      .req r4
	
  //saving registers
	push {r4, r5, r6, lr}
  
  //int i = 0
  mov i, #0
	                      
  Ewhile:
    //loading mystr[i]
    ldrb r5, [mystr, i]
    
    //checking for null
    cmp r5, #0
	  beq Eend_while
     
    //checking for non alphas < a
    cmp r5, #97                    
	  blt Eskip
     
    //checking for non alphas > z
    cmp r5, #122
    bgt Eskip
    
    //finding the index of the key
    sub r5, r5, #97
    
    //loading value at key[r5] and storing it at encryp[i]
    ldrb r6, [key, r5]
    strb r6, [encryp, i]
    
  Eskip_back:   
    add i, i, #1
    b Ewhile
  
  //keeps non alphabetical characters intact  
  Eskip:
    //loading value at str[i] and storing it at encryp[i]
    ldrb r6, [mystr, i]
    strb r6, [encryp, i]
    b Eskip_back
    
  Eend_while:  
    //setting last char of encryp to null
    mov r6, #0
    strb r6, [encryp, i]
  
  
  .unreq mystr
  .unreq key
  .unreq encryp
  .unreq i
  
  pop {r4, r5, r6, pc}


/*
  function name:  decode
 
   description: this function takes a encrypted message and decodes it using a key. It 
     stores this encoded message in decryp
     
   input parameter(s):
     r0 - base of a ecnrypted message
     r1 - base of a key
     r2 - empty decrypted message string
  
   return value (if any):
     none
     
   other output parameters:
     decrypted message reference provided is altered
  
   typical calling sequence:
    e.g.
      put encrypted string with a null char in r0
      put a proper key in r1
      put empty decryption string in r2
      call encode
  
   local register usage:
     e.g.
       r0 - encrypted string provided
       r1 - encryption key
       r2 - empty decrypted message string
       r4 - generic i
       r5 - holds random values
       r6 - generic j
       r7 - holds random values

*/

decrypt:

  mystr 		  .req r0
  key 	  		.req r1
  decryp		  .req r2
  i		 		    .req r4
  j       		.req r6
 
  //saving registers
	push {r4, r5, r6, r7, lr}
  
  //int i = 0
  mov i, #0
  
  Dwhile:
    //loading mystr[i]
    ldrb r5, [mystr, i]
    
    //checking for null
    cmp r5, #0
	  beq Dend_while
     
    //checking for non alphas < a
    cmp r5, #97                    
	  blt Dskip
     
    //checking for non alphas > z
    cmp r5, #122
    bgt Dskip
    
    //index of letter in key
    mov j, #0
    
  //looping and incrementing until index of letter in key is found
  Dloop: 
    //loading key[j]
    ldrb r7, [key, j]
      
    //does str[i] = key[j]
    cmp r5, r7
    beq foundIndex
      
    //j++
    add j, j, #1
    b Dloop
      
  foundIndex:  
    //j + 97 = decimal of letter // storing this at decryp[i]
    add r7, j, #97
    strb r7, [decryp, i]
  
  Dskip_back:  
    //i++  
    add i, i, #1
    bal Dwhile
    
  //keeps non alphabetical characters intact  
  Dskip:
    //loading value at mystr[i] and storing it at decryp[i]
    ldrb r7, [mystr, i]
    strb r7, [decryp, i]
    b Dskip_back
    
  Dend_while:
    //setting last char of decryp to null
    mov r7, #0
    strb r7, [decryp, i]
    
  .unreq mystr
  .unreq key
  .unreq decryp
  .unreq i
  .unreq j
  
  pop {r4, r5, r6, r7, pc}
  
  
 //initialize arrays
  .section .data
	seenA:		.skip 27
	newA:		  .skip 27

