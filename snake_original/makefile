all:
	nasm -f bin snake.asm -o snake.bin
run:
	qemu-system-i386 -drive format=raw,file=snake.bin