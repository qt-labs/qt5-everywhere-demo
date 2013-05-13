import QtQuick 2.0
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

    function goHome()
    {
        worldMouseArea.panning = false
        xOffset = 0; //(app.homeCenterX * app.homeScaleFactor);
        yOffset = (-app.homeCenterY * app.homeScaleFactor);
        rotationOriginX = 0;
        rotationOriginY = 0;
        angle = 0;
        zoomInTarget = app.homeScaleFactor;
        app.navigationState = 0 //home
        app.forceActiveFocus()
        navigationPanel.rotateButtons(0);
        zoomAnimation.restart();
    }
    function goTo(target)
    {
        if (target)
        {
            worldMouseArea.panning = false
            xOffset = -target.x;
            yOffset = -target.y;
            rotationOriginX = target.x;
            rotationOriginY = target.y;
            angle = -target.angle + target.targetAngle;
            zoomInTarget = target.targetScale;
            app.navigationState = 1 //slide
            navigationPanel.rotateButtons(target.targetAngle);
        }
    }

    function goNext() {
        goTo(app.getNext());
        navigationAnimation.restart()
    }
    function goPrevious() {
        goTo(app.getPrevious());
        navigationAnimation.restart()
    }

    Behavior on angle {
        RotationAnimation{
            duration: Style.APP_ANIMATION_DELAY
            direction: RotationAnimation.Shortest
        }
        enabled: !worldPinchArea.pinching
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
        NumberAnimation{
            duration: Style.APP_ANIMATION_DELAY
        }
        enabled: !worldPinchArea.pinching
    }
    Behavior on rotationOriginY {
        NumberAnimation{
            duration: Style.APP_ANIMATION_DELAY
        }
        enabled: !worldPinchArea.pinching
    }

    Image{
        id: logo
        source: "QtLogo.png"
        anchors.centerIn: parent
        width: Style.LOGO_WIDTH
        height: Style.LOGO_HEIGHT
        sourceSize: Qt.size(Style.LOGO_WIDTH, Style.LOGO_HEIGHT)
        smooth: !zoomAnimation.running
        opacity: 1.0
        z: 2
    }

    Image {
        id: logoIsland
        anchors.top: logo.bottom
        anchors.topMargin: -logo.height*0.4
        anchors.horizontalCenter: logo.horizontalCenter
        source: "images/island.svg"
        width: logo.width*1.5
        height: logo.height
        z: -2
    }

    transform: [

        Scale{
            id: canvasScale
            origin.x: canvas.rotationOriginX
            origin.y: canvas.rotationOriginY
            xScale: canvas.scalingFactor
            yScale :canvas.scalingFactor

        },
        Rotation{
            id: canvasRotation
            origin.x: canvas.rotationOriginX
            origin.y: canvas.rotationOriginY
            angle: canvas.angle
        }
    ]
}
