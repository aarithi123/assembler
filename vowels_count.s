.section .data

input_format:	.asciz	"Please enter a string: \n"
input_spec:		.asciz	"%[^\n]"
output_spec:	.asciz	"The number of vowels is %d \n"
input:			.space	255

.section .text

.global main

main:
	ldr X0, =input_format
	bl printf
	
	ldr X0, =input_spec
	ldr X1, =input
	bl scanf
	
	
	
	ldr x10, =input 
	add X9, xzr, xzr 
	
	add x12, xzr, xzr 

LOOP:	
	ldrb w11, [X10, x12]
    add x12, x12, #1
	CBZ X11, result 

	cmp X11, 'a'
	b.eq sum
	cmp X11, 'A'
	b.eq sum

	cmp X11, 'e'
	b.eq sum
	cmp X11, 'E'
	b.eq sum

	cmp X11, 'i'
	b.eq sum
	cmp X11, 'I'
	b.eq sum

	cmp X11, 'o'
	b.eq sum
	cmp X11, 'O'
	b.eq sum

	cmp X11, 'u'
	b.eq sum
	cmp X11, 'U'
	b.eq sum

	b LOOP

sum:	
	add X9, X9, 1
	b LOOP

result:
	ldr X0, =output_spec
	mov X1, X9
	bl printf
	b exit

eXit:
	mov X0, 0
	mov X8, 93
	svc 0
	ret
