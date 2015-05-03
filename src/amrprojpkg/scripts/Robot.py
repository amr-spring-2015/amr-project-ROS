#!/usr/bin/env python
#-*- coding: utf-8 -*-
"""
@author: JD
"""

import rospy
import serial
import time
import string
from std_msgs.msg import String
from std_msgs.msg import Int16

ser = serial.Serial('/dev/rfcomm0', 460800, timeout=1)

pub = rospy.Publisher('/feedback', String, queue_size=10)


def test(data):
	print data

def robotCommand(direction, distance):
	ser.flushInput()
	ser.flushOutput()
	ser.write("@1,")
	ser.write(direction)
	ser.write(",")
	ser.write(distance)
	if direction == "1" or direction == "2": ser.write(",6,")	#Right wheel control gain for turning
	else: ser.write(",4,")						#Right wheel control gain for going straight
	if direction == "1" or direction == "2": ser.write("6,") 	#Left wheel control gain for turning
	else: ser.write("0,") 						#Left wheel is controlled by yaw when going straight
	if direction == "1" or direction == "2": ser.write("100,") 	#Yaw control gain for turning
	else: ser.write("12,") 						#Yaw control gain for going straight
	if direction == "1" or direction == "2": ser.write("60e") 	#initial PWM value for turning
	else: ser.write("60e") 						#initial PWM value for going straight

	#return False  #for debug, comment out otherwise

	cnt = ser.inWaiting()
	while cnt < 5:
		cnt = ser.inWaiting()
	s = ser.read(5)		
	L = []		
        for i in s:
		L.append(i)
	if L[0] == "@" and L[1] == "1":
		result = ord(L[3])
		if result == 1: return True
		else: return False	


def mainloop():
	while not rospy.is_shutdown():
		rospy.init_node('robot_control')
		rospy.Subscriber('/chatter', Int16, test)
		pub.publish("Y")
		if (robotCommand("0","75")): print "object found!!"
		else: print "object not found"
		time.sleep(2)
		#robotCommand("1","0")
		#time.sleep(2)

if __name__ == '__main__':
	mainloop()
