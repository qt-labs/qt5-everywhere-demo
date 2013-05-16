import QtQuick 2.0
import "HeartData.js" as Data

Rectangle {
    id: app
    anchors.fill: parent
    color: "black"

    property int frequency: 60
    property int beatDataIndex: -1
    property int heartDataIndex: 0
    property int beatDifference: 1200
    property var previousTime: 0
    property string curveColor: "#22ff22"
    property string textColor: "#22ff22"

    function pulse() {
        if (!heartAnimation.running) {
            heartAnimation.restart()
            heartTimer.restart()
            calculateFrequency();
            app.beatDataIndex = 0
        }
    }

    function calculateFrequency() {
        var ms = new Date().getTime();
        if (app.previousTime > 0)
            app.beatDifference = 0.8*beatDifference + 0.2*(ms - app.previousTime)
        app.frequency = Math.round(60000.0 / app.beatDifference)
        app.previousTime = ms;
    }

    function updateData() {
        app.heartDataIndex++;
        if (app.heartDataIndex >= Data.heartData.length)
            app.heartDataIndex = 0;
        else
            app.heartDataIndex++;

        if (beatDataIndex >= 0)
            fillBeatData()
        else
            fillRandomData()

        heartCanvas.requestPaint()
    }

    function fillBeatData() {
        var value = 0;
        switch (app.beatDataIndex) {
        case 0: value = Math.random()*0.1+0.1; break;
        case 1: value = Math.random()*0.1+0.0; break;
        case 2: value = Math.random()*0.3+0.7; break;
        case 3: value = Math.random()*0.1-0.05; break;
        case 4: value = Math.random()*0.3-0.8; break;
        case 5: value = Math.random()*0.1-0.05; break;
        case 6: value = Math.random()*0.1-0.05; break;
        case 7: value = Math.random()*0.1+0.15; break;
        default: value = 0; break;
        }

        Data.heartData[app.heartDataIndex] = value;
        app.beatDataIndex++;
        if (app.beatDataIndex > 7)
            app.beatDataIndex = -1
    }

    function fillRandomData() {
        Data.heartData[app.heartDataIndex] = Math.random()*0.05-0.025
    }

    onWidthChanged: Data.fillHeartData(Math.floor(app.width*0.5))

    Rectangle {
        id: canvasBackground
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        height: 0.7 * parent.height

        gradient: Gradient {
            GradientStop {position: .0; color :"black"}
            GradientStop {position: .5; color :"#00ff00"}
            GradientStop {position: 1.0; color :"black"}
        }
        opacity: .3
    }

    Rectangle {
        id: canvasContainer
        anchors.fill: canvasBackground
        color: "transparent"

        Canvas {
            id: heartCanvas
            anchors.fill: parent
            antialiasing: true
            renderTarget: Canvas.Image
            onPaint: {
                var ctx = heartCanvas.getContext('2d')

                ctx.clearRect(0,0,canvasContainer.width,canvasContainer.height)

                var baseY = heartCanvas.height/2;
                var length = Data.heartData.length;
                var step = (heartCanvas.width-5) / length;
                var yFactor = heartCanvas.height * 0.35;
                var heartIndex = (heartDataIndex+1) % length;

                ctx.strokeStyle = app.curveColor
                ctx.beginPath()
                ctx.moveTo(0,baseY)
                var i=0, x=0, y=0;
                for (i=0; i<length; i++) {
                    x=i*step;
                    y=baseY - Data.heartData[heartIndex]*yFactor;
                    ctx.lineTo(x,y)
                    heartIndex = (heartIndex+1)%length;
                }
                ctx.stroke()
                ctx.closePath()

                ctx.beginPath()
                ctx.fillStyle = app.curveColor
                ctx.ellipse(x-5,y-5,10,10)
                ctx.fill()
                ctx.closePath()
            }
        }
    }
    Image {
        id: heart
        anchors { left: parent.left; top: parent.top }
        anchors.margins: app.width * 0.05
        source: "heart.png"
        MouseArea {
            anchors.fill: parent
            onPressed: pulse()
        }
    }

    Text {
        id: pulseText
        anchors { right: parent.right; verticalCenter: heart.verticalCenter }
        anchors.margins: app.width * 0.05
        antialiasing: true
        text: app.frequency
        color: app.textColor
        font { pixelSize: app.width * .1; bold: true }
    }

    // Pulse timer
    Timer {
        id: heartTimer
        interval: 1200
        running: true
        repeat: false
        onTriggered: pulse()
    }

    // Update timer
    Timer {
        id: updateTimer
        interval: 50
        running: true
        repeat: true
        onTriggered: updateData()
    }

    SequentialAnimation{
        id: heartAnimation
        NumberAnimation { target: heart; property: "scale"; duration: 100; from: 1.0; to:1.2; easing.type: Easing.Linear }
        NumberAnimation { target: heart; property: "scale"; duration: 100; from: 1.2; to:0.8; easing.type: Easing.Linear }
        NumberAnimation { target: heart; property: "scale"; duration: 100; from: 0.8; to:1.0; easing.type: Easing.Linear }
    }

    /*SequentialAnimation{
        id: textAnimation
        running: true
        loops: Animation.Infinite
        NumberAnimation { target: pulseText; property: "scale"; duration: 100; from: 1.0; to:1.1; easing.type: Easing.Linear }
        NumberAnimation { target: pulseText; property: "scale"; duration: 100; from: 1.1; to:1.0; easing.type: Easing.Linear }
    }*/

    Component.onCompleted: {
        Data.fillHeartData(Math.max(100,Math.floor(app.width*0.5)))
    }
}
