#!/usr/bin/env python

import roslib
import rospy 

if __name__ == '__main__':
	rospy.init_node('parameter_fetcher')
	parameter = rospy.get_param('vaibhavparam', 'default value')
	print parameter

rospy.spin()
