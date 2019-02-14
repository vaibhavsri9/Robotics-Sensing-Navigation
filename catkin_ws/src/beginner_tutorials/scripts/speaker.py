#!/usr/bin/env python
import rospy 
from std_msgs.msg import String 
 
def speaker():
	pub = rospy.Publisher('chatter', String, queue_size=10)
	rospy.init_node('speaker', anonymous=True)
	rate = rospy.Rate(10) 
	while not rospy.is_shutdown():
		hello_str = "message sent %s"% rospy.get_time()
		rospy.loginfo(hello_str)
		pub.publish(hello_str)
		rate.sleep()

if __name__=='__main__':
	try:
		speaker()
	except rospy.ROSInterruptException:
		pass	
