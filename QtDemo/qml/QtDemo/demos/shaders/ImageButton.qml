import QtQuick 2.0

Item {
    id: root

    property int buttonSize: 50
    property bool checked:  false

    width: buttonSize
    height: buttonSize

    signal clicked

    Image {
        id: image
        source: root.checked ? "images/PauseButton.png" : "images/PlayButton.png"
        anchors.fill: parent
        opacity: mouseArea.pressed ? 0.6 : 1
        smooth: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: root
        onClicked: {
            root.checked = !root.checked
            root.clicked();
        }
    }
}
