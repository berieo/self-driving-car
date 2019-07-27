import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import dw.NETCAN 1.0
import dw.COM 1.0

Window {
    visible: true
    width: 1024
    height:768
    property int platform: 0
    //0: X86 1: ARM

COM
{
   id: com
   onReadyRead:
   {
        var data = com.readAllVar()
        //陀螺仪
        //gyroInfo.text = data + "\r\n";
        var gx = (((data[1]*256) + data[0]) / 32768*180).toFixed(3);
        var gy = (((data[3]*256) + data[2]) / 32768*180).toFixed(3);
        var gz = (((data[5]*256)+data[4]) / 32768*180).toFixed(3);
        receive.text = " 滚转角(x) = " + gx + "度 俯仰角(y) = " + gy + "度 偏航角(z) = " + gz + "度";
   }
}

NETCAN
{
    id: netcan
    onDataComing:
    {
        //陀螺仪
        if(id === 594)
        {
            //gyroInfo.text = data + "\r\n";
            var gx = (((data[1]*256) + data[0]) / 32768*180).toFixed(3);
            var gy = (((data[3]*256) + data[2]) / 32768*180).toFixed(3);
            var gz = (((data[5]*256)+data[4]) / 32768*180).toFixed(3);
            receive.text = " 滚转角(x) = " + gx + "度 俯仰角(y) = " + gy + "度 偏航角(z) = " + gz + "度";
        }

    }
}

    Button {
        id: button
        x: 705
        y: 45
        text: qsTr("Open CAN Port")
        onClicked: 
        {
            if(platform == 0)
            //X86
            {
                var v = com0.availablePort();
                com0.setBaudRate("baud115200");
                if(com0.open("/dev/ttyUSB0"))
                {
                    receive.text += "com0 opened OK\r\n"
                }
                else
                {
                    receive.text += "com0 opened failure\r\n";
                }
            }
            else
            //ARM
            {
                netcan.cconfig("can0", 500000);
                netcan.handle = netcan.copen("can0");
                netcan.cstartOrStopReceive(netcan.handle, true, 10);
            }
        }
    }
    

Label {
    id: receive
    x: 37
    y: 45
    width: 629
    height: 392
    wrapMode: Text.WrapAnywhere

}

    Component.onCompleted:
    {
        var data = new Array
        data[0] = 3
        data[1] = 2
        data[2] = 5
        data[3] = 8
        data[4] = 6
        data[5] = 5

            var gx = (((data[1]*256) + data[0]) / 32768*180).toFixed(3);
            var gy = (((data[3]*256) + data[2]) / 32768*180).toFixed(3);
            var gz = (((data[5]*256)+data[4]) / 32768*180).toFixed(3);
            receive.text = " 滚转角(x) = " + gx + "度 俯仰角(y) = " + gy + "度 偏航角(z) = " + gz + "度";

    }

}
