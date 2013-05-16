import QtQuick 2.0

Rectangle {
    id: root
    anchors.fill: parent
    color: "#262626"

    Text {
        id: text
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        wrapMode: Text.WordWrap
        text: "This is under construction.\n\n Maybe we can show Qt description here?"
        color: "white"
    }
}
