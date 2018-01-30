comment(`  Brayden Fidler CPSC 2310 Section 4')


comment(`Stroring starting temperature in celsius')
bipush(-40) 
istore_1         

label(loop)      

comment(`Calculating and storing the temperature in farenheit using celsius')
iload_1
bipush(9)
imul
iconst_5
idiv
bipush(32)
iadd
istore_2

comment(`Printing temperature celsius')
iconst_1
invokevirtual(1)
 
comment(`Printing temperature farenheit')
iconst_2         
invokevirtual(2)

comment(`incrementing celcius by 10')
iinc(1, 10)       

comment(`loading celsius and substracting by final value to compare')
iload_1          
bipush(120)       
isub             

comment(`branching again if final value hasn't been reached')
ifle(loop)       

return
