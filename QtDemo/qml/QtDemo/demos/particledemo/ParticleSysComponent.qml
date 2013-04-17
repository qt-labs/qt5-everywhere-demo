import QtQuick 2.0
import QtQuick.Particles 2.0

/**
 * ParticleSystem component draw particles with the given color. The
 * location of the particles depends on the given TouchPoint 'point'.
 */
ParticleSystem {
    id: root
    anchors.fill: parent
    running: true

    property color particleColor: "#ff0000"
    property TouchPoint point: null;

    Emitter {
        id: emitter
        lifeSpan: 500
        emitRate: 80
        x: root.point.x
        y: root.point.y
        enabled: root.point.pressed
        size: 15
        endSize: 25
        sizeVariation: .5
        velocity: AngleDirection{angle:0; angleVariation: 360; magnitude:50}
        acceleration: AngleDirection{angle:0; angleVariation: 360; magnitude: 50}
        shape: EllipseShape{fill:true}
    }

    ImageParticle {
        id: imageParticle
        source: "particle.png"
        color: root.particleColor
        alpha: 0.0
    }
}
