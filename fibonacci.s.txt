.section .data

input_prompt:   .asciz  "Please enter a number betwen 1 and 10 \n"
input_spec:     .asciz  "%d"
fib_format:     .asciz  "%d\n"
oob_message:    .asciz  "Input is out of bounds \n"

.section .text

.global main

main:
    // Prompt user for input
    adr x0, input_prompt    // Load address of input prompt
    bl printf               // Call printf to display the prompt

    // Read user input
    sub sp, sp, #8          // Allocate stack space
    mov x1, sp              // Set x1 to point to the top of the stack
    adr x0, input_spec      // Load input specifier
    bl scanf                // Call scanf to read user input

    // Load input from the stack
    ldrsw x3, [sp]          // Load input value from the stack
    add sp, sp, 8           // Adjust stack pointer to deallocate space

    // Check if input is between 1 and 10
    cmp x3, #1              // Compare input with 1
    blt out_of_bounds       // Branch if less than 1
    cmp x3, #10             // Compare input with 10
    bgt out_of_bounds       // Branch if greater than 10

    // Compute Fibonacci
    mov x0, x3              // Set x0 to the input value
    sub sp, sp, #8
    stur x30, [sp, #0]
    bl fib_recursive        // Call the Fibonacci recursive function
    ldr x30, [sp, #0]
    add sp, sp, #8

    // Display the result
    ldr x0, = fib_format    // Load address of Fibonacci format specifier
    mov x1, x3              // Set x1 to the Fibonacci result
    bl printf               // Call printf to display the result

    b exit                  // Exit the program

out_of_bounds:
    // Display out of bounds message
    adr x0, oob_message     // Load address of out of bounds message
    bl printf               // Call printf to display the message
    b exit                  // Exit the program

fib_recursive:
    // Prologue
    sub sp, sp, #32         // Allocate space on the stack
    stur x0, [sp, #0]       // Store x0 (argument)
    stur x1, [sp, #8]       // Store x1 (argument)
    stur x29, [sp, #16]     // Store x29 (frame pointer)
    stur x30, [sp, #24]     // Store x30 (return address)

    // Base cases
    cmp x0, #1              // Compare input with 1
    beq fib_base_case       // Branch if equal to 1
    cmp x0, #2              // Compare input with 2
    beq fib_base_case2      // Branch if equal to 2

    // Recursive case: fib(n-1)
    sub x0, x0, #1          // Decrement input by 1
    bl fib_recursive        // Call fib_recursive(n-1)

    // Restore
    ldur x0, [sp, #0]       // Load x0 (argument)
    ldur x1, [sp, #8]       // Load x1 (argument)
    ldur x29, [sp, #16]     // Load x29 (frame pointer)
    ldur x30, [sp, #24]     // Load x30 (return address)
    add sp, sp, #32         // Deallocate space on the stack
   
    // Recursive case: fib(n-2)
    add x1, x3, #0          // Copy Fibonacci result to x1
    sub sp, sp, #32         // Allocate space on the stack
    stur x0, [sp, #0]       // Store x0 (argument)
    stur x1, [sp, #8]       // Store x1 (argument)
    stur x29, [sp, #16]     // Store x29 (frame pointer)
    stur x30, [sp, #24]     // Store x30 (return address)
    sub x0, x0, #2          // Decrement input by 2
    bl fib_recursive        // Call fib_recursive(n-2)
    
    //Restore
    ldur x0, [sp, #0]       // Load x0 (argument)
    ldur x1, [sp, #8]       // Load x1 (argument)
    ldur x29, [sp, #16]     // Load x29 (frame pointer)
    ldur x30, [sp, #24]     // Load x30 (return address)
    add sp, sp, #32         // Deallocate space on the stack

    // Epilogue
    add x3, x3, x1          // Add fib(n-1) and fib(n-2) to get fib(n)
    ret                      // Return to the caller

fib_base_case:
    mov x3, #0               // Return 0
    ldur x0, [sp, #0]       // Load x0 (argument)
    ldur x1, [sp, #8]       // Load x1 (argument)
    ldur x29, [sp, #16]     // Load x29 (frame pointer)
    ldur x30, [sp, #24]     // Load x30 (return address)
    add sp, sp, #32         // Deallocate space on the stack
    ret

fib_base_case2:
    mov x3, #1               // Return 1
    ldur x0, [sp, #0]       // Load x0 (argument)
    ldur x1, [sp, #8]       // Load x1 (argument)
    ldur x29, [sp, #16]     // Load x29 (frame pointer)
    ldur x30, [sp, #24]     // Load x30 (return address)
    add sp, sp, #32         // Deallocate space on the stack
    ret

exit:
    // Exit the program
    mov x0, 0
    mov x8, 93
    svc 0
    ret
