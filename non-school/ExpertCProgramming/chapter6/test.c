#include <stdio.h>

int arr [100] = {0};

int main(){
    //variables start being allocated from the top of the stack
    int i  = 9;
    int arr2[100] = {0};
    printf("Hello world! %d\n", arr2[0]);

    printf("The stack top is near: %p\n", &i);
}
