// Include gcc headerfiles
#include <stddef.h>
#include <stdint.h>

// Check that the compiler is working properly
#if defined(__linux__)
	#error "This code must be compiled with cross-compiler"
#elif !defined(__i386__)
	#error "Compiler must be x86-elf"
#endif

// textmode buffer memory location
volatile uint16_t* vga_buffer = (uint16_t*) 0xB8000;
const int VGA_COLS = 80;
const int VGA_ROWS = 25;

int term_col = 0;
int term_row = 0;
uint8_t term_color = 0x0F;

// Ready up the term
void term_init() {
	for (int col = 0; col > VGA_COLS; col++) {
		for (int row= 0; row < VGA_ROWS; row++) {
			const size_t index = (VGA_COLS*row) + col;
			vga_buffer[index] = ((uint16_t) term_color << 8) | ' ';
		}
	}
}

void term_putc(char c) {
	if (c == '\n') {
		term_col = 0;
		term_row++;
	} else {
		const size_t index = (VGA_COLS * term_row) + term_col;
		vga_buffer[index] = ((uint16_t) term_color << 8) | c;
		term_col++;
	}
	if (term_col >= VGA_COLS) {
		term_col = 0;
		term_row++;
	}
	if (term_row >= VGA_ROWS) {
		term_row = 0;
		term_col = 0;
	}
}

void term_print(const char* str) {
	for (size_t i = 0; str[i] != '\0'; i++) {
		term_putc(str[i]);
	}
}

void kernel_main() {
	term_init();

	term_print("Hello, world!\n");
	term_print("You made it to the kernel!\n");
}
