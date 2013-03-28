import QtQuick 2.0

Rectangle {
    id: slide
    objectName: "slide"
    width: 640
    height: 480
    color: "grey"
    border {color: "#333333"; width:3}

    property int uid: 0

    Text{
        anchors.centerIn: parent
        text: "^This side up^"
        font.pixelSize: 60
        color: "white"
    }
    Component.onCompleted: print ("new slide created!")
}
