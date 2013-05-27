import QtQuick 2.0

Item {
    id: slide
    objectName: "slide"
    x: startX
    y: startY + deltaY
    rotation: deltaRot

    property bool rotAnimationEnabled: false
    property bool yAnimationEnabled: false
    property int uid: 0
    property string url: ""
    property int device: 0
    property string imageSource: ""
    property bool loaded: false
    property bool loading: false
    property real targetScale: 1
    property int startX: 0
    property int startY: 0
    property bool animationRunning: navigationAnimation.running || zoomAnimation.running
    property int demoWidth: 603
    property int demoHeight: 378
    property int maskVerticalOffset: 51
    property int maskHorizontalOffset: 1
    property string demoColor: "#883322"
    property string name: ""
    property real deltaRot: 0
    property int deltaY: 0
    property int swing: 5
    property bool dirty: parent.angle !== 0 || rotation !==0

    function targetWidth()
    {
        return demoWidth*scale;
    }

    function targetHeight()
    {
        return demoHeight*scale;
    }

    Rectangle {
        id: demoBackground
        anchors.centerIn: parent
        width: demoContainer.width * 1.03
        height: demoContainer.height * 1.03
        color: "black"
        z: !slide.dirty && (slide.loading || slide.loaded) ? 1:-1

        Rectangle{
            id: demoContainer
            anchors.centerIn: parent
            width: demoWidth
            height: demoHeight
            color: demoColor
            clip: true

            Text {
                id: splashScreenText
                color: 'white'
                font.pixelSize: parent.width *.1
                text: slide.name
                anchors.centerIn: parent
                smooth: true
                visible: true
            }
        }
    }

    ShaderEffectSource{
        id: demo
        anchors.centerIn: parent
        width: demoWidth
        height: demoHeight
        sourceItem: demoContainer
        live: visible && (slide.loading || slide.loaded)
        visible: slide.dirty || !slide.loaded || updating
        hideSource: visible && !updating && !loading
        clip: true

        property bool updating: false

        onScheduledUpdateCompleted: {
            updating = false
            releaseDemo(true)
        }
    }

    Image {
        id: deviceMaskImage
        anchors.centerIn: parent
        anchors.verticalCenterOffset: maskVerticalOffset
        anchors.horizontalCenterOffset: maskHorizontalOffset
        smooth: !animationRunning
        antialiasing: !animationRunning
        source: slide.imageSource
        width: slide.width
        height: slide.height
        z: 2

        //IslandElementContainer { id: leftElementcontainer; place: 0; islandHeight: islandImage.height; islandWidth: islandImage.width }
        //IslandElementContainer { id: rightElementcontainer;place: 1; islandHeight: islandImage.height; islandWidth: islandImage.width }
        IslandElementContainer { id: bottomElementcontainer;place: 2; islandHeight: islandImage.height; islandWidth: islandImage.width }
    }

    Image {
        id: islandImage
        anchors.top: deviceMaskImage.bottom
        anchors.topMargin: -height * 0.3
        anchors.horizontalCenter: deviceMaskImage.horizontalCenter
        source: "images/island.png"
        smooth: !animationRunning
        antialiasing: !animationRunning
        width: Math.max(deviceMaskImage.width, deviceMaskImage.height) * 1.6
        height: width/2
        z: -3
    }

    SequentialAnimation{
        id: rotationAnimation
        NumberAnimation { target: slide; property: "deltaRot"; duration: 3000; to:swing; easing.type: Easing.InOutQuad }
        NumberAnimation { target: slide; property: "deltaRot"; duration: 3000; to:-swing; easing.type: Easing.InOutQuad }
        loops: Animation.Infinite
    }

    SequentialAnimation{
        id: yAnimation
        NumberAnimation { target: slide; property: "deltaY"; duration: 4000; to:10*swing; easing.type: Easing.InOutQuad }
        NumberAnimation { target: slide; property: "deltaY"; duration: 4000; to:-10*swing; easing.type: Easing.InOutQuad }
        loops: Animation.Infinite
    }

    // Load timer
    Timer {
        id: loadTimer
        interval: 5
        running: false
        repeat: false
        onTriggered: {
            loadSplashScreen();
            load()
        }
    }

    // Starter timer
    Timer {
        id: yStarter
        interval: Math.random()*5000
        onTriggered: yAnimation.start()
    }
    // Starter timer
    Timer {
        id: rotStarter
        interval: Math.random()*2000
        onTriggered: rotationAnimation.start()
    }

    function loadDemo(){
        yAnimation.stop()
        rotationAnimation.stop()
        deltaY = 0
        deltaRot = 0


        if (!slide.loaded)
        {
            splashScreenText.visible = true
            loadTimer.start();
        } else if (slide.name==="Internet Radio"){
            for (var i =0; i<demoContainer.children.length; i++){
                if (demoContainer.children[i].objectName === "demoApp"){
                    demoContainer.children[i].focus = true;
                }
            }
        }
    }

    function load() {
        if (!slide.url || slide.loaded) return;

        print("CREATING DEMO: "+ slide.url)
        var component = Qt.createComponent(slide.url);
        print ("CREATED: "+slide.url)
        var incubator = component.incubateObject(demoContainer, { x: 0, y: 0, objectName: "demoApp" });
        if (incubator.status !== Component.Ready) {
            incubator.onStatusChanged = function(status) {
                if (status === Component.Ready) {
                    print ("Object", incubator.object, "is now ready!");
                    slide.loaded = true
                    releaseSplashScreen()
                }
            }
        } else {
            print ("Object", incubator.object, "is ready immediately!");
            slide.loaded = true
            releaseSplashScreen()
        }
    }

    function loadSplashScreen()
    {
        slide.loading = true
        var splash = Qt.createComponent("SplashScreen.qml");
        if (splash.status === Component.Ready)
            splash.createObject(demoContainer, {objectName: "splashScreen", text: slide.name});
    }

    function releaseSplashScreen()
    {
        splashScreenText.visible = false
        slide.loading = false
        for (var i =0; i<demoContainer.children.length; i++){
            if (demoContainer.children[i].objectName === "splashScreen"){
                demoContainer.children[i].explode();
            }
        }
    }

    function releaseDemo(snapShotCreated){
        if (!slide.loaded) return;
        if (!snapShotCreated){
            demo.updating = true
            demo.scheduleUpdate()
            return;
        }

        if (yAnimationEnabled)
            yAnimation.restart()
        if (rotAnimationEnabled)
            rotationAnimation.restart()
        if (slide.name === "Internet Radio") return; //Always alive

        app.forceActiveFocus();

        if (!slide.loaded)
            return;

        slide.loaded = false;

        for (var i =0; i<demoContainer.children.length; i++){
            if (demoContainer.children[i].objectName === "demoApp"){
                demoContainer.children[i].destroy();
            }
        }
    }

    function createElements()
    {
        //leftElementcontainer.createElements()
        //rightElementcontainer.createElements()
        bottomElementcontainer.createElements()
    }

    Component.onCompleted: {
        if (yAnimationEnabled)
            yStarter.start()
        if (rotAnimationEnabled)
            rotStarter.start()
    }
}
