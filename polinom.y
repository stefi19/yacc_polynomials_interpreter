%{
    #include <stdio.h>
    #include <stdlib.h>

    //prototypes of the functions from user subrutines
    void initialize_array(int arr[10]);
    void add_arrays(int arr1[10], int arr2[10], int result[10]);
    void subtract_arrays(int arr1[10], int arr2[10], int result[10]);
    void print_array(int arr[10]);
    void yyerror(const char *s);
    int yylex(void);
%}

%union{ int ival; int array[10];}

%left '+' '-'
%token <ival> NUMBER
%token VAR

%type <array> expr monom

%%

file:
| file expr '\n' {print_array($2);}
| file '\n'
|
;

expr: expr '+' expr {add_arrays($1, $3, $$);}
| expr '-' expr {subtract_arrays($1, $3, $$);}
| '(' expr ')' {for(int i=0; i<10; i++) $$[i]=$2[i];}
| monom
;

monom: NUMBER '*' VAR '^' NUMBER {initialize_array($$); $$[$5]=$1;}
| NUMBER '*' VAR {initialize_array($$); $$[1]=$1;}
| VAR '^' NUMBER {initialize_array($$); $$[$3]=1;}
| VAR {initialize_array($$); $$[1]=1;}
| NUMBER {initialize_array($$); $$[0]=$1;}
;

%%

void initialize_array(int arr[10]) {
    for (int i = 0; i < 10; i++) {
        arr[i] = 0;
    }
}

void add_arrays(int arr1[10], int arr2[10], int result[10]) {
    for (int i = 0; i < 10; i++) {
        result[i] = arr1[i] + arr2[i];
    }
}

void subtract_arrays(int arr1[10], int arr2[10], int result[10]) {
    for (int i = 0; i < 10; i++) {
        result[i] = arr1[i] - arr2[i];
    }
}

void print_array(int arr[10]) {
    for(int i=0; i<10; i++) {
        if(arr[i] != 0) {
            if(i == 0) {
                printf("%d", arr[i]);
            } else {
                printf(" + %dx^%d", arr[i], i);
            }
        }
    }
    printf("\n");
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
