%{
    #include <stdio.h>
    #include <stdlib.h>

    // prototypes of the functions from user subrutines
    void initialize_array(int arr[10]);
    void add_arrays(int arr1[10], int arr2[10], int result[10]);
    void subtract_arrays(int arr1[10], int arr2[10], int result[10]);
    void print_array(int arr[10]);
    void yyerror(const char *s);
    void multiply_arrays(int arr1[10], int arr2[10], int result[10]);
    void derive_array(int arr[10], int result[10]);
    int compute_value(int arr[10], int x);
    int yylex(void);
%}

%union{ int ival; int array[10]; }

%left '+' '-'
%left '*'
%left '^'

%token <ival> NUMBER
%token VAR
%token VALUE

%type <array> expr monom
%type <ival> expr_int

%%

file:
| file expr '\n' { print_array($2); }
| file expr_int '\n' { printf("%d\n", $2); }
| file '\n'
|
;

expr: expr '+' expr { add_arrays($1, $3, $$); }
| expr '-' expr { subtract_arrays($1, $3, $$); }
| expr '*' expr { multiply_arrays($1, $3, $$); }
| '(' expr ')' { for(int i = 0; i < 10; i++) $$[i] = $2[i]; }
| '(' expr ')' '\'' { derive_array($2, $$); }
| monom { for(int i = 0; i < 10; i++) $$[i] = $1[i]; }
;

expr_int: VALUE '[' expr ',' NUMBER ']' { $$ = compute_value($3, $5); }
;

monom: NUMBER '*' VAR '^' NUMBER {
        initialize_array($$);
        $$[$5] = $1;
    }
| NUMBER '*' VAR {
        initialize_array($$);
        $$[1] = $1;
    }
| VAR '^' NUMBER {
        initialize_array($$);

        if($3 >= 10) {
            yyerror("Exponent too large");
            YYERROR;
        }

        $$[$3] = 1;
    }
| VAR {
        initialize_array($$);
        $$[1] = 1;
    }
| NUMBER {
        initialize_array($$);
        $$[0] = $1;
    }
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
    int printed = 0;

    for(int i = 9; i >= 0; i--) {
        if(arr[i] != 0) {
            if(printed == 0) {
                if(arr[i] < 0) {
                    printf("-");
                }
            } else {
                if(arr[i] < 0) {
                    printf(" - ");
                } else {
                    printf(" + ");
                }
            }

            int coef = arr[i];

            if(coef < 0) {
                coef = -coef;
            }

            if(i == 0) {
                printf("%d", coef);
            } else {
                printf("%dY^%d", coef, i);
            }

            printed = 1;
        }
    }

    if(printed == 0) {
        printf("0");
    }

    printf("\n");
}

void multiply_arrays(int arr1[10], int arr2[10], int result[10]) {
    int temp[10] = {0};
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            if (i + j < 10) {
                temp[i + j] += arr1[i] * arr2[j];
            }
        }
    }
    for (int i = 0; i < 10; i++) {
        result[i] = temp[i];
    }
}

void derive_array(int arr[10], int result[10]) {
    for (int i = 0; i < 10; i++) {
        result[i] = 0;
    }

    for (int i = 1; i < 10; i++) {
        result[i - 1] = arr[i] * i;
    }
}

int compute_value(int arr[10], int x) {
    int result = 0;
    int power = 1;

    for (int i = 0; i < 10; i++) {
        result += arr[i] * power;
        power *= x;
    }

    return result;
}
