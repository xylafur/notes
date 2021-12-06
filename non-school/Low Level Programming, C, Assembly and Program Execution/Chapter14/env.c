#include <stdio.h>
#include <stdint.h>

int main(int argc, char *argv[], char *envp[])
{
    uint32_t ii;
    for (ii = 0; envp[ii] != NULL; ii++) {
        printf("Envp[%u] = %s\n", ii, envp[ii]);
    }
}
