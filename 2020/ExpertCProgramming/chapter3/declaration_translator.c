#include <stdio.h>
#include "token.h"
#include "stack.h"

char types [256][5] = {
    "int",
    "unsigned",
    "static",
    "float",
    "char"
};

struct token_group {
    struct token_t * tokens;
    uint8_t num_tokens;
};

void init_token_group(struct token_group * group, char * decl){
    group = malloc(sizeof token_group);

    //TODO: Split up the input string
}

void deinit_token_group(struct token_group * group){
    free(group);
}

char * translate_declaration(char * decl){
    struct token_group * group;
    struct token_stack * stack;
    char out_string [256];

    init_token_group(group, decl);
    init_token_stack(stack);

    compute_translation(group, stack, out_string)

    deinit_token_group(group);
    deinit_token_stack(stack);

    return out_string;
}

int main(){
    return 0;
}
