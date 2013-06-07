import QtQuick 2.0

Item {
    id: group
    objectName: "group"

    /*color: "transparent"
    border.color: "red"
    border.width: 10*/

    property int uid: 0
    property real targetScale: 1
    property string textSource: "images/txt_feeds.png"
    property int textX: 0
    property int textY: 0
    property string name: "Text"
    property real imageScale: 6.0

    /*Image {
        x: group.textX
        y: group.textY
        source: group.textSource
        smooth: true
        scale: group.imageScale
    }*/

    property int fontSize: 120
    property string uiFont: "Purisa"
    property bool bold: true
    property int fontTransition: 6

    Text {
        text: group.name
        x: textX
        y: textY
        font.pixelSize: group.fontSize
        font.family: "Purisa"
        font.bold: group.bold
        color: "#42200a"
        smooth: true

        Text {
            text: group.name
            color: "#1d6cb0"
            x:group.fontTransition
            y:-group.fontTransition
            font.pixelSize: group.fontSize
            font.family: "Purisa"
            font.bold: group.bold
            smooth: true
        }
    }

}
