import QtQuick 2.0

Rectangle {
    id: root
    height: applicationWindow.height * 0.2
    color: "#BB333333"
    border.color: "#777777"
    anchors.margins: -1
    property int margin: applicationWindow.height * 0.02

    signal toggleFX()
    signal play()
    signal pause()

    ImageButton {
        id: playButton
        buttonSize: root.height * 0.5
        anchors.centerIn: root

        onClicked: {
            if (playButton.checked)
                root.play()
            else
                root.pause()
        }
    }

    Rectangle {
        id: fx
        anchors.right: root.right
        anchors.verticalCenter: root.verticalCenter
        anchors.margins: root.margin
        width: effectSelectionPanel.width
        height: root.height * 0.5
        radius: 2
        color: "#333333"
        border.color: "#777777"
        opacity: 0.5

        Text {
            anchors.centerIn: fx
            color: "#ffffff"
            text: effectSelectionPanel.effectName
            font.pixelSize: fx.height * 0.5
        }

        MouseArea {
            anchors.fill: parent
            onPressed: fx.color = "#555555"
            onReleased: fx.color = "#333333"
            onClicked: root.toggleFX();
        }
    }
}
