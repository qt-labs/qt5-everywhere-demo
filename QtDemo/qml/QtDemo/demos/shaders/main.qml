/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Mobility Components.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2

Rectangle {
    id: applicationWindow
    anchors.fill:parent
    color: "black"
    property int margin: applicationWindow.height * 0.02

    Content {
        id: content
        anchors.fill: parent
    }

    Rectangle {
        id: fx
        anchors.right: applicationWindow.right
        anchors.bottom: applicationWindow.bottom
        anchors.margins: applicationWindow.margin
        width: applicationWindow.width * 0.25
        height: applicationWindow.height * 0.08
        color: "#333333"
        border.color: "#777777"
        opacity: 0.5

        Text {
            anchors.centerIn: fx
            color: "#ffffff"
            text: effectSelectionPanel.effectName
            font.pixelSize: fx.height * 0.5
        }

        MouseArea {
            anchors.fill: parent
            onPressed: fx.color = "#555555"
            onReleased: fx.color = "#333333"
            onClicked: effectSelectionPanel.visible = !effectSelectionPanel.visible;
        }
    }

    ParameterPanel {
        id: parameterPanel
        opacity: 0.7
        visible: effectSelectionPanel.visible && model.count !== 0
        width: applicationWindow.width * 0.4
        sliderHeight: applicationWindow.height * 0.15
        anchors {
            bottom: effectSelectionPanel.bottom
            right: effectSelectionPanel.left
        }
    }

    EffectSelectionPanel {
        id: effectSelectionPanel
        visible: false
        opacity: 0.7
        anchors {
            top: applicationWindow.top
            right: applicationWindow.right
            margins: applicationWindow.margin
        }
        width: fx.width
        height: applicationWindow.height - fx.height - 2*applicationWindow.margin
        itemHeight: fx.height
        color: fx.color

        onClicked: {
            content.effectSource = effectSource
            parameterPanel.model = content.effect.parameters
        }
    }

    Component.onCompleted: {
        content.init()
    }
}
