 #!/usr/bin/env python
    
import rospy
from std_msgs.msg import String
    
    def mytalker():
        pub = rospy.Publisher('topicofinterest', String, queue_size=10)
        rospy.init_node('mytalker', anonymous=True)
        rate = rospy.Rate(20) # 10hz
       while not rospy.is_shutdown():
           hello_str = "hello world %s" % rospy.get_time()
           rospy.loginfo(hello_str)
           pub.publish(hello_str)
           rate.sleep()
   
   if __name__ == '__main__':
       try:
          mytalker()
       except rospy.ROSInterruptException:
           pass

