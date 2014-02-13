/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
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

import QtQuick 2.0
import QtQuick.XmlListModel 2.0

Rectangle {
    id: mainWindow
    anchors.fill: parent
    color: appBackground

    property int tileHeight: parseInt(grid.height / 3)
    property int tileFontSize: tileHeight * 0.08
    property int horizontalMargin: height * 0.08
    property int topBarsize: height * 0.2
    property int bottomBarSize: height * 0.08
    property int tileMargin: height * 0.01
    property int appHeaderFontSize: topBarsize * 0.4
    property string appBackground: "#262626"
    property string tileBackground: "#86bc24"
    property string textColor: "white"
    property string uiFont: "Segoe UI"

    XmlListModel {
        id: feedModel
        //source: "http://blog.qt.digia.com/feed/"
        source: "http://news.yahoo.com/rss/tech"
        //query: "/rss/channel/item"
        // Filter out items that don't have images
        query: "/rss/channel/item[exists(child::media:content)]"
        namespaceDeclarations: "declare namespace media=\"http://search.yahoo.com/mrss/\";"
        XmlRole  { name: "url"; query: "media:content/@url/string()" }
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "pubDate"; query: "pubDate/string()" }
        XmlRole { name: "link"; query: "link/string()" }

        onStatusChanged: {
            if (status == XmlListModel.Ready) {
                playbanner.start();
            } else if (status == XmlListModel.Error) {
                networkErrorMessage.start();
            }
        }
    }

    // Top bar
    Item {
        id: topBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: horizontalMargin
        opacity: 0
        height: topBarsize
        Text {
            id: title
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            text: qsTr("Yahoo Technology")
            font.family: uiFont;
            font.pixelSize: appHeaderFontSize;
            color: textColor
            smooth: true
        }
    }

    // Grid view
    GridView {
        id: grid
        anchors.fill: parent
        anchors.topMargin: topBarsize
        anchors.bottomMargin: bottomBarSize
        anchors.leftMargin: horizontalMargin
        anchors.rightMargin: horizontalMargin
        opacity: 0
        flow: GridView.TopToBottom
        cellHeight: tileHeight
        cellWidth: parseInt(tileHeight * 1.5)
        cacheBuffer: cellWidth
        clip: false
        focus: true
        model: feedModel
        delegate: RssDelegate {}

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
        orientation: Qt.Horizontal
        position: grid.visibleArea.xPosition
        pageSize: grid.visibleArea.widthRatio
    }

    Item {
        id: networkErrorBox
        opacity: 0
        anchors.fill: parent

        Text {
            anchors.centerIn: parent
            text: qsTr("Sorry! No network connection")
            font.family: uiFont;
            font.pixelSize: appHeaderFontSize;
            color: textColor
            smooth: true
        }
    }

    SequentialAnimation {
         id: playbanner
         running: false
         NumberAnimation { target: topBar; property: "opacity"; to: 1.0; duration: 300}
         NumberAnimation { target: grid; property: "opacity"; to: 1.0; duration: 300}
    }

    NumberAnimation {
        id: networkErrorMessage
        running: false
        target: networkErrorBox
        property: "opacity"
        to: 1.0
        duration: 300
    }

}
