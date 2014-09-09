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
    id: elementContainer

    width: place == 2 ? parent.width : (islandWidth-parent.width)/2
    height: place == 2 ? 0.1*islandHeight : 0.4*islandHeight
    x: place == 0 ? -width : place == 1 ? parent.width : 0
    y: place == 2 ? parent.height : (parent.height - height*0.6)

    property int place : 0
    property int itemWidth : islandWidth * 0.1
    property int islandWidth: 100
    property int islandHeight: 100

    function createElement(xx, yy, itemId) {
        var component = Qt.createComponent("Element.qml")
        if (component.status === Component.Ready)
            component.createObject(elementContainer, {"x": xx, "y": yy, "itemId": itemId});
    }

    function createElements()
    {
        // Left side
        if (place === 0) {
            var temp0 = Math.floor(Math.random()*6.9);
            switch(temp0) {
            case 0:
                createElement(elementContainer.width*0.4, elementContainer.height*0.2, 1);
                createElement(elementContainer.width*0.25, elementContainer.height*0.3, 1);
                createElement(elementContainer.width*0.15, elementContainer.height*0.5, 1);
                createElement(elementContainer.width*0.55, elementContainer.height*0.4, 1);
                break;
            case 1:
                createElement(elementContainer.width*0.6, elementContainer.height*0.1, 1);
                createElement(elementContainer.width*0.4, elementContainer.height*0.2, 1);
                createElement(elementContainer.width*0.7, elementContainer.height*0.3, 1);
                createElement(elementContainer.width*0.3, elementContainer.height*0.5, 1);
                break;
            case 2:
                createElement(elementContainer.width*0.6, elementContainer.height*0.1, 3);
                createElement(elementContainer.width*0.4, elementContainer.height*0.6, 4);
                createElement(elementContainer.width*0.8, elementContainer.height*0.8, 4);
                break;
            case 3:
                createElement(elementContainer.width*0.6, elementContainer.height*0.1, 3);
                createElement(elementContainer.width*0.4, elementContainer.height*0.4, 1);
                createElement(elementContainer.width*0.5, elementContainer.height*0.5, 2);
                createElement(elementContainer.width*0.7, elementContainer.height*0.6, 2);
                break;
            case 4:
            case 5:
                var characterId = 10 + Math.floor(Math.random()*5.9);
                createElement(elementContainer.width*0.7, elementContainer.height*0.3, characterId);
                break;
            default: break;
            }
        }
        else if (place === 1) {
            var temp1 = Math.floor(Math.random()*6.9);
            switch(temp1) {
            case 0:
                createElement(elementContainer.width*0.6, elementContainer.height*0.2, 1);
                createElement(elementContainer.width*0.75, elementContainer.height*0.3, 1);
                createElement(elementContainer.width*0.85, elementContainer.height*0.5, 1);
                createElement(elementContainer.width*0.45, elementContainer.height*0.4, 1);
                break;
            case 1:
                createElement(elementContainer.width*0.4, elementContainer.height*0.1, 1);
                createElement(elementContainer.width*0.6, elementContainer.height*0.2, 1);
                createElement(elementContainer.width*0.3, elementContainer.height*0.3, 1);
                createElement(elementContainer.width*0.7, elementContainer.height*0.5, 1);
                break;
            case 2:
                createElement(elementContainer.width*0.4, elementContainer.height*0.1, 3);
                createElement(elementContainer.width*0.6, elementContainer.height*0.6, 4);
                createElement(elementContainer.width*0.2, elementContainer.height*0.8, 4);
                break;
            case 3:
                createElement(elementContainer.width*0.4, elementContainer.height*0.1, 3);
                createElement(elementContainer.width*0.6, elementContainer.height*0.4, 2);
                createElement(elementContainer.width*0.5, elementContainer.height*0.5, 1);
                createElement(elementContainer.width*0.3, elementContainer.height*0.6, 2);
                break;
            case 4:
            case 5:
                var characterId1 = 20 + Math.floor(Math.random()*4.9);
                createElement(elementContainer.width*0.3, elementContainer.height*0.3, characterId1);
                break;
            default: break;
            }
        }
        else {
            var temp2 = Math.floor(Math.random()*4.9);
            switch(temp2) {
            case 0:
                createElement(elementContainer.width*0.8, elementContainer.height*0.8, 5);
                createElement(elementContainer.width*0.4, elementContainer.height*0.5, 5);
                break;
            case 1:
                createElement(elementContainer.width*0.1, elementContainer.height*0.5, 1);
                createElement(elementContainer.width*0.2, elementContainer.height*0.9, 2);
                createElement(elementContainer.width*0.6, elementContainer.height*0.8, 4);
                break;
            case 2:
                createElement(elementContainer.width*0.2, elementContainer.height*0.5, 6);
                createElement(elementContainer.width*0.7, elementContainer.height*0.6, 2);
                createElement(elementContainer.width*0.6, elementContainer.height*0.7, 1);
                break;
            case 3:
                createElement(elementContainer.width*0.2, elementContainer.height*0.8, 6);
                createElement(elementContainer.width*0.7, elementContainer.height*0.6, 6);
                break;
            default: break;
            }
        }
    }
}
