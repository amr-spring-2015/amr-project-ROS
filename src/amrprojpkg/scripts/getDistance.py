#!/usr/bin/env python
#-*- coiding: utf-8 -*-
"""
@author: JD
"""

import rospy
import serial
import time
import string

ser = serial.Serial('/dev/rfcomm0', 460800, timeout=1)

def twosComp(val, bits):
	if (val & (1 << (bits - 1))) != 0:	# if sign bit is set
        	val = val - (1 << bits)        	# compute negative value
    	return val                        	# return positive value as is

def mainloop():
	ser.write("@1,1,128,1,128e")
        time.sleep(1)
	while not rospy.is_shutdown():
		#ser.write("@1,1,1,1,1e")		
		ser.flushInput()
		ser.flushOutput()
		ser.write("@2e")
		cnt = ser.inWaiting()		
		tin = tout = time.clock()		
		while cnt < 12 and tout-tin < 1:
			cnt = ser.inWaiting()
			tout = time.clock()					
		if tout-tin < 1:
			s = ser.read(11)		
			L = []		
			for i in s:
				L.append(i)
			if L[0] == "@" and L[1] == "2":					
				rwh = ord(L[3])
				rwl = ord(L[5])
				lwh = ord(L[7])
				lwl = ord(L[9])
				rw = rwh*256 + rwl
				lw = lwh*256 + lwl
				print "rw counts: ",rw," lw counts: ",lw,"\r"
			else: pass
		else: pass
		#time.sleep(1)

if __name__ == '__main__':
	mainloop()
