import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import dw.OpenCV.Core.CVCore 1.0
import dw.OpenCV.CVImgCodecs 1.0

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
    source: "/home/duowei/FDP/QT/SmartAgent_Release/bin/qml_demo/carline_detect/original.jpg"
}

Image {
    id: resultpic
    x: 6
    y: 500
    width: 640
    height: 480
    //source: "/home/duowei/FDP/QT/SmartAgent_Release/bin/qml_demo/carline_detect/result.jpg"

}

CVImgCodecs
{
    id: codecs
}

CVCore
{
    id: cvcore
}

Button {
    id: detect
    x: 702
    y: 96
    text: qsTr("detect")
    onClicked:
    {
        codecs.getAvailableFlags();
        var mat = codecs.imread_1("/home/duowei/FDP/QT/SmartAgent_Release/bin/qml_demo/carline_detect/original.jpg")
        label.text = "ptr: " + mat + "\r\n"
        label.text += "original mat info: " + codecs.getMatInfo(mat) + "\r\n"
        if(mat > 0)
        {
            var dstmat = codecs.createMat();
            cvcore.inRange_0(mat, 180, 180, 180,0, 220,220,220, 0, dstmat);
            //label.text += "result mat info: " + codecs.getMatInfo(dstmat) + "\r\n"
            var rowdata = codecs.getMatLine(dstmat, 200)
            //label.text += "row: " + rowdata.length + "\r\n"
            for(var i = 0; i < rowdata.length; i++)
            {
                if(rowdata[i] > 0)
                {
                    //label.text += "row with data: " + i + "\r\n"
                }
            }

            codecs.imwrite_1("/home/duowei/FDP/QT/SmartAgent_Release/bin/qml_demo/carline_detect/result.jpg", dstmat)
            resultpic.source = "/home/duowei/FDP/QT/SmartAgent_Release/bin/qml_demo/carline_detect/result.jpg"
            codecs.freeMat(mat)
            codecs.freeMat(dstmat)
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


}
