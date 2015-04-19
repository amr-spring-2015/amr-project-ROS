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
	while not rospy.is_shutdown():
		ser.flushInput()
		ser.flushOutput()
		ser.write("@10e")
		cnt = ser.inWaiting()		
		tin = tout = time.clock()		
		while cnt < 12 and tout-tin < 1:
			cnt = ser.inWaiting()
			tout = time.clock()					
		if tout-tin < 1:
			s = ser.read(12)		
			L = []		
			for i in s:
				L.append(i)
			if L[0] == "@" and L[1] == "1" and L[2] == "0":		
				for i in range(len(L)):
					L[i] = ord(L[i])
				ax = L[4]<<8|L[6]
				ay = L[8]<<8|L[10]
				print "x: ",ax," y: ",ay,"\r"
			else: pass
		else: pass

if __name__ == '__main__':
	mainloop()
