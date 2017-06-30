#
#This Program allows for autonomous flight control of the ArDrone Parrot quadcopter. 
#The programs causes the parrot to hover over a particular point nd on detection of
#any obstacles, avoid the obstacles by moving backwards(i.e. -ve X axis)
#
#@Author : Raghavendra Sriram
#
#!/usr/bin/env python
#
import roslib; roslib.load_manifest('drone_teleop')
import rospy
import rosbag

from geometry_msgs.msg import Twist
from std_msgs.msg import Empty
from std_msgs.msg import Float64
from turtlesim.msg import Velocity
from turtlesim.msg import Pose
from sensor_msgs.msg import Joy
import sys, select, termios, tty
from std_msgs.msg import Int16

import time


msg = """
Perform Gesture					   
"""	 #control portal for the user							
xpos=0
ypos=0
xdis=0

Pos = 0
Neg = 0	

def callback(RecMsg):
	xpos = RecMsg.linear
	ypos = RecMsg.angular
 

	
def callback1(laserp):
	global xdis
	xdis = laserp.x	
	
def cbTakeoff(msg_takeoff): 
	global auto
	print "got takeoff callback"
	auto = True
	
def cbLand(msg_land): 	
	global auto
	print "got land callback"
	auto = False
	

if __name__=="__main__":
	
	global auto
	global xdis
	
	auto = False

	print msg
	
	pub = rospy.Publisher('cmd_vel', Twist)
	land_pub = rospy.Publisher('/ardrone/land', Empty)
	reset_pub = rospy.Publisher('/ardrone/reset', Empty)
	toggle_pub=rospy.Publisher('/ardrone/togglecam', Empty)
	takeoff_pub =rospy.Publisher('/ardrone/takeoff', Empty)
	rospy.Subscriber('/ardrone/takeoff',Empty,cbTakeoff) 
	rospy.Subscriber('/ardrone/land', Empty, cbLand) 
	rospy.Subscriber('/drocanny/vanishing_points',Velocity,callback)
	rospy.Subscriber('/drone/walldis',Pose,callback1)

	twist = Twist()
	rospy.init_node('drone_teleop')
	
	try :
		while not rospy.is_shutdown():

			if auto:
				print 'Starting Autonomous navigation'
				
				print 'autonomous Mode'
				rospy.sleep(.50)
				
				twist.linear.x=0.0
				
				print xdis
				if(xdis==1):
					twist.linear.x= -0.05
					
				pub.publish(twist)
	
	except Exception as e:
		print e
		print repr(e)
	
	finally:
		twist = Twist()
		twist.linear.x = 0 
		twist.linear.y = 0 
		twist.linear.z = 0
		twist.angular.x = 0
		twist.angular.y = 0
		twist.angular.z = 0
		pub.publish(twist)
		
