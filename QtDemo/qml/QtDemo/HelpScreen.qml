import QtQuick 2.0

Item {
    id: root
    anchors.fill:parent
    property int delay: 500

    property int rotationAngle:0

    SequentialAnimation {
        id: closeAnimation

        ScriptAction{
            script: {
                instructionText.visible = false
                pointer.visible = false
                highlightImage.smooth = false

                highlight.size = Math.max(root.height, root.width)*2.5
            }
        }

        PauseAnimation { duration: root.delay }

        onRunningChanged: if (!running){
                              stopAnimations()
                              root.visible=false
                              highlight.size=0
                              highlightImage.smooth = true
                          }
    }

    Item{
        id: highlight
        property int size: 0
        property bool hidden: false
        width:1
        height:1
        Behavior on x {NumberAnimation{duration: root.delay}}
        Behavior on y {NumberAnimation{duration: root.delay}}
        Behavior on size {id: sizeBehavior; NumberAnimation{duration: root.delay}}
    }

    Image{
        id: highlightImage
        anchors.centerIn: highlight
        width: highlight.hidden? 0: highlight.size
        height: highlight.hidden? 0: highlight.size
        source: "images/highlight_mask.png"
        opacity: .6
        smooth: true
    }

    Rectangle{
        id: top
        anchors {left:parent.left; top: parent.top; right: parent.right; bottom: highlightImage.top}
        color: "black"
        opacity: .6
    }

    Rectangle{
        id: bottom
        anchors {left:parent.left; top: highlightImage.bottom; right: parent.right; bottom: parent.bottom}
        color: "black"
        opacity: .6
    }

    Rectangle{
        id: left
        anchors {left:parent.left; top: highlightImage.top; right: highlightImage.left; bottom: highlightImage.bottom}
        color: "black"
        opacity: .6
    }

    Rectangle{
        id: right
        anchors {left:highlightImage.right; top: highlightImage.top; right: parent.right; bottom: highlightImage.bottom}
        color: "black"
        opacity: .6
    }

    Item{
        id: pointer
        width: parent.width*.3
        height: parent.width*.3

        Image{
            id: handImage
            width: parent.width*.5
            height: width
            source: "images/hand.png"
            y: parent.height/2-height/2
            x: parent.width/2-width/2+deltaX
            property int deltaX:0

            anchors.verticalCenter: parent.verticalCenter

            SequentialAnimation{
                id: pointingAnimation
                PauseAnimation { duration: root.delay}
                NumberAnimation{
                    target: handImage
                    property: "deltaX"
                    from: -handImage.width*.3
                    to: handImage.width*.3
                    duration: 500
                    easing.type: Easing.InOutCubic
                }
                PauseAnimation { duration: 200 }
                NumberAnimation{
                    target: handImage
                    property: "deltaX"
                    from: handImage.width*.3
                    to: -handImage.width*.3
                    duration: 500
                    easing.type: Easing.InOutCubic

                }
            }

        }
    }

    Text{id: instructionText
        anchors {top: parent.top; topMargin: parent.height*.1; horizontalCenter: parent.horizontalCenter}
        width:parent.width*.8
        font.pixelSize: Math.min(parent.height, parent.width)*.05
        font.weight: Font.Bold
        color: "white"
        wrapMode: Text.WordWrap
        text: "Click on the devices to open applications"
    }

    SequentialAnimation {
        id: helpAnimation
        loops: Animation.Infinite

        PauseAnimation { duration: 1000 }
        PropertyAction { target: instructionText; property: "text"; value: "Click on the devices to open applications " }
        PropertyAction { target: pointer; property: "visible"; value: true}
        PropertyAction { target: highlight; property: "hidden"; value: false}

        SequentialAnimation {
            id: clickAnimation
            property int index: 0
            property variant uids: [9,13]
            loops: 3

            ScriptAction{
                script: {
                    clickAnimation.index+=1
                    if (clickAnimation.index>=clickAnimation.uids.length) clickAnimation.index=0
                }
            }

            ScriptAction{
                script: {
                    highlight.size= (700+clickAnimation.index*100)*canvas.scalingFactor

                    highlight.x=root.width/2 +getPosition(clickAnimation.uids[clickAnimation.index]).x*canvas.scalingFactor
                    highlight.y=root.height/2 +getPosition(clickAnimation.uids[clickAnimation.index]).y*canvas.scalingFactor

                    pointer.x= root.width/2 -pointer.width/2 +getPosition(clickAnimation.uids[clickAnimation.index]).x*canvas.scalingFactor*.5
                    pointer.y= root.height/2 -pointer.height/2 +getPosition(clickAnimation.uids[clickAnimation.index]).y*canvas.scalingFactor*.5
                    pointer.rotation=Math.atan2(getPosition(clickAnimation.uids[clickAnimation.index]).y*canvas.scalingFactor, getPosition(clickAnimation.uids[clickAnimation.index]).x*canvas.scalingFactor)*180.0/Math.PI
                    pointingAnimation.restart()
                }
            }

            PauseAnimation { duration: 3000 }
        }
        SequentialAnimation{
            id: navigationAnimation
            PropertyAction { target: instructionText; property: "text"; value: "Navigate between applications with arrows\n\nUse Home button to go to the beginning" }
            ScriptAction{
                script: {
                    highlight.size= Math.min(root.width, root.height)/2

                    if (root.width > root.height){
                        highlight.x=root.width
                        highlight.y=root.height/2
                        pointer.x= root.width/2 -pointer.width/2 +root.width*.2
                        pointer.y= root.height/2 -pointer.height/2
                        pointer.rotation=0
                    }else{
                        highlight.x=root.width/2
                        highlight.y=root.height
                        pointer.x= root.width/2 -pointer.width/2
                        pointer.y= root.height/2 -pointer.height/2 +root.height*.2
                        pointer.rotation=90
                    }
                    pointingAnimation.restart()
                }
            }
            PauseAnimation { duration: 6000 }
        }
    }

    onWidthChanged: if (visible) show()
    onHeightChanged: if (visible) show()

    function show(){
        instructionText.text = "Click on the devices to open applications"
        instructionText.visible = true
        highlight.hidden = true

        pointer.visible = false
        rotationAngle = 0

        startAnimations()
        visible = true
    }

    function startAnimations(){
        pointingAnimation.restart()
        helpAnimation.restart()
    }

    function stopAnimations(){
        pointingAnimation.stop()
        helpAnimation.stop()
    }

    MouseArea{
        anchors.fill: root
        onClicked: {
            stopAnimations()
            closeAnimation.restart()
        }
    }
}

