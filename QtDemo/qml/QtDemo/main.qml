import QtQuick 2.0
import "engine.js" as Engine
import "style.js" as Style

Rectangle{
    id: app
    width: Style.APP_WIDTH
    height: Style.APP_HEIGHT
    clip: true
    color: "white"
    property bool showDebugRects: false //true

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
        property bool panning: false

        onReleased: {
            // Check the point only if we didn't move the mouse
            if (!panning) {
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
            panning = false
        }

        onPressed: {
            // Save mouse state
            oldX = mouse.x
            oldY = mouse.y
        }

        onPositionChanged: {
            var dx = mouse.x - oldX;
            var dy = mouse.y - oldY;

            if (!panning && (Math.abs(dx) > 1 || Math.abs(dy) > 1))
                panning=true;

            oldX = mouse.x;
            oldY = mouse.y;

            if (!zoomAnimation.running)
            {
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
        pinch.minimumScale: .2
        pinch.maximumScale: 5
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
        property real scalingFactor: .2

        property real zoomInTarget: 1
        property real zoomOutTarget: .4

        property real rotationOriginX
        property real rotationOriginY

        function goHome()
        {
            xOffset = 0
            yOffset = 0
            rotationOriginX = 0
            rotationOriginY = 0
            angle = 0
            zoomInTarget = 0.2

            zoomAnimation.restart();
        }
        function goTo(target)
        {
            xOffset = -target.x
            yOffset = -target.y
            rotationOriginX = target.x
            rotationOriginY = target.y
            angle = -target.angle
            zoomOutTarget = .4
            zoomInTarget = 1.0/(target.scale)

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
            if (!running && canvas.zoomInTarget !== .2){
                print ("zoomanimation calls loaddemo")
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
