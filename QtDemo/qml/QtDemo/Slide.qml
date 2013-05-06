import QtQuick 2.0

Rectangle {
    id: slide
    objectName: "slide"

    width: 867
    height: 520
    scale: 2

    color: "transparent"
    border {color: app.showDebugRects ? borderColor : "transparent"; width:3}

    property int uid: 0
    property color borderColor: "black"
    property string url: ""
    property int device: 0
    property string imageSource: ""
    property bool loaded: false
    property bool loading: false
    property real targetScale: 1
    property real targetAngle: device <= 2 ? -90 : 0

    property int demoWidth: 603
    property int demoHeight: 378

    property int maskVerticalOffset: 51
    property int maskHorizontalOffset: 1

    property string name: ""

    function targetWidth()
    {
        return device <= 2 ? demoHeight*scale: demoWidth*scale;
    }

    function targetHeight()
    {
        return device <= 2 ? demoWidth*scale : demoHeight*scale;
    }

    Rectangle{
        id: demoContainer
        anchors.centerIn: parent
        width: demoWidth
        height: demoHeight
        color: "#111111"
        clip: true
        z: (slide.loading || slide.loaded) ? 1:-1

        Text {
            id: splashScreenText
            color: 'white'
            font.pixelSize: parent.height *.1
            text: slide.name
            anchors.centerIn: parent
            smooth: true
            visible: false
        }
    }

    ShaderEffectSource{
        id: demo
        anchors.centerIn: parent
        width: demoWidth
        height: demoHeight
        sourceItem: demoContainer
        live: (slide.loading || slide.loaded)
        visible: true
        smooth: false
        hideSource: true
        clip: true
        z: (slide.loading || slide.loaded) ? 1:-1
    }

    Image {
        id: deviceMaskImage
        anchors.centerIn: parent
        anchors.verticalCenterOffset: maskVerticalOffset
        anchors.horizontalCenterOffset: maskHorizontalOffset
        source: slide.imageSource
        width: slide.width
        height: slide.height
        z: 2

        IslandElementContainer { id: leftElementcontainer; place: 0; islandHeight: islandImage.height; islandWidth: islandImage.width }
        IslandElementContainer { id: rightElementcontainer;place: 1; islandHeight: islandImage.height; islandWidth: islandImage.width }
        IslandElementContainer { id: bottomElementcontainer;place: 2; islandHeight: islandImage.height; islandWidth: islandImage.width }
    }

    Image {
        id: islandImage
        anchors.top: deviceMaskImage.bottom
        anchors.topMargin: -height * 0.3
        anchors.horizontalCenter: deviceMaskImage.horizontalCenter
        source: "images/island.svg"
        width: Math.max(deviceMaskImage.width, deviceMaskImage.height) * 1.6
        height: width/2
        z: -3
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

    function loadDemo(){
        if (!slide.loaded)
        {
            splashScreenText.visible = true
            demo.scheduleUpdate()
            loadTimer.start();
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
                    //disabledImage.scheduleUpdate()
                    slide.loaded = true
                    releaseSplashScreen()
                }
            }
        } else {
            print ("Object", incubator.object, "is ready immediately!");
            //disabledImage.scheduleUpdate()
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

    function releaseDemo(){
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
        leftElementcontainer.createElements()
        rightElementcontainer.createElements()
        bottomElementcontainer.createElements()
    }

    Component.onCompleted: {
        print ("new slide created!")
    }
}
