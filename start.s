.extern kernel_main

.global start

.set MB_MAGIC, 0x1BADB00
.set MB_FLAGS, (1 << 0) | (1 << 1)

.set MB_CHECKSUM, (0 - (MB_MAGIC + MB_FLAGS))

.section .multiboot
	.align 4
	.long MB_MAGIC
	.long MB_FLAGS
	.long MB_CHECKSUM

.section .bss
	// allocate memory stack for c code
	.align 16
	stack_bottom:
		.skip 4096 // amount of bytes to reserve
	stack_top:

.section .text
	// start of code, first code that runs
	start:
		// make c env ready
		mov $stack_top, %esp

		// call c main
		call kernel_main

		// If c code returns
		hang: 
			cli 
			hlt
			jmp hang
		
