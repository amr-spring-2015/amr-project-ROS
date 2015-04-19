#!/usr/bin/env python
#-*- coding: utf-8 -*-
"""
@authors: JD & CDLC
"""

import rospy
import serial
import time
import string
from std_msgs.msg import String
from std_msgs.msg import Int16

dist = "100"								#number of encoder transition for one unit of distance

robotCmd = 0								#Command from matlab

rospy.init_node('robot_control')					#Initialize ROS node

ser = serial.Serial('/dev/rfcomm0', 460800, timeout=1)			#Start serial port over bluetooth

pub = rospy.Publisher('/feedback', String, queue_size=1)		#Start the feedback topic for communication between robot and matlab

pub.publish("Y")							#Let matlab know robot is ready for first command

def getCmd(Cmd):
	global robotCmd
	robotCmd = Cmd

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
		rospy.Subscriber('/chatter', Int16, getCmd)
		while robotCmd != 1 or robotCmd != 90 or robotCmd != -90 or robotCmd != 180:	#Wait for valid command from matlab
			rospy.Subscriber('/chatter', Int16, getCmd)
		pub.publish("N")								#got valid command, publish i'm not there yet
		if robotCmd = 1:								#go forward 1 unit
			if robotCommand("0",dist):						#found an object
				pub.publish("F")						#tell matlab we found it
				break								#break out of loop (program is complete)
			else: pub.publish("Y")							#otherwise, tell matlab we are done
		else if robotCmd = 90:								#turn left 90
			robotCommand("1","0")
			pub.publish("Y")							#tell matlab we are done
		else if robotCmd = -90:								#turn right 90
			robotCommand("2","0")	
			pub.publish("Y")							#tell matlab we are done
		else if robotCmd = 180:								#turn 180
			robotCommand("1","0")
			robotCommand("1","0")
			pub.publish("Y")							#tell matlab we are done

if __name__ == '__main__':
	mainloop()
