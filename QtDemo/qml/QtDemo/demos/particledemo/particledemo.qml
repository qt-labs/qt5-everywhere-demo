/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.Particles 2.0

Rectangle {
    id: particleRoot
    color: "#000000"
    anchors.fill: parent

    property real distance: parent.height*.4
    property real angle: 0
    property real movement: 0
    property alias running: angleAnimation.running
    property int pointCount: mouseArea.pointCount + multiPointTouchArea.pointCount

    BootScreenDemo {
        width: Math.min(parent.width,parent.height)
        height: width
        anchors.centerIn: parent
        z: 1
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
            to: parent.height*.4
            duration: distanceAnimation.delay/2
            easing.type: distanceAnimation.easingType
        }

        NumberAnimation {
            from: parent.height*.4
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
                particleRoot.movement = Math.random()*2
                angleAnimation.restart()
                distanceAnimation.restart()
            }
        }
    }

    /**
     * Create five ParticleSysComponents for drawing particles
     * in the place of multitouch points with the given color.
     */
    ParticleSysComponent{ id: p1; particleColor: "#ff0000"; startAngle: 1*360/(5-particleRoot.pointCount); }
    ParticleSysComponent{ id: p2; particleColor: "#00ff00"; startAngle: 2*360/(5-particleRoot.pointCount); }
    ParticleSysComponent{ id: p3; particleColor: "#0000ff"; startAngle: 3*360/(5-particleRoot.pointCount); }
    ParticleSysComponent{ id: p4; particleColor: "#ffff00"; startAngle: 4*360/(5-particleRoot.pointCount); }
    ParticleSysComponent{ id: p5; particleColor: "#ff00ff"; startAngle: 5*360/(5-particleRoot.pointCount); }

    /**
     * In this demo we only support five touch point at the same time.
     * One from mouseArea (because of Desktop-support) and four from MultiPointTouchArea.
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
            TouchPoint { id: point4 }
        ]

        onPressed: updatePointCount()
        onReleased: updatePointCount()
        onTouchUpdated: {
            p2.touchX = point1.x; p2.touchY = point1.y; p2.pressed = point1.pressed;
            p3.touchX = point2.x; p3.touchY = point2.y; p3.pressed = point2.pressed;
            p4.touchX = point3.x; p4.touchY = point3.y; p4.pressed = point3.pressed;
            p5.touchX = point4.x; p5.touchY = point4.y; p5.pressed = point4.pressed;
        }

        function updatePointCount(){
            var tmp = 0
            for (var i=0; i<4; i++) {
                if (touchPoints[i].pressed)
                    tmp++
            }
            pointCount = tmp
        }
    }

    /**
     * For desktop.
     */
    MouseArea {
        id: mouseArea
        anchors.fill: parent

        property int pointCount:0

        onPressed: {
            pointCount = 1;
            p1.touchX = mouse.x;
            p1.touchY = mouse.y;
            p1.pressed = true;
        }
        onReleased: {
            pointCount = 0;
            p1.pressed = false;
        }
        onPositionChanged: {
            p1.touchX = mouse.x;
            p1.touchY = mouse.y;
        }
    }
}
