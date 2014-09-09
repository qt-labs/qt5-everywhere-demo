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

Item {
    id: controlBar
    anchors.fill: parent

    property MediaPlayer mediaPlayer: null
    property bool isMouseAbove: false
    property int margin: applicationWindow.width * 0.01

    signal openURL()

    state: "VISIBLE"

    onMediaPlayerChanged: {
        if (mediaPlayer === null)
            return;
        volumeControl.volume = mediaPlayer.volume;
    }

    function updateStatusText()
    {
        var strText = ""
        switch (mediaPlayer.status) {
            case MediaPlayer.NoMedia: strText = "No Media"; break;
            case MediaPlayer.Loading: strText = "Loading..."; break;
            case MediaPlayer.Buffering: strText = "Buffering..."; break;
            case MediaPlayer.Stalled: strText = "Stalled"; break;
            case MediaPlayer.EndOfMedia: strText = "EndOfMedia"; break;
            case MediaPlayer.InvalidMedia: strText = "InvalidMedia"; break;
            case MediaPlayer.UnknownStatus: strText = "UnknownStatus"; break;
            default: strText = ""; break;
        }

        statusText.text = strText;
    }

    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        width: applicationWindow.height * 0.12
        height: width
        color: "#88333333"

        Image {
            id: closeImage
            source: "images/CloseButton.png"
            anchors.centerIn: parent
            width: 0.5*parent.height
            height: width
            opacity: closeMouseArea.pressed ? 0.6 : 1
            smooth: true
        }

        MouseArea {
            id: closeMouseArea
            anchors.fill: parent
            onClicked: {
                if (mediaPlayer !== null) {
                    mediaPlayer.stop();
                    mediaPlayer.source = "";
                }

                videoSelector.show();
            }
        }
    }

    Rectangle {
        id: bottomBar
        height: parent.height * 0.2
        color: "#88333333"
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        property double playBackHeight: height*0.48
        property double seekHeight: height*0.48

        VolumeControl {
            id: volumeControl
            anchors.verticalCenter: playbackControl.verticalCenter
            anchors.left: bottomBar.left
            anchors.leftMargin: bottomBar.margin
            height: bottomBar.playBackHeight
            width: parent.width * 0.3
            onVolumeChanged: {
                if (mediaPlayer !== null)
                    mediaPlayer.volume = volume
            }

            Connections {
                target: mediaPlayer
                onVolumeChanged: volumeControl.volume = mediaPlayer.volume
            }
        }

        //Playback Controls
        PlaybackControl {
            id: playbackControl
            anchors.horizontalCenter: bottomBar.horizontalCenter
            anchors.top: bottomBar.top
            anchors.topMargin: bottomBar.margin
            height: bottomBar.playBackHeight

            onPlayButtonPressed: {
                if (mediaPlayer === null)
                    return;

                if (isPlaying) {
                    mediaPlayer.pause();
                } else {
                    mediaPlayer.play();
                }
            }
        }

        Text {
            id: statusText
            anchors.right: parent.right
            anchors.verticalCenter: playbackControl.verticalCenter
            anchors.rightMargin: bottomBar.margin
            verticalAlignment: Text.AlignVCenter
            height: bottomBar.playBackHeight
            font.pixelSize: playbackControl.height * 0.5
            color: "white"
        }

        //Seek controls
        SeekControl {
            id: seekControl
            anchors.bottom: bottomBar.bottom
            anchors.right: bottomBar.right
            anchors.left: bottomBar.left
            height: bottomBar.seekHeight
            anchors.leftMargin: bottomBar.margin
            anchors.rightMargin: bottomBar.margin

            enabled: playbackControl.isPlaybackEnabled
            duration: mediaPlayer !== null ? mediaPlayer.duration : 0

            onSeekValueChanged: {
                if (mediaPlayer !== null) {
                    mediaPlayer.seek(newPosition);
                    position = mediaPlayer.position;
                }
            }

            Component.onCompleted: {
                if (mediaPlayer !== null)
                    seekable = mediaPlayer.seekable;
            }
        }

        Connections {
            target: mediaPlayer
            onPositionChanged: {
                if (!seekControl.pressed) seekControl.position = mediaPlayer.position;
            }
            onStatusChanged: {
                if ((mediaPlayer.status == MediaPlayer.Loaded) || (mediaPlayer.status == MediaPlayer.Buffered) || mediaPlayer.status === MediaPlayer.Buffering || mediaPlayer.status === MediaPlayer.EndOfMedia)
                    playbackControl.isPlaybackEnabled = true;
                else
                    playbackControl.isPlaybackEnabled = false;
                updateStatusText();
            }
            onErrorChanged: {
                updateStatusText();
            }

            onPlaybackStateChanged: {
                if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                    playbackControl.isPlaying = true;
                    applicationWindow.resetTimer();
                } else {
                    show();
                    playbackControl.isPlaying = false;
                }
            }

            onSeekableChanged: {
                seekControl.seekable = mediaPlayer.seekable;
            }
        }
    }

    //Usage: give the value you wish to modify position,
    //returns a value between 0 and duration
    function normalizeSeek(value) {
        var newPosition = mediaPlayer.position + value;
        if (newPosition < 0)
            newPosition = 0;
        else if (newPosition > mediaPlayer.duration)
            newPosition = mediaPlayer.duration;
        return newPosition;
    }

    function hide() {
        controlBar.state = "HIDDEN";
    }

    function show() {
        controlBar.state = "VISIBLE";
    }

    states: [
        State {
            name: "HIDDEN"
            PropertyChanges {
                target: controlBar
                opacity: 0.0
            }
        },
        State {
            name: "VISIBLE"
            PropertyChanges {
                target: controlBar
                opacity: 0.95
            }
        }
    ]

    transitions: [
        Transition {
            from: "HIDDEN"
            to: "VISIBLE"
            NumberAnimation {
                id: showAnimation
                target: controlBar
                properties: "opacity"
                from: 0.0
                to: 1.0
                duration: 200
            }
        },
        Transition {
            from: "VISIBLE"
            to: "HIDDEN"
            NumberAnimation {
                id: hideAnimation
                target: controlBar
                properties: "opacity"
                from: 0.95
                to: 0.0
                duration: 200
            }
        }
    ]
}
