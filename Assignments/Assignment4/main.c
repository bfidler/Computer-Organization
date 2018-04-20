#include <stdio.h>
#include <string.h>
#include <assert.h>

int prepareKey(char *key);
void encrypt(char *message, char *key, char *encr);
void decrypt(char *message, char *key, char *decr);

int main()
{
   char str0[60] = "attack at dawn";
   char str1[60] = "this is a test of the encoding algorithm";
              
   char key1[35] = "trailblazers";
   char key2[35] = "letsgotigersgofightwin";

   char e[60];
   char d[60];
   
   int k;
   k = prepareKey(key1);
   assert(k != 0);

   printf("\nstring: trailblazers\n");
   printf("key:    %s\n", key1);
   printf("---------------------------\n");
   printf("original :  %s\n", str0);
   encrypt(str0, key1, e);
   printf("encrypted:  %s\n", e);
   decrypt(e, key1, d);
   printf("decrypted:  %s\n", d);
  
   printf("\nstring: trailblazers\n");
   printf("key:    %s\n", key1);
   printf("---------------------------\n");
   printf("original :  %s\n", str1);
   encrypt(str1, key1, e);
   printf("encrypted:  %s\n", e);
   decrypt(e, key1, d);
   printf("decrypted:  %s\n", d);
  

   k = prepareKey(key2);
   assert(k != 0);
   printf("\nstring: letsgotigersgofightwin\n"); 
   printf("key:    %s\n", key2);
   printf("------------------------------------\n");
   printf("original :  %s\n", str0);
   encrypt(str0, key2, e);
   printf("encrypted:  %s\n", e);
   decrypt(e, key2, d);
   printf("decrypted:  %s\n", d);
  
   printf("\nstring: letsgotigersgofightwin\n"); 
   printf("key:    %s\n", key2);
   printf("------------------------------------\n");
   printf("original :  %s\n", str1);
   encrypt(str1, key2, e);
   printf("encrypted:  %s\n", e);
   decrypt(e, key2, d);
   printf("decrypted:  %s\n", d);
  
   return 0;
}
