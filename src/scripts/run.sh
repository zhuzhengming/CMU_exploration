#!/bin/bash
   
   # Source ROS1 environment
    source /opt/ros/noetic/setup.bash
    source ~/workspace/two_ws/devel/setup.bash
    echo "ROS1 environment sourced."
    gnome-terminal -- bash -c "roslaunch exploration_go2 GO2.launch; exec bash"


    # Source ROS2 environment
    source /opt/ros/foxy/setup.bash
    source ~/workspace_ros2/install/setup.bash
    echo "ROS2 environment sourced."
    gnome-terminal -- bash -c "ros2 launch control control_bridge.launch.py method:=CMU; exec bash"
