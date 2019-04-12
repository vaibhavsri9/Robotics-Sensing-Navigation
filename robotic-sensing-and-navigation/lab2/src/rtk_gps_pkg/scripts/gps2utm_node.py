#!/usr/bin/env python
import roslib
import rospy
import utm
from sensor_msgs.msg import *
from  nav_msgs.msg import *
from geometry_msgs.msg import *


def callback(data):
	rospy.loginfo(rospy.get_caller_id())
	longitude = data.longitude
	latitude = data.latitude
	altitude = data.altitude
	x = utm.from_latlon(latitude,longitude)
	print longitude
	print latitude
	print altitude
	utm_pub = rospy.Publisher("utm_fix", Odometry, queue_size=10)
	odom = Odometry()
	odom.pose.pose.position.x = x[0]
	odom.pose.pose.position.y = x[1]
	odom.pose.pose.position.z = altitude
	utm_pub.publish(odom) 	
	pt = Point()
	pt.x = x[0]
	pt.y =x[1]
	pt.z = altitude

def gps2utm():
	rospy.init_node('gps2utm', anonymous=True)
	rospy.Subscriber("rtk_fix", NavSatFix, callback)
	rospy.spin()

if __name__ == '__main__':
	try:	
	    gps2utm()
	except rospy.ROSInterruptException:
		pass

