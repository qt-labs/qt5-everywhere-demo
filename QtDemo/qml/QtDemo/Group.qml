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

import QtQuick 2.0

Item {
    id: group
    objectName: "group"

    /*color: "transparent"
    border.color: "red"
    border.width: 10*/

    property int uid: 0
    property real targetScale: 1
    property string textSource: "images/txt_feeds.png"
    property int textX: 0
    property int textY: 0
    property string name: "Text"
    property real imageScale: 6.0

    /*Image {
        x: group.textX
        y: group.textY
        source: group.textSource
        smooth: true
        scale: group.imageScale
    }*/

    property int fontSize: 120
    property string uiFont: "Purisa"
    property bool bold: true
    property int fontTransition: 6

    Text {
        text: group.name
        x: textX
        y: textY
        font.pixelSize: group.fontSize
        font.family: "Purisa"
        font.bold: group.bold
        color: "#42200a"
        smooth: true

        Text {
            text: group.name
            color: "#1d6cb0"
            x:group.fontTransition
            y:-group.fontTransition
            font.pixelSize: group.fontSize
            font.family: "Purisa"
            font.bold: group.bold
            smooth: true
        }
    }

}
