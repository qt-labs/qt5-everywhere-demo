import QtQuick 2.0

Rectangle {
    id: root
    objectName: "volumePoint"
    width: size
    height: size
    radius: size/2
    color: volume >= level ? "#0e82b8": "#095477"
    border {width:1; color: "#888888"}
    property int size: 10
    property real level: 0
    property real volume: parent.volume

    Behavior on color{ColorAnimation { duration: 500 }}

    Item {
        id: pointClickArea
        objectName: "pointClickArea"
        property alias value: root.level
        anchors.fill: parent
        anchors.margins: -root.size*2
    }
}
