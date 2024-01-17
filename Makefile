set_env:
	export PREFIX="$HOME/opt/cross"
	export TARGET=i686-elf
	export PATH="$PREFIX/bin:$PATH"

make:
	i686-elf-as boot.s boot.o
	i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
link:
	i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

verify_multiboot:
	grub-file --is-x86-multiboot myos.bin
	echo $?

clean: 
	rm -f *.o
	rm -f *.bin
	rm -rf isodir
