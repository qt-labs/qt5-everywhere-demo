import QtQuick 2.0

Item {
    id: root
    anchors.fill:parent
    property int delay: 500
    property int rotationAngle:0
    property int showInstruction: 0

    SequentialAnimation {
        id: closeAnimation

        ScriptAction{
            script: {
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
        opacity: .8
        smooth: true
    }

    Rectangle{
        id: top
        anchors {left:parent.left; top: parent.top; right: parent.right; bottom: highlightImage.top}
        color: "black"
        opacity: .8
    }

    Rectangle{
        id: bottom
        anchors {left:parent.left; top: highlightImage.bottom; right: parent.right; bottom: parent.bottom}
        color: "black"
        opacity: .8
    }

    Rectangle{
        id: left
        anchors {left:parent.left; top: highlightImage.top; right: highlightImage.left; bottom: highlightImage.bottom}
        color: "black"
        opacity: .8
    }

    Rectangle{
        id: right
        anchors {left:highlightImage.right; top: highlightImage.top; right: parent.right; bottom: highlightImage.bottom}
        color: "black"
        opacity: .8
    }

    Image {
        anchors {horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: parent.height*.1}
        source: "images/txt_tapDevices.png"
        visible: root.showInstruction === 1
        scale: parent.width/1000
    }

    Image {
        anchors {horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: parent.height*.1}
        source: "images/txt_useArrows.png"
        visible: root.showInstruction === 2
        scale: parent.width/1000
    }

    Image {
        anchors {horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: parent.height*.1}
        source: "images/txt_useHome.png"
        visible: root.showInstruction === 3
        scale: parent.width/1000
    }


    Item{
        id: pointer
        width: parent.width*.3
        height: parent.width*.3

        Image{
            id: handImage
            width: parent.width*.8
            height: width
            source: "images/hand.png"
            y: parent.height/2-height/2
            x: parent.width/2-width/2+deltaX
            property int deltaX:0
            anchors.verticalCenter: parent.verticalCenter
            rotation: 90

            SequentialAnimation{
                id: pointingAnimation
                PauseAnimation { duration: root.delay}
                NumberAnimation{
                    target: handImage
                    property: "deltaX"
                    from: -handImage.width*.2
                    to: handImage.width*.2
                    duration: 500
                    easing.type: Easing.InOutCubic
                }
                PauseAnimation { duration: 200 }
                NumberAnimation{
                    target: handImage
                    property: "deltaX"
                    from: handImage.width*.2
                    to: -handImage.width*.2
                    duration: 500
                    easing.type: Easing.InOutCubic

                }
            }

        }

    }

    SequentialAnimation {
        id: helpAnimation
        loops: Animation.Infinite

        PauseAnimation { duration: 1000 }
        PropertyAction { target: handImage; property: "mirror"; value: true}
        PropertyAction { target: root; property: "showInstruction"; value: 1}
        PropertyAction { target: pointer; property: "visible"; value: true}
        PropertyAction { target: highlight; property: "hidden"; value: false}

        SequentialAnimation {
            id: clickAnimation
            property int index: 0
            property variant uids: [9,13]
            loops: 2

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
        PauseAnimation { duration: 1000 }

        SequentialAnimation{
            id: navigationAnimation
            PropertyAction { target: handImage; property: "mirror"; value: false}
            PropertyAction { target: root; property: "showInstruction"; value: 2}
            ScriptAction{
                script: {
                    highlight.size= Math.min(root.width, root.height)*.4

                    var _x=0;
                    var _y=0;

                    if (root.width > root.height){
                        _x = navigationPanel.x+navigationPanel.width /2
                        _y = navigationPanel.y+navigationPanel.height*.33
                        pointer.x= root.width/2 -pointer.width/2 +root.width*.2
                        pointer.y= root.height/2 -pointer.height/2
                        highlight.x=_x
                        highlight.y=_y

                    }else{
                        _x=navigationPanel.x+navigationPanel.width*.33
                        _y=navigationPanel.y + navigationPanel.height /2
                        pointer.x= root.width/2 -pointer.width/2
                        pointer.y= root.height/2 -pointer.height/2 +root.height*.2
                        highlight.x=_x
                        highlight.y=_y
                    }

                    pointer.rotation=Math.atan2(_y-(pointer.y+pointer.height/2), _x-(pointer.x+pointer.width/2))*180.0/Math.PI

                    pointingAnimation.restart()
                }
            }
            PauseAnimation { duration: 5000 }

            PropertyAction { target: root; property: "showInstruction"; value: 3}
            ScriptAction{
                script: {
                    highlight.size= Math.min(root.width, root.height)*.3

                    var _x=0;
                    var _y=0;

                    if (root.width > root.height){
                        _x = navigationPanel.x+navigationPanel.width /2
                        _y = navigationPanel.y+navigationPanel.height-navigationPanel.width /2
                        pointer.x= root.width/2 -pointer.width/2 +root.width*.2
                        pointer.y= root.height/2 -pointer.height/2
                        highlight.x=_x
                        highlight.y=_y

                    }else{
                        _x=navigationPanel.x+navigationPanel.width-navigationPanel.height /2
                        _y=navigationPanel.y + navigationPanel.height /2
                        pointer.x= root.width/2 -pointer.width/2
                        pointer.y= root.height/2 -pointer.height/2 +root.height*.2
                        highlight.x=_x
                        highlight.y=_y
                    }
                    pointer.rotation=Math.atan2(_y-(pointer.y+pointer.height/2), _x-(pointer.x+pointer.width/2))*180.0/Math.PI

                    pointingAnimation.restart()
                }
            }
            PauseAnimation { duration: 5000 }
        }

    }

    onWidthChanged: if (visible) show()
    onHeightChanged: if (visible) show()

    function show(){
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

