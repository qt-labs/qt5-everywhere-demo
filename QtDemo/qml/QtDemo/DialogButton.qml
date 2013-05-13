import QtQuick 2.0

Rectangle {
    id: button
    radius: 10
    height: 0.3 * dialog.height
    width: dialog.width * 0.5 - dialog.dialogMargin
    color: "transparent"

    property string buttonText
    signal clicked()

    Text {
        anchors.centerIn: parent
        text: button.buttonText
        font.pixelSize: 0.4 * button.height
        color: "#ffffff"
    }

    MouseArea {
        anchors.fill: parent
        onPressed: parent.color = Qt.rgba(0.2, 0.2, 0.2, 0.4)
        onReleased: parent.color = "transparent"
        onClicked: button.clicked()
    }
}
