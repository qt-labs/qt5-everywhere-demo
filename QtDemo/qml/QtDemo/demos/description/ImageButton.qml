
import QtQuick 2.0

Item {
    id: root

    height: parent.height * 0.8
    width: image.width * image.scale

    property alias enabled: mouseArea.enabled
    property alias imageSource: image.source

    property bool checkable: false
    property bool checked: false
    property alias hover: mouseArea.containsMouse
    property alias pressed: mouseArea.pressed
    property double imageSize: 0.9*root.height

    opacity: enabled ? 1.0 : 0.3
    signal clicked

    Image {
        id: image
        anchors.centerIn: parent
        scale: root.height / height
        visible: true
        opacity: pressed ? 0.6 : 1
        smooth: true
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: root
        onPositionChanged: applicationWindow.resetTimer()
        onClicked: root.clicked();
    }
}
