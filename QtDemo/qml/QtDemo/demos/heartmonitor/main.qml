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
import "HeartData.js" as Data

Rectangle {
    id: app
    anchors.fill: parent
    color: "black"

    property int frequency: 60
    property int beatDataIndex: -1
    property int heartDataIndex: 0
    property int beatDifference: 1200
    property var previousTime: 0
    property string curveColor: "#22ff22"
    property string alarmColor: "#ff2222"
    property string textColor: "#22ff22"
    property string gridColor: "#333333"

    function pulse() {
        if (!heartAnimation.running) {
            heartAnimation.restart()
            heartTimer.restart()
            calculateFrequency();
            app.beatDataIndex = 0
        }
    }

    function calculateFrequency() {
        var ms = new Date().getTime();
        if (app.previousTime > 0)
            app.beatDifference = 0.8*beatDifference + 0.2*(ms - app.previousTime)
        app.frequency = Math.round(60000.0 / app.beatDifference)
        app.previousTime = ms;
    }

    function updateData() {
        app.heartDataIndex++;
        if (app.heartDataIndex >= Data.heartData.length)
            app.heartDataIndex = 0;
        else
            app.heartDataIndex++;

        if (beatDataIndex >= 0)
            fillBeatData()
        else
            fillRandomData()

        heartCanvas.requestPaint()
    }

    function fillBeatData() {
        var value = 0;
        switch (app.beatDataIndex) {
        case 0: value = Math.random()*0.1+0.1; break;
        case 1: value = Math.random()*0.1+0.0; break;
        case 2: value = Math.random()*0.3+0.7; break;
        case 3: value = Math.random()*0.1-0.05; break;
        case 4: value = Math.random()*0.3-0.8; break;
        case 5: value = Math.random()*0.1-0.05; break;
        case 6: value = Math.random()*0.1-0.05; break;
        case 7: value = Math.random()*0.1+0.15; break;
        default: value = 0; break;
        }

        Data.heartData[app.heartDataIndex] = value;
        app.beatDataIndex++;
        if (app.beatDataIndex > 7)
            app.beatDataIndex = -1
    }

    function fillRandomData() {
        Data.heartData[app.heartDataIndex] = Math.random()*0.05-0.025
    }

    onWidthChanged: {
        Data.fillHeartData(Math.floor(app.width*0.5))
        gridCanvas.requestPaint();
    }
    onHeightChanged: gridCanvas.requestPaint()

    Item {
        id: grid
        anchors.fill: parent

        Canvas {
            id: gridCanvas
            anchors.fill: parent
            antialiasing: true
            renderTarget: Canvas.Image
            onPaint: {
                var ctx = gridCanvas.getContext('2d')

                ctx.clearRect(0,0,grid.width,grid.height)
                var step = 1000 / updateTimer.interval * (app.width / Data.heartData.length)
                var xCount = app.width / step
                var yCount = app.height / step
                ctx.strokeStyle = app.gridColor;

                var x=0;
                ctx.beginPath()
                for (var i=0; i<xCount; i++) {
                    x = i*step
                    ctx.moveTo(x,0)
                    ctx.lineTo(x,app.height)
                }
                ctx.stroke()
                ctx.closePath()

                var y=0;
                ctx.beginPath()
                for (var j=0; j<yCount; j++) {
                    y = j*step
                    ctx.moveTo(0, y)
                    ctx.lineTo(app.width,y)
                }
                ctx.stroke()
                ctx.closePath()
            }
        }
    }

    Rectangle {
        id: canvasBackground
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        height: 0.75 * parent.height

        gradient: Gradient {
            GradientStop {position: .0; color :"black"}
            GradientStop {position: .5; color :"#00ff00"}
            GradientStop {position: 1.0; color :"black"}
        }
        opacity: .3
    }

    Item {
        id: canvasContainer
        anchors.fill: canvasBackground

        Canvas {
            id: heartCanvas
            anchors.fill: parent
            antialiasing: true
            renderTarget: Canvas.Image
            onPaint: {
                var ctx = heartCanvas.getContext('2d')

                ctx.clearRect(0,0,canvasContainer.width,canvasContainer.height)

                var baseY = heartCanvas.height/2;
                var length = Data.heartData.length;
                var step = (heartCanvas.width-5) / length;
                var yFactor = heartCanvas.height * 0.35;
                var heartIndex = (heartDataIndex+1) % length;
                ctx.strokeStyle = app.curveColor;

                ctx.beginPath()
                ctx.moveTo(0,baseY)
                var i=0, x=0, y=0;
                for (i=0; i<length; i++) {
                    x=i*step;
                    y=baseY - Data.heartData[heartIndex]*yFactor;
                    ctx.lineTo(x,y)
                    heartIndex = (heartIndex+1)%length;
                }
                ctx.stroke()
                ctx.closePath()

                ctx.beginPath()
                ctx.fillStyle = app.curveColor
                ctx.ellipse(x-5,y-5,10,10)
                ctx.fill()
                ctx.closePath()
            }
        }
    }
    Image {
        id: heart
        anchors { left: parent.left; top: parent.top }
        anchors.margins: app.width * 0.05
        height: parent.height * 0.2
        width: height*1.2
        source: "heart.png"
        MouseArea {
            anchors.fill: parent
            onPressed: pulse()
        }
    }

    Text {
        id: pulseText
        anchors { right: parent.right; verticalCenter: heart.verticalCenter }
        anchors.margins: app.width * 0.05
        antialiasing: true
        text: app.frequency
        color: app.frequency > 100 ? app.alarmColor : app.textColor
        font { pixelSize: app.width * .1; bold: true }
    }

    // Pulse timer
    Timer {
        id: heartTimer
        interval: 1200
        running: true
        repeat: false
        onTriggered: pulse()
    }

    // Update timer
    Timer {
        id: updateTimer
        interval: 30
        running: true
        repeat: true
        onTriggered: updateData()
    }

    SequentialAnimation{
        id: heartAnimation
        NumberAnimation { target: heart; property: "scale"; duration: 100; from: 1.0; to:1.2; easing.type: Easing.Linear }
        NumberAnimation { target: heart; property: "scale"; duration: 100; from: 1.2; to:1.0; easing.type: Easing.Linear }
    }

    Component.onCompleted: {
        Data.fillHeartData(Math.max(100,Math.floor(app.width*0.5)))
    }
}
