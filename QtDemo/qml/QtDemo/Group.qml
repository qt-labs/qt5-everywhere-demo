import QtQuick 2.0

Item {
    id: group
    objectName: "group"

    /*color: "transparent"
    border.color: "red"
    border.width: 10*/

    property int uid: 0
    property real targetScale: 1
    property string name: "Text"
    property int textX: 0
    property int textY: 0
    property int fontSize: 120
    property string uiFont: "Mukti Narrow"
    property bool bold: false
    property int fontTransition: 6

    Text {
        text: group.name
        x: textX
        y: textY
        font.pixelSize: group.fontSize
        font.family: group.uiFont
        font.bold: group.bold
        color: "#42200a"
        smooth: true

        Text {
            text: group.name
            color: "#779e3e"
            x:group.fontTransition
            y:-group.fontTransition
            font.pixelSize: group.fontSize
            font.family: group.uiFont
            font.bold: group.bold
            smooth: true
        }
    }

}
