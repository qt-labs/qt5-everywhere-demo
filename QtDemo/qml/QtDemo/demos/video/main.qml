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
import QtMultimedia 5.0

Rectangle {
    id: applicationWindow
    focus: true
    color: "black"
    anchors.fill:parent

    MouseArea {
        id: mouseActivityMonitor
        anchors.fill: parent

        hoverEnabled: true
        onClicked: {
            if (controlBar.state === "VISIBLE") {
                controlBar.hide();
            } else {
                controlBar.show();
                controlBarTimer.restart();
            }
        }
    }

    signal resetTimer
    onResetTimer: {
        controlBar.show();
        controlBarTimer.restart();
    }

    Content {
        id: content
        anchors.fill: parent
    }

    VideoSelector {
        id: videoSelector
        anchors.fill: parent
        anchors.margins: applicationWindow.width * 0.02
        visible: true
        onSelectVideo: {
            videoSelector.hide()
            content.openVideo(link)
            content.videoPlayer.play()
        }
        onVisibleChanged: {
            if (visible)
                controlBar.hide()
            else
                controlBar.show()
        }
    }

    Timer {
        id: controlBarTimer
        interval: 4000
        running: false

        onTriggered: hideToolBars();
    }

    ControlBar {
        id: controlBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: applicationWindow.bottom
        mediaPlayer: content.videoPlayer.mediaPlayer
    }

    Component.onCompleted: {
        controlBar.hide()
    }

    property real volumeBeforeMuted: 1.0

    Keys.onPressed: {
        applicationWindow.resetTimer();
        if (event.key === Qt.Key_Up || event.key === Qt.Key_VolumeUp) {
            content.videoPlayer.mediaPlayer.volume = Math.min(1, content.videoPlayer.mediaPlayer.volume + 0.1);
            return;
        } else if (event.key === Qt.Key_Down || event.key === Qt.Key_VolumeDown) {
            if (event.modifiers & Qt.ControlModifier) {
                if (content.videoPlayer.mediaPlayer.volume) {
                    volumeBeforeMuted = content.videoPlayer.mediaPlayer.volume;
                    content.videoPlayer.mediaPlayer.volume = 0
                } else {
                    content.videoPlayer.mediaPlayer.volume = volumeBeforeMuted;
                }
            } else {
                content.videoPlayer.mediaPlayer.volume = Math.max(0, content.videoPlayer.mediaPlayer.volume - 0.1);
            }
            return;
        }

        // What's next should be handled only if there's a loaded media
        if (content.videoPlayer.mediaPlayer.status !== MediaPlayer.Loaded
                && content.videoPlayer.mediaPlayer.status !== MediaPlayer.Buffered)
            return;

        if (event.key === Qt.Key_Space) {
            if (content.videoPlayer.mediaPlayer.playbackState === MediaPlayer.PlayingState)
                content.videoPlayer.mediaPlayer.pause()
            else if (content.videoPlayer.mediaPlayer.playbackState === MediaPlayer.PausedState
                     || content.videoPlayer.mediaPlayer.playbackState === MediaPlayer.StoppedState)
                content.videoPlayer.mediaPlayer.play()
        } else if (event.key === Qt.Key_Left) {
            content.videoPlayer.mediaPlayer.seek(Math.max(0, content.videoPlayer.mediaPlayer.position - 30000));
            return;
        } else if (event.key === Qt.Key_Right) {
            content.videoPlayer.mediaPlayer.seek(Math.min(content.videoPlayer.mediaPlayer.duration, content.videoPlayer.mediaPlayer.position + 30000));
            return;
        }
    }

    function hideToolBars() {
        if (!controlBar.isMouseAbove && content.videoPlayer.isPlaying)
            controlBar.hide();
    }

}
