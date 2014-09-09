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
    anchors.fill: parent

    property int logoCount: 0

    Image {
        id: background
        source: "images/wallpaper.png"
        anchors.fill: root
    }

    function createNewLogo(x,y,logoState) {
        logoCount++;
        var component = Qt.createComponent("Logo.qml")
        if (component.status === Component.Ready) {
            var logo = component.createObject(root, {"posX": x, "posY": y, "logoState": logoState, "logoSizeDivider" : logoState, "objectName": "logo"});
            logo.play();
        }
    }

    function createNewLogos(x, y, logoSize, logoState) {
        var newSize = logoSize / logoState;
        var temp = logoSize - newSize;

        createNewLogo(x, y, logoState);
        createNewLogo(x+temp, y, logoState);
        createNewLogo(x+temp, y+temp, logoState);
        createNewLogo(x, y+temp, logoState);
        createNewLogo(x+logoSize/2-newSize/2, y+logoSize/2-newSize/2, logoState);
    }

    function decreaseCounter() {
        if (logoCount > 1) {
            logoCount--;
            return true;
        }
        return false;
    }

    Component.onCompleted: {
        var logoSize = Math.min(root.height, root.width) / 2;
        createNewLogo(root.width/2 - logoSize/2, root.height/2 - logoSize/2, 1)
    }
}
