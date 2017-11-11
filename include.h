#ifndef INCLUDE_H
#define INCLUDE_H

typedef struct
{
  char * place; // variable name (x,y,t1,etc)
  char * code; //Generate code of the Statement
} attributes;


typedef struct
{
  char * place; // variable name (x,y,t1,etc)
  char * code; //Generate code of the Statement
  char * lab;
} label;

typedef struct
{
  int par;
} params;

struct linked_list
{
	char * pID;
	int pCount;
    int called;
	struct linked_list *next;

};
typedef struct linked_list node;
node * head;
int newline;
int procline;
#endif
