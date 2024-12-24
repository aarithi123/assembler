.data
get_input_string:  .asciz "Enter two decimal integers and an operator (+ - / *):\n"
invalid_operand_string: .asciz "Error: invalid operator \n"
divide_by_zero_string: .asciz "Error: divide by zero \n"
result_string:      .asciz "Result: %d\n"
charFormat:        .asciz "%c"
intFormat:          .asciz "%d"
inputFormat:        .asciz "%d %d %c"
debug_text:        .asciz "debug"

int1:              .space 4
int2:              .space 4
sign:              .space 1

.text
.global main

main:
    // Prompt user for input
    ldr x0, =get_input_string
    bl printf

    // Read two integers and an operator
    ldr x0, =inputFormat  // Input format string
    ldr x1, =int1        // Address to store first integer
    ldr x2, =int2        // Address to store second integer
    ldr x3, =sign        // Address to store operator
    bl scanf              // Get input from user
                          // scanf puts write value into address provided by x1,x2,x3 ie address of int1, int2 and sign
                          // scanf deos not put read value into registers

    // Load inputs into registers
    ldr x1, =int1        // Load address of int1 into x1
    ldr x2, =int2        // Load address of int2 into x2
    ldr x3, =sign      // Load address of sign inot x3


    ldr x4, [x1]      // read value from int1 into x1
    ldr x5, [x2]      // read value from int2 into x2
    ldr x6, [x3]      // read value from sign inot x3

    // Check for the operator and perform the corresponding operation
    cmp x6, #'+'          // Check for addition
    beq add_operation

    cmp x6, #'-'          // Check for subtraction
    beq sub_operation

    cmp x6, #'*'          // Check for multiplication
    beq mul_operation

    cmp x6, #'/'          // Check for division
    beq div_operation

    // If invalid operator
    ldr x0, =invalid_operand_string
    bl printf
    b exit

add_operation:
    add x1, x4, x5        // A + B
    b print_result

sub_operation:
    sub x1, x4, x5        // A - B
    b print_result

mul_operation:
    mul x1, x4, x5        // A * B
    b print_result

div_operation:
    cmp x2, #0            // Check for division by zero
    beq div_by_zero
    sdiv x1, x4, x5      // A / B
    b print_result

div_by_zero:
    ldr x0, =divide_by_zero_string
    bl printf
    b exit

print_result:
    ldr x0, =result_string // Load result format string
    bl printf              // Print result
    b exit

exit:
    mov x0, #0
    mov x8, #93
    svc #0
