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
import QtQuick.XmlListModel 2.0

Item {
    id: videoSelector

    property int tileHeight: parseInt(grid.height / 2)
    property int tileMargin: tileHeight * 0.1
    property int tileFontSize: tileHeight * 0.08
    property string tileBackground: "#262626"
    property string textColor: "white"
    property string uiFont: "Segoe UI"

    signal selectVideo(string link)

    state: "VISIBLE"

    onOpacityChanged: {
        if (state === "HIDDEN" && opacity <= 0.05)
            visible = false;
    }

    XmlListModel {
        id: videoModel
        source: "http://qt-project.org/uploads/videos/qt5_videos.xml"
        query: "/videolist/item"
        XmlRole  { name: "thumbnail"; query: "thumbnail/string()" }
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "link"; query: "link/string()" }

        onStatusChanged: {
            if (status == XmlListModel.Ready) {
                networkErrorBox.opacity = 0.0
            } else if (status == XmlListModel.Error) {
                networkErrorBox.opacity = 1.0
            }
        }
    }

    Item {
        id: networkErrorBox
        opacity: 0
        anchors.fill: parent

        Text {
            anchors.centerIn: parent
            text: qsTr("Sorry! No network connection")
            font.family: uiFont;
            font.pixelSize: tileFontSize * 2;
            color: textColor
            smooth: true
        }
    }

    // Grid view
    GridView {
        id: grid
        anchors.fill: parent
        flow: GridView.TopToBottom
        cellHeight: tileHeight
        cellWidth: parseInt(tileHeight * 1.5)
        cacheBuffer: cellWidth
        clip: false
        focus: true
        model: videoModel
        delegate: VideoDelegate { onVideoSelected: videoSelector.selectVideo(link); }

        // Only show the scrollbars when the view is moving.
        states: State {
            when: grid.movingHorizontally
            PropertyChanges { target: horizontalScrollBar; opacity: 1 }
        }

        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 400 }
        }
    }

    ScrollBar {
        id: horizontalScrollBar
        width: parent.width; height: 6
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        opacity: 0
        position: grid.visibleArea.xPosition
        pageSize: grid.visibleArea.widthRatio
    }

    function hide() {
        videoSelector.state = "HIDDEN";
    }

    function show() {
        videoSelector.visible = true;
        videoSelector.state = "VISIBLE";
    }

    states: [
        State {
            name: "HIDDEN"
            PropertyChanges {
                target: videoSelector
                opacity: 0.0
            }
        },
        State {
            name: "VISIBLE"
            PropertyChanges {
                target: videoSelector
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
                target: videoSelector
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
                target: videoSelector
                properties: "opacity"
                from: 0.95
                to: 0.0
                duration: 200
            }
        }
    ]
}
