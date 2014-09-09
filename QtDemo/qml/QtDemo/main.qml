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
import QtQuick.Window 2.1
import "engine.js" as Engine
import "style.js" as Style

Window {
    visible: true

    onWidthChanged: app.calculateScales();
    onHeightChanged: app.calculateScales();

    Rectangle {
        id: app
        anchors.fill: parent
        clip: true
        focus: true

        property real homeScaleFactor: .2
        property int homeCenterX: 0
        property int homeCenterY: 0
        property real minScaleFactor: .04
        property real maxScaleFactor: 1
        property real tapLimitX : 2
        property real tapLimitY : 1
        property int navigationState: 0 //home, group, slide, dirty
        property bool useGroups: true

        function calculateScales(){
            if (app.width > 0 && app.height > 0){
                var bbox = Engine.boundingBox();
                app.homeScaleFactor = Engine.scaleToBox(app.width*0.85, app.height*0.85, bbox.width, bbox.height);
                app.homeCenterX = bbox.centerX;
                app.homeCenterY = bbox.centerY;
                app.minScaleFactor = app.homeScaleFactor / 10;
                app.maxScaleFactor = app.homeScaleFactor * 20;
                Engine.updateObjectScales(app.width*0.9, app.height*0.9);
                Engine.updateGroupScales(app.width, app.height);
                tapLimitX = Math.max(1,app.width * 0.02);
                tapLimitY = Math.max(1,app.height * 0.02);

                var target = Engine.getCurrentGroup()
                if (app.useGroups && app.navigationState == 1) {
                    if (target !== null)
                        canvas.goTo(target, true)
                    else
                        canvas.goHome(false)
                }
                else if (app.navigationState == 2) {
                    target = Engine.getCurrent()
                    if (target !== null)
                        canvas.goTo(target, true)
                    else
                        canvas.goHome(false)
                }
                else
                    canvas.goHome(false)

                navigationPanel.checkOrientation()
            }
        }

        function selectTarget(uid) {
            return Engine.selectTarget(uid)
        }

        function selectGroup(uid) {
            return Engine.selectGroup(uid)
        }

        function getCurrentGroup() {
            return Engine.getCurrentGroup()
        }

        function getNext() {
            if (app.useGroups && app.navigationState == 1)
                return Engine.getNextGroup()
            else
                return Engine.getNext()
        }

        function getPrevious() {
            if (app.useGroups && app.navigationState == 1)
                return Engine.getPreviousGroup()
            else
                return Engine.getPrevious()
        }

        function getPosition(index){
            return Engine.getPosition(index)
        }

        FontLoader {
            id: fontLoader
            source: "fonts/PatrickHandSC-Regular.ttf"
        }

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#89d4ff" }
            GradientStop { position: 1.0; color: "#f3fbff" }
        }

        Cloud { id: cloud1; sourceImage: "images/cloud1.png"}
        Cloud { id: cloud2; sourceImage: "images/cloud1.png"}
        Cloud { id: cloud3; sourceImage: "images/cloud1.png"}
        Cloud { id: cloud4; sourceImage: "images/cloud2.png"}
        Cloud { id: cloud5; sourceImage: "images/cloud2.png"}
        Cloud { id: cloud6; sourceImage: "images/cloud2.png"}

        PinchArea {
            anchors.fill: parent
            property real initialValue: 1.0
            pinch.minimumRotation: 0
            pinch.maximumRotation: 0
            onPinchStarted: initialValue = canvas.scalingFactor
            onPinchUpdated: canvas.scalingFactor = Math.min(app.maxScaleFactor, Math.max(app.minScaleFactor, initialValue + pinch.scale-1.0));

            WorldMouseArea {
                id: worldMouseArea
            }
        }

        WorldCanvas { id:canvas }
        NavigationPanel{ id: navigationPanel }

        HelpScreen {
            id: helpscreen
            visible: false
        }
        QuitDialog {
            id: quitDialog
            visible: false

            onYes: Qt.quit()
            onNo: visible = false
        }

        SmoothedAnimation {
            id: zoomAnimation
            target: canvas;
            property: "scalingFactor";
            duration: Style.APP_ANIMATION_DELAY
            velocity: -1
            to:canvas.zoomInTarget

            onRunningChanged: {
                if (!running) {
                    if (app.navigationState === 2)
                        Engine.loadCurrentDemo();
                    else
                        Engine.releaseDemos();
                }
            }
        }

        SequentialAnimation {
            id: navigationAnimation

            property int animCounter: 0

            function restartAnimation() {
                navigationAnimation.animCounter++;
                restart();
            }

            NumberAnimation {
                id: zoomOutAnimation
                target: canvas;
                property: "scalingFactor";
                duration: Style.APP_ANIMATION_DELAY/2;
                to: app.homeScaleFactor*1.3
                easing.type: Easing.OutCubic
            }

            NumberAnimation {
                id: zoomInAnimation
                target: canvas;
                property: "scalingFactor";
                duration: Style.APP_ANIMATION_DELAY/2;
                to: canvas.zoomInTarget
                easing.type: Easing.InCubic
            }

            onRunningChanged: {
                if (!running)
                    animCounter--

                if (animCounter === 0 && app.navigationState === 2)
                    Engine.loadCurrentDemo();
            }
        }

        Keys.onReleased: {
            // Handle back-key
            if (event.key === Qt.Key_Back) {
                event.accepted = true;

                if (app.navigationState !== 0)
                    canvas.goBack();
                else
                    quitDialog.visible = true
            }
        }

        Component.onCompleted: {
            if (app.useGroups)
                Engine.initGroups()

            Engine.initSlides()
            cloud1.start();
            cloud2.start();
            cloud3.start();
            cloud4.start();
            cloud5.start();
            cloud6.start();

            app.calculateScales()
        }
    }
}
