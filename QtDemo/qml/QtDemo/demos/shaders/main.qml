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

import QtQuick 2.0

Rectangle {
    id: applicationWindow
    anchors.fill:parent
    color: "black"

    Content {
        id: content
        anchors.fill: parent
        anchors.bottomMargin: controlBar.height
    }

    ControlBar {
        id: controlBar
        anchors.left: applicationWindow.left
        anchors.right: applicationWindow.right
        anchors.bottom: applicationWindow.bottom

        onToggleFX: effectSelectionPanel.visible = !effectSelectionPanel.visible;
        onPlay: content.play();
        onPause: content.pause();
    }

    ParameterPanel {
        id: parameterPanel
        opacity: controlBar.opacity
        visible: effectSelectionPanel.visible && model.count !== 0
        width: applicationWindow.width * 0.5
        sliderHeight: applicationWindow.height * 0.15
        anchors {
            bottom: effectSelectionPanel.bottom
            right: effectSelectionPanel.left
        }
    }

    EffectSelectionPanel {
        id: effectSelectionPanel
        visible: false
        opacity: controlBar.opacity
        anchors {
            bottom: controlBar.top
            right: applicationWindow.right
        }
        width: applicationWindow.width * 0.3
        height: applicationWindow.height - controlBar.height
        itemHeight: applicationWindow.height*0.08
        color: controlBar.color

        onClicked: {
            content.effectSource = effectSource
            parameterPanel.model = content.effect.parameters
        }
    }

    Component.onCompleted: {
        content.init()
    }
}
