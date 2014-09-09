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
    width: 1
    height: 1

    property int itemId : 1

    Image {
        id: elementImage
        anchors.centerIn: root
        z: 5
    }

    Component.onCompleted: {
        elementImage.source = root.itemId === 1 ? "images/tree1.png" :
                              root.itemId === 2 ? "images/tree2.png" :
                              root.itemId === 3 ? "images/mountain.png" :
                              root.itemId === 4 ? "images/stones.png" :
                              root.itemId === 5 ? "images/box_open.png" :
                              root.itemId === 6 ? "images/box.png" :
                              root.itemId === 10 ? "images/character0.png" :
                              root.itemId === 11 ? "images/character1.png" :
                              root.itemId === 12 ? "images/character3.png" :
                              root.itemId === 13 ? "images/character7.png" :
                              root.itemId === 14 ? "images/character8.png" :
                              root.itemId === 15 ? "images/character9.png" :
                              root.itemId === 20 ? "images/character2.png" :
                              root.itemId === 21 ? "images/character4.png" :
                              root.itemId === 22 ? "images/character5.png" :
                              root.itemId === 23 ? "images/character6.png" :
                              root.itemId === 24 ? "images/character10.png" :
                              ""
    }
}
