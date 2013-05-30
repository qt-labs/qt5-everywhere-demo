import QtQuick 2.0

Item {
    id: elementContainer
    width: place == 2 ? 0.8*parent.width : 0.1*islandWidth
    height: place == 2 ? 0.1*islandHeight : 0.15*islandHeight
    x: place == 0 ? (-width-0.02*islandWidth) : place == 1 ? (parent.width+0.02*islandWidth) : 0.1*parent.width
    y: place == 2 ? parent.height : (parent.height - height)

    property int place : 0
    property int itemWidth : islandWidth * 0.07
    property int islandWidth: 100
    property int islandHeight: 100

    function createElements()
    {
        var count = Math.floor(Math.random()*4.9)
        var step = place == 2 ? elementContainer.width / Math.max(count,1) : elementContainer.height / Math.max(count,1);

        for (var i=0; i<count; i++) {
            var itemId = place == 2 ? Math.floor(Math.random()*2.9) : Math.floor(Math.random()*1.9);
            var component = Qt.createComponent("Element.qml")
            if (component.status === Component.Ready)
                component.createObject(elementContainer,
                                       {"posY": place == 2 ? Math.random()*elementContainer.height : (step/2 + step*i),
                                        "posX": place == 2 ? (step/2 + step*i) : Math.random()*elementContainer.width,
                                        "itemWidth": elementContainer.itemWidth,
                                        "itemId":itemId});
        }
    }
}
