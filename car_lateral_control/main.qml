import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import dw.OpenCV.Core.CVCore 1.0
import dw.OpenCV.CVImgCodecs 1.0
import dw.OpenCV.ImgProc.CVImgProc 1.0

Window {
visible: true
width: 1024
height:1024

Image {
    id: orgpic
    x: 6
    y: 6
    width: 640
    height: 480
    source: "/home/duowei/FDP/QT/SmartAgent_Release/bin/qml_demo/driverless/car_lateral_control/original.jpg"
}

Image {
    id: resultpic
    property double row1: 638*0.2
    property double col1: 0
    property double row2: 640*0.6
    property double col2: 0
    property int camerawidth: 640
    property double positionP: 1.00
    property double positionI: 0.0
    property double positionD: 0.40
    property double positionP_v: 0.0
    property double positionI_v: 0.0
    property double positionD_v: 0.0
    property double changeP: 1.0
    property double changeI: 0.0
    property double changeD: 0.4
    property double changeP_v: 0.0
    property double changeI_v: 0.0
    property double changeD_v: 0.0
    property double lastchange: 0.0
    property double currentspeed: 1.0
    property double steering: 0.0
    property double clipIMax: 100
    property double clipIMin: -100
    property double lastOffset: 0.0
    property double lastChange: 0.0
    x: 6
    y: 500
    width: 640
    height: 480

}

CVImgCodecs
{
    id: codecs
}

CVCore
{
     id: cvcore
     property var matt
     property var mat
     property var dstmat
}

CVImgProc
{
    id: cvimgproc
}

Button {
    id: detect
    x: 702
    y: 96
    text: qsTr("detect")
    onClicked:
    {
        cvcore.matt = codecs.imread_1("/home/duowei/FDP/QT/SmartAgent_Release/bin/qml_demo/driverless/car_lateral_control/original.jpg")
        cvcore.mat = codecs.createMat()
        var v1 = cvcore.getTickCount_0();
        cvimgproc.resize_1(cvcore.matt,cvcore.mat,640,480)
        var v2 = cvcore.getTickCount_0()
        label.text += "resize: " + (v2 - v1) * 1000. / cvcore.getTickFrequency_0() + "\r\n";

        //label.text = "ptr: " + cvcore.mat + "\r\n"
        //label.text += "original mat info: " + codecs.getMatInfo(cvcore.mat) + "\r\n"
        if(cvcore.mat > 0)
        {
            v1 = cvcore.getTickCount_0();
            cvcore.dstmat = codecs.createMat();
            v2 = cvcore.getTickCount_0()
            label.text += "createmat: " + (v2 - v1) * 1000. / cvcore.getTickFrequency_0()  + "\r\n";;

            //label.text += "result mat info: " + codecs.getMatInfo(cvcore.dstmat) + "\r\n"
            v1 = cvcore.getTickCount_0();
            cvcore.inRange_0(cvcore.mat, 180, 180, 180,0, 220,220,220, 0, cvcore.dstmat);
            v2 = cvcore.getTickCount_0()
            label.text += "inRange: " + (v2 - v1) * 1000. / cvcore.getTickFrequency_0() + "\r\n";;
            return;

            //to calculate the Control Points
            var rowdata = codecs.getMatLine(cvcore.dstmat, resultpic.row1)
            resultpic.col1 = calColPoint_2(rowdata)
            rowdata = codecs.getMatLine(cvcore.dstmat, resultpic.row2)
            resultpic.col2 = calColPoint_2(rowdata)

            // to draw row1 line
            cvimgproc.line_0(cvcore.dstmat,0,resultpic.row1,640,resultpic.row1,255,255,255,0,3,"LINE_8",0)
            // to draw row2 line
            cvimgproc.line_0(cvcore.dstmat,0,resultpic.row2,640,resultpic.row2,255,255,255,0,3,"LINE_8",0)

            //to darw a circle for col1
            cvimgproc.circle_0(cvcore.dstmat, resultpic.col1, resultpic.row1, 3, 128,128,128,0,1,"LINE_8", 0)
            //to darw a circle for col2
            cvimgproc.circle_0(cvcore.dstmat, resultpic.col2, resultpic.row2, 3, 128,128,128,0,1,"LINE_8", 0)

            var yellow = codecs.getRGBFromColor("white")
            label.text += "yellow: " + yellow + "\r\n"
            //cvimgproc.line_0(dstmat, resultpic.col1, resultpic.row1, resultpic.col2, resultpic.row2,
            //                yellow[0],yellow[1],yellow[2],0,3,"LINE_8",0)
            cvimgproc.line_1(cvcore.dstmat, resultpic.col1, resultpic.row1, resultpic.col2, resultpic.row2,
                            yellow[2],yellow[1],yellow[0],0,3)
            codecs.imwrite_1("/home/duowei/FDP/QT/SmartAgent_Release/bin/qml_demo/driverless/car_lateral_control/result.jpg", cvcore.dstmat)
            resultpic.source = "/home/duowei/FDP/QT/SmartAgent_Release/bin/qml_demo/driverless/car_lateral_control/result.jpg"
            codecs.freeMat(cvcore.mat)
            codecs.freeMat(cvcore.matt)
            codecs.freeMat(cvcore.dstmat)
            //test PID calculation
            label.text += "PID: " + pidCal(260,260) + "\r\n"
        }
    }
}

Label {
    id: label
    x: 702
    y: 167
    width: 224
    height: 775
}

function pidCal(X1, X2)
{
    var offset = ((2.0 * X1) / (resultpic.camerawidth)) - 1.0;
    //var offset = (X1 + X2) / (resultpic.camerawidth) - 1.0;
    var change = (2.0 * (X2 - X1)) / (resultpic.camerawidth);
    //label.text += "offset: " + offset + "\r\n"
    //label.text += "change: " + change + "\r\n"

    //Position offset loop
    resultpic.positionP_v = resultpic.positionP * offset;
    resultpic.positionI_v += resultpic.positionI * offset;

    if(resultpic.positionI_v > resultpic.clipIMax)
    resultpic.positionI_v = clipIMax;
    else if(resultpic.positionI_v < resultpic.clipIMin)
    resultpic.positionI_v = resultpic.clipIMin;

    resultpic.positionD_v = resultpic.positionD * (offset - resultpic.lastOffset);
    resultpic.lastOffset = offset;
    var offsetPID = resultpic.positionP_v + resultpic.positionI_v + resultpic.positionD_v;

    //Position change loop
    resultpic.changeP_v = resultpic.changeP * change;
    resultpic.changeI_v += resultpic.changeI * change;

    if(resultpic.changeI_v > resultpic.clipIMax)
    resultpic.changeI_v = resultpic.clipIMax;
    else if(resultpic.changeI < resultpic.clipIMin)
    resultpic.changeI_v = resultpic.clipIMin;

    resultpic.changeD_v = resultpic.changeD * (change - resultpic.lastChange);
    resultpic.lastChange = change;

    var changePID = resultpic.changeP_v + resultpic.changeI_v + resultpic.changeD_v;
    //Speed and steering values
    resultpic.steering = (offsetPID + changePID) * resultpic.currentspeed;
    //label.text += "offsetPID + changePID: " + (offsetPID + changePID) + "\r\n"
    //label.text += "offsetPID: " + offsetPID + "\r\n"
    //label.text += "changePID: " + changePID + "\r\n"
    //label.text += "steering: " + resultpic.steering + "\r\n"
    return resultpic.steering
}

function calColPoint_1(rowdata)
{
    var pos = 0
    var icount = 0
    for(var i = 0; i < rowdata.length; i++)
    {
       if(rowdata[i] > 0)
       {
          pos += rowdata[i]
          icount++;
       }
    }
    if(icount > 0)
    {
        pos = pos / icount
    }
    return pos;
}

function calColPoint_2(rowdata)
{
    var pos1 = 0, pos2 = 0
    var icount = 0
    for(var i = 0; i < rowdata.length; i++)
    {
       if(rowdata[i] > 0)
       {
            pos1 = i
            break;
       }
    }
    for(var i = rowdata.length - 1; i >= 0; i--)
    {
       if(rowdata[i] > 0)
       {
            pos2 = i
            break;
       }
    }
    return (pos1 + pos2) / 2;
}


}
