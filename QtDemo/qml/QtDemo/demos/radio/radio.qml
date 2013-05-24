import QtQuick 2.0
import QtMultimedia 5.0

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
            onSourceChanged: {
                if (volumeButton.playing) playMusic.play()
            }
            onAvailabilityChanged: {
                if (availability === Audio.Available) {
                    if (volumeButton.playing) playMusic.play()
                }
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


                PathView {
                    enabled: root.activeFocus
                    id: stationList
                    anchors.fill:parent
                    anchors.leftMargin: parent.height*.9
                    model: stationModel
                    pathItemCount: 6
                    clip: true
                    property int openedIndex: -1

                    onMovementStarted: {
                        idleTimer.stop()
                        openedIndex = -1
                        pathItemCount = 5
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
                        interval: 500
                        property string source:""
                        onTriggered: playMusic.source = source
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
                            text: (index+1) +". " +name
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
                                    browseTimer.source = source
                                    browseTimer.restart()
                                }
                            }
                        }
                    }
                }
            }
        }

        ListModel {
            id: stationModel
            ListElement{name: "BBC World Service"; source: "http://vpr.streamguys.net/vpr24.mp3"}
            ListElement{name: "CBC Music Hard Rock"; source: "http://2903.live.streamtheworld.com:80/CBC_HAROCK_H_SC.mp3"}
            ListElement{name: "JPR Classics & News"; source: "http://jpr.streamguys.org:80/jpr-classics"}
            ListElement{name: "VPR Classical"; source: "http://vprclassical.streamguys.net/vprclassical24.mp3"}
            ListElement{name: "VPR Jazz24"; source: "http://vprjazz.streamguys.net/vprjazz24.mp3"}
            ListElement{name: "Radio Paradise"; source: "http://scfire-m26.websys.aol.com:80/radio_paradise_mp3_128kbps.mp3"}
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
