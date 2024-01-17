.set ALIGN, 1<<0
.set MEMINFO, 1<<1
.set FLAGS, ALIGN | MEMINFO
.set MAGIC, 0x1BADB002
.set CHECKSUM, (0 - (MAGIC + FLAGS))

.section .multiboot
	.align 4
	.long MAGIC
	.long FLAGS
	.long CHECKSUM

.section .bss
	// allocate memory stack for c code
	.align 16
	stack_bottom:
		.skip 16384 // amount of bytes to reserve
	stack_top:

.section .text
.global _start
.type _start, @function
_start:
	// make c env ready
	mov $stack_top, %esp

	// call c main
	call kernel_main

	// If c code returns
	hang: 
		cli 
		hlt
		jmp hang
.size _start, . - _start
