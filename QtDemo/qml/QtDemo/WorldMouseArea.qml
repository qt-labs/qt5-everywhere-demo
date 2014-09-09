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

MouseArea{
    id: worldMouseArea
    anchors.fill: parent

    property int oldX: 0
    property int oldY: 0
    property int startMouseX: 0
    property int startMouseY: 0
    property bool panning: false

    onReleased: {
        var dx = mouse.x - startMouseX;
        var dy = mouse.y - startMouseY;

        var coords = mapToItem(canvas, width/2, height/2)

        canvas.rotationOriginX=coords.x
        canvas.rotationOriginY=coords.y

        canvas.xOffset = -canvas.rotationOriginX;
        canvas.yOffset = -canvas.rotationOriginY;

        // Check the point only if we didn't move the mouse too much
        if (!mouse.wasHeld && Math.abs(dx) <= app.tapLimitX && Math.abs(dy) <= app.tapLimitY)
        {
            panning = false
            var target = null;
            var object = mapToItem(canvas, mouse.x, mouse.y)
            var item = canvas.childAt(object.x,object.y)
            if (item) {
                if (item.objectName === 'slide')
                    target = app.selectTarget(item.uid)
                else if (item.objectName === 'group')
                    target = app.selectGroup(item.uid)
            }

            // If we found target, go to the target
            if (target) {
                canvas.goTo(target, false, item.objectName === 'slide' ? 2 : 1)
                zoomAnimation.restart()
            }
            else // If not target under mouse -> go home
                canvas.goHome(true)
        }
    }

    onPressed: {
        // Save mouse state
        oldX = mouse.x
        oldY = mouse.y
        startMouseX = mouse.x
        startMouseY = mouse.y
    }

    onPositionChanged: {
        var dx = mouse.x - oldX;
        var dy = mouse.y - oldY;

        oldX = mouse.x;
        oldY = mouse.y;

        if (!zoomAnimation.running && !navigationAnimation.running)
        {
            panning = true;
            canvas.xOffset += dx;
            canvas.yOffset += dy;
            app.navigationState = 3 //dirty
        }
    }
    onWheel: {
        var newScalingFactor = canvas.scalingFactor
        if (wheel.angleDelta.y > 0){
            newScalingFactor+=canvas.scalingFactor*.05
        }else{
            newScalingFactor-=canvas.scalingFactor*.05
        }
        if (newScalingFactor < app.minScaleFactor) newScalingFactor = app.minScaleFactor
        if (newScalingFactor > app.maxScaleFactor) newScalingFactor = app.maxScaleFactor
        canvas.scalingFactor = newScalingFactor
    }
}
