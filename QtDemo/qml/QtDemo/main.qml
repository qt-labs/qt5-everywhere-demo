import QtQuick 2.0
import "engine.js" as Engine
import "style.js" as Style

Rectangle{
    id: app
    clip: true
    color: "white"
    property bool showDebugRects: false //true
    property real homeScaleFactor: .2
    property real minScaleFactor: .04
    property real maxScaleFactor: 1
    property real tapLimitX : 2
    property real tapLimitY : 1

    function calculateScales(){
        if (app.width > 0 && app.height > 0){
            var appWidth = app.width*0.9;
            var appHeight = app.height*0.9;

            var bbox = Engine.boundingBox();
            app.homeScaleFactor = Engine.scaleToBox(appWidth, appHeight, bbox.width, bbox.height);
            app.minScaleFactor = app.homeScaleFactor / 5;
            app.maxScaleFactor = app.homeScaleFactor * 5;

            Engine.updateObjectScales(app.width, app.height);
            tapLimitX = Math.max(1,app.width * 0.02);
            tapLimitY = Math.max(1,app.height * 0.02);
        }

    }

    onWidthChanged: calculateScales();
    onHeightChanged: calculateScales();

    Rectangle{
        anchors.centerIn: parent
        width:1000
        height:1
        color: "black"
        visible: app.showDebugRects
    }

    Rectangle{
        anchors.centerIn: parent
        width: 1
        height:1000
        color: "black"
        visible: app.showDebugRects
    }

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

            // Check the point only if we didn't move the mouse too much
            if (!mouse.wasHeld && Math.abs(dx) <= app.tapLimitX && Math.abs(dy) <= app.tapLimitY)
            {
                panning = false
                var target = null;

                // Check if there is target under mouse.
                if (!target){

                    var object = mapToItem(canvas, mouse.x, mouse.y)
                    var item = canvas.childAt(object.x,object.y)

                    if (item && item.objectName === 'slide') {
                        target = Engine.selectTarget(item.uid)
                    }
                }

                // If we found target, go to the target
                if (target)
                    canvas.goTo(target)
                else // If not target under mouse -> go home
                    canvas.goHome()
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

            if (!zoomAnimation.running)
            {
                panning = true;
                canvas.xOffset += dx;
                canvas.yOffset += dy;
            }
        }

    }
    Item{
        id: pinchProxy
        scale:.2
        onRotationChanged: canvas.angle=rotation
        onScaleChanged: canvas.scalingFactor=scale
    }

    PinchArea{
        id: worldPinchArea
        anchors.fill: parent
        pinch.target: pinchProxy
        pinch.minimumScale: app.minScaleFactor
        pinch.maximumScale: app.maxScaleFactor
        pinch.maximumRotation: 360
        pinch.minimumRotation: -360
        enabled: !zoomAnimation.running

        property bool pinching: false

        onPinchStarted: {
            pinching = true
            pinchProxy.rotation = canvas.angle
            pinchProxy.scale = canvas.scalingFactor

            if (canvas.scalingFactor>1){
                var object = mapToItem(canvas, pinch.center.x, pinch.center.y)

                canvas.rotationOriginX = object.x
                canvas.rotationOriginY = object.y
            }
        }
        onPinchFinished: pinching = false;
    }

    Item{
        id:canvas
        width:1
        height:1

        x: app.width/2+xOffset
        y: app.height/2+yOffset

        property real xOffset: 0
        property real yOffset: 0
        property real angle: 0

        property real zoomInTarget: app.homeScaleFactor
        property real scalingFactor: app.homeScaleFactor

        property real rotationOriginX
        property real rotationOriginY

        function goHome()
        {
            xOffset = 0;
            yOffset = 0;
            rotationOriginX = 0;
            rotationOriginY = 0;
            angle = 0;
            zoomInTarget = app.homeScaleFactor;

            zoomAnimation.restart();
        }
        function goTo(target)
        {
            xOffset = -target.x;
            yOffset = -target.y;
            rotationOriginX = target.x;
            rotationOriginY = target.y;
            angle = -target.angle + target.targetAngle;
            zoomInTarget = target.targetScale;

            zoomAnimation.restart()
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

        //        Rectangle{
        //            anchors.centerIn: parent
        //            width:4000
        //            height:4000
        //            color:"transparent"
        //            radius:2000
        //            border{color:"red"; width:100}
        //        }

        Image{
            id: logo
            source: "QtLogo.png"
            anchors.centerIn: parent
            width: Style.LOGO_WIDTH
            height: Style.LOGO_HEIGHT
            sourceSize: Qt.size(Style.LOGO_WIDTH, Style.LOGO_HEIGHT)
            smooth: !zoomAnimation.running
            opacity: .0
            Behavior on opacity {
                SequentialAnimation{
                    PauseAnimation {duration: 800}
                    NumberAnimation {duration: 300}
                }
            }
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

    SequentialAnimation{
        id: zoomAnimation
        NumberAnimation { target: canvas; property: "scalingFactor"; duration: Style.APP_ANIMATION_DELAY; to:canvas.zoomInTarget }
        onRunningChanged: {
            if (!running && canvas.zoomInTarget !== app.homeScaleFactor){
                Engine.loadCurrentDemo();
            }
        }
    }

    NavigationPanel{
        anchors{top:parent.top; right:parent.right}
    }


    Component.onCompleted: {
        logo.opacity=1.0
        Engine.showBootScreen()

        Engine.initSlides()
    }
}
