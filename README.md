

# PL4
PL4 is just a simple language we studied in the 'Compiler Design' course in Sabanci University.

The languages grammar is defined as:

<img src="https://raw.githubusercontent.com/eralpsahin/pl4-to-tac/master/PL4_Grammar.png">

# Three Address Code (TAC)
It is an intermediate code used to optimising compilers to aid in the implementation of code-improving transformations. Since each TAC instruction has at most three operands, it is suitable for optimisations such as, register and memory allocation.


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

# Makefile
- `make` will create an executable named as PL4 can be runned by
`./pl4 inputfile outputfile`
- `make file` will compile, parse, and generate an output file called output.tac and write to that file for sample input I added.
- `make stout` will compile parse, and generate an output to the standard output for sample input I added.
