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
    property int navigationState: 0 //home, slide, dirty

    function calculateScales(){
        if (app.width > 0 && app.height > 0){
            var bbox = Engine.boundingBox();
            app.homeScaleFactor = Engine.scaleToBox(app.width*0.8, app.height*0.8, bbox.width, bbox.height);
            app.homeCenterX = bbox.centerX;
            app.homeCenterY = bbox.centerY;
            app.minScaleFactor = app.homeScaleFactor / 10;
            app.maxScaleFactor = app.homeScaleFactor * 20;
            Engine.updateObjectScales(app.width*0.9, app.height*0.9);
            tapLimitX = Math.max(1,app.width * 0.02);
            tapLimitY = Math.max(1,app.height * 0.02);

            var target = Engine.getCurrent();
            if (navigationState == 1 && target !== null)
                canvas.goTo(target, true);
            else
                canvas.goHome()

            navigationPanel.checkOrientation()
        }
    }

    function selectTarget(uid) {
        return Engine.selectTarget(uid)
    }

    function getNext() {
        return Engine.getNext()
    }

    function getPrevious() {
        return Engine.getPrevious()
    }

    onWidthChanged: calculateScales();
    onHeightChanged: calculateScales();

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#89d4ff" }
        GradientStop { position: 1.0; color: "#f3fbff" }
    }

    Cloud { id: cloud1; sourceImage: "images/cloud1.svg"}
    Cloud { id: cloud2; sourceImage: "images/cloud1.svg"}
    Cloud { id: cloud3; sourceImage: "images/cloud1.svg"}
    Cloud { id: cloud4; sourceImage: "images/cloud2.svg"}
    Cloud { id: cloud5; sourceImage: "images/cloud2.svg"}
    Cloud { id: cloud6; sourceImage: "images/cloud2.svg"}

    Item{
        id: pinchProxy
        scale:.2
        onRotationChanged: canvas.angle=rotation
        onScaleChanged: canvas.scalingFactor=scale
    }

    WorldMouseArea { id: worldMouseArea }
    WorldPinchArea { id: worldPinchArea }
    WorldCanvas { id:canvas }
    NavigationPanel{ id: navigationPanel }

    /*Image{
        id: logo
        source: "QtLogo.png"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: parent.height * 0.02
        width: parent.height * 0.1
        height: width
        opacity: 1.0
    }*/

    QuitDialog {
        id: quitDialog
        visible: false

        onYes: Qt.quit()
        onNo: visible = false
    }

    NumberAnimation {
        id: zoomAnimation
        target: canvas;
        property: "scalingFactor";
        duration: Style.APP_ANIMATION_DELAY;
        to:canvas.zoomInTarget

        onRunningChanged: {
            if (!running) {
                if (app.navigationState === 1)
                    Engine.loadCurrentDemo();
                else
                    Engine.releaseDemos();
            }
        }
    }

    SequentialAnimation {
        id: navigationAnimation

        NumberAnimation {
            id: zoomOutAnimation
            target: canvas;
            property: "scalingFactor";
            duration: Style.APP_ANIMATION_DELAY/2;
            to: app.homeScaleFactor
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
            if (!running) {
                if (navigationState === 1)
                    Engine.loadCurrentDemo();
                else
                    Engine.releaseDemos();
            }
        }
    }

    Keys.onPressed: {
        // Handle back-key
        if (event.key === Qt.Key_MediaPrevious) {
            if (app.navigationState !== 0) {
                event.accepted = true;
                canvas.goHome();
            }
            else {
                quitDialog.visible = true
            }
        }
    }

    Component.onCompleted: {
        Engine.initSlides()
        cloud1.start();
        cloud2.start();
        cloud3.start();
        cloud4.start();
        cloud5.start();
        cloud6.start();
    }
}
