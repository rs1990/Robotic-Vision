/*
*
* kinectAngles: creates a ROS node that generates human joint angles based on kinect information.
*
*@Author : Raghavendra Sriram
*/

#include <ros/ros.h>
#include <tf/transform_listener.h>

int main(int argc, char** argv){

  ros::init(argc, argv, "my_tf_listener");

  ros::NodeHandle node;

  tf::TransformListener listener;

  ros::Rate rate(10.0);

float pi = 3.14159265359;

  while (node.ok()){


    tf::StampedTransform sh_transform;
    tf::StampedTransform el_transform, tr_transform, hp_transform;
    tf::Transform test;
    

    ////////////////////////////////////////////////
    // RIGHT ARM
    ////////////////////////////////////////////////
    try
    {
      listener.lookupTransform("/neck_1", "/left_shoulder_1",  
                               ros::Time(0), sh_transform);
    }
    catch (tf::TransformException ex){
      ROS_ERROR("%s",ex.what());
    }
    

    try{
          listener.lookupTransform("/left_shoulder_1", "/left_elbow_1",
                                   ros::Time(0), el_transform);
    }
    catch (tf::TransformException ex){
      ROS_ERROR("%s",ex.what());
    }

    double Rs,Re,Ps,Pe,Ys,Ye,el, temp;
    tf::Quaternion angRE;
    

    //For the shoulder pitch and yaw are switched
    sh_transform.getBasis().getRPY(Rs, Ps, Ys);
    
    el_transform.getBasis().getRotation(angRE);
              
    // right shoulder roll pitch yaw
    ROS_INFO("Right shoulder Rs: %f Ps: %f Ys: %f",Rs*(180/pi),Ps*(180/pi),Ys*(180/pi));
    ROS_INFO("right elbow angle = %f",angRE.getAngle()*(180/pi));

    try
    {
      listener.lookupTransform("/right_foot_1", "/torso_1",  
                               ros::Time(0), tr_transform);
    }
    catch (tf::TransformException ex){
      ROS_ERROR("%s",ex.what());
    }	

    double Rt,Pt,Yt;
    tr_transform.getBasis().getRPY(Rt, Pt, Yt);

    ROS_INFO("Torso Rt: %f Pt: %f Yt: %f",Rt*(180/pi),Pt*(180/pi),Yt*(180/pi));
        
    try
    {
      listener.lookupTransform("/torso_1", "/right_hip_1",  
                               ros::Time(0), hp_transform);
    }
    catch (tf::TransformException ex){
      ROS_ERROR("%s",ex.what());
    }	

    double Rh,Ph,Yh;
    hp_transform.getBasis().getRPY(Rh, Ph, Yh);

    ROS_INFO("left hip Rh: %f Ph: %f Yh: %f",Rh*(180/pi),Ph*(180/pi),Yh*(180/pi));

    //For elbow
    el_transform.getBasis().getRPY(temp, el, temp);


    rate.sleep();
  }
  return 0;
};
