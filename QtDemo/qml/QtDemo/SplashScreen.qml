import QtQuick 2.0
import "engine.js" as Engine

Rectangle {
    id: splashScreen
    anchors.fill: parent
    color: "transparent"

    property int splashWidth : 100
    Image {
        id: splashImage
        anchors.centerIn: parent
        source: "QtLogo_splash.png"
        width: splashWidth
        height: splashWidth * 1.19
    }
}
