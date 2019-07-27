import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.0
import dw.OPCUAClient 1.0


Window {
visible: true
width: 640
height:480
property int count: 0

Timer
{
property int count: 0
id: timer
onTriggered: 
    {
        //updatevalue();
        readvalue();
        timer.start()
    }
}

    OPCUAClient
    {
        id: client
        onError:  text1.text += "error: " + msg + "\r\n"
    }

    Button {
        id: button1
        x: 23
        y: 34
        text: qsTr("getNodeList")
        onClicked:
        {
            //text1.text += "connect:" + client.connectToServer("192.168.1.105",16664)  +  "\r\n"
            //text1.text += "connect:" + client.connectToServer("192.168.1.166",16664)  +  "\r\n"
            //text1.text += "connect:" + client.connectToServer("192.168.1.166",19999)  +  "\r\n"
            //text1.text += "connect:" + client.connectToServer("127.0.0.1",16664)  +  "\r\n"
            //var status = client.connectToServer("192.168.0.105",9212)
            var status = client.connectToServer("192.168.0.110",9212)
            //var status = client.connectToServer("192.168.0.108",16665)
            //var status = client.connectToServer("127.0.0.1",16665)
            text1.text += "connect:" + status  +  "\r\n"
            text1.text += "nodelist: " + client.getServerNodeList() + "\r\n"
            if(status  === 0)
            {
                timer.interval = 100
                //timer.start();
            }
        }
    }

Text {
    id: text1
    x: 23
    y: 81
    width: 521
    height: 349
    text: qsTr("")
    wrapMode: Text.WordWrap
    font.pixelSize: 12
}

Button {
    id: button2
    x: 148
    y: 69
    text: qsTr("connect")
}

Button {
    id: button3
    x: 262
    y: 110
    text: qsTr("readNodeValue")
    onClicked:
    {
        readvalue();
    }
}

Button {
    id: button4
    x: 399
    y: 180
    text: qsTr("writeNodeValue")
    onClicked:
    {
        //client.writeNodeValue("videostarted",1,"sint32")
        client.writeNodeValue("name","A中A","string")
    }
}

function readvalue()
{

        text1.text = "read: " + count++  + "\r\n";
        /*
        text1.text += " the.answer: " + client.readNodeValue("the.answer")  + "\r\n";
        text1.text += " name: " + client.readNodeValue("name")  + "\r\n";
        text1.text += " sint32: " + client.readNodeValue("sint32")  + "\r\n";
        text1.text += "double: " + client.readNodeValue("double")  + "\r\n";
        text1.text += "uint32: " + client.readNodeValue("uint32")  + "\r\n";
        text1.text += "float: " + client.readNodeValue("float")  + "\r\n";
        */
        //text1.text += " publickey: " + client.readNodeValue("WelcomeText")  + "\r\n";
        //var v = client.readNodeValue("publickey")
        var v = client.readNodeValue("WelcomeText")
        text1.text += " WelcomeText: " + v  + "\r\n";


}

function updatevalue()
{
        var va = new Array
        va[0] = 8;
        va[1] = 4;
        va[2] = 5;
        va[3] = 7;
        va[4] = 8;
        va[5] = 4;
        va[6] = 5;
        va[7] = 7;
        va[8] = 8;
        va[9] = 4;
        va[10] = 5;
        va[11] = 7;
        //text1.text += "read: " + client.writeNodeValue("the.answer",1099, "sint32")
        //client.writeNodeValue("the.answer",va, "bytestring")
        client.writeNodeValue("name", "mytest", "string")
}

}
