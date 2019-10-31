/*  
 *  In this function we need to:
 *      - Initialize port B as an input port
 *          - We need to enable pins 0-7 as interrupts
 *          - make the interrupts falling edge triggered
 *          - clear any existing interrupts
 *
 *      - Initialize Port C as an output port
 *          - we are using pins 0-7
 */
void init(){
    // enable ports B and C
    SYSCTL_RCGC2_R |= (0x2 | 0x4);

    // Make port B input
    GPIO_PORTB_DIR_R = 0x0;
    GPIO_PORTB_AFSEL_R = 0x0;
    GPIO_PORTB_DEN_R = 0x7F;

    // Edge triggered interrupts
    GPIO_PORTB_IS_R = 0x00;
    // We don't want both edges
    GPIO_PORTB_IBE_R = 0x00;
    // We only want falling edge
    GPIO_PORTB_IEV_R = 0x00;
    // We need to unmask our interrupts
    GPIO_PORTB_IM_R = 0x7F;
    // Clear out the old interrupts
    GPIO_PORTB_ICR_R = 0x7F;
    // Set the priority of port B to 1
    NVIC_PRIO_R = 0x2000;
    // Enable 
    NVIC_EN0_R |= 0x02;

    // Make port C output
    GPIO_PORTB_DIR_R = 0x7F;
    GPIO_PORTB_AFSEL_R = 0x0;
    GPIO_PORTB_DEN_R = 0x7F;
}


void GPIOPortB_Handler(void){
    uint8_t destination;
    // Figure out which pin the interrupt was triggered on
    switch(GPIO_PORTB_DATA_R){
        case 0x1: // Inside Elevator: Floor 1 button
            destination = 0x1;
            break;
        case 0x2: // Inside Elevator: Floor 2 button
            destination = 0x2;
            break;
        case 0x4: // Inside Elevator: Floor 3 button
            destination = 0x3;
            break;
        case 0x8: // Floor 1 up button
            destination = 0x1;
            break;
        case 0x10: // Floor 2 up button
            destination = 0x2;
            break;
        case 0x20: // Floor 2 down button
            destination = 0x2;
            break;
        case 0x40: // Floor 3 down button
            destination = 0x3;
            break;
        default:
            // We assume that only one switch can actually happen at once
            break;
    }


    // Turn on the correct LED.  We can assume that there is another interrupt
    // handler that is triggered and will turn the LED off when the elevator
    // reaches that floor
    GPIO_PORTC_DATA_R |= GPIO_PORTB_DATA_R;

    // Clear the bits that were set
    GPIO_PORTB_ICR_R = GPIO_PORTB_DATA_R; 

    // If the elevator is moving, we have to intelligently plan going to this floor
    if(is_elevator_moving()) {
        if(is_floor_on_the_way(destination)) {
            // This stop is on the way, so lets stop the elevator there and
            // pick them up
            add_stop(destination);
        } else {
            // Once we turn around we will go to this floor
            queue_destination(destination);
        }
    } else {
        // We aren't moving, just go to the requested floor
        move_to_floor(destination);
    }
}

int main(){
    init();
}
