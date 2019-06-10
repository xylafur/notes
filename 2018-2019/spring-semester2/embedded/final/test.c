#include <stdio.h>
#include <stdint.h>

int16_t min(int16_t n1, int16_t n2, int16_t n3){
    return n1 < n2 ? n1 < n3 ? n1 : n3 : n2 < n3 ? n2 : n3;
}

int main(){
    printf("%d\n", min(1, 2, 3));
    return 0;
}
