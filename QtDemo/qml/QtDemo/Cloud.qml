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

Item {
    id: cloudRoot
    x: app.width
    y: randomY+deltaY
    width: app.width*0.2
    height: width*0.4

    property int duration: 20000
    property string sourceImage: ""
    property real deltaY: 0
    property real randomY: app.height*0.3
    property real amplitudeY: app.height*0.2

    function start() {
        recalculate()
        cloudXAnimation.restart();
        cloudYAnimation.restart();
    }

    function recalculate() {
        cloudRoot.duration = Math.random()*15000 + 10000
        cloudRoot.x = app.width
        cloudRoot.randomY = Math.random()*app.height
        cloudRoot.width = app.width*0.2
        cloudRoot.height = cloudRoot.width*0.4
        cloudRoot.scale = Math.random()*0.6 + 0.7
    }

    Image {
        id: cloud
        anchors.fill: cloudRoot
        source: cloudRoot.sourceImage
    }

    SequentialAnimation{
        id: cloudYAnimation
        NumberAnimation { target: cloudRoot; property: "deltaY"; duration: cloudRoot.duration*0.3; from: 0; to:cloudRoot.amplitudeY; easing.type: Easing.InOutQuad }
        NumberAnimation { target: cloudRoot; property: "deltaY"; duration: cloudRoot.duration*0.3; from: cloudRoot.amplitudeY; to:0; easing.type: Easing.InOutQuad }
        running: true
        onRunningChanged: {
            if (!running) {
                cloudRoot.amplitudeY = Math.random() * (app.height*0.2)
                restart()
            }
        }
    }

    NumberAnimation {
        id: cloudXAnimation
        target: cloudRoot
        property: "x"
        duration: cloudRoot.duration
        to:-cloudRoot.width
        running: true

        onRunningChanged: {
            if (!running) {
                recalculate()
                restart()
            }
        }
    }
}
