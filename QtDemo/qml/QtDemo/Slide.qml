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

Item {
    id: slide
    objectName: "slide"

    property int uid: 0
    property int gid: 0
    property string url: ""
    property int device: 0
    property string imageSource: ""
    property bool loaded: false
    property bool loading: false
    property real targetScale: 1
    property bool animationRunning: navigationAnimation.running || zoomAnimation.running
    property int demoWidth: 603
    property int demoHeight: 378
    property int maskVerticalOffset: 51
    property int maskHorizontalOffset: 1
    property string demoColor: "#4353c3"
    property string name: ""

    function targetWidth()
    {
        return demoWidth*scale;
    }

    function targetHeight()
    {
        return demoHeight*scale;
    }

    Rectangle {
        id: demoBackground
        anchors.centerIn: parent
        width: demoContainer.width * 1.03
        height: demoContainer.height * 1.03
        color: "black"
        z: slide.loading || slide.loaded ? 1:-1

        Rectangle{
            id: demoContainer
            anchors.centerIn: parent
            width: demoWidth
            height: demoHeight
            color: demoColor
            clip: true

            Text {
                id: splashScreenText
                color: 'white'
                font.pixelSize: parent.width *.2
                font.family: fontLoader.name
                text: slide.name
                anchors.centerIn: parent
                smooth: true
                visible: true
            }
        }
    }

    ShaderEffectSource{
        id: demo
        anchors.centerIn: parent
        width: demoWidth
        height: demoHeight
        sourceItem: demoContainer
        live: false
        visible: (hasSnapshot && !slide.loaded) || updating
        hideSource: visible && !updating && !loading
        clip: true

        property bool updating: false
        property bool hasSnapshot: false

        onScheduledUpdateCompleted: {
            updating = false
            hasSnapshot = true
            releaseDemo(true)
        }
    }

    Image {
        id: deviceMaskImage
        anchors.centerIn: parent
        anchors.verticalCenterOffset: maskVerticalOffset
        anchors.horizontalCenterOffset: maskHorizontalOffset
        smooth: !animationRunning
        antialiasing: !animationRunning
        source: slide.imageSource
        width: slide.width
        height: slide.height
        z: 2

        IslandElementContainer { id: leftElementcontainer; place: 0; islandHeight: islandImage.height; islandWidth: islandImage.width }
        IslandElementContainer { id: rightElementcontainer;place: 1; islandHeight: islandImage.height; islandWidth: islandImage.width }
        IslandElementContainer { id: bottomElementcontainer;place: 2; islandHeight: islandImage.height; islandWidth: islandImage.width }
    }

    Image {
        id: islandImage
        anchors.top: deviceMaskImage.bottom
        anchors.topMargin: -height * 0.3
        anchors.horizontalCenter: deviceMaskImage.horizontalCenter
        source: "images/island.png"
        smooth: !animationRunning
        antialiasing: !animationRunning
        width: Math.max(deviceMaskImage.width, deviceMaskImage.height) * 1.6
        height: width/2
        z: -3
    }

    // Load timer
    Timer {
        id: loadTimer
        interval: 5
        running: false
        repeat: false
        onTriggered: {
            loadSplashScreen();
            load()
        }
    }

    function loadDemo(){
        if (!slide.loaded)
        {
            splashScreenText.visible = true
            loadTimer.start();
        } else if (slide.url==="demos/radio/radio.qml"){
            for (var i =0; i<demoContainer.children.length; i++){
                if (demoContainer.children[i].objectName === "demoApp"){
                    demoContainer.children[i].focus = true;
                }
            }
        }
    }

    function load() {
        if (!slide.url || slide.loaded) return;

        print("CREATING DEMO: "+ slide.url)
        var component = Qt.createComponent(slide.url);
        print ("CREATED: "+slide.url)
        var incubator = component.incubateObject(demoContainer, { x: 0, y: 0, objectName: "demoApp" });
        if (incubator.status !== Component.Ready) {
            incubator.onStatusChanged = function(status) {
                if (status === Component.Ready) {
                    print ("Object", incubator.object, "is now ready!");
                    slide.loaded = true
                    releaseSplashScreen()
                }
            }
        } else {
            print ("Object", incubator.object, "is ready immediately!");
            slide.loaded = true
            releaseSplashScreen()
        }
    }

    function loadSplashScreen()
    {
        slide.loading = true
        var splash = Qt.createComponent("SplashScreen.qml");
        if (splash.status === Component.Ready)
            splash.createObject(demoContainer, {objectName: "splashScreen", text: slide.name});
    }

    function releaseSplashScreen()
    {
        splashScreenText.visible = false
        slide.loading = false
        for (var i =0; i<demoContainer.children.length; i++){
            if (demoContainer.children[i].objectName === "splashScreen"){
                demoContainer.children[i].explode();
            }
        }
    }

    function releaseDemo(snapShotCreated){
        if (!slide.loaded) return;
        if (!snapShotCreated){
            demo.updating = true
            demo.scheduleUpdate()
            return;
        }

        if (slide.url === "demos/radio/radio.qml")
            return; //Always alive

        app.forceActiveFocus();

        if (!slide.loaded)
            return;

        slide.loaded = false;

        for (var i =0; i<demoContainer.children.length; i++){
            if (demoContainer.children[i].objectName === "demoApp"){
                demoContainer.children[i].destroy(500);
            }
        }
    }

    function createElements()
    {
        leftElementcontainer.createElements()
        rightElementcontainer.createElements()
        bottomElementcontainer.createElements()
    }
}
