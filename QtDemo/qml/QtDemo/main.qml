import QtQuick 2.0
import "engine.js" as Engine
import "style.js" as Style

Rectangle{
    id: app
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
            if (app.useGroups && navigationState == 1) {
                if (target !== null)
                    canvas.goTo(target, true)
                else
                    canvas.goHome()
            }
            else if (navigationState == 2) {
                target = Engine.getCurrent()
                if (target !== null)
                    canvas.goTo(target, true)
                else
                    canvas.goHome()
            }
            else
                canvas.goHome()

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

    onWidthChanged: calculateScales();
    onHeightChanged: calculateScales();

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

    WorldMouseArea { id: worldMouseArea }
    WorldCanvas { id:canvas }
    NavigationPanel{ id: navigationPanel }

    HelpScreen {
        id: helpscreen
        visible: false
    }
    function getPosition(index){
        return Engine.getPosition(index)
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

            if (animCounter === 0 && navigationState === 2)
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
    }
}
