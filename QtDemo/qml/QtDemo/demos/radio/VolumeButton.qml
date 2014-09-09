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
    id: root
    width: size
    height: size

    property int steps: 10
    property int size: 0
    property real volume: .5
    property bool playing: false
    signal clicked();

    Item {
        id: bg
        anchors.fill: parent

        Rectangle {
            id: bgRect

            gradient: Gradient {
                GradientStop {position: .0; color: "lightgray"}
                GradientStop {position: 1.0; color: "white"}
            }

            border {width:1; color: "#888888"}
            radius: root.size/2
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
        }

        Rectangle {
            gradient: Gradient {
                GradientStop {position: .0; color: playButtonMouseArea.pressed ? "#052e41": "#095477"}
                GradientStop {position: 1.0; color: playButtonMouseArea.pressed ? "#095477": "#052e41"}
            }

            border {width:1; color: "#888888"}
            radius: width/2
            anchors.centerIn: parent
            width: parent.width*.6
            height: parent.height*.6

            Image {
                anchors {fill: parent; margins: parent.height*.3}
                source: !root.playing ? "images/radio_btn_play.png" : "images/radio_btn_pause.png"
            }

            MouseArea {
                id: playButtonMouseArea
                anchors.fill: parent
                anchors.margins: parent.width*.2
                onClicked:{
                    root.clicked()
                }
            }
        }
    }

    Item {
        id: volumeIndicator
        anchors.centerIn: root
        width: root.size
        height: root.size
        z:2

        Rectangle{
            id: volumeCircle
            objectName: "volumeCircle"
            anchors {horizontalCenter: parent.horizontalCenter; top: parent.top}

            gradient: Gradient {
                GradientStop {position: .1; color: "#095477"}
                GradientStop {position: 1.0; color: "#0e82b8"}
            }

            width: root.size * .2
            height: width
            radius: width/2
            border {width:1; color: "#888888"}

            Image {
                anchors {fill: parent; margins: parent.height*.2}
                source: "images/radio_sound_icon.png"
                rotation: -volumeRotation.angle
            }
        }

        transform: Rotation {
            id: volumeRotation
            origin.x: volumeIndicator.width/2
            origin.y: volumeIndicator.height/2
            angle: 270.0*root.volume+225
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: volumeIndicator
        property bool grabbed: false
        anchors.margins: -root.size*.2
        z: -1

        onPressed: {
            var object = mapToItem(volumeIndicator, mouse.x, mouse.y)
            var item = volumeIndicator.childAt(object.x,object.y)
            if (item && item.objectName === 'volumeCircle') {
                grabbed = true
                return;
            } else {
                grabbed = false
            }

            object = mapToItem(root, mouse.x, mouse.y)
            item = root.childAt(object.x,object.y)
            if (item && item.objectName === 'volumePoint') {
                root.volume = item.level
            }
        }

        onPositionChanged: {
            if (!grabbed) return;
            var ang = (225+Math.atan2((mouse.y-mouseArea.height/2.0), (mouse.x-mouseArea.width/2.0))*180.0/Math.PI)
            if (ang >360) ang-=360
            if (ang > 270) return;
            root.volume = (ang)/270.0
        }
    }

    function init(){
        for (var i=0; i<=root.steps; i++){
            var x=Math.cos(((i)*270/root.steps+135)*0.01745)*root.size*.40
            var y=Math.sin(((i)*270/root.steps+135)*0.01745)*root.size*.40
            var component = Qt.createComponent("VolumePoint.qml")
            if (component.status === Component.Ready) {
                var object = component.createObject(root);
                object.size = root.size*.05
                object.x = root.size/2+x-object.size/2
                object.y = root.size/2+y-object.size/2
                object.level = i/root.steps
            }
        }
    }
}
