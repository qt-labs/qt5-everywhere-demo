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
import "style.js" as Style
//based on the SmokeText component from SameGame

Item {
    id: root
    anchors.fill: parent
    z:1

    property alias text: txt.text

    Rectangle{
        id: background
        anchors.fill:parent
        color: "black"
    }

    ParticleSystem{
        id: particleSystem;
        anchors.fill: parent

        Text {
            id: txt
            color: 'white'
            font.pixelSize: parent.width *.2
            font.family: fontLoader.name
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
