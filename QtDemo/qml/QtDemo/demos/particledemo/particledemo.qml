import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {
    color: "#000022"
    anchors.fill: parent

    /**
     * Create six ParticleSysComponents for drawing particles
     * in the place of multitouch points with the given color.
     */
    ParticleSysComponent{ point: point1; particleColor: "#ff0000" }
    ParticleSysComponent{ point: point2; particleColor: "#00ff00" }
    ParticleSysComponent{ point: point3; particleColor: "#0000ff" }
    ParticleSysComponent{ point: point4; particleColor: "#ffffff" }
    ParticleSysComponent{ point: point5; particleColor: "#ff00ff" }
    ParticleSysComponent{ point: point6; particleColor: "#00ffff" }

    /**
     * In this demo we only support six touch point at the same time.
     */
    MultiPointTouchArea {
        id: multiPointTouchArea
        anchors.fill: parent
        minimumTouchPoints: 1
        maximumTouchPoints: 6
        touchPoints: [
            TouchPoint { id: point1 },
            TouchPoint { id: point2 },
            TouchPoint { id: point3 },
            TouchPoint { id: point4 },
            TouchPoint { id: point5 },
            TouchPoint { id: point6 }
        ]
    }
}
