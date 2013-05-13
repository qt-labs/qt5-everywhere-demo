import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {
    id: root
    color: "#000000"
    anchors.fill: parent

    property real distance: parent.height*.5
    property real angle: 0
    property real movement: 0
    property alias running: angleAnimation.running

    BootScreenDemo {
        width: 500
        height: 500
        anchors.centerIn: parent
        onFinished: {
            distanceAnimation.restart()
            angleAnimation.restart()
        }
    }

    RotationAnimation on angle {
        id: angleAnimation
        from: 0
        to: 360
        running: false
        duration: distanceAnimation.delay
        direction: RotationAnimation.Shortest
        loops: Animation.Infinite
    }

    SequentialAnimation on distance {
        id: distanceAnimation
        property int easingType:0
        property int delay: 1000
        running: false

        NumberAnimation {
            from: 0
            to: parent.height*.5
            duration: distanceAnimation.delay/2
            easing.type: distanceAnimation.easingType
        }

        NumberAnimation {
            from: parent.height*.5
            to: 0
            duration: distanceAnimation.delay/2
            easing.type: distanceAnimation.easingType
        }

        onRunningChanged: {
            if (!running){
                var type = Math.floor(Math.random()*10)
                switch (type){
                case 0:
                    distanceAnimation.easingType=Easing.InOutBack
                    break;
                case 1:
                    distanceAnimation.easingType=Easing.InOutBounce
                    break;
                case 2:
                    distanceAnimation.easingType=Easing.InOutCirc
                    break;
                case 3:
                    distanceAnimation.easingType=Easing.InOutElastic
                    break;
                case 4:
                    distanceAnimation.easingType=Easing.InOutSine
                    break;
                case 5:
                    distanceAnimation.easingType=Easing.OutInQuad
                    break;
                case 6:
                    distanceAnimation.easingType=Easing.OutInCubic
                    break;
                case 7:
                    distanceAnimation.easingType=Easing.OutExpo
                    break;
                case 8:
                    distanceAnimation.easingType=Easing.OutCurve
                    break;
                default:
                    distanceAnimation.easingType=Easing.Linear
                    break;
                }

                distanceAnimation.delay = 500 + Math.floor(Math.random()*1500)
                angleAnimation.from = 180 + Math.random()*90 - 45
                root.movement = Math.random()*2
                angleAnimation.restart()
                distanceAnimation.restart()
            }
        }
    }

    /**
     * Create five ParticleSysComponents for drawing particles
     * in the place of multitouch points with the given color.
     */
    ParticleSysComponent{ id: p1; point: point1; particleColor: "#ff0000"; angle: root.angle; startAngle: 1*360/(5-multiPointTouchArea.pointCount); pointCount: multiPointTouchArea.pointCount; radius: root.distance; movement: root.movement; emitting: root.running }
    ParticleSysComponent{ id: p2; point: point2; particleColor: "#00ff00"; angle: root.angle; startAngle: 2*360/(5-multiPointTouchArea.pointCount); pointCount: multiPointTouchArea.pointCount; radius: root.distance; movement: root.movement; emitting: root.running }
    ParticleSysComponent{ id: p3; point: point3; particleColor: "#0000ff"; angle: root.angle; startAngle: 3*360/(5-multiPointTouchArea.pointCount); pointCount: multiPointTouchArea.pointCount; radius: root.distance; movement: root.movement; emitting: root.running }
    ParticleSysComponent{ id: p4; point: point4; particleColor: "#ffff00"; angle: root.angle; startAngle: 4*360/(5-multiPointTouchArea.pointCount); pointCount: multiPointTouchArea.pointCount; radius: root.distance; movement: root.movement; emitting: root.running }
    ParticleSysComponent{ id: p5; point: point5; particleColor: "#ff00ff"; angle: root.angle; startAngle: 5*360/(5-multiPointTouchArea.pointCount); pointCount: multiPointTouchArea.pointCount; radius: root.distance; movement: root.movement; emitting: root.running }

    /**
     * In this demo we only support five touch point at the same time.
     */

    MultiPointTouchArea {
        id: multiPointTouchArea
        anchors.fill: parent
        minimumTouchPoints: 1
        maximumTouchPoints: 6

        property int pointCount:0

        touchPoints: [
            TouchPoint { id: point1 },
            TouchPoint { id: point2 },
            TouchPoint { id: point3 },
            TouchPoint { id: point4 },
            TouchPoint { id: point5 }
        ]

        onPressed: updatePointCount()

        onReleased: updatePointCount()

        function updatePointCount(){
            var tmp = 0
            for (var i=0; i<5; i++){
                if (touchPoints[i].pressed) tmp++
            }
            pointCount = tmp
        }
    }
}
