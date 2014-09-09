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

    property int position: 0
    property int duration: 0
    property bool seekable: false
    property alias pressed : seekSlider.pressed
    property bool enabled

    signal seekValueChanged(int newPosition)

    onPositionChanged: {
        elapsedText.text = formatTime(position);
        seekSlider.value = position;
    }

    onDurationChanged: {
        remainingText.text = formatTime(duration);
    }

    Text {
        id: elapsedText
        anchors.verticalCenter: seekSlider.verticalCenter
        anchors.left: root.left
        verticalAlignment: Text.AlignVCenter
        height: parent.height
        text: "00:00"
        font.pixelSize: height * 0.4
        color: "#cccccc"
    }

    Slider {
        id: seekSlider
        anchors.left: elapsedText.right
        anchors.right: remainingText.left
        anchors.verticalCenter: root.verticalCenter
        mutable: root.seekable
        enabled: root.enabled
        height: parent.height

        minimum: 0.0
        maximum: root.duration !== 0 ? root.duration : 1

        onValueChangedByHandle: {
            seekValueChanged(newValue);
            applicationWindow.resetTimer()
        }
    }

    Text {
        id: remainingText
        anchors.verticalCenter: seekSlider.verticalCenter
        anchors.right: root.right
        verticalAlignment: Text.AlignVCenter
        height: parent.height
        text: "00:00"
        font.pixelSize: height * 0.4
        color: "#cccccc"
    }

    function formatTime(time) {
        time = time / 1000
        var hours = Math.floor(time / 3600);
        time = time - hours * 3600;
        var minutes = Math.floor(time / 60);
        var seconds = Math.floor(time - minutes * 60);

        if (hours > 0)
            return formatTimeBlock(hours) + ":" + formatTimeBlock(minutes) + ":" + formatTimeBlock(seconds);
        else
            return formatTimeBlock(minutes) + ":" + formatTimeBlock(seconds);

    }

    function formatTimeBlock(time) {
        if (time === 0)
            return "00"
        if (time < 10)
            return "0" + time;
        else
            return time.toString();
    }
}
