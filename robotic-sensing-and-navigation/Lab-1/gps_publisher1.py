#!/usr/bin/env python

import sys 
import lcm 
import serial
import time
import utm 
from gps_lcm import gps_msg

lc = lcm.LCM()
ser = serial.Serial('/dev/ttyACM0', 4800, timeout=2)
while True:
	line = ser.readline()
	if line.startswith('$GPGGA'):
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
	 	x = utm.from_latlon(latfinal,longitudefinal)
		utmx = x[0]
		utmy = x[1]
		print latfinal
		print longitudefinal
		print altdf
		msg = gps_msg()
		msg.time = int(time.time() * 100000)
		msg.lat = latfinal
		msg.longtd = longitudefinal
		msg.altitude = altdf 				
		msg.utm_x = utmx
		msg.utm_y = utmy
		# do similar for msg.longitude 
		# Do for all the struct field
 
		lc.publish("GPS_DATA", msg.encode())

