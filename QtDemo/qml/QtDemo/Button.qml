import QtQuick 2.0

Item {
    id: root
    width: (app.height + app.width) * 0.04
    height: width

    property string imageSource : ""
    property double rotation: 0
    signal clicked()

    Image {
        id: buttonImage
        anchors.fill: root
        anchors.margins: 0
        source: root.imageSource
        opacity: 0.7
        rotation: root.rotation
    }

    MouseArea {
        id: buttonMouseArea
        anchors.fill: root
        anchors.margins: -20
        hoverEnabled: true
        onClicked: root.clicked()
        onEntered: buttonImage.anchors.margins = -(root.width * 0.1)
        onExited: buttonImage.anchors.margins = 0
        onPressed: {buttonImage.opacity = 1.0; buttonImage.anchors.margins = -(root.width * 0.1)}
        onReleased: { buttonImage.opacity = 0.7; buttonImage.anchors.margins = 0}
    }
}
