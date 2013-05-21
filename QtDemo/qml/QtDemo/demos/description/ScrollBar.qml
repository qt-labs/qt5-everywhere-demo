import QtQuick 2.0

Item {
    id: scrollBar

    // The properties that define the scrollbar's state.
    // position and pageSize are in the range 0.0 - 1.0.  They are relative to the
    // height of the page, i.e. a pageSize of 0.5 means that you can see 50%
    // of the height of the view.
    property real position
    property real pageSize

    // A light, semi-transparent background
    Rectangle {
        id: background
        anchors.fill: parent
        radius: width/2 - 1
        color: "transparent"
    }

    Rectangle {
        x: scrollBar.position * (scrollBar.width-2) + 1
        y: 1
        width: scrollBar.pageSize * (scrollBar.width-2)
        height: parent.height
        radius: height/2 - 1
        color: "#22aa22"
    }
}
