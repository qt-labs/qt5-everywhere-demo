import QtQuick 2.0
import QtQuick.Particles 2.0
//based on the SmokeText component from SameGame

Item {
    id: root
    anchors.fill: parent
    z:1

    property alias text: txt.text

    Rectangle{
        id: background
        anchors.fill:parent
        color: "#111111"
    }

    ParticleSystem{
        id: particleSystem;
        anchors.fill: parent

        Text {
            id: txt
            color: 'white'
            font.pixelSize: parent.width *.1
            anchors.centerIn: parent
            smooth: true
        }

        Emitter {
            id: emitter
            anchors.fill: txt
            enabled: false
            emitRate: 1000
            lifeSpan: 1500
            size: parent.height * .2
            endSize: parent.height * .1
            velocity: AngleDirection { angleVariation: 360; magnitudeVariation: 160 }
        }

        ImageParticle {
            id: smokeParticle
            source: "images/particle-smoke.png"
            alpha: 0.1
            alphaVariation: 0.1
            color: 'white'
        }
    }

    SequentialAnimation {
        id: anim
        running: false
        ScriptAction { script: emitter.pulse(100); }
        NumberAnimation { target: txt; property: "opacity"; from: 1.0; to: 0.0; duration: 400}
        NumberAnimation { target: background; property: "opacity"; from: 1.0; to: 0.0; duration: 1000}
        PauseAnimation { duration: 200 }
        onRunningChanged: if (!running) root.destroy();
    }

    function explode(){
        anim.restart()
    }
}
