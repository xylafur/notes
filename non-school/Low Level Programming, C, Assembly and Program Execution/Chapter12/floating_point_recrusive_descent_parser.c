/*
 * Recursive descent parser to perform floating point arithmetic
 * <nonzero> ::= '1' | '2' | '3' | ... | '9'
 * <digit> ::= '0' | <nonzero>
 * <raw> ::= <digit> | <digit> <raw>
 * <float> ::= <raw> | <raw> '.' <raw>
 *
 * <expr> ::= <float> '+' <expr> | <float> '*' <expr> | <float> '-' <expr>
 */
#include <stdbool.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>

//strtof(str, NULL);

char stack [256][256] = {0};
uint32_t stack_top = 0;
char const* stream = NULL;
char word [256] = {0};
uint32_t word_loc = 0;

bool accept(char c) {
    while (*stream == ' ') {
        stream++;
    }
    if (*stream == c) {
        word[word_loc++] = *stream;
        stream++;
        return true;
    }
    return false;
}

void push(void) {
    strcpy(stack[stack_top++], word);
    word_loc = 0;
    memset(word, 0, 256);
}

void pop(char *res) {
    strcpy(res, stack[--stack_top]);
}

bool nonzero(void) {
    return accept('1') || accept('2') ||accept('3') ||accept('4') ||accept('5') ||
           accept('6') ||accept('7') ||accept('8') ||accept('9');
}
bool digit(void) {
    return accept('0') || nonzero();
}
bool raw(void) {
    if (digit()) { raw(); return true; }
    return false;
}
bool number(void) {
    if (nonzero()) {
        raw();
        return true;
    }
    return accept('0');
}

bool _float(void) {
    if (number()) {
        if (accept('.')) {
            if (number()) {
                return true;
            }
            return false;
        }
        return true;

    } else if (accept('.')) {
        if (number()) {
            return true;
        }
        return false;
    }
    return false;
}

bool expr(void) {
    if (!_float()) {
        return false;
    }
    push();
    if (accept('+') || accept('*') || accept('-')) {
        push();

        if (_float()) {
            push();
            return true;
        }
        return false;
    }
    return true;
}

void init_parser(void) {
    memset(stack, 0, 256*256);
    memset(word, 0, 256);
    stack_top = 0;
    word_loc = 0;
}

bool parse(void) {
    int32_t ii;
    bool res = expr();
    printf("Dumping stack: \n");
    for (ii = stack_top - 1; ii >= 0; ii--) {
        printf("  [%2d] %s\n", ii, stack[ii]);
    }
    return res;
}

float resolve_stack() {
    char opstack[256];
    float datastack [256];
    uint32_t ii, jj = 0, kk = 0;
    float a1, a2;
    // Realized halfway through that this is a queue I'm converting into a stack, too lazy to
    // change naming for this
    for (ii = 0; ii < stack_top; ii++) {
        printf("%s\n", stack[ii]);
        if (!strcmp(stack[ii], "*")) {
            a1 = datastack[--jj];
            a2 = strtof(stack[++ii], NULL);
            datastack[jj++] = a1 * a2;

        } else if (!strcmp(stack[ii], "+")) {
            opstack[kk++] = '+';
        } else if (!strcmp(stack[ii], "-")) {
            opstack[kk++] = '-';
        }
        printf("Pushing to datastack %u %s\n", jj, stack[ii]);
        datastack[jj++] = strtof(stack[ii], NULL);
    }
    while (kk) {
        char op = opstack[--kk];
        a1 = datastack[--jj];
        a2 = datastack[--jj];
        switch (op) {
            case '+':
                printf("%f + %f\n", a1, a2);
                datastack[jj++] = a1 + a2;
                break;
            case '-':
                datastack[jj++] = a2 - a1;
                break;
        }
    }
    return datastack[0];

}

void check(const char *string) {
    float res;
    init_parser();

    stream = string;
    printf("%s -> %d\n", string, parse());
    res = resolve_stack();
    printf("%s = %f\n", string, res);
}

int main() {
    check("5.5");
    check("1 + 2");
    check("5.5 * 5");
}
