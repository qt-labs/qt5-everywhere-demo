import QtQuick 2.0

Item {
    id: group
    objectName: "group"

    property int uid: 0
    property real targetScale: 1
    property string name: "TestText"
    property int textX: 0
    property int textY: 0
    property int fontSize: (width+height) * 0.05

    Text {
        text: group.name
        x: textX
        y: textY
        font.pixelSize: group.fontSize
        color: "black"
        font.bold: true
        Text {
            text: group.name
            color: "white"
            x:5
            y:5
            font.bold: true
            font.pixelSize: group.fontSize
        }
    }
}
