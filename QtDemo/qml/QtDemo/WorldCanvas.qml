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
import "style.js" as Style

Item{
    id:canvas
    width:1
    height:1

    x: app.width/2+xOffset
    y: app.height/2+yOffset

    property real xOffset: 0
    property real yOffset: 0
    property real angle: 0

    property real zoomInTarget: 5
    property real scalingFactor: 5

    property real rotationOriginX
    property real rotationOriginY

    function goHome(useZoom)
    {
        worldMouseArea.panning = false
        xOffset = 0; //(app.homeCenterX * app.homeScaleFactor);
        yOffset = 0; //(-app.homeCenterY * app.homeScaleFactor);
        rotationOriginX = 0;
        rotationOriginY = 0;
        angle = 0;
        zoomInTarget = app.homeScaleFactor;
        app.navigationState = 0 //home
        app.forceActiveFocus()
        if (useZoom)
            zoomAnimation.restart();
        else
            navigationAnimation.restartAnimation()
    }
    function goTo(target, updateScalingFactor)
    {
        if (target)
        {
            worldMouseArea.panning = false
            xOffset = -target.x;
            yOffset = -target.y;
            rotationOriginX = target.x;
            rotationOriginY = target.y;
            angle = 0
            zoomInTarget = target.targetScale;
            if (updateScalingFactor)
                scalingFactor = zoomInTarget
            app.navigationState = target.navState
        }
    }

    function goNext() {
        goTo(app.getNext(), false);
        navigationAnimation.restartAnimation()
    }
    function goPrevious() {
        goTo(app.getPrevious(), false);
        navigationAnimation.restartAnimation()
    }

    function goBack()
    {
        if (app.useGroups && app.navigationState == 2) {
            goTo(app.getCurrentGroup(), false)
            zoomAnimation.restart()
        }
        else
            canvas.goHome(true)
    }

    Behavior on xOffset {
        id: xOffsetBehaviour
        enabled: !worldMouseArea.panning
        NumberAnimation{duration: Style.APP_ANIMATION_DELAY}
    }

    Behavior on yOffset {
        id: yOffsetBehaviour
        enabled: !worldMouseArea.panning
        NumberAnimation{duration: Style.APP_ANIMATION_DELAY}
    }

    Behavior on rotationOriginX {
        enabled: !worldMouseArea.panning
        NumberAnimation{
            duration: Style.APP_ANIMATION_DELAY
        }
    }
    Behavior on rotationOriginY {
        enabled: !worldMouseArea.panning
        NumberAnimation{
            duration: Style.APP_ANIMATION_DELAY
        }
    }

    transform: [

        Scale{
            id: canvasScale
            origin.x: canvas.rotationOriginX
            origin.y: canvas.rotationOriginY
            xScale: canvas.scalingFactor
            yScale :canvas.scalingFactor

        }
    ]
}
