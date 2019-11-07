/*
 *  For this i am going to assume that this
 *
 *      add(5, multiply(4, 3))
 *
 *  would be given to me in a list as
 *
 *      ["4", "3", "multiply", 5, "add"]
 *
 */

/*  My example is in C, not c++.  It is valid c++ code, but c++ will complain
 *  about my pointer manipulation because I don't cast
 */
#include <string.h>
void convert_postfix(char ** input, unsigned int input_length, char * output){
    //We are assuming that the memory for output has been allocated before
    //being passed into this function and that its length is sufficient
    int index = 0, ii;
    for(ii = 0; ii < input_length; ii++){
        if(!strcmp(input[ii], "add")){
            output[index] = '+';
        }else if (!strcmp(input[ii], "multiply")){
            output[index] = '*';
        }else{
            strcpy(output + index, input[ii]);
            index += strlen(input[ii]);
        }
        //so we have a buffer in between each character or integer
        strcpy(output + index, " ");
        index += 1;
    }
}

int main(){
    /*
     *  Assuming that the parsing happens somewhere in here
     */
    char * postfix_notation = malloc(computed_length);
    convert_postfix(parsed_input, input_length, postfix_notation);
    printf("%s\n", postfix_notation);
    free(postfix_notation);
}
