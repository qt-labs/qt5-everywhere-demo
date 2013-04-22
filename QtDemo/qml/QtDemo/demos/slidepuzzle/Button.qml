import QtQuick 2.0

Rectangle {
    id: button
    property int index: 0;
    property int posX: 0;
    property int posY: 0;
    property bool ready: true;
    x: posX * game.buttonWidth()
    y: posY * game.buttonHeight()
    width: game.buttonWidth()
    height: game.buttonHeight()
    color: "transparent"
    border.color: "#555555"
    border.width: game.gameRunning ? 1 : 0
    opacity: button.ready ? 1.0 : 0.7

    MouseArea {
        anchors.fill: parent
        onPressed: {
            if (game.gameRunning)
                game.move(button)
        }
    }

    Image {
        id: buttonImage
        anchors.fill: parent
        source: "images/button_" + index + ".png"
        smooth: true
    }

    Behavior on x {
        enabled: game.gameRunning;
        NumberAnimation {
            id: xani
            easing.type: Easing.InOutBounce;
            duration: 150;
            onRunningChanged: {
                if (!xani.running)
                    game.checkGameOver();
            }
        }
    }
    Behavior on y {
        enabled: game.gameRunning;
        NumberAnimation {
            id: yani
            easing.type: Easing.InOutBounce;
            duration: 150;
            onRunningChanged: {
                if (!yani.running)
                    game.checkGameOver();
            }
        }
    }
}
