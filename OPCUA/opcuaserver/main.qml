import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.0
import dw.OPCUAServer 1.0
import dw.OPCUAClient 1.0

Window {
    id: win
    visible: true
    width: 640
    height:480
    property int count: 0
    property var pkey

Timer
{
id: timer
interval:  10
onTriggered:
{
        //server.updataNodeValue("the.answer", count++, "sint32")
        //server.updataNodeValue("the.answer", 302.23, "float")
        updatevalue()
        server.loop(false, false)
        timer.start(10)
/*        text1.text = "update: " + count++ + " :  " + "\r\n"
        text1.text += "name: " + server.readNodeValue("name") + "\r\n"
        text1.text += " sint32: " + server.readNodeValue("sint32")  + "\r\n";
        text1.text += "double: " + server.readNodeValue("double")  + "\r\n";
        text1.text += "uint32: " + server.readNodeValue("uint32")  + "\r\n";
        text1.text += "float: " + server.readNodeValue("float")  + "\r\n";
*/

    }
}
    OPCUAServer
    {
        id: server
        onError:  {//text1.text += "err: " + msg + "\r\n"
                  }
        onWriteEvent:  {
            if(nodename == "publickey")
            {
                pkey = value;
                text1.text += "public key: " + pkey + "\r\n"
            }
            else if(nodename == "string")
            text1.text = "write event: " + count++ + " : " + nodename + " : " + valtype + " : " + value + "\r\n"
        }
    }

    OPCUAClient
    {
        id: client
    }

    Button {
        id: button1
        x: 475
        y: 68
        text: qsTr("server")
        onClicked:
        {
            //client.connectToServer("192.168.1.108",16665)
            //client.connectToServer("127.0.0.1",16665)
            server.initServer(16665)
            var v = new Array
            v[0] = 1
            v[1] = 2
            v[2] = 3
            v[3] = 4
            text1.text += "init serer\r\n"
            server.addNode("publickey", "string", "A不顾禁令航拍A")
            //server.addNode("publickey", "string", "A中A")
            //server.addNode("publickey", "bytestring", "publickey")


            server.addNode("the.answer", "bytestring", v)
            server.addNode("name","string", "default")
            server.addNode("sint32", "sint32", 9669)
            server.addNode("double", "double", 96.88)
            server.addNode("sint16", "sint16", 96)
            server.addNode("uint32", "uint32", 96.88)
            server.addNode("float", "float", 96.88)

            //server.addNode("the.answer", "string", "intof")
            //server.runServer(false);
            text1.text += "add node\r\n"
            //server.runServerStartup();
            text1.text += "run server\r\n"
            timer.interval = 100
            timer.start()
            //client.writeNodeValue("publickey", win.pkey, "bytestring")

        }
    }

Text {
    id: text1
    x: 50
    y: 301
    width: 502
    height: 313

    text: qsTr("Text")
    wrapMode: Text.WordWrap
    font.pixelSize: 20
}

Button {
    id: button2
    x: 58
    y: 68
    text: qsTr("updatevalue")
    onClicked:
    {
    }
}

function updatevalue()
{
        var va = new Array
        va[0] = 10
        va[1] = 9
        va[2] = 8
        va[3] = 7
        va[4] = 8
        va[5] = 7
        va[6] = 8
        va[7] = 7
        //va[0] = 5
        server.updataNodeValue("the.answer", va, "bytestring")
        var t = "international";
        server.updataNodeValue("name", t, "string")
        server.updataNodeValue("sint32", count, "sint32")
        server.updataNodeValue("double", count / 10., "double")
        server.updataNodeValue("sint16", count, "sint16")
        server.updataNodeValue("uint32", count, "uint32")
        server.updataNodeValue("float", count / 20., "float")
        //server.updataNodeValue("the.answer", 1996.8, "float")
        //server.updataNodeValue("the.answer", "international of china", "string")
        //text1.text += "readback: " + server.readNodeValue("the.answer") + "\r\n"
        /*count++;
        if(count > 100000)
        count = 0;
        */

}

}
