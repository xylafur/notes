/*
 *  There are alot of bugs in this code.......
 *
 *  I described it as it is behaving, not as it should be behaving.
 */

void Switch_Init()
{
    volatile unsigned long loop1;           // This is a unused variable.
    SYSCTL_RCGC2_R |= SYSCTL_RCGC2_GPIOG;   // Enables port G
    loop1 = SYSCTL_RCGC2_R;                 // This does nothing, loop1 exists on stack and is never used
    GPIO_PORTG_DIR_R &= ~0x78;              // Makes port g pins 0, 1, 2 and 7 input
    GPIO_PORTG_AFSEL_R &= 0x00;             // Disables all alternative functions
    GPIO_PORTG_DEN_R |= 0x78;               // Enables pins 3, 4, 5 and 6
    GPIO_PORTG_PUR_R |= 0x78;               // enable pullup resistors for 3, 4, 5, 6
}

void Led_Init()
{
    volatile unsigned long loop2;           // Another unused variable
    SYSCTL_RCGC2_R |= SYSCTL_RCGC2_GPIOD;   // Enables port D
    Loop2 = SYSCTL_RCGC2_R;                 // Useless statement
    GPIO_PORTD_DIR_R |= 0x0F;               // Makes port D pins 0, 1, 2, 3 output
    GPIO_PORTG_AFSEL_R &= 0x00;             // disables alternative functions for port G
    GPIO_PORTD_DEN_R |= 0x0F;               // Enables pins 0 - 3
}

// Calls the incorrectly written init functions and then does stuff.
int main()
{
    Switch_Init();
    Led_Init();
    //…
    ////Do stuff
    ////…
}
