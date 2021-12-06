#include <stdio.h>
#include <setjmp.h>

int main(void) {
    jmp_buf jb;
    int val;
    val = setjmp(jb);
    puts("Hello");
    printf("val: %u\n", val);
    if (val == 0) {
        longjmp(jb, 10);
    } else {
        puts("End");
    }
    puts("After");

    return 0;
}
