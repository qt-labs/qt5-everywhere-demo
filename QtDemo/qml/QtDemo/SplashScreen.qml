import QtQuick 2.0
import "engine.js" as Engine

Rectangle {
    id: splashScreen
    anchors.fill: parent
    color: "transparent"

    Image {
        id: splashImage
        anchors.centerIn: parent
        source: "QtLogo.png"
        width: 150
        height: 150
    }
}
