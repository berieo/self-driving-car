import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Window 2.0

import dw.FollowGoRobot1 1.0

Window {
    visible: true
    width: 640
    height:480


    FollowGoRobot1
    {
        id: robot
        x: 10
        y: 10
        width: 640
        height: 480
        onCalResult:
        {

        }

        Button {
            id: cali
            x: 489
            y: 95
            width: 114
            height: 40
            text: qsTr("Calibrate")
            onClicked:
            {
                robot.captureOneCameraforCali();
                //robot.resetCameraCaliPics();
            }
        }
    }

Button {
    id: button
    x: 496
    y: 20
    text: qsTr("open")
    onClicked:
    {
        if(robot.openCamera("/dev/video0") >= 0)
       //if(v4l2.openCamera("/dev/video0", 0, 1) >= 0)
        label2.text += "open ok\r\n";
        else
        label2.text += "open fail\r\n";


        if(robot.setFMT(640,480,"V4L2_PIX_FMT_YUYV") >= 0)
        //if(robot.setFMT(320,240,"V4L2_PIX_FMT_YUYV") >= 0)
        //if(v4l2.setFMT(320,240,"V4L2_PIX_FMT_MJPEG") >=0)
       label2.text += "set fmt ok\r\n"
        else
       label2.text += "set fmt fail\r\n"

        if(robot.setFPS(10) >= 0)
        //if(v4l2.setFMT(640,480,"V4L2_PIX_FMT_MJPEG") >=0)
       label2.text += "set fps ok\r\n"
        else
       label2.text += "set fps fail\r\n"

        if(robot.setNMAP(4) >= 0)
        //if(v4l2.setFMT(640,480,"V4L2_PIX_FMT_MJPEG") >=0)
       label2.text += "set nmap ok\r\n"
        else
       label2.text += "set nmap fail\r\n"


        if(robot.startCapturing() >= 0)
        //if(v4l2.setFMT(640,480,"V4L2_PIX_FMT_MJPEG") >=0)
       label2.text += "start caputuring ok\r\n"
        else
       label2.text += "start caputuring fail\r\n"

       robot.setTestMode(3)

    }
}

Label {
    id: label2
    x: 13
    y: 20
    width: 477
    height: 434
    text: qsTr("")
    wrapMode: Text.WrapAnywhere
}


}

