%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "include.h"

void yyerror(const char * s)
{
	printf("ERROR\n");
}
int temp = 0;
int Label = 0;
void print_list(node * head) {
    node * current = head;

    while (current != NULL) {
			printf("pID: %s, ",current->pID);
	    printf("pCount: %d, ", current->pCount);
			printf("Called%d\n",current ->called );
      current = current->next;
    }
}
void push(node ** head, char * pID, int pCount) {

	node * nn = malloc(sizeof(node));
	nn ->pCount = pCount;
	nn ->pID = pID;
	nn ->next = *head;
	nn ->called = 0;
	*head = nn;
}
int legitness(node * head, char * pID, int pCount) {
	node * current = head;

    while (current != NULL) {
		if(pCount == current ->pCount && strcmp(current->pID,pID)==0) {
			return 0;
		}
		current = current ->next;
	}
	return 1;
}
void accio(node * head, char * pID, int pCount) {

	node * current = head;
	while (current != NULL) {
		if(pCount == current ->pCount && strcmp(current->pID,pID)==0)
				current ->called = 1;
		current = current ->next;
	}
}
void check_Call(node * head) {
	node * current = head;

	while (current != NULL) {
		if(current ->called == 0)
		printf("Procedure defined at line ?? \"%s()\" with %d parameters is not called.\n",current->pID,current ->pCount);
		current = current->next;
	}
}
%}

%union
{
	int type;
	params p;
  char * str;
	attributes attr;
	label l;
}

%type <p> Params Params2
%type <p> tPROC
%type <l> StmtBlk
%token <attr> tID tINTNUM tFALSE tTRUE tLEFTBRACKET tRIGHTBRACKET
%type <attr> AssignStmt Expr Stmt IfStmt WhileStmt CallStmt StmtList Main ExprList ExprList2 Proc Program Procedures
%token tPROC tENDPROC tCOMA tMAIN tENDMAIN tBEGIN tEND tIF tTHEN tELSE tWHILE tASSIGN tSEMICOLON

%left tAND
%left tISEQUAL
%left '<'
%left '+'
%left '*'

%%
Program: Procedures Main {
	//printf("End of program\n");
	check_Call(head);
	char * str = (char *) malloc(strlen($1.code) + strlen($1.code) + 25);
	strcpy(str, $1.code);
	strcat(str,$2.code);
	$$.code = str;
	printf("\nGenerated TAC Code:\n------------------------------------------------------------------------------------------\n\n%s",$$.code);
};

Procedures: Procedures Proc {
	//printf("Read Procedures\n");
	char * str = (char *) malloc(strlen($2.code) + strlen($1.code) + 25);
	strcpy(str, $1.code);
	strcat(str,$2.code);
	$$.code = str;
}
| {
	$$.code = "";
};

Proc: tPROC tID tLEFTBRACKET Params tRIGHTBRACKET StmtList tENDPROC {

	// Get the parameter counts here nigga
	$$.code = "";
	$$.place = "";
	int pCount = $4.par;
	//printf("Read Proc\n");
	if(legitness(head,$2.place,pCount)) {
		//printf("That was legitness, yeah it was\n");
		push(&head,$2.place,pCount);
	} else {
		printf("Illegal overloading for procedure \"%s()\" with %d parameters\n",$2.place,pCount);
	}

	char paramCount[5];
	sprintf(paramCount,"%d",$4.par); // put the int into a string
	char * str = (char *) malloc(100 + strlen($6.code) + 25);
	strcpy(str, "Label");
	strcat(str, $2.place);
	strcat(str,paramCount);
	strcat(str," : ");
	strcat(str,$6.code);
	strcat(str,"return\n");
	//Cant currently getting the newline
	//printf("Found the procedure here: %d\n",newline);
	$$.code = str;
};

Params: tID Params2 {
	//printf("Read Params\n");
	$$.par = $2.par + 1;

}
| {

	$$.par = 0;
};

Params2: tCOMA tID Params2 {
	$$.par = $3.par + 1;
}
| {
	$$.par = 0;
};

Main: tMAIN StmtList tENDMAIN {

	char * str = (char *) malloc(strlen($2.code) + 25);
	strcpy(str, "Labelmain : ");
	strcat(str, $2.code);
	strcat(str,"return\n");
	$$.code = str;
	//printf("Code of the main \n%s\n",$$.code);
};

StmtBlk: tBEGIN StmtList tEND {
	//printf("found blok");


	//TODO: Create label here and stuff
	$$.code = $2.code;
};

StmtList:  Stmt StmtList {
	char * str = (char *) malloc(strlen($1.code)+ strlen($2.code) + 25);
	strcpy(str, $1.code);
	strcat(str, $2.code);

	$$.code = str;
}
| Stmt {
	$$.code = $1.code;
};

Stmt: AssignStmt {
	$$.code = $1.code;

}
| IfStmt {
	$$.code = $1.code;
}
| WhileStmt | CallStmt ;

AssignStmt: tID tASSIGN Expr tSEMICOLON {
	//printf("read assignment\n");
	$$.place = $1.place;
	char * str = (char *) malloc(1 + strlen($3.code) + 200);
	strcpy(str, $3.code);
	strcat(str, $1.place);
	strcat(str," = ");
	strcat(str,$3.place);
	strcat(str,"\n");
	$$.code = str;
	if(strncmp ($3.place,"temp",4) == 0)
		temp--;
};

IfStmt: tIF tLEFTBRACKET Expr tRIGHTBRACKET tTHEN StmtBlk tELSE StmtBlk {

	if(strncmp ($3.place,"temp",4) == 0)
		temp--;
	char * lab = (char *) malloc(200);
	snprintf(lab, sizeof(lab), "Label%d", Label);
	Label++;
	char * lab2 = (char *) malloc(200);
	snprintf(lab2, sizeof(lab2), "Label%d", Label);
	Label++;

	//printf("Here it comes %s\n %s",lab,lab2);
	char * str = (char *) malloc(1 + strlen($3.code) + strlen($6.code)+ strlen($8.code) + 200);
	strcpy(str, $3.code);
	strcat(str,"if (");
	strcat(str,$3.place);
	strcat(str,") GOTO ");
	strcat(str,lab);
	strcat(str,"\n");
	strcat(str,$8.code);
	strcat(str,"GOTO ");
	strcat(str,lab2);
	strcat(str,"\n");
	strcat(str,lab);
	strcat(str," : ");
	strcat(str,$6.code);
	strcat(str,lab2);
	strcat(str," : ");
	$$.code = str;

};

WhileStmt: tWHILE tLEFTBRACKET Expr tRIGHTBRACKET StmtBlk {
	//Wont decrement the temp variable since line containing temp variable
	//will be executed more than one
	if(strncmp ($3.place,"temp",4) == 0) {
		temp--;
	}

	char * lab = (char *) malloc(200);
	snprintf(lab, sizeof(lab), "Label%d", Label);
	Label++;
	char * lab2 = (char *) malloc(200);
	snprintf(lab2, sizeof(lab2), "Label%d", Label);
	Label++;
	char * lab3 = (char *) malloc(200);
	snprintf(lab3, sizeof(lab3), "Label%d", Label);
	Label++;

	char * str = (char *) malloc(1 + strlen($3.code) + strlen($5.code)+ 200);
	strcpy(str, $3.code);
	strcat(str,lab);
	strcat(str," : if (");
	strcat(str,$3.place);
	strcat(str,") GOTO ");
	strcat(str,lab2);
	strcat(str,"\n");
	strcat(str,"GOTO ");
	strcat(str,lab3);
	strcat(str,"\n");
	strcat(str,lab2);
	strcat(str," : ");
	strcat(str,$5.code);
	strcat(str,"GOTO ");
	strcat(str,lab);
	strcat(str,"\n");
	strcat(str,lab3);
	strcat(str," : ");

	$$.code = str;
};

CallStmt: tID tLEFTBRACKET ExprList tRIGHTBRACKET tSEMICOLON {

	//Again get the numbers of the parameters from somewhere
	$$.code = "";
	$$.place = $3.place;
	char * params = $$.place;
	char * quotePtr = params;

	//Got the number of parameters here
	unsigned pCount = 1;
	for (;*quotePtr != '\0'; quotePtr++){

		if(*quotePtr == '\n')
			pCount ++;

	}


	if(!legitness(head,$1.place,pCount)) {
		accio(head,$1.place,pCount);
	} else {
		printf("No definition for procedure \"%s()\" with %d parameters\n",$2.place,pCount);
	}

	char * str = (char *) malloc(1 + strlen($3.code) + strlen(params) + 200);
	strcpy(str, $3.code);
	strcat(str,params);
	strcat(str,"\n");
	strcat(str, "call ");
	strcat(str, $1.place);
	strcat(str,"\n");
	$$.code = str;

};

ExprList: Expr ExprList2 {
	$$.place = "";
	char * str = (char *) malloc(1 + strlen($1.code) + strlen($2.code) + 25);
	strcpy(str, $1.code);
	strcat(str, $2.code);
	$$.code = str;


	char * str2 = (char *) malloc(1 + strlen($1.code) + strlen($2.code) + 25);
	strcpy(str2, "Param ");
	strcat(str2, $1.place);
	strcat(str2, $2.place);
	$$.place = str2;
}
| {
	$$.code = "";
	$$.place = "";
};

ExprList2: tCOMA Expr ExprList2 {

	$$.code = "";
	char * str = (char *) malloc(1 + strlen($2.code) + strlen($3.code) + 25);
	strcpy(str, $2.code);
	strcat(str, $3.code);
	$$.code = str;

	char * str2 = (char *) malloc(1 + strlen($2.place) + strlen($3.place) + 25);
	strcpy(str2, "\nParam ");
	strcat(str2,$2.place);
	strcat(str2, $3.place);
	$$.place = str2;
}
| {
	$$.place = "";
	$$.code = "";
};

Expr: tINTNUM {
		$$.place = $1.place;
		$$.code = "";
}
| tFALSE {
		$$.place = "false";
		$$.code = "";
}
| tTRUE {
		$$.place = "true";
		$$.code = "";
}
| tID {
	//printf("ID is: %s\n\n", $1.place);
	$$.place = $1.place;
	$$.code = "";
}
| tLEFTBRACKET Expr tRIGHTBRACKET {
	//printf("Expression in brackets %s\n\n", $2.code);
	$$.place = $2.place;
	$$.code = $2.code;
}
| Expr '+' Expr {

	if(strncmp ($1.place,"temp",4) == 0)
		temp--;
	if(strncmp ($3.place,"temp",4) == 0)
		temp--;
	char * myString = (char *) malloc(1 + strlen($1.code)+ strlen($3.code) + 25);
	snprintf(myString, sizeof(myString), "temp%d", temp);
	$$.place = myString;
	temp++;

	char * str = (char *) malloc(1 + strlen($1.code)+ strlen($3.code) + 25);
	strcpy(str, $1.code);
	strcat(str, $3.code);
	strcat(str,$$.place);
	strcat(str," = ");
	strcat(str,$1.place);
	strcat(str," + ");
	strcat(str,$3.place);
	strcat(str,"\n");
	$$.code = str;

};
| Expr '*' Expr {

	if(strncmp ($1.place,"temp",4) == 0)
		temp--;
	if(strncmp ($3.place,"temp",4) == 0)
		temp--;
	char * myString = (char *) malloc(1 + strlen($1.code)+ strlen($3.code) + 25);
	snprintf(myString, sizeof(myString), "temp%d", temp);
	$$.place = myString;
	temp++;

	char * str = (char *) malloc(1 + strlen($1.code)+ strlen($3.code) + 25);
	strcpy(str, $1.code);
	strcat(str, $3.code);
	strcat(str,$$.place);
	strcat(str," = ");
	strcat(str,$1.place);
	strcat(str," * ");
	strcat(str,$3.place);
	strcat(str,"\n");
	$$.code = str;

};
| Expr '<' Expr {

	if(strncmp ($1.place,"temp",4) == 0)
		temp--;
	if(strncmp ($3.place,"temp",4) == 0)
		temp--;
	char * myString = (char *) malloc(1 + strlen($1.code)+ strlen($3.code) + 25);
	snprintf(myString, sizeof(myString), "temp%d", temp);
	$$.place = myString;
	temp++;

	char * str = (char *) malloc(1 + strlen($1.code)+ strlen($3.code) + 200);
	strcpy(str, $1.code);
	strcat(str, $3.code);
	strcat(str,$$.place);
	strcat(str," = ");
	strcat(str,$1.place);
	strcat(str," < ");
	strcat(str,$3.place);
	strcat(str,"\n");
	$$.code = str;

};
| Expr tISEQUAL Expr {

	if(strncmp ($1.place,"temp",4) == 0)
		temp--;
	if(strncmp ($3.place,"temp",4) == 0)
		temp--;
	char * myString = (char *) malloc(1 + strlen($1.code)+ strlen($3.code) + 200);
	snprintf(myString, sizeof(myString), "temp%d", temp);
	$$.place = myString;
	temp++;

	char * str = (char *) malloc(1 + strlen($1.code)+ strlen($3.code) + 25);
	strcpy(str, $1.code);
	strcat(str, $3.code);
	strcat(str,$$.place);
	strcat(str," = ");
	strcat(str,$1.place);
	strcat(str," == ");
	strcat(str,$3.place);
	strcat(str,"\n");
	$$.code = str;

};
| Expr tAND Expr {

	if(strncmp ($1.place,"temp",4) == 0)
		temp--;
	if(strncmp ($3.place,"temp",4) == 0)
		temp--;
	char * myString = (char *) malloc(1 + strlen($1.code)+ strlen($3.code) + 200);
	snprintf(myString, sizeof(myString), "temp%d", temp);
	$$.place = myString;
	temp++;

	char * str = (char *) malloc(1 + strlen($1.code)+ strlen($3.code) + 25);
	strcpy(str, $1.code);
	strcat(str, $3.code);
	strcat(str,$$.place);
	strcat(str," = ");
	strcat(str,$1.place);
	strcat(str," and ");
	strcat(str,$3.place);
	strcat(str,"\n");
	$$.code = str;

};

%%

int main()
{
	head = malloc(sizeof(node));
	head -> pCount -1;
	head -> pID = " "; //Unique name
	head -> called = 1;
	head->next = NULL;
	newline = 1;
	procline = 0;
	if(!yyparse())
	{
		printf("\n------------------------------------------------------------------------------------------");
	}

	return 0;
}
