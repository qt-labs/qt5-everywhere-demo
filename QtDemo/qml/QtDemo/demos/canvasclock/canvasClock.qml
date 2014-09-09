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

Rectangle {
    id: root
    anchors.fill: parent
    property color rimColor: Qt.rgba(1,0,0,1) //'#ff0000'
    property color dialColor: Qt.rgba(0.2,0.2,0.2,1) //'#333333'
    property color bgcolor: Qt.rgba(1,1,1,1)
    property int dialStyle: 0
    color: "#333333"

    Text{
        id: codeText
        anchors {fill:parent}
        text: ""
        rotation: 10
        color: "#666666"
        font.pixelSize: root.height*.05

        verticalAlignment:Text.AlignBottom

        property int pos: 0

        property string code: "
var ctx = clockCanvas.getContext('2d')
ctx.clearRect(0,0,clockContainer.clockRadius,clockContainer.clockRadius)

var gradient = ctx.createRadialGradient(clockContainer.clockRadius/4, clockContainer.clockRadius/4, 0, clockContainer.clockRadius/4, clockContainer.clockRadius/4, clockContainer.clockRadius)
gradient.addColorStop(0, '#ffffff')
gradient.addColorStop(1, '#888888')

ctx.fillStyle = gradient
ctx.arc(clockContainer.clockRadius/2, clockContainer.clockRadius/2, clockContainer.clockRadius*.475, 0, 360, false)
ctx.fill()

drawDials(ctx)

var gradient2 = ctx.createLinearGradient(0, 0, clockContainer.clockRadius, clockContainer.clockRadius)
gradient2.addColorStop(0, Qt.rgba(0,0,0,.5))
gradient2.addColorStop(.5, Qt.rgba(1,1,1,.5))
gradient2.addColorStop(1, Qt.rgba(0,0,0,.5))

var gradient3 = ctx.createLinearGradient(0, 0, clockContainer.clockRadius, clockContainer.clockRadius)
gradient3.addColorStop(0, Qt.rgba(1,1,1,.5))
gradient3.addColorStop(.5, Qt.rgba(0,0,0,.5))
gradient3.addColorStop(1, Qt.rgba(1,1,1,.5))

ctx.lineWidth = clockContainer.clockRadius*.05
ctx.strokeStyle = root.rimColor

ctx.beginPath()
ctx.arc(clockContainer.clockRadius/2, clockContainer.clockRadius/2, clockContainer.clockRadius*.45, 0, 360, false)
ctx.stroke()

ctx.strokeStyle = gradient2
ctx.arc(clockContainer.clockRadius/2, clockContainer.clockRadius/2, clockContainer.clockRadius*.45, 0, 360, false)
ctx.stroke()

ctx.beginPath()
ctx.strokeStyle = root.rimColor
ctx.arc(clockContainer.clockRadius/2, clockContainer.clockRadius/2, clockContainer.clockRadius*.475, 0, 360, false)
ctx.stroke()

ctx.strokeStyle = gradient3
ctx.arc(clockContainer.clockRadius/2, clockContainer.clockRadius/2, clockContainer.clockRadius*.475, 0, 360, false)
ctx.stroke()
ctx.closePath()

function drawPointer(context, angle, len, thickness, color){
    context.beginPath()
    context.lineWidth = thickness
    context.strokeStyle = color
    context.moveTo(clockContainer.clockRadius/2, clockContainer.clockRadius/2)
    var x1=Math.cos(angle*0.01745)*len
    var y1=Math.sin(angle*0.01745)*len
    context.lineTo(clockContainer.clockRadius/2+.5+x1,clockContainer.clockRadius/2+.5+y1)
    context.stroke()
    context.closePath()
}"

        Timer{
            id: textTimer
            interval: 10
            onTriggered: {
                codeText.pos++
                if (codeText.pos >= codeText.code.length)codeText.pos=0
                codeText.text+=codeText.code.charAt(codeText.pos)
                if (codeText.text.length >1000){
                    codeText.text=codeText.text.substring(codeText.text.length-1000)
                }
            }
            repeat: true
            running: true
        }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {position: .0; color :"black"}
            GradientStop {position: .5; color :"transparent"}
            GradientStop {position: 1.0; color :"black"}

        }
        opacity: .5
    }

    Item {
        id: clockContainer
        width: 2* Math.min(root.width*.8, root.height*.8)
        height: width
        scale: 0.5
        anchors.centerIn: parent
        property int clockRadius: width

        ShaderEffectSource{
            id: clockBg
            anchors.fill: parent
            sourceItem: clockCanvas
            hideSource: true
            live: false
        }

        Canvas {
            id: clockCanvas
            anchors.fill: parent
            onPaint: {
                var ctx = clockCanvas.getContext('2d')

                ctx.clearRect(0,0,clockContainer.clockRadius,clockContainer.clockRadius)

                var gradient = ctx.createRadialGradient(clockContainer.clockRadius/4, clockContainer.clockRadius/4, 0, clockContainer.clockRadius/4, clockContainer.clockRadius/4, clockContainer.clockRadius)

                ctx.fillStyle = root.bgcolor
                ctx.arc(clockContainer.clockRadius/2, clockContainer.clockRadius/2, clockContainer.clockRadius*.475, 0, 360, false)
                ctx.fill()

                gradient.addColorStop(0, Qt.rgba(0,0,0,0))
                gradient.addColorStop(1, Qt.rgba(0,0,0,.5))

                ctx.fillStyle = gradient
                ctx.arc(clockContainer.clockRadius/2, clockContainer.clockRadius/2, clockContainer.clockRadius*.475, 0, 360, false)
                ctx.fill()

                drawDials(ctx)

                var gradient2 = ctx.createLinearGradient(0, 0, clockContainer.clockRadius, clockContainer.clockRadius)
                gradient2.addColorStop(0, Qt.rgba(0,0,0,.5))
                gradient2.addColorStop(.5, Qt.rgba(1,1,1,.5))
                gradient2.addColorStop(1, Qt.rgba(0,0,0,.5))

                var gradient3 = ctx.createLinearGradient(0, 0, clockContainer.clockRadius, clockContainer.clockRadius)
                gradient3.addColorStop(0, Qt.rgba(1,1,1,.5))
                gradient3.addColorStop(.5, Qt.rgba(0,0,0,.5))
                gradient3.addColorStop(1, Qt.rgba(1,1,1,.5))

                ctx.lineWidth = clockContainer.clockRadius*.05

                ctx.strokeStyle = root.rimColor
                ctx.beginPath()
                ctx.arc(clockContainer.clockRadius/2, clockContainer.clockRadius/2, clockContainer.clockRadius*.45, 0, 360, false)
                ctx.stroke()

                ctx.strokeStyle = gradient2
                ctx.arc(clockContainer.clockRadius/2, clockContainer.clockRadius/2, clockContainer.clockRadius*.45, 0, 360, false)
                ctx.stroke()

                ctx.beginPath()
                ctx.strokeStyle = root.rimColor
                ctx.arc(clockContainer.clockRadius/2, clockContainer.clockRadius/2, clockContainer.clockRadius*.475, 0, 360, false)
                ctx.stroke()

                ctx.strokeStyle = gradient3

                ctx.arc(clockContainer.clockRadius/2, clockContainer.clockRadius/2, clockContainer.clockRadius*.475, 0, 360, false)
                ctx.stroke()
                ctx.closePath()


                clockBg.scheduleUpdate()
            }

            function drawDials(context){

                context.strokeStyle = "#888888"
                context.fillStyle = root.dialColor
                context.lineWidth = 2
                context.beginPath()
                for (var i=1; i<=60; i++){
                    var x1=Math.cos(((i)*6)*0.01745)*clockContainer.clockRadius*.4
                    var y1=Math.sin(((i)*6)*0.01745)*clockContainer.clockRadius*.4

                    var x2=Math.cos(((i)*6)*0.01745)*clockContainer.clockRadius*.45
                    var y2=Math.sin(((i)*6)*0.01745)*clockContainer.clockRadius*.45

                    context.moveTo(clockContainer.clockRadius/2+.5+x1,clockContainer.clockRadius/2+.5+y1)
                    context.lineTo(clockContainer.clockRadius/2+.5+x2,clockContainer.clockRadius/2+.5+y2)
                    context.stroke()
                }
                context.closePath()

                context.strokeStyle = "#222222"
                context.beginPath()

                var romans = ['I','II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI', 'XII']
                for (i=1; i<=12; i++){
                    x1=Math.cos((-90+(i)*30)*0.01745)*clockContainer.clockRadius*.35 -clockContainer.width*0.03
                    y1=Math.sin((-90+(i)*30)*0.01745)*clockContainer.clockRadius*.35 +clockContainer.height*0.04

                    if (root.dialStyle === 1) x1-=clockContainer.width*0.01

                    context.font = 'bold '+Math.floor(clockContainer.width*.07)+'px sans-serif'


                    if (i >= 10)
                        x1 -= clockContainer.width*0.02
                    context.textAlign = 'right';
                    context.textBaseline  = 'middle'

                    var dial = i

                    if (root.dialStyle === 1) dial = romans[i-1]
                    context.text(dial,clockContainer.clockRadius/2+x1,clockContainer.clockRadius/2+y1)

                    context.fill()
                    context.stroke()
                }
                context.closePath()
            }
        }

        Canvas {
            id: clockPointers
            anchors.fill: parent
            antialiasing: true
            renderTarget: Canvas.Image
            onPaint: {
                var ctx = clockPointers.getContext('2d')
                ctx.clearRect(0,0,clockContainer.clockRadius,clockContainer.clockRadius)
                ctx.lineCap = 'round'
                drawPointer(ctx, -90+clock.hours*30, clockContainer.clockRadius*.25, clockContainer.clockRadius*.05, "#000000")
                drawPointer(ctx, -90+clock.minutes*6, clockContainer.clockRadius*.375, clockContainer.clockRadius*.025, "#333333")
                drawPointer(ctx, -90+clock.seconds*6, clockContainer.clockRadius*.40, 4, "#aa0000")

                // Draw nail
                ctx.beginPath()
                ctx.fillStyle = "#535353"
                ctx.ellipse(clockContainer.clockRadius/2-16,clockContainer.clockRadius/2-16,32,32)
                ctx.fill()
                ctx.closePath()
            }

            function drawPointer(context, angle, len, thickness, color){
                context.beginPath()
                context.lineWidth = thickness
                context.strokeStyle = color
                context.moveTo(clockContainer.clockRadius/2, clockContainer.clockRadius/2)
                var x1=Math.cos(angle*0.01745)*len
                var y1=Math.sin(angle*0.01745)*len
                context.lineTo(clockContainer.clockRadius/2+.5+x1,clockContainer.clockRadius/2+.5+y1)
                context.stroke()
                context.closePath()
            }
        }

        Timer{
            id: clock
            interval: 1000
            repeat: true
            running: !mouseArea.pressed

            property int hours: 0
            property int minutes: 0
            property int seconds: 0

            onTriggered: {
                seconds ++
                if (seconds == 60) seconds = 0

                if (seconds == 0) minutes++
                if (minutes == 60) {
                    hours++
                    minutes=0
                }

                if (hours >= 12) hours=0

                clockPointers.requestPaint()
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: clockContainer
        property bool grabbed: false

        onPressed: {

            var temp = clockContainer.clockRadius/2
            var ang = (90+Math.atan2((mouseY-temp), (mouseX-temp))*57.2957795)
            if (ang <0) ang+=360

            if (ang/6 > clock.minutes-2 && ang/6<clock.minutes+2){

                grabbed = true
                return;
            } else {
                var y = mouseY-temp
                var x = mouseX-temp
                var dist = Math.sqrt(y*y+x*x)

                if (dist>clockContainer.clockRadius*.42*clockContainer.scale){
                    root.rimColor = newColor()
                    clockCanvas.requestPaint()
                    return;
                }else if (dist>clockContainer.clockRadius*.32*clockContainer.scale) {
                    root.dialStyle = Math.round(Math.random())
                    root.dialColor = newColor()
                    clockCanvas.requestPaint()
                }else{
                    root.bgcolor = newColor()
                    clockCanvas.requestPaint()
                }
            }
        }

        onPositionChanged: {
            if (grabbed) {
                var temp = clockContainer.clockRadius/2
                var ang = (90+Math.atan2((mouseY-temp), (mouseX-temp))*57.2957795)
                if (ang <0) ang+=360

                var oldMinutes = clock.minutes
                clock.minutes=ang/6

                if (oldMinutes>55 && clock.minutes <5) clock.hours++
                if (oldMinutes<5 && clock.minutes >50) clock.hours--
                if (clock.hours >12) clock.hours=1
                if (clock.hours <0) clock.hours=11


                clockPointers.requestPaint()
            }
        }
        onReleased: grabbed = false;
    }

    function newColor(){
        var r=Math.random()
        var g=Math.random()
        var b=Math.random()
        return Qt.rgba(r,g,b,1)
    }

    Component.onCompleted: {
        var d = new Date()
        clock.hours = d.getHours()
        if (clock.hours>=12)clock.hours-=12
        clock.minutes = d.getMinutes()
        clock.seconds = d.getSeconds()
        clockCanvas.requestPaint()
    }
}
