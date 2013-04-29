import QtQuick 2.0

Rectangle {
    id: cloudRoot
    x: app.width
    y: randomY+deltaY
    width: app.width*0.2
    height: width*0.4

    color: "transparent"

    property int duration: 20000
    property string sourceImage: ""
    property real deltaY: 0
    property real randomY: app.height*0.3
    property real amplitudeY: app.height*0.1

    function start() {
        recalculate()
        cloudXAnimation.restart();
        cloudYAnimation.restart();
    }

    function recalculate() {
        cloudRoot.duration = Math.random()*15000 + 10000
        cloudRoot.x = app.width
        cloudRoot.randomY = Math.random()*app.height
        cloudRoot.width = app.width*0.2
        cloudRoot.height = cloudRoot.width*0.4
        cloudRoot.scale = Math.random()*0.6 + 0.7
    }

    Image {
        id: cloud
        anchors.fill: cloudRoot
        source: cloudRoot.sourceImage
    }

    SequentialAnimation{
        id: cloudYAnimation
        NumberAnimation { target: cloudRoot; property: "deltaY"; duration: cloudRoot.duration*0.5; from: 0; to:cloudRoot.amplitudeY; easing.type: Easing.InOutQuad }
        NumberAnimation { target: cloudRoot; property: "deltaY"; duration: cloudRoot.duration*0.5; from: cloudRoot.amplitudeY; to:0; easing.type: Easing.InOutQuad }
        running: true
        onRunningChanged: {
            if (!running) {
                cloudRoot.amplitudeY = Math.random() * (app.height*0.2)
                restart()
            }
        }
    }

    NumberAnimation {
        id: cloudXAnimation
        target: cloudRoot
        property: "x"
        duration: cloudRoot.duration
        to:-cloudRoot.width
        running: true

        onRunningChanged: {
            if (!running) {
                recalculate()
                restart()
            }
        }
    }
}
