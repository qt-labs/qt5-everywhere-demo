import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id: root

    property real size: Math.min(root.width, root.height);
    signal finished()

    SequentialAnimation {
        id: entryAnimation
        ParallelAnimation {
            SequentialAnimation {
                PropertyAction { target: sphereSystem; property: "running"; value: true }
                PropertyAction { target: starSystem; property: "running"; value: true }
                PauseAnimation { duration: 300 }
                PropertyAction { target: sphereEmitter; property: "emitRate"; value: 2000 }
                PropertyAction { target: starEmitter; property: "emitRate"; value: 2000 }
                PauseAnimation { duration: 500 }
                ScriptAction { script: {
                        starAccel.x = 50
                        starAccel.xVariation = 200;
                        starAccel.yVariation = 200;
                        sphereAccel.x = -50
                        sphereAccel.xVariation = 200
                        sphereAccel.yVariation = 200
                        sphereParticle.alpha = 0;
                    }
                }
                PauseAnimation { duration: 300 }
                PropertyAction { target: starEmitter; property: "enabled"; value: false }
                PropertyAction { target: sphereEmitter; property: "enabled"; value: false }
                PauseAnimation { duration: 5000 }
            }
            SequentialAnimation {
                PauseAnimation { duration: 5000 }
                NumberAnimation { target: label; property: "opacity"; to: 1; duration: 500 }
                NumberAnimation { target: label; property: "opacity"; to: 0; duration: 100 }
            }
        }
        ScriptAction { script: {
                engine.markIntroAnimationDone();
            }
        }
    }

    Item {
        id: engine
        property bool bootAnimationEnabled: true
        function markIntroAnimationDone() {
            root.finished()
        }
    }

    Component.onCompleted: {
        if (engine.bootAnimationEnabled) {
            entryAnimation.running = true
        } else {
            engine.markIntroAnimationDone()
        }
    }

    Item {
        id: logo;
        width: root.size  / 2;
        height: root.size  / 2;
        anchors.centerIn: parent
        //anchors.verticalCenterOffset: -root.size * 0.1
    }

    Text {
        id: label

        anchors.horizontalCenter: logo.horizontalCenter
        anchors.top: logo.bottom

        font.pixelSize: size * 0.1
        color: "black"
        text: ""  //"Qt 5.1"
        opacity: 0
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
            emitRate: 50
            lifeSpan: 4000
            size: 24
            sizeVariation: 8
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
            size: 32
            sizeVariation: 8

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
}
