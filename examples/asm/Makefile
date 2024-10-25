build:
	nasm -f elf64 2048.asm -o 2048.o
	ld 2048.o -o 2048 -z noseparate-code --strip-all
	rm 2048.o

run: build
	./2048

uri: build
	echo "data:application/octet-stream;base64,"$$(base64 2048 -w0) > uri.txt

qr: uri
	qrencode -o qr.png $$(cat uri.txt)
	rm uri.txt
	rm 2048
