/**
* 
* Kinect Application to command the Quadrotor to take off and land and move.
*
* @Author : Raghavendra Sriram
*/

#include <ros/ros.h>
#include <tf/transform_listener.h>
#include <geometry_msgs/Twist.h>
#include<std_msgs/Empty.h>
#include<std_msgs/Float64.h>
#include <ardrone_autonomy/FlightAnim.h>
#include <ardrone_autonomy/LedAnim.h>

typedef enum
{
    NONE = 0,
    LAND = 1,
    TAKEOFF = 2

}COMMAND;

int main(int argc, char** argv)
{                                                                                                   // Initializing various nodes and Publishers.

    ros::init(argc, argv, "kinect_quad_navigation");                                                 //
    //
    ros::NodeHandle node;                                                                            //
    ros::Publisher twist_pub = node.advertise<geometry_msgs::Twist>("cmd_vel",1000);                 //
    ros::Publisher takeOff_pub = node.advertise<std_msgs::Empty>("/ardrone/takeoff",1000);      //
    ros::Publisher land_pub= node.advertise<std_msgs::Empty>("ardrone/land",1000);              //
    ros::Publisher pos_pub = node.advertise<std_msgs::Float64>("raghu/pos",1000);                    //
    ros::Publisher neg_pub = node.advertise<std_msgs::Float64>("raghu/neg", 1000);


    tf::TransformListener listener;                                                                  //

    ros::Rate rate(10.0);                                                                            //


    float pi = 3.14159265359;                                                                        // Defining constant value of Pi
    double count = 0;                                                                                // Initializing variable count for initialization sequence of the tracking.
    bool initialized = false;                                                                        //

    double min_left_shoulder = 90;                                                                   // Defining maximum value of left Shoulder angle
    double min_right_shoulder = 90;                                                                  // Defining maximum value of right Shoulder angle
    double min_left_elbow = 90;                                                                      // Defining maximum value of left Elbow angle
    double min_right_elbow = 90;                                                                     // Defining maximum value of Right Elbow angle
    COMMAND newcmd = NONE;
    COMMAND curcmd = NONE;
    COMMAND newGesture = NONE;
    COMMAND curGesture = NONE;
    int gestureTimes = 0;

    ROS_INFO("INITIALIZATION START: Please move your arms slowly along the side.");                  // Sending Output message : "INITIALIZATION START..." to Terminal To indicate to user
    // the statrt of initialization sequence

    //Start of :  MAIN LOOP
    while (node.ok())                                                                                // Starting While loop to start obtaining Transfer frame values from the Kinect(program : Kinect Angles)
    {

        // ros fuerte kinect pointcloud;
        tf::StampedTransform tf_left_shoulder;                                                        // TF of left Shoulder
        tf::StampedTransform tf_right_shoulder;                                                       // TF of Right Shoulder
        tf::StampedTransform tf_left_elbow;                                                           // TF of left Elbow
        tf::StampedTransform tf_right_elbow;                                                          // TF of Right Elbow

        ros::spinOnce();                                                                              // To repeat the loop continously and to keep obtaining data from the node.


        try
        {
            listener.lookupTransform("/neck_1","/left_shoulder_1",ros::Time(0),tf_left_shoulder);      // To get data from all the transfer frames at time 0
            listener.lookupTransform("/neck_1","/right_shoulder_1",ros::Time(0),tf_right_shoulder);    //
            listener.lookupTransform("/left_shoulder_1","/left_elbow_1",ros::Time(0),tf_left_elbow);   //
            listener.lookupTransform("/right_shoulder_1","/right_elbow_1",ros::Time(0),tf_right_elbow);//
        }
        catch (tf::TransformException ex)                                                              //
        {
            ROS_ERROR("%s",ex.what());
        }

        tf::Quaternion angle_left_shoulder;                                                           //
        tf::Quaternion angle_right_shoulder;                                                          //
        tf::Quaternion angle_left_elbow;                                                              //
        tf::Quaternion angle_right_elbow;                                                             //
        tf_left_shoulder.getBasis().getRotation(angle_left_shoulder);                                 //
        tf_right_shoulder.getBasis().getRotation(angle_right_shoulder);                               //
        tf_left_elbow.getBasis().getRotation(angle_left_elbow);                                       //
        tf_right_elbow.getBasis().getRotation(angle_right_elbow);                                     //

        double als = angle_left_shoulder.getAngle()*(180/pi);                                         //
        // ROS_INFO("Right shoulder: angle %f",als);                                                  //
        double ars = angle_right_shoulder.getAngle()*(180/pi);                                        //
        // ROS_INFO("Left shoulder: angle %f",ars);                                                   //
        double ale = angle_left_elbow.getAngle()*(180/pi);                                            //
        // ROS_INFO("Right elbow: angle %f",ale);                                                     //
        double are = angle_right_elbow.getAngle()*(180/pi);                                           //
        //   ROS_INFO("Left elbow bow: angle %f",are);                                                //


        geometry_msgs::Twist msg;
        std_msgs::Float64 posmsg;
        std_msgs::Float64 negmsg;

        // INITIALIZATION sequence
        if ( !initialized )                                                                           //
        {
            if ( als < min_left_shoulder )                                                            //
            {
                min_left_shoulder = als;                                                              // Calibrating min_left_shoulder to least value recorded
            }
            if ( ars < min_right_shoulder )                                                           //
            {
                min_right_shoulder = ars;                                                             // Calibrating min_right_shoulder to least value recorded
            }
            if ( ale < min_left_elbow )
            {
                min_left_elbow = ale;                                                                 // Calibrating min_left_elbow to least value recorded
            }
            if ( are < min_right_elbow )
            {
                min_right_elbow = are;                                                                // Calibrating min_right_elbow to least value recorded
            }
        }
        count = count + 1;                                                                            // Incrementing count for each iteration so that it continues upto 100
        // ROS_INFO("count %f",count);

        // Initialization completion display
        if ( count == 50 )                                                                            // Complete initialization when count reaches 100
        {
            initialized = true;
            ROS_INFO("INITIALIZATION DONE!");
        }

        // Identify gestures and send commands to Quadcopter
        if ( initialized == true )
        {
            double pos = 0;
            double neg = 0;
            double none = 0;

            //ROS_INFO("MINIMUM LEFT SHOULDER: angle %f",min_left_shoulder);
            //ROS_INFO("MINIMUM RIGHT SHOULDER: angle %f",min_right_shoulder);
            //ROS_INFO("MINIMUM LEFT ELBOW: angle %f",min_left_elbow);
            //ROS_INFO("MINIMUM RIGHT ELBOW: angle %f",min_right_elbow);

            // Gesture for Left hand = Take off
            if ( als >= min_left_shoulder-20 && als <= min_left_shoulder+20 &&
                 ale >= min_left_elbow-25 && ale <= min_left_elbow+25 )
            {
                //pos = 1;
                newGesture = TAKEOFF;
                //ROS_INFO("Takeoff Guesture: ARS: %f, ARE: %f, ALS: %f, ALE: %f \n", ars, are, als, ale);
            }

            // Gestmin_right_elbowure for right hand = Land
            else if ( ars >= min_right_shoulder-20 && ars <= min_right_shoulder+20 &&
                 are >= min_right_elbow-25 && are <= min_right_elbow+25 )
            {
                //neg = 1;
                newGesture = LAND;
                //ROS_INFO("Land Guesture: ARS: %f, ARE: %f, ALS: %f, ALE: %f \n", ars, are, als, ale);

            }
            else
            {
                //ROS_INFO("Unknown Guesture: ARS: %f, ARE: %f, ALS: %f, ALE: %f \n", ars, are, als, ale);
                newGesture = NONE;
            }



            msg.linear.x = 0;
            msg.linear.y = 0;
            msg.linear.z = 0;

            msg.angular.x = 0;
            msg.angular.y = 0;
            msg.angular.z = 0;

            if(newGesture != curGesture)
            {
				gestureTimes = 0;
			}
			else
			{
				gestureTimes++;
			}
			
			curGesture = newGesture;				

			
			if(gestureTimes > 10)
			{
				gestureTimes = 0;
				newcmd = newGesture;
				
				if(newcmd != curcmd)
				{
			
					//ROS_INFO("cur: %d, new: %d", curcmd, newcmd);
					curcmd = newcmd;

					switch(newcmd)
					{
						case TAKEOFF:

							takeOff_pub.publish(msg);
							ROS_INFO("Taking Off");

							break;

						case LAND:

							land_pub.publish(msg);
							ROS_INFO("Landing");

							break;

						default:

							pos = 1;
							ROS_INFO("Hovering");
					}
				}

			}
		}

        rate.sleep();

    }
    return (0);
}




