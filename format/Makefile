all: clean
	@echo "[+] Building challenge 01 ..."
		gcc -fno-stack-protector -ggdb -o ch_01 challenge_01.c
	@echo " "
	@echo "[+] Building challenge 02 ..."
		gcc -fno-stack-protector -ggdb -o ch_02 challenge_02.c
	@echo " "
clean:
	@echo "[+] Cleaning ..."
	rm -rf *~ *.o ch_*
install: clean build
	@echo "[+] Install ..."