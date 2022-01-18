/* Label the program's entry point */
ENTRY(reset_handler)

/* End of Ram/ start of the stack */
/* $KB of SRAM */
_estack = 0x20001000;

/* Set the minimum size for stack and dynamic memory.
 * The linker will generate an error if there is less than this much ram
 * leftover */
_Min_Leftover_RAM = 0x400;

MEMORY
{
    FLASH ( rx )        : ORIGIN = 0x08000000, LENGTH = 32K
    RAM ( rxw )         : ORIGIN = 0x20000000, LENGTH = 4K
}

SECTIONS
{
    /* The vector table goes at the start of flash */
    .vector_table :
    {
        . = ALIGN(4);
        KEEP (*(.vector_table))
        . = ALIGN(4);
    } >FLASH

    /* Text section contains the main program code */
    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.text*)
        . = ALIGN(4);
    } >FLASH

    /* The rodata section contains read-only data, constants, strings, any
     * information that won't change (readonly)
     */
    .rodata :
    {
        . = ALIGN(4);
        *(.rodata)
        *(.rodata*)
        . = ALIGN(4);
    } >FLASH

    /* The 'data' section is space set aside in RAM for things like variables
     * (changable things) */
    _sidata = .;
    .data : AT(_sidata)
    {
        . = ALIGN(4);
        /* Mark the start and end locations for the data sections */
        _sdata = .;
        *(.data)
        *(.data*)
        _edata = .;
        . = ALIGN(4);
    } >RAM

    /* The bss section is similar to the data section, but it is initialized to
     * all 0s at the beginning of the start of the program */
    .bss :
    {
        . = ALIGN(4);
        /* We mark the start and end of the bss section as well */
        _sbss = .;
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } >RAM

    /* Set space asside for the applications heap / stack */
    .dynamic_allocations :
    {
        . = ALIGN(4);
        _ssystem_ram = .;
        . = . + _Min_Leftover_RAM;
        . = ALIGN(4);
        _esystem_ram = .;
    } >RAM

}
