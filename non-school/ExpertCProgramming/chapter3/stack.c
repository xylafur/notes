#include "stack.h"
#include "token.h"
#include <stdint.h>
#include <stdlib.h>

uint8_t check_stack(struct token_stack * stack){
    return stack->size != 0;
}

void token_stack_push(struct token_stack * stack, struct token_t * token){
    stack->_token_stack[stack->size++] = token;
}

struct token_t token_stack_pop(struct token_stack * stack){
    return stack->_token_stack[stack->size--];
}

void init_stack(struct token_stack * stack){
    struct stack *the_stack = malloc(sizeof struct stack);
    the_stack->size = 0;
    return the_stack;
}

//I have a feeling that I shouldn't be freeing the contents of the stack here, since I'm
//not allocating them here, but at the same time it seems to make sense, considering they
//are a part of this data structure.
void deinit_stack(struct token_stack * stack){
    uint8_t ii;
    for(ii = 0; ii < stack->size; ii++){
        free(stack->token_stack[ii]);
    }
    free(stack);
}


