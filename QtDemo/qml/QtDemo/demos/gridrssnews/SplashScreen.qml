import QtQuick 2.0

Rectangle {
    width: parent.width
    height: parent.height
    color: mainWindow.appBackground

    Item {
        id: it
        width: logo.width + 24 + text.paintedWidth
        anchors.centerIn: parent

        Image {
            id: logo
            anchors.verticalCenter: it.verticalCenter
            anchors.left: it.left
            source: "Qt_logo.png"
        }
        Text {
            id: text
            anchors.left: logo.right
            anchors.leftMargin: 24
            anchors.verticalCenter: it.verticalCenter
            text: qsTr("Blog")
            font.family: mainWindow.uiFont;
            font.pointSize: mainWindow.appHeaderFontSize;
            color: mainWindow.textColor
        }
    }

    Component.onCompleted: splashScreen.state = "show"

    states:
        State {
            name: "hide"
            PropertyChanges { target: splashScreen; x: parent.width; y: 0 }
        }


    transitions:
        Transition {
            PropertyAnimation { properties: "x,y"; duration: 200; easing.type: Easing.OutCirc; }
        }
}
