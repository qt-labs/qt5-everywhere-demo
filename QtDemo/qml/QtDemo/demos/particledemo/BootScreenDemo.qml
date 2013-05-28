import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id: root
    property real size: Math.min(root.width, root.height);
    signal finished()

    SequentialAnimation {
        id: entryAnimation
        running: true
        PropertyAction { target: sphereEmitter; property: "emitRate"; value: 150 }
        PropertyAction { target: starEmitter; property: "emitRate"; value: 100 }
        PropertyAction { target: starEmitter; property: "enabled"; value: true }
        PropertyAction { target: sphereEmitter; property: "enabled"; value: true }
        PropertyAction { target: sphereSystem; property: "running"; value: true }
        PropertyAction { target: starSystem; property: "running"; value: true }
        PauseAnimation { duration: 5000 }

        onRunningChanged: if (!running) explodeAnimation.restart()
    }

    SequentialAnimation{
        id: explodeAnimation
        ScriptAction { script: {
                starAccel.x = 5
                starAccel.xVariation = 20;
                starAccel.yVariation = 20;
                sphereAccel.x = -5
                sphereAccel.xVariation = 20
                sphereAccel.yVariation = 20
                sphereParticle.alpha = 0;
            }
        }
        PropertyAction { target: sphereEmitter; property: "emitRate"; value: 200 }
        PropertyAction { target: starEmitter; property: "emitRate"; value: 200 }
        PauseAnimation { duration: 2000 }
        PropertyAction { target: starEmitter; property: "enabled"; value: false }
        PropertyAction { target: sphereEmitter; property: "enabled"; value: false }
        PauseAnimation { duration: 5000 }

        onRunningChanged: {
            if (!running) {
                root.finished()
                root.destroy()
            }
        }
    }

    Item {
        id: logo;
        width: root.size  / 2;
        height: root.size  / 2;
        anchors.centerIn: parent
    }

    ParticleSystem {
        id: sphereSystem;
        anchors.fill: logo
        running: false

        ImageParticle {
            id: sphereParticle
            source: "images/particle.png"
            color: "#80c342"
            alpha: 1
            colorVariation: 0.0
        }

        Emitter {
            id: sphereEmitter
            anchors.fill: parent
            emitRate: 100
            lifeSpan: 4000
            size: root.width*.15
            sizeVariation: size *.2
            velocity: PointDirection { xVariation: 2; yVariation: 2; }

            acceleration: PointDirection {
                id: sphereAccel
                xVariation: 1;
                yVariation: 1;
            }

            shape: MaskShape {
                source: "images/qt-logo-green-mask.png"
            }
        }
    }

    ParticleSystem {
        id: starSystem;
        anchors.fill: logo
        running: false

        ImageParticle {
            id: starParticle
            source: "images/particle_star.png"
            color: "#ffffff"
            alpha: 0
            colorVariation: 0
        }

        Emitter {
            id: starEmitter
            anchors.fill: parent
            emitRate: 50
            lifeSpan: 5000
            size: root.width*.1
            sizeVariation: size *.2
            velocity: PointDirection { xVariation: 1; yVariation: 1; }

            acceleration: PointDirection {
                id: starAccel
                xVariation: 0;
                yVariation: 0;
            }

            shape: MaskShape {
                source: "images/qt-logo-white-mask.png"
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {

            if (entryAnimation.running) {
                entryAnimation.complete()
                return;
            }

            if (explodeAnimation.running) {
                root.finished()
                root.destroy()
            }

        }
    }
}
