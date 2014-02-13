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
import QtMultimedia 5.0
import QtQuick.XmlListModel 2.0

FocusScope {
    id: scope
    x: parent.x; y: parent.y
    width: parent.width; height: parent.height
    focus: true
    property bool active: false

    Rectangle {
        id: root
        width:parent.width
        height: parent.height
        anchors.centerIn: parent
        focus: true
        color: "#262626"

        Audio {
            id: playMusic
            source: ""
            volume: volumeButton.volume
            autoLoad: true
            Component.onDestruction: {
                volumeButton.playing = false
                playMusic.stop()
                playMusic.source = ""
            }
        }

        Rectangle {
            id: playerRect
            anchors.top: volumeButton.top
            anchors.left: volumeButton.left
            anchors.bottom: volumeButton.bottom
            anchors.right: parent.right
            anchors.rightMargin: parent.height*.05
            gradient: Gradient {
                GradientStop {position: .1; color: "lightgrey"}
                GradientStop {position: 1.0; color: "white"}
            }
            border {width:1; color: "#888888"}
            radius: height/2

            Rectangle {
                id: displayRect
                anchors.fill: parent
                anchors.margins: parent.height*.1
                gradient: Gradient {
                    GradientStop {position: .0; color: "#095477"}
                    GradientStop {position: 1.0; color: "#052e41"}
                }
                border {width:1; color: "#888888"}
                radius: height/2
                clip: true


                Item {
                    id: networkErrorBox
                    opacity: 0
                    anchors.fill: parent

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width * 0.1
                        text: qsTr("Sorry! No network connection")
                        font.pixelSize: stationList.height*.1;
                        color: "white"
                        smooth: true
                    }
                }

                PathView {
                    //enabled: root.activeFocus
                    id: stationList
                    anchors.fill:parent
                    anchors.leftMargin: parent.height*.9
                    model: stationModel
                    property int openedIndex: -1

                    onMovementStarted: {
                        idleTimer.stop()
                        openedIndex = -1
                    }
                    onMovementEnded: idleTimer.restart()

                    onOpenedIndexChanged: {
                        if (openedIndex === -1) return
                        idleTimer.lastIndex=openedIndex
                        positionViewAtIndex(openedIndex, PathView.Center)
                    }

                    Timer {
                        id: idleTimer
                        interval: 5000
                        property int lastIndex: -1
                        onTriggered: {
                            stationList.openedIndex = idleTimer.lastIndex
                        }
                    }

                    Timer {
                        id: browseTimer
                        interval: 1000
                        property string source:""
                        onTriggered: {

                            if (playMusic.status===Audio.Loading) {
                                browseTimer.restart()
                                return;
                            }
                            playMusic.stop()
                            playMusic.source = ""
                            playMusic.source = source

                        }
                    }

                    path: Path {
                        startX: stationList.x; startY: 0
                        PathArc {
                            id: pathArc
                            x: stationList.x; relativeY: stationList.height*1.1
                            radiusX: volumeButton.height/2
                            radiusY: volumeButton.height/2
                            useLargeArc: false
                        }
                    }

                    delegate:  Item {
                        id: stationDelegate
                        property bool opened: stationList.openedIndex === index
                        width: stationList.width*.7
                        height: opened? stationList.height*.4: stationList.height*.2

                        Behavior on height {NumberAnimation{duration:200}}

                        Text {
                            id: delegateText
                            anchors.left: parent.left
                            anchors.top: parent.top
                            text: (index+1) +". " +title
                            font.pixelSize: stationDelegate.opened? stationList.height*.15 : stationList.height*.1
                            font.weight: stationDelegate.opened? Font.Bold: Font.Normal
                            color: stationList.openedIndex ===-1 || opened? "white": "#0e82b8"
                            Behavior on font.pixelSize {NumberAnimation{duration:200}}
                        }

                        Text {
                            id: statustextText
                            anchors.left: parent.left
                            anchors.top: delegateText.bottom

                            text: playMusic.playbackState=== Audio.PlayingState ? "Playing...":
                                                                                  playMusic.status=== Audio.Buffering ? "Buffering...":
                                                                                                                        playMusic.status=== Audio.Loading ? "Loading...":
                                                                                                                                                            playMusic.playbackState=== Audio.StoppedState ? "Stopped":"Error"

                            font.pixelSize: stationList.height*.1
                            color: delegateText.color
                            opacity: opened? 1.0: .0
                            Behavior on opacity {NumberAnimation{duration:200}}
                        }


                        MouseArea {
                            anchors.fill: parent
                            visible: root.activeFocus

                            onClicked: {
                                if (opened){
                                    idleTimer.lastIndex=-1
                                    stationList.openedIndex=-1
                                }else {
                                    stationList.openedIndex= index
                                    browseTimer.source = url
                                    browseTimer.restart()
                                }
                            }
                        }
                    }
                }
            }
        }

        XmlListModel {
            id: stationModel
            source: "http://qt-project.org/uploads/videos/qt5_radio_channels.xml"
            query: "/radio/channel"
            XmlRole {name: "title"; query: "title/string()"}
            XmlRole {name: "url"; query: "url/string()"}

            onStatusChanged: {
                if (status == XmlListModel.Ready) {
                    networkErrorBox.opacity = 0;
                } else if (status == XmlListModel.Error) {
                    networkErrorBox.opacity = 1;
                }
            }
        }

        VolumeButton {
            id: volumeButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: size*.1
            size:parent.height*.5
            playing: playMusic.playbackState === Audio.PlayingState
            onClicked: {
                if (!playMusic.source) return;
                if (!playing) {
                    playMusic.play()
                }else {
                    playMusic.stop()
                }
            }
        }

        Component.onCompleted: {
            volumeButton.init()
            scope.focus = true
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_Down || event.key === Qt.Key_VolumeDown) {
                event.accepted = true
                if (volumeButton.volume > .1){
                    volumeButton.volume-=.1
                }else{
                    volumeButton.volume = 0.0
                }
            }

            if (event.key === Qt.Key_Up || event.key === Qt.Key_VolumeUp) {
                event.accepted = true
                if (volumeButton.volume < .9){
                    volumeButton.volume+=.1
                }else{
                    volumeButton.volume = 1.0
                }
            }
        }
    }
}
