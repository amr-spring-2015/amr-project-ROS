#!/usr/bin/env python
#-*- coding: utf-8 -*-
"""
@author: JD
"""

import rospy
import serial
import Tkinter as tk

global prevf
global prevb
global prevl
global prevr
prevf = 0
prevb = 0
prevl = 0
prevr = 0

ser = serial.Serial('/dev/rfcomm0', 460800, timeout=1)

def keypress(event):
	global prevf
	global prevb
	global prevl
	global prevr
	if event.keysym == 'Escape':
		root.destroy()
	x = event.char
	if x == "f":
		if prevf == 0:
			ser.write("@1,1,128,1,128e")
			print "forward\r\n"
			prevf = 1
		else:
			ser.write("@1,1,0,1,0e")
			prevf = 0
	if x == "b":
		if prevb == 0:
			ser.write("@1,0,128,0,128e")
			print "back\r\n"
			prevb = 1
		else:
			ser.write("@1,1,0,1,0e")
			prevb = 0
	if x == "r":
		if prevl == 0:
			ser.write("@1,1,128,0,128e")
			print "left\r\n"
			prevl = 1
		else:
			ser.write("@1,1,0,1,0e")
			prevl = 0
	if x == "l":
		if prevr == 0:		
			ser.write("@1,0,128,1,128e")
			print "right\r\n"
			prevr = 1
		else:
			ser.write("@1,1,0,1,0e")
			prevr = 0	

root = tk.Tk()
print "Press (f)orward (b)ack (r)ight (l)eft (Escape key to exit):"
root.bind_all('<Key>', keypress)
root.mainloop()

def mainloop():
	print "main loop"
		
if __name__ == '__main__':
	mainloop()

