#ifndef TOKEN_HEADER
#define TOKEN_HEADER

#define MAX_TOKEN_LENGTH 256

typedef enum {
    IDENTIFIER,
    ARRAY,
    FUNC_PARENTH,
    OPEN_PARENTH,
    CLOSE_PARENTH,
    CONST,
    VOLATILE,
    POINTER,
    TYPE
} token_e;

struct token_t {
    token_e type;
    char val [MAX_TOKEN_LENGTH];
};

token_e get_token_type(char * str);

#endif
