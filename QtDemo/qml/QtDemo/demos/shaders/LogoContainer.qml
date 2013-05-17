import QtQuick 2.0

Rectangle {
    id: root
    color: "transparent"
    anchors.fill: parent

    property int logoCount: 0

    Image {
        id: background
        source: "images/wallpaper.png"
        anchors.fill: root
    }

    function createNewLogo(x,y,logoState) {
        logoCount++;
        var component = Qt.createComponent("Logo.qml")
        if (component.status === Component.Ready) {
            var logo = component.createObject(root, {"posX": x, "posY": y, "logoState": logoState, "logoSizeDivider" : logoState, "objectName": "logo"});
            logo.play();
        }
    }

    function createNewLogos(x, y, logoSize, logoState) {
        var newSize = logoSize / logoState;
        var temp = logoSize - newSize;

        createNewLogo(x, y, logoState);
        createNewLogo(x+temp, y, logoState);
        createNewLogo(x+temp, y+temp, logoState);
        createNewLogo(x, y+temp, logoState);
        createNewLogo(x+logoSize/2-newSize/2, y+logoSize/2-newSize/2, logoState);
    }

    function decreaseCounter() {
        if (logoCount > 1) {
            logoCount--;
            return true;
        }
        return false;
    }

    Component.onCompleted: {
        var logoSize = Math.min(root.height, root.width) / 2;
        createNewLogo(root.width/2 - logoSize/2, root.height/2 - logoSize/2, 1)
    }
}
