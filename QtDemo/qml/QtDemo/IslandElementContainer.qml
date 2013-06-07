import QtQuick 2.0

Item {
    id: elementContainer

    width: place == 2 ? parent.width : (islandWidth-parent.width)/2
    height: place == 2 ? 0.1*islandHeight : 0.4*islandHeight
    x: place == 0 ? -width : place == 1 ? parent.width : 0
    y: place == 2 ? parent.height : (parent.height - height*0.6)

    property int place : 0
    property int itemWidth : islandWidth * 0.1
    property int islandWidth: 100
    property int islandHeight: 100

    function createElement(xx, yy, itemId) {
        var component = Qt.createComponent("Element.qml")
        if (component.status === Component.Ready)
            component.createObject(elementContainer, {"x": xx, "y": yy, "itemId": itemId});
    }

    function createElements()
    {
        // Left side
        if (place === 0) {
            var temp0 = Math.floor(Math.random()*5.9);
            switch(temp0) {
            case 0:
                createElement(elementContainer.width*0.4, elementContainer.height*0.2, 1);
                createElement(elementContainer.width*0.25, elementContainer.height*0.3, 1);
                createElement(elementContainer.width*0.15, elementContainer.height*0.5, 1);
                createElement(elementContainer.width*0.55, elementContainer.height*0.4, 1);
                break;
            case 1:
                createElement(elementContainer.width*0.6, elementContainer.height*0.1, 1);
                createElement(elementContainer.width*0.4, elementContainer.height*0.2, 1);
                createElement(elementContainer.width*0.7, elementContainer.height*0.3, 1);
                createElement(elementContainer.width*0.3, elementContainer.height*0.5, 1);
                break;
            case 2:
                createElement(elementContainer.width*0.6, elementContainer.height*0.1, 3);
                createElement(elementContainer.width*0.4, elementContainer.height*0.6, 4);
                createElement(elementContainer.width*0.8, elementContainer.height*0.8, 4);
                break;
            case 3:
                createElement(elementContainer.width*0.6, elementContainer.height*0.1, 3);
                createElement(elementContainer.width*0.4, elementContainer.height*0.4, 1);
                createElement(elementContainer.width*0.5, elementContainer.height*0.5, 2);
                createElement(elementContainer.width*0.7, elementContainer.height*0.6, 2);
                break;
            case 4:
                createElement(elementContainer.width*0.7, elementContainer.height*0.3, 0);
                break;
            default: break;
            }
        }
        else if (place === 1) {
            var temp1 = Math.floor(Math.random()*4.9);
            switch(temp1) {
            case 0:
                createElement(elementContainer.width*0.6, elementContainer.height*0.2, 1);
                createElement(elementContainer.width*0.75, elementContainer.height*0.3, 1);
                createElement(elementContainer.width*0.85, elementContainer.height*0.5, 1);
                createElement(elementContainer.width*0.45, elementContainer.height*0.4, 1);
                break;
            case 1:
                createElement(elementContainer.width*0.4, elementContainer.height*0.1, 1);
                createElement(elementContainer.width*0.6, elementContainer.height*0.2, 1);
                createElement(elementContainer.width*0.3, elementContainer.height*0.3, 1);
                createElement(elementContainer.width*0.7, elementContainer.height*0.5, 1);
                break;
            case 2:
                createElement(elementContainer.width*0.4, elementContainer.height*0.1, 3);
                createElement(elementContainer.width*0.6, elementContainer.height*0.6, 4);
                createElement(elementContainer.width*0.2, elementContainer.height*0.8, 4);
                break;
            case 3:
                createElement(elementContainer.width*0.4, elementContainer.height*0.1, 3);
                createElement(elementContainer.width*0.6, elementContainer.height*0.4, 2);
                createElement(elementContainer.width*0.5, elementContainer.height*0.5, 1);
                createElement(elementContainer.width*0.3, elementContainer.height*0.6, 2);
                break;
            default: break;
            }
        }
        else {
            var temp2 = Math.floor(Math.random()*4.9);
            switch(temp2) {
            case 0:
                createElement(elementContainer.width*0.8, elementContainer.height*0.8, 5);
                createElement(elementContainer.width*0.4, elementContainer.height*0.5, 5);
                break;
            case 1:
                createElement(elementContainer.width*0.1, elementContainer.height*0.5, 1);
                createElement(elementContainer.width*0.2, elementContainer.height*0.9, 2);
                createElement(elementContainer.width*0.6, elementContainer.height*0.8, 4);
                break;
            case 2:
                createElement(elementContainer.width*0.2, elementContainer.height*0.5, 6);
                createElement(elementContainer.width*0.7, elementContainer.height*0.6, 2);
                createElement(elementContainer.width*0.6, elementContainer.height*0.7, 1);
                break;
            case 3:
                createElement(elementContainer.width*0.2, elementContainer.height*0.8, 6);
                createElement(elementContainer.width*0.7, elementContainer.height*0.6, 6);
                break;
            default: break;
            }
        }
    }
}
