#include <stdio.h>

int main()
{
    union {
        int a;
        float f;
    } u;

    u.f = 0.5;
    printf("%d %f\n", u.f, u.f);
    printf("%lf  %u\n", u.f, u.a);


    /*  the float is being converted into a double percision floating point value in the
     *  assembly code!
     *
     *      movss   8(%rbp), %xmm0
     *      cvtss2sd    %xmm0, %xmm1
     *
     *      Is this the thing that the book was talking about where all single percision
     *      floating point values are treated as doble percision floating point values in
     *      C???  I thought that was just for the PDP
     */
    //printf("%u %u %u\n", f, (int)0);
    //printf("%lu %lu\n", sizeof((float)0.0), sizeof((int)0));
}
