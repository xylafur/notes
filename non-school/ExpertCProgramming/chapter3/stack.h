#ifndef STACK_HEADER
#define STACK_HEADER

#define MAX_STACK_SIZE 256

struct token_stack {
    struct token_t * _token_stack [MAX_STACK_SIZE];
    uint8_t size;
};

uint8_t check_stack(struct stack * stack);

void token_stack_push(struct stack * stack, struct token_t * token);

struct token_t token_stack_pop(struct stack * stack);

struct stack * init_stack();

void deinit_stack(struct stack * stack);

#endif
