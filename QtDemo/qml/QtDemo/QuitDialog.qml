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

Rectangle {
    id: root
    anchors.fill: parent
    color: Qt.rgba(0.0, 0.0, 0.0, 0.7)

    signal yes()
    signal no()

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        id: dialog
        anchors.centerIn: parent
        width: dialogText.paintedWidth * 1.1
        height: parent.height * 0.3
        property double dialogMargin: height * 0.05

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#222222" }
            GradientStop { position: 0.3; color: "#000000" }
            GradientStop { position: 1.0; color: "#111111" }
        }
        radius: 10
        border { color: "#999999"; width: 1 }

        Item {
            id: content
            anchors { left: parent.left; right: parent.right; top: parent.top }
            height: dialog.height * 0.6

            Text {
                id: dialogText
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Are you sure you want to quit?")
                color: "#ffffff"
                font.pixelSize: 0.2 *content.height
            }
        }

        Rectangle {
            id: line
            anchors { left: parent.left; right: parent.right; top: content.bottom }
            anchors.leftMargin: dialog.dialogMargin
            anchors.rightMargin: dialog.dialogMargin
            height: 1
            color: "#777777"
        }

        DialogButton {
            anchors { bottom: dialog.bottom; left:dialog.left; bottomMargin: dialog.dialogMargin; leftMargin: dialog.dialogMargin }
            buttonText: "Yes"
            onClicked: root.yes()
        }
        DialogButton {
            anchors { bottom: dialog.bottom; right:dialog.right; bottomMargin: dialog.dialogMargin; rightMargin: dialog.dialogMargin }
            buttonText: "No"
            onClicked: root.no()
        }

    }

}
