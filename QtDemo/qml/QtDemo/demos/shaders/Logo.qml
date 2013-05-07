import QtQuick 2.0

Rectangle {
    id: root
    color: "transparent"
    property int logoSize: Math.min(parent.height, parent.width) / 2
    property int logoState: 1

    property double posX: parent.width / 2 - logoSize
    property double posY: parent.height / 2 - logoSize
    property double rot: 0
    property double dx: 10
    property double dy: 10
    property double drot: 1

    function play() {
        randomValues();
        animationTimer.restart()
    }

    function pause() {
        animationTimer.stop();
    }

    function end() {
        parent.decreaseCounter(root.posX,root.posY)
        root.visible = false
        destroy()
    }

    function logoClicked() {
        parent.createNewLogos(root.posX,root.posY,root.logoState)
    }

    function randomValues() {
        root.dx = Math.random()*5
        root.dy = Math.random()*5
        root.drot = Math.floor(Math.random()*10) - 5
    }

    function move() {
        var x = root.posX + root.dx;
        var y = root.posY + root.dy;
        var limit = logoSize / logoState;

        // Check x
        if (x + limit >= parent.width) {
            x = parent.width - limit;
            root.dx = -root.dx;
        }
        else if (x <= 0) {
            x = 0;
            root.dx = -root.dx;
        }

        // Check y
        if (y + limit >= parent.height) {
            y = parent.height - limit;
            root.dy = -root.dy;
        }
        else if (y <= 0) {
            y = 0;
            root.dy = -root.dy;
        }

        root.posX = x
        root.posY = y
        root.rot = root.rot + root.drot
    }

    Timer {
        id: animationTimer
        interval: 20
        running: false
        repeat: true
        onTriggered: move();
    }

    Image {
        id: logo
        width: (logoSize / logoState)
        height: (logoSize / logoState)
        x: root.posX
        y: root.posY
        rotation: root.rot
        source: "images/qt-logo.png"
        opacity: 1.0

        MouseArea {
            anchors.fill: parent
            onClicked: {
                logoState++;
                if (logoState >= 3)
                    end();
                else
                    logoClicked();
            }
        }
    }
}
