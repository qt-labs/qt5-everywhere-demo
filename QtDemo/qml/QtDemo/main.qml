import QtQuick 2.0
import "engine.js" as Engine

Item{
    id: app
    width: 1280
    height: 800
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

    MouseArea{
        id: worldMouseArea

        property int startX: 0
        property int startY: 0

        property int oldX: 0
        property int oldY: 0

        property bool panning: false
        property bool flicking: false

        anchors.fill: parent

        onClicked: {
            var target = null;
            var velocity = 0;

            if (flicking){
                var a=mouse.x-startX;
                var b=mouse.y-startY;

                velocity = Math.sqrt(a*a+b*b)

                if (velocity < 10) flicking = false
            }

            if (flicking) {
                print ("flick gesture recognized")

                var angle = Math.atan2(-(mouse.y-startY),-(mouse.x-startX))*57.2957795
                target = Engine.lookForSlides(mouse.x, mouse.y, angle)

            } else if (panning) {
                panning = false
                return
            }

            if (!target){

                var object = mapToItem(canvas, mouse.x, mouse.y)
                var item = canvas.childAt(object.x,object.y)


                if (item && item.objectName === 'slide') {
                    target = Engine.selectTarget(item.uid)
                } else {
                    //select random target for now...
                    target = Engine.selectTarget(null)
                }
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
            flicking = true
            flickTimer.restart()
        }

        onPositionChanged: {
            panning= true

            canvas.xOffset+=(mouse.x - oldX)
            canvas.yOffset+=(mouse.y - oldY)

            oldX = mouse.x
            oldY = mouse.y
        }

        //onFlickingChanged: print ("Flicking changed to: "+flicking)

        Timer {
            id: flickTimer
            interval: 200  //Adjust suitable interval for flicking gesture
            repeat: false
            onTriggered: {
                worldMouseArea.flicking = false
            }
        }
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

        Behavior on angle {RotationAnimation{duration: 1000; direction: RotationAnimation.Shortest}}

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
            //Qt logo image taken 28.3.2013 from: http://upload.wikimedia.org/wikipedia/de/0/08/Qt_(Bibliothek)_logo.svg
            source: "QtLogo.svg"
            anchors.centerIn: parent
            width: 5030
            height: 6000
            sourceSize: Qt.size(5030,6000)
            smooth: !zoomFlyByAnimation.running
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
        NumberAnimation { target: canvas; property: "scalingFactor"; duration: 700; to:canvas.zoomOutTarget; easing.type: Easing.OutCubic }
        NumberAnimation { target: canvas; property: "scalingFactor"; duration: 700; to:canvas.zoomInTarget; easing.type: Easing.OutBounce }
    }


    NavigationPanel{
        anchors{top:parent.top; right:parent.right}
    }

    Component.onCompleted: Engine.initSlides()
}
