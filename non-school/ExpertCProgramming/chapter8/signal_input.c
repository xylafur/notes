#include <stdio.h>
#include <signal.h>

void my_handler(int sig)
{
    // you should never make function calls from inside a signal, but this is just for
    // exercise
    printf("In %s\n", __func__);
}

int main()
{
    int st;
    struct sigaction my_sig = {0};
    my_sig.sa_handler = &my_handler;

    st = sigaction(SIGIO, &my_sig, 0);
    if(st){
        printf("Error running sigaction!\n");
        return 1;
    }
    while(1){
    }

}
