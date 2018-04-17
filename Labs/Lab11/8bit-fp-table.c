/*
	Brayden Fidler
	CPSC 2311
	Lab Section 4
*/


#include <stdio.h>
#include <math.h>
  
int main()
{
  int sign, exp, fraction, significand;
  int i;
  float f;
  float prev = 0;

  for (i = 0; i < 256; i++)
  {
    /* begin your code */
	sign = (i >> 7) & 1;	//asr 7, & by 1
	exp = (i >> 3) & 15;	//asr 3, & by 15
	fraction = i & 7;		//& by 7, no need to shift
	
	int denormal = 0;

	//check for denormal
	if(exp == 0) {
		exp = 1;
		denormal = 1;
	}
	
	//converting exponent
	exp = exp - 8;

	//setting bits of full significand
	if (denormal == 0)
		significand = 8 | fraction;
	else
		significand = fraction;

	//could also say significand = (!denormal << 3) | fraction

	//step 5 sucks
	exp = exp - 3;

	//calculating f
	f = significand * pow(2, exp);
	if (sign == 1)
		f *= -1;	

    /* end your code */

    printf ("%02x => %08x = %+11.6f (spacing = %+11.6f)\n",
            i, *(int*) &f, f, prev-f);
    prev = f;
  }

  return 0;
}
