import QtQuick 2.0
import "engine.js" as Engine

Item{
    id: app
    width: 640
    height: 480
    clip: true
    Rectangle{
        anchors.centerIn: parent
        width:1000
        height:1
        color: "black"
    }

    Rectangle{
        anchors.centerIn: parent
        width: 1
        height:1000
        color: "black"
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
        property real scalingFactor: .1

        property real zoomInTarget: 1
        property real zoomOutTarget: .4

        property real rotationOriginX
        property real rotationOriginY

        Behavior on angle {NumberAnimation{duration: 1000}}

        Behavior on xOffset {
            id: xOffsetBehaviour
            enabled: !worldMouseArea.panning
            NumberAnimation{duration: 1000}
        }

        Behavior on yOffset {
            id: yOffsetBehaviour
            enabled: !worldMouseArea.panning
            NumberAnimation{duration: 1000}
        }

        Behavior on rotationOriginX {NumberAnimation{duration: 1000}}
        Behavior on rotationOriginY {NumberAnimation{duration: 1000}}

        Rectangle{
            anchors.centerIn: parent
            width:4000
            height:4000
            color:"transparent"
            radius:2000
            border{color:"red"; width:100}
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
        alwaysRunToEnd: true
        NumberAnimation { target: canvas; property: "scalingFactor"; duration: 500; to:canvas.zoomOutTarget; easing.type: Easing.OutCubic }
        NumberAnimation { target: canvas; property: "scalingFactor"; duration: 500; to:canvas.zoomInTarget; easing.type: Easing.InCubic }
    }

    MouseArea{
        id: worldMouseArea

        property int startX: 0
        property int startY: 0

        property int oldX: 0
        property int oldY: 0

        property bool panning: false

        anchors.fill: parent

        onClicked: {
            if (panning) {
                panning = false
                return
            }
            var object = mapToItem(canvas, mouse.x, mouse.y)
            var item = canvas.childAt(object.x,object.y)

            var target = null

            if (item && item.objectName === 'slide') {
                target = Engine.selectTarget(item.uid)
            } else {
                //select random target for now...
                target = Engine.selectTarget(null)
            }

            canvas.xOffset = -target.x
            canvas.yOffset = -target.y
            canvas.rotationOriginX = target.x
            canvas.rotationOriginY = target.y
            canvas.angle = -target.angle
            canvas.zoomOutTarget = .4
            canvas.zoomInTarget = 1.0/target.scale

            zoomFlyByAnimation.restart()
        }

        onPressed: {
            startX = mouse.x
            startY = mouse.y
            oldX = mouse.x
            oldY = mouse.y
        }

        onPositionChanged: {
            panning= true

            canvas.xOffset+=(mouse.x - oldX)
            canvas.yOffset+=(mouse.y - oldY)

            oldX = mouse.x
            oldY = mouse.y
        }

        onReleased: {
            //TODO: make it so that movement slows down and stops
            //rather that just stopping the movement
        }

        // drag.target: canvas
        // drag.axis: Drag.XAndYAxis
    }

    NavigationPanel{
        anchors{top:parent.top; right:parent.right}
    }

    Component.onCompleted: Engine.initSlides()
}
