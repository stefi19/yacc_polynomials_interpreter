%{
    #include <stdio.h>
    #include <stdlib.h>

    // prototypes of the functions from user subrutines
    void initialize_array(int arr[10][10]);
    void add_arrays(int arr1[10][10], int arr2[10][10], int result[10][10]);
    void subtract_arrays(int arr1[10][10], int arr2[10][10], int result[10][10]);
    void print_array(int arr[10][10]);
    void yyerror(const char *s);
    void multiply_arrays(int arr1[10][10], int arr2[10][10], int result[10][10]);
    void derive_array(int arr[10][10], int result[10][10]);
    int compute_value(int arr[10][10], int x);
    int yylex(void);
%}

%union{ int ival; int array[10][10]; }

%left '+' '-'
%left '*'
%left '^'

%token <ival> NUMBER
%token VARX
%token VARY
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
| '(' expr ')' {
        for(int i = 0; i < 10; i++) {
            for(int j = 0; j < 10; j++) {
                $$[i][j] = $2[i][j];
            }
        }
    }
| '(' expr ')' '\'' { derive_array($2, $$); }
| monom {
        for(int i = 0; i < 10; i++) {
            for(int j = 0; j < 10; j++) {
                $$[i][j] = $1[i][j];
            }
        }
    }
;

expr_int: VALUE '[' expr ',' NUMBER ']' { $$ = compute_value($3, $5); }
;

monom: NUMBER {
        initialize_array($$);
        $$[0][0] = $1;
    }
| VARX {
        initialize_array($$);
        $$[1][0] = 1;
    }
| VARY {
        initialize_array($$);
        $$[0][1] = 1;
    }
| VARX '^' NUMBER {
        initialize_array($$);
        $$[$3][0] = 1;
    }
| VARY '^' NUMBER {
        initialize_array($$);
        $$[0][$3] = 1;
    }
;

%%

void initialize_array(int arr[10][10]) {
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            arr[i][j] = 0;
        }
    }
}

void add_arrays(int arr1[10][10], int arr2[10][10], int result[10][10]) {
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            result[i][j] = arr1[i][j] + arr2[i][j];
        }
    }
}

void subtract_arrays(int arr1[10][10], int arr2[10][10], int result[10][10]) {
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            result[i][j] = arr1[i][j] - arr2[i][j];
        }
    }
}

void print_array(int arr[10][10]) {
    int printed = 0;

    for(int i = 0; i < 10; i++) {
        for(int j = 0; j < 10; j++) {
            if(arr[i][j] != 0) {
                if(printed == 0) {
                    if(arr[i][j] < 0) {
                        printf("-");
                    }
                } else {
                    if(arr[i][j] < 0) {
                        printf(" - ");
                    } else {
                        printf(" + ");
                    }
                }

                int coef = arr[i][j];

                if(coef < 0) {
                    coef = -coef;
                }

                if(i == 0 && j == 0) {
                    printf("%d", coef);
                } else {
                    if(coef != 1) {
                        printf("%d*", coef);
                    }

                    if(i != 0) {
                        printf("X");

                        if(i != 1) {
                            printf("^%d", i);
                        }
                    }

                    if(i != 0 && j != 0) {
                        printf("*");
                    }

                    if(j != 0) {
                        printf("Y");

                        if(j != 1) {
                            printf("^%d", j);
                        }
                    }
                }

                printed = 1;
            }
        }
    }

    if(printed == 0) {
        printf("0");
    }

    printf("\n");
}

void multiply_arrays(int arr1[10][10], int arr2[10][10], int result[10][10]) {
    int temp[10][10] = {0};

    for (int i1 = 0; i1 < 10; i1++) {
        for (int j1 = 0; j1 < 10; j1++) {
            for (int i2 = 0; i2 < 10; i2++) {
                for (int j2 = 0; j2 < 10; j2++) {
                    if (i1 + i2 < 10 && j1 + j2 < 10) {
                        temp[i1 + i2][j1 + j2] += arr1[i1][j1] * arr2[i2][j2];
                    }
                }
            }
        }
    }

    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            result[i][j] = temp[i][j];
        }
    }
}

void derive_array(int arr[10][10], int result[10][10]) {
    initialize_array(result);

    // derivative with respect to Y
    for (int i = 0; i < 10; i++) {
        for (int j = 1; j < 10; j++) {
            result[i][j - 1] = arr[i][j] * j;
        }
    }
}

int compute_value(int arr[10][10], int x) {
    int result = 0;
    int power_x = 1;

    for (int i = 0; i < 10; i++) {
        int power_y = 1;

        for (int j = 0; j < 10; j++) {
            result += arr[i][j] * power_x * power_y;
            power_y *= x;
        }

        power_x *= x;
    }

    return result;
}

