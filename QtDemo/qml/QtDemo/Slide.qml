import QtQuick 2.0

Rectangle {
    id: slide
    objectName: "slide"
    width: 1280
    height: 800
    color: "transparent"
    border {color: borderColor; width:3}

    property int uid: 0
    property color borderColor: "black"
    property string url: ""
    property bool loaded: false

    Rectangle{
        id: demoContainer
        anchors.centerIn: parent
        width: 320
        height: 480
        color: "black"
        clip: true
    }

    function loadDemo(){
        if (!slide.url || slide.loaded) return;

        slide.loaded = true
        var component = Qt.createComponent(slide.url);
        var incubator = component.incubateObject(demoContainer, {
                                                     x: 0,
                                                     y: 0,
                                                     objectName: "demoApp"
                                                 });
        //        if (incubator.status !== Component.Ready) {
        //            incubator.onStatusChanged = function(status) {
        //                if (status === Component.Ready) {
        //                    print ("Object", incubator.object, "is now ready!");
        //                }
        //            }
        //        } else {
        //            print ("Object", incubator.object, "is ready immediately!");
        //        }
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
