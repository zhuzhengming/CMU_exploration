//
// Created by jin on 24-7-16.
//
#include <ros/ros.h>
#include <sensor_msgs/Imu.h>
#include <sensor_msgs/PointCloud2.h>
#include <std_msgs/String.h>

template <typename T>
class TimestampRepublisher {
public:
    TimestampRepublisher(ros::NodeHandle& nh, const std::string& input_topic, const std::string& output_topic) {
        // 创建发布器
        pub_ = nh.advertise<T>(output_topic, 10);
        // 订阅输入话题
        sub_ = nh.subscribe(input_topic, 10, &TimestampRepublisher::callback, this);
    }

private:
    void callback(const typename T::ConstPtr& msg) {
        // 创建新的消息
        T new_msg = *msg;
        // 重新打上当前时间戳
        new_msg.header.stamp = ros::Time::now();
        // 发布重新打上时间戳的消息
        pub_.publish(new_msg);
    }

    ros::Publisher pub_;
    ros::Subscriber sub_;
};

int main(int argc, char** argv) {
    ros::init(argc, argv, "timestamp_republisher");
    ros::NodeHandle nh;

    // 创建TimestampRepublisher对象，用于不同类型的数据
    // 转发IMU
    TimestampRepublisher<sensor_msgs::Imu> imu_republisher(nh, "/livox/imu", "/sync_imu");
    // 转发雷达帧
    TimestampRepublisher<sensor_msgs::PointCloud2> scan_republisher(nh, "/hesai/pandar", "/sync_hesai");
    // 其他
//    TimestampRepublisher<std_msgs::String> string_republisher(nh, "/string_topic", "/republished_string");

    ros::spin();

    return 0;
}
