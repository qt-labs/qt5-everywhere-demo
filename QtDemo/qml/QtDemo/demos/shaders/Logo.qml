import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id: root

    property int logoSize: Math.min(parent.height, parent.width) / 2
    property int logoSizeDivider: 1
    property int logoState: 1
    property double posX: parent.width / 2
    property double posY: parent.height / 2
    property double rot: 0
    property double dx: 10
    property double dy: 10
    property double drot: 1
    property string explodeColor: "#ff3333"

    function play() {
        randomValues();
        animationTimer.restart()
    }

    function logoClicked() {
        switch(root.logoState) {
        case 1: {
            parent.createNewLogos(root.posX,root.posY,logoSize,2)
            parent.decreaseCounter();
            logo.visible = false;
            root.logoState = 2;
            root.explodeColor = "#33ff33"
            explodeAnimation.restart()
            break;
        }
        default: {
            // return true if we must destroy this logo
            if (parent.decreaseCounter(root.posX,root.posY) === true) {
                logo.visible = false;
                root.logoState = 2;
                root.dx = 0;
                root.dy = 0;
                root.drot = 0;
                root.explodeColor = "#ff3333"
                explodeAnimation.restart()
            }
            else { // It was last logo, we will keep it
                root.logoState = 1
                root.logoSizeDivider = 1
                root.explodeColor = "#3333ff"
                explodeAnimation.restart()
            }
            break;
        }
        }

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

    ParticleSystem{
        id: particleSystem;
        anchors.fill: logo

        Emitter {
            id: emitter
            anchors.fill: particleSystem
            enabled: false
            emitRate: 1000
            lifeSpan: 500
            size: logo.height * .5
            endSize: logo.height * .1
            velocity: AngleDirection { angleVariation: 360; magnitudeVariation: 160 }
        }

        ImageParticle {
            id: smokeParticle
            source: "images/particle-smoke.png"
            alpha: 0.3
            alphaVariation: 0.1
            color: root.explodeColor
        }
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
        width: (logoSize / logoSizeDivider)
        height: (logoSize / logoSizeDivider)
        x: root.posX
        y: root.posY
        rotation: root.rot
        source: "images/qt-logo.png"

        MouseArea {
            anchors.fill: parent
            onClicked: logoClicked();
        }
    }

    SequentialAnimation {
        id: explodeAnimation
        running: false
        ScriptAction { script: emitter.pulse(100); }
        PauseAnimation { duration: 600 }
        onRunningChanged: {
            if (!explodeAnimation.running && root.logoState > 1)
                root.destroy();
        }
    }

}
