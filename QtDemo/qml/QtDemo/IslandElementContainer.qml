import QtQuick 2.0

Rectangle {
    id: container
    width: place == 2 ? 0.5*islandWidth : 0.1*islandWidth
    height: place == 2 ? 0.1*islandHeight : 0.15*islandHeight
    x: place == 0 ? -width : place == 1 ? parent.width : 0.1*parent.width
    y: parent.height - 0.1*islandHeight - (place != 2 ? height : 0)
    color: "transparent"
    //border {width: 3; color: "red"}

    property int place : 0
    property int itemWidth : islandWidth * 0.07
    property int islandWidth: 100
    property int islandHeight: 100

    Component.onCompleted: {
        var count = place == 2 ? Math.floor(Math.random()*3.9) : Math.floor(Math.random()*2.9);
        var itemId = Math.floor(Math.random()*2.9);
        var step = place == 2 ? container.width / Math.max(count,1) : container.height / Math.max(count,1);
        for (var i=0; i<count; i++) {
            var component = Qt.createComponent("Element.qml")
            if (component.status === Component.Ready)
                component.createObject(container,
                                       {"posY": place == 2 ? Math.random()*container.height : (step/2 + step*i),
                                        "posX": place == 2 ? (step/2 + step*i) : Math.random()*container.width,
                                        "itemWidth": container.itemWidth,
                                        "itemId":itemId});
        }
    }
}
