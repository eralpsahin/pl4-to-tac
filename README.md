

# PL4
PL4 is just a simple language we studied in the 'Compiler Design' course in Sabanci University.

The languages grammar is defined as:

<img src="https://raw.githubusercontent.com/eralpsahin/pl4-to-tac/master/PL4_Grammar.png">

# PL4 Sample Program
```
proc
    myAwesomeFunction(int,int,str)
    hel = 4 + 4;
endproc
proc
    myAwesomeFunction(str,str,str)
    suchoverload = much + coding;
endproc
main
    while( a < 4)
        begin
        if(elma and armut * 2 + 3)
            then
            begin
                myAnotherAwesomeFunction(a,8+8,2,4);
            end
            else
            begin
                c = 45 + 43;
            end
    end

    calling = correctly + now;
    myAwesomeFunction(int,int,str);

    Longlong  = a * b + c * d + e * f;
endmain
```

# Three Address Code (TAC)
It is an intermediate code used to optimising compilers to aid in the implementation of code-improving transformations. Since each TAC instruction has at most three operands, it is suitable for optimisations such as, register and memory allocation.

# Sample TAC output
```
Illegal overloading for procedure "myAwesomeFunction()" with 3 parameters
No definition for procedure "myAnotherAwesomeFunction()" with 4 parameters

Generated TAC Code:
------------------------------------------------------------------------------------------

LabelmyAwesomeFunction3 : temp0 = 4 + 4
hel = temp0
return
LabelmyAwesomeFunction3 : temp0 = much + coding
suchoverload = temp0
return
Labelmain : temp0 = a < 4
Label2 : if (temp0) GOTO Label3
GOTO Label4
Label3 : temp1 = armut * 2
temp1 = temp1 + 3
temp1 = elma and temp1
if (temp1) GOTO Label0
temp3 = 45 + 43
c = temp3
GOTO Label1
Label0 : temp2 = 8 + 8
Param a
Param temp2
Param 2
Param 4
call myAnotherAwesomeFunction
Label1 : GOTO Label2
Label4 : temp1 = correctly + now
calling = temp1
Param int
Param int
Param str
call myAwesomeFunction
temp1 = a * b
temp2 = c * d
temp1 = temp1 + temp2
temp2 = e * f
temp1 = temp1 + temp2
Longlong = temp1
return

------------------------------------------------------------------------------------------
```




# Makefile
- `make` will create an executable named as PL4 can be runned by
`./pl4 inputfile outputfile`
- `make file` will compile, parse, and generate an output file called output.tac and write to that file for sample input I added.
- `make stout` will compile parse, and generate an output to the standard output for sample input I added.
