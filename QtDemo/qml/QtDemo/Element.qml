import QtQuick 2.0

Item {
    id: root
    width: 1
    height: 1

    property int itemId : 1

    Image {
        id: elementImage
        anchors.centerIn: root
        z: 5
    }

    Component.onCompleted: {
        elementImage.source = root.itemId === 0 ? "images/man1.png" :
                              root.itemId === 1 ? "images/tree1.png" :
                              root.itemId === 2 ? "images/tree2.png" :
                              root.itemId === 3 ? "images/mountain.png" :
                              root.itemId === 4 ? "images/stones.png" :
                              root.itemId === 5 ? "images/box_open.png" :
                              root.itemId === 6 ? "images/box.png" :
                              ""
    }
}
