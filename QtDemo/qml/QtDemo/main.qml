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
        enabled: !zoomAnimation.running && !zoomFlyByAnimation.running

        property int startX: 0
        property int startY: 0

        property int oldX: 0
        property int oldY: 0

        property bool panning: false
        //property bool flicking: false

        anchors.fill: parent

        onDoubleClicked: {
            //to initial state
            canvas.xOffset = 0
            canvas.yOffset = 0
            canvas.rotationOriginX = 0
            canvas.rotationOriginY = 0
            canvas.angle = 0
            canvas.zoomInTarget = 0.2

            zoomAnimation.restart()
        }

        onClicked: {
            print ("MOUSEAREA CLICKED!: "+mouse.x +", "+mouse.y)
            var target = null;
            var velocity = 0;

            panning = false;

            if (!target){

                var object = mapToItem(canvas, mouse.x, mouse.y)
                var item = canvas.childAt(object.x,object.y)

                if (item && item.objectName === 'slide') {
                    target = Engine.selectTarget(item.uid)
                } else {
                    //select random target for now...
                    //target = Engine.selectTarget(null)
                }
            }

            if (!target) return
            canvas.xOffset = -target.x
            canvas.yOffset = -target.y
            canvas.rotationOriginX = target.x
            canvas.rotationOriginY = target.y
            canvas.angle = -target.angle

            canvas.zoomOutTarget = .4

            canvas.zoomInTarget = 1.0/(target.scale)

                //zoomFlyByAnimation.restart()
                zoomAnimation.restart()
        }

        onPressed: {
            startX = mouse.x
            startY = mouse.y
            oldX = mouse.x
            oldY = mouse.y
            //flicking = true
            //flickTimer.restart()
        }

        onPositionChanged: {
            //if (!panning && (Math.abs(mouse.x-startX) >20 || Math.abs(mouse.x-startX) >20)){
                panning= true
            //}

            canvas.xOffset+=(mouse.x - oldX)
            canvas.yOffset+=(mouse.y - oldY)

            oldX = mouse.x
            oldY = mouse.y
        }

        //onFlickingChanged: print ("Flicking changed to: "+flicking)

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
        enabled: !zoomAnimation.running && !zoomFlyByAnimation.running

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
            smooth: !zoomFlyByAnimation.running
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
        id: zoomFlyByAnimation
        NumberAnimation { target: canvas; property: "scalingFactor"; duration: Style.APP_ANIMATION_DELAY/2; to:canvas.zoomOutTarget; easing.type: Easing.OutCubic }
        NumberAnimation { target: canvas; property: "scalingFactor"; duration: Style.APP_ANIMATION_DELAY/2; to:canvas.zoomInTarget; easing.type: Easing.InCubic }
        //NumberAnimation { target: canvas; property: "scalingFactor"; duration: 600; to:canvas.zoomInTarget; easing.type: Easing.OutBounce }
    }

    SequentialAnimation{
        id: zoomAnimation
        alwaysRunToEnd: true
        NumberAnimation { target: canvas; property: "scalingFactor"; duration: Style.APP_ANIMATION_DELAY; to:canvas.zoomInTarget }
        onStarted: zoomFlyByAnimation.stop()
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
