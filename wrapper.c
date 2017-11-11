#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* This is a bit silly code, it just wraps the compiler program
    Sends parameters retrieved to the compiler as
    compiler < argv[0] > argv[1]

*/
int main ( int argc, char *argv[] )
{

    char * str = (char *) malloc(strlen(argv[1]) + strlen(argv[2]) + 25);
	strcpy(str, "./compiler < ");
	strcat(str,argv[1]);
    strcat(str," > ");
    strcat(str,argv[2]);
    int status = system(str);


	return 0;
}
