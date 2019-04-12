#!/usr/bin/env python
import roslib 
import rospy 
import serial
from sensor_msgs.msg import NavSatFix



def rtkgps(portname,baudrate):
	pub = rospy.Publisher('rtk_fix',NavSatFix,queue_size=1)
	rospy.init_node('rtk_gps_node', anonymous=True)
	rate = rospy.Rate(10)
	ser = serial.Serial(portname, baudrate, timeout=2)
	while True:
		line = ser.readline()
		if  line.startswith('$GNGGA'):
		 	ls = line.split(",")
		 	lat = ls[2]
		 	lat1 = ls[2].strip()
		 	latf = float(lat1)
		 	latfinal = latf/100
		 	longitude = ls[4]
		 	longitude1 = ls[4].strip()
		 	longitudef = float(longitude1)
		 	longitudefinal = longitudef/100
		 	altd = ls[9].strip()
		 	altdf = float(altd)
		 	print latfinal
		 	print longitudefinal
		 	print altdf
		 	rtk_fix = NavSatFix()
				#include header and time
	         	rtk_fix.latitude = latfinal
		 	rtk_fix.longitude = longitudefinal
		 	rtk_fix.altitude = altdf
		 	pub.publish(rtk_fix)
					
if __init__ == '__main__':
	portName = rospy.get_param('port_name','default_value')
	baudRate = rospy.get_param('baud_rate','default_value')
	try:
		rtkgps(portName,baudRate)
	except rospy.ROSInterruptException:
			pass
	


