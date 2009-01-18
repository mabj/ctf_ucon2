all: clean
	@echo "[+] Building challenge 01 ..."
		gcc -fno-stack-protector -ggdb -o ch_01 challenge_01.c
	@echo " "
	@echo "[+] Building challenge 02 ..."
		gcc -fno-stack-protector -ggdb -o ch_02 challenge_02.c
	@echo " "
	@echo "[+] Building challenge 03 ..."
		gcc -fno-stack-protector -ggdb -o ch_03 challenge_03.c
	@echo  " "
	@echo "[+] Building challenge 04 ..."
		gcc -fno-stack-protector -ggdb -o ch_04 challenge_04.c
	@echo " "
	@echo "[+] Building challenge 05 ..."
		gcc -fno-stack-protector -ggdb -o ch_05 challenge_05.c
	@echo " "
clean:
	@echo "[+] Cleaning ..."
	rm -rf *~ *.o ch_*
install: clean build
	@echo "[+] Install ..."