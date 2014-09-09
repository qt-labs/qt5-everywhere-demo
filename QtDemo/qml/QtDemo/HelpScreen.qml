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
import "style.js" as Style

Item {
    id: root
    anchors.fill:parent
    property int delay: 500
    property int rotationAngle:0

    SequentialAnimation {
        id: closeAnimation

        ScriptAction{
            script: {
                pointer.visible = false
                instructionText.text = ""
                instructionText2.text = ""
                highlightImage.smooth = false
                highlight.size = Math.max(root.height, root.width)*2.5
            }
        }

        PauseAnimation { duration: root.delay }

        onRunningChanged: if (!running){
                              stopAnimations()
                              root.visible=false
                              highlight.size=0
                              highlightImage.smooth = true
                          }
    }


    Item{
        id: highlight
        property int size: 0
        property bool hidden: false
        width:1
        height:1
        Behavior on x {NumberAnimation{duration: root.delay}}
        Behavior on y {NumberAnimation{duration: root.delay}}
        Behavior on size {id: sizeBehavior; NumberAnimation{duration: root.delay}}
    }

    Image{
        id: highlightImage
        anchors.centerIn: highlight
        width: highlight.hidden? 0: highlight.size
        height: highlight.hidden? 0: highlight.size
        source: "images/highlight_mask.png"
        opacity: .8
        smooth: true
    }

    Rectangle{
        id: top
        anchors {left:parent.left; top: parent.top; right: parent.right; bottom: highlightImage.top}
        color: "black"
        opacity: .8
    }

    Rectangle{
        id: bottom
        anchors {left:parent.left; top: highlightImage.bottom; right: parent.right; bottom: parent.bottom}
        color: "black"
        opacity: .8
    }

    Rectangle{
        id: left
        anchors {left:parent.left; top: highlightImage.top; right: highlightImage.left; bottom: highlightImage.bottom}
        color: "black"
        opacity: .8
    }

    Rectangle{
        id: right
        anchors {left:highlightImage.right; top: highlightImage.top; right: parent.right; bottom: highlightImage.bottom}
        color: "black"
        opacity: .8
    }

    Text{
        id: instructionText
        anchors {horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: parent.height*.05}
        text: ""
        font.pixelSize: parent.width*.075
        font.family: fontLoader.name
        smooth: true
        color: "white"

        Text{
            id: instructionText2
            anchors {horizontalCenter: parent.horizontalCenter; top: parent.bottom; topMargin: -parent.height/2}
            text: ""
            font.pixelSize: parent.font.pixelSize
            font.family: fontLoader.name
            smooth: true
            color: "white"
        }
    }

    Item{
        id: pointer
        width: parent.width*.3
        height: parent.width*.3

        Image{
            id: handImage
            width: parent.width*.8
            height: width
            source: "images/hand.png"
            y: parent.height/2-height/2
            x: parent.width/2-width/2+deltaX
            property int deltaX:0
            anchors.verticalCenter: parent.verticalCenter
            rotation: 90

            SequentialAnimation{
                id: pointingAnimation
                PauseAnimation { duration: root.delay}
                NumberAnimation{
                    target: handImage
                    property: "deltaX"
                    from: -handImage.width*.2
                    to: handImage.width*.2
                    duration: 500
                    easing.type: Easing.InOutCubic
                }
                PauseAnimation { duration: 200 }
                NumberAnimation{
                    target: handImage
                    property: "deltaX"
                    from: handImage.width*.2
                    to: -handImage.width*.2
                    duration: 500
                    easing.type: Easing.InOutCubic

                }
            }

        }
    }

    SequentialAnimation {
        id: helpAnimation
        loops: Animation.Infinite

        PauseAnimation { duration: 1000 }
        PropertyAction { target: handImage; property: "mirror"; value: true}
        PropertyAction { target: instructionText; property: "text"; value: "Tap on the devices to"}
        PropertyAction { target: instructionText2; property: "text"; value: "open applications"}
        PropertyAction { target: pointer; property: "visible"; value: true}
        PropertyAction { target: highlight; property: "hidden"; value: false}

        SequentialAnimation {
            id: clickAnimation
            property int index: 0
            property variant uids: [8,12]
            loops: 2

            ScriptAction{
                script: {
                    clickAnimation.index+=1
                    if (clickAnimation.index>=clickAnimation.uids.length) clickAnimation.index=0
                }
            }

            ScriptAction{
                script: {
                    highlight.size= (700+clickAnimation.index*100)*canvas.scalingFactor

                    highlight.x=root.width/2 +app.getPosition(clickAnimation.uids[clickAnimation.index]).x*canvas.scalingFactor
                    highlight.y=root.height/2 +app.getPosition(clickAnimation.uids[clickAnimation.index]).y*canvas.scalingFactor

                    pointer.x= root.width/2 -pointer.width/2 +app.getPosition(clickAnimation.uids[clickAnimation.index]).x*canvas.scalingFactor*.5
                    pointer.y= root.height/2 -pointer.height/2 +app.getPosition(clickAnimation.uids[clickAnimation.index]).y*canvas.scalingFactor*.5
                    pointer.rotation=Math.atan2(app.getPosition(clickAnimation.uids[clickAnimation.index]).y*canvas.scalingFactor, app.getPosition(clickAnimation.uids[clickAnimation.index]).x*canvas.scalingFactor)*180.0/Math.PI
                    pointingAnimation.restart()
                }
            }

            PauseAnimation { duration: 3000 }
        }
        PauseAnimation { duration: 1000 }

        SequentialAnimation{
            id: navigationAnimation
            PropertyAction { target: handImage; property: "mirror"; value: false}
            PropertyAction { target: instructionText; property: "text"; value: "Use the Arrow to navigate"}
            PropertyAction { target: instructionText2; property: "text"; value: "between applications"}
            ScriptAction{
                script: {
                    highlight.size= Math.min(root.width, root.height)*.4

                    var _x=0;
                    var _y=0;

                    if (root.width > root.height){
                        _x = navigationPanel.x+navigationPanel.width /2
                        _y = navigationPanel.y+navigationPanel.height*.33
                        pointer.x= root.width/2 -pointer.width/2 +root.width*.2
                        pointer.y= root.height/2 -pointer.height/2
                        highlight.x=_x
                        highlight.y=_y

                    }else{
                        _x=navigationPanel.x+navigationPanel.width*.33
                        _y=navigationPanel.y + navigationPanel.height /2
                        pointer.x= root.width/2 -pointer.width/2
                        pointer.y= root.height/2 -pointer.height/2 +root.height*.2
                        highlight.x=_x
                        highlight.y=_y
                    }

                    pointer.rotation=Math.atan2(_y-(pointer.y+pointer.height/2), _x-(pointer.x+pointer.width/2))*180.0/Math.PI

                    pointingAnimation.restart()
                }
            }
            PauseAnimation { duration: 5000 }

            PropertyAction { target: instructionText; property: "text"; value: "Use the Home button to"}
            PropertyAction { target: instructionText2; property: "text"; value: "return to the beginning"}
            ScriptAction{
                script: {
                    highlight.size= Math.min(root.width, root.height)*.3

                    var _x=0;
                    var _y=0;

                    if (root.width > root.height){
                        _x = navigationPanel.x+navigationPanel.width /2
                        _y = navigationPanel.y+navigationPanel.height-navigationPanel.width /2
                        pointer.x= root.width/2 -pointer.width/2 +root.width*.2
                        pointer.y= root.height/2 -pointer.height/2
                        highlight.x=_x
                        highlight.y=_y

                    }else{
                        _x=navigationPanel.x+navigationPanel.width-navigationPanel.height /2
                        _y=navigationPanel.y + navigationPanel.height /2
                        pointer.x= root.width/2 -pointer.width/2
                        pointer.y= root.height/2 -pointer.height/2 +root.height*.2
                        highlight.x=_x
                        highlight.y=_y
                    }
                    pointer.rotation=Math.atan2(_y-(pointer.y+pointer.height/2), _x-(pointer.x+pointer.width/2))*180.0/Math.PI

                    pointingAnimation.restart()
                }
            }
            PauseAnimation { duration: 5000 }
        }

    }

    onWidthChanged: if (visible) show()
    onHeightChanged: if (visible) show()

    function show(){
        highlight.hidden = true

        pointer.visible = false
        rotationAngle = 0

        startAnimations()
        visible = true
    }

    function startAnimations(){
        pointingAnimation.restart()
        helpAnimation.restart()
    }

    function stopAnimations(){
        pointingAnimation.stop()
        helpAnimation.stop()
    }

    MouseArea{
        anchors.fill: root
        onClicked: {
            stopAnimations()
            closeAnimation.restart()
        }
    }
}

