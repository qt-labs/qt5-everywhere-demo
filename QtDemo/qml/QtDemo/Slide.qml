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
    property bool loaded: false
    property real targetScale: 1
    property real targetAngle: device === 0 ? -90 : 0

    property int maskWidth: 867
    property int maskHeight: 520

    property int demoWidth: 603
    property int demoHeight: 378

    property int maskVerticalOffset: 51
    property int maskHorizontalOffset: 1

    function targetWidth()
    {
        return device == 0 ? height*scale: width*scale;
    }

    function targetHeight()
    {
        return device == 0 ? width*scale : height*scale;
    }

    Rectangle{
        id: demoContainer
        anchors.centerIn: parent
        width: demoWidth
        height: demoHeight
        color: "black"
        clip: true
        z: slide.loaded ? 1:-1
    }

    ShaderEffectSource{
        id: demo
        anchors.centerIn: parent
        width: demoWidth
        height: demoHeight
        sourceItem: demoContainer
        live: slide.loaded
        visible: true
        smooth: false
        hideSource: true
        clip: true
        z: slide.loaded ? 1:-1
    }

    Image {
        id: deviceMaskImage
        anchors.centerIn: parent
        anchors.verticalCenterOffset: maskVerticalOffset
        anchors.horizontalCenterOffset: maskHorizontalOffset
        source: device === 0 ? "images/iPhone_mask.png" :
                               device === 1 ? "images/Tablet_mask.png" :
                                              device === 2 ? "images/MedicalDevice_mask.png" :
                                                             device === 3 ? "images/Laptop_mask.png" :
                                                                            ""
        width: maskWidth
        height: maskHeight
        z: 2
    }

    function loadDemo(){
        if (!slide.url || slide.loaded) return;

        var component = Qt.createComponent(slide.url);
        print ("CREATED COMPONENT FROM: "+slide.url)
        var incubator = component.incubateObject(demoContainer, {
                                                     x: 0,
                                                     y: 0,
                                                     objectName: "demoApp"
                                                 });
        if (incubator.status !== Component.Ready) {
            incubator.onStatusChanged = function(status) {
                if (status === Component.Ready) {
                    print ("Object", incubator.object, "is now ready!");
                    //disabledImage.scheduleUpdate()
                    slide.loaded = true
                }
            }
        } else {
            print ("Object", incubator.object, "is ready immediately!");
            //disabledImage.scheduleUpdate()
            slide.loaded = true
        }
    }

    function releaseDemo(){
        if (!slide.loaded) return;
        slide.loaded = false;

        for (var i =0; i<demoContainer.children.length; i++){
            if (demoContainer.children[i].objectName === "demoApp"){
                demoContainer.children[i].destroy();
            }
        }
    }

    Component.onCompleted: {
        print ("new slide created!")
    }

//    Rectangle{
//        id: debug
//        anchors.fill: demoContainer
//        color: "transparent"
//        z: 100
//        border {color: "red"; width:3}
//    }

}
