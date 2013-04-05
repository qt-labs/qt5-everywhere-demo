import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {
    width: 800
    height: 480
    color: "blue"

    ParticleSystem {
        id: system
        width: 640
        height: 480
        running: true

        Emitter {
            id: emitter
            lifeSpan: 500
            emitRate: 20
            size: 12
            endSize: 30
            sizeVariation: .5
            enabled: mouseArea.pressed
            velocity: AngleDirection{angle:0; angleVariation: 360; magnitude:100}
            acceleration: AngleDirection{angle:0; angleVariation: 360; magnitude: 100}
            shape: EllipseShape{fill:true}
        }

        ImageParticle {
            source: "particle.png"
            alpha: 0.0
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPositionChanged: {
            emitter.x=mouse.x
            emitter.y=mouse.y
        }

        onPressed: {
            emitter.x=mouse.x
            emitter.y=mouse.y
            emitter.burst(10)
        }
    }
}
