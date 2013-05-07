import QtQuick 2.0

Rectangle {
    id: root
    color: "transparent"
    anchors.fill: parent

    property int logoCount: 0
    property bool running: false

    Image {
        id: background
        source: "images/wallpaper.png"
        anchors.fill: root
    }

    function play() {
        running = true
        for (var i =0; i<root.children.length; i++){
            if (root.children[i].objectName === "logo"){
                root.children[i].play();
            }
        }
    }

    function pause() {
        running = false
        for (var i =0; i<root.children.length; i++){
            if (root.children[i].objectName === "logo"){
                root.children[i].pause();
            }
        }
    }

    function createNewLogo(x,y,logoState) {
        logoCount++;
        var component = Qt.createComponent("Logo.qml")
        if (component.status === Component.Ready) {
            var logo = component.createObject(root, {"posX": x, "posY": y, "logoState": logoState, "objectName": "logo"});
            if (running)
                logo.play();
        }
    }

    function createNewLogos(x, y, logoState) {
        for (var i=0; i<5; i++) {
            createNewLogo(x, y, logoState)
        }
    }

    function decreaseCounter(x,y) {
        logoCount--;
        if (logoCount <= 0)
            createNewLogo(x,y,1)
    }

    Component.onCompleted: {
        createNewLogo(root.width/2, root.height/2, 1)
    }
}
