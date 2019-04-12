#!/usr/bin/env python
from beginner_tutorials.srv import *
import rospy
    
    def handle_ints(req):
        print "Returning [%s + %s = %s]"%(req.a, req.b, (req.a + req.b))
        return AddTwoIntsResponse(req.a + req.b)
   
   def add_ints_server():
       rospy.init_node('add_ints_server')
       s = rospy.Service('add_two_ints', AddTwoInts, handle_ints)
       print "Ready to add two ints."
       rospy.spin()
   
   if __name__ == "__main__":
      add_ints_server()
