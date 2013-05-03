import QtQuick 2.0

Rectangle {
    id: root
    color: "transparent"

    property int itemId : 1
    property int posX: 0
    property int posY: 0
    property int itemWidth: 50

    Image {
        id: elementImage
        anchors.fill: root
        z: 5
    }

    Component.onCompleted: {
        root.width = root.itemWidth
        root.height = root.itemId == 2 ? root.itemWidth*0.8 : root.itemWidth*1.3
        root.x = root.posX - root.width/2
        root.y = root.posY - root.height/2
        elementImage.source = root.itemId === 0 ? "images/tree1.svg" :
                              root.itemId === 1 ? "images/tree2.svg" :
                              root.itemId === 2 ? "images/stones.svg" :
                              ""
    }
}
