import QtQuick 2.0

Rectangle {
    id: root
    color: "transparent"
    clip: true
    anchors.fill: parent

//    NumberAnimation{
//        id: fadeOutAnimation
//        target: root
//        property: "opacity"
//        from: 1.0
//        to: .0
//        duration: 500
//        onRunningChanged: if (!running) root.destroy()
//    }

    Behavior on opacity {NumberAnimation{duration: 300}}

    BootScreenDemo{
        width: 500
        height: 500
        anchors.centerIn: parent
        onFinished: {
            root.opacity=0.0
            root.destroy() //fadeOutAnimation.restart()
        }
  }

    MouseArea{
        id: eventEater
        anchors.fill: parent
        onClicked: {
//            root.opacity=0.0
//            root.destroy()
        }
        //fadeOutAnimation.restart()
    }

    Component.onDestruction: print ("BootScreen released!")
}
