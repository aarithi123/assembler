.section .data
input_prompt:      .asciz "Input a string: "
input_spec:        .asciz "%[^\n]"
palindrome_spec:    .asciz "String is a palindrome (T/F): %c\n"
not_palindrome_spec: .asciz "String is not a palindrome (T/F): %c\n"

.section .text
.global main

main:
    //make space on stack
    sub sp, sp, #16
    str x30, [sp, #8]
    str x29, [sp, #0]
    mov x29, sp

    sub sp, sp, #512

    ldr x0, =input_prompt
    bl printf

    ldr x0, =input_spec
    mov x1, sp
    bl scanf

    //edge case - empty string
    cmp w0, #0
    b.eq is_palindrome

    //check length of input
    mov x0, sp
    bl strlen
    mov x2, x0

    //create arguments
    mov x0, sp
    mov x1, #0
    sub x2, x2, #1
    bl palindrome

    cmp w0, #0
    b.eq not_palindrome
    b is_palindrome

//true condition
is_palindrome:
    ldr x0, =palindrome_spec
    mov w1, #'T'
    bl printf
    add sp, sp, #512
    b pre_exit

//false condition
not_palindrome:
    ldr x0, =palindrome_spec
    mov w1, #'F'
    bl printf
    add sp, sp, #512

pre_exit:
    mov w0, #0
    ldr x30, [sp, #8]
    ldr x29, [sp, #0]
    b exit

# branch to this label on program completion
exit:
    mov x0, 0
    mov x8, 93
    svc 0
    ret

//recursive function
palindrome:
    //subtract to add to stack
    sub sp, sp, #16
    str x30, [sp, #8]
    str x29, [sp, #0]
    mov x29, sp

    cmp w1, w2
    b.ge palindrome_true //jump to base case

    ldrb w3, [x0, w1, UXTW]
    ldrb w4, [x0, w2, UXTW]
    cmp w3, w4
    b.ne palindrome_false

    //update indices
    add w1, w1, #1
    sub w2, w2, #1

    bl palindrome

    //restore values
    ldr x30, [sp, #8]
    ldr x29, [sp, #0]
    add sp, sp, #16
    br x30

//base case
palindrome_true:
    mov w0, #1
    ldr x30, [sp, #8]
    ldr x29, [sp, #0]
    add sp, sp, #16
    br x30

//not a palindrome - exit recursive function
palindrome_false:
    mov w0, #0
    ldr x30, [sp, #8]
    ldr x29, [sp, #0]
    add sp, sp, #16
    br x30
