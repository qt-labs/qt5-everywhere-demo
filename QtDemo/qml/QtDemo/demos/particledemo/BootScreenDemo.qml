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
