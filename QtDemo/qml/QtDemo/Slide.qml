import QtQuick 2.0

Rectangle {
    id: slide
    objectName: "slide"
    width: 1280
    height: 800
    color: "transparent"
    border {color: app.showDebugRects ? borderColor : "transparent"; width:3}

    property int uid: 0
    property color borderColor: "black"
    property string url: ""
    property int device: 0
    property bool loaded: false

    Rectangle{
        id: demoContainer
        anchors.centerIn: parent
        width: device === 0 ? 320 : device !== 3 ? 700 : 620
        height: device === 0 ? 480 : device !== 3 ? 480 : 400
        color: "black"
        clip: true
    }

    ShaderEffectSource {
        id: disabledImage
        anchors.fill: demoContainer
        sourceItem: demoContainer
        live: false
        visible: !slide.loaded
    }

    Image {
        id: deviceMaskImage
        anchors.centerIn: parent
        anchors.verticalCenterOffset: device < 2 ? 45 : device === 2 ? 90 : device !== 3 ? 0: 50
        anchors.horizontalCenterOffset: -2
        source: device === 0 ? "images/iPhone_mask.png" :
                               device === 1 ? "images/Tablet_mask.png" :
                                              device === 2 ? "images/MedicalDevice_mask.png" :
                                                             device === 3 ? "images/Laptop_mask.png" :
                                                                            ""
        width: device === 0 ? 375 : device === 1 ? 838 : device === 2 ? 838 : 867
        height: device === 0 ? 835 : device === 1 ? 589 : device === 2 ? 762 : 520
        sourceSize: device === 0 ? Qt.size(375, 835) : device === 1 ? Qt.size(839, 589) : device === 2 ? Qt.size(838, 762) : Qt.size(867, 520)
    }

    function loadDemo(){
        if (!slide.url || slide.loaded) return;

        var component = Qt.createComponent(slide.url);
        var incubator = component.incubateObject(demoContainer, {
                                                     x: 0,
                                                     y: 0,
                                                     objectName: "demoApp"
                                                 });
        if (incubator.status !== Component.Ready) {
            incubator.onStatusChanged = function(status) {
                if (status === Component.Ready) {
                    print ("Object", incubator.object, "is now ready!");
                    disabledImage.scheduleUpdate()
                    slide.loaded = true
                }
            }
        } else {
            print ("Object", incubator.object, "is ready immediately!");
            disabledImage.scheduleUpdate()
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
}
