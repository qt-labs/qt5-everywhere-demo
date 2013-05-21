import QtQuick 2.0

Rectangle {
    id: delegate
    height: grid.cellHeight
    width: grid.cellWidth
    color: "transparent"
    property int tileMargin: videoSelector.tileMargin

    signal videoSelected(string url)

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: parent.tileMargin/2
        width: parent.width - tileMargin
        height: parent.height - tileMargin
        color: videoSelector.tileBackground

        MouseArea {
            anchors.fill: parent
            onClicked: {
                grid.currentIndex = index
                console.log(link)
                delegate.videoSelected(link)
            }
        }

        states: [
            State {
                name: "selected"
                when: delegate.GridView.isCurrentItem
            }
        ]


        Image {
            id: iconImage
            source: url
            width: parent.width
            height: parent.height
        }

        Rectangle{
            width: parent.width
            height: dateText.height + tileMargin
            anchors.top: dateText.top
            anchors.bottom: parent.bottom
            color: "Black"
            opacity: 0.5
            visible: iconImage.source

        }

        Text {
            id: dateText
            anchors.left: parent.left
            anchors.leftMargin: tileMargin
            anchors.bottom: parent.bottom
            anchors.bottomMargin: tileMargin
            anchors.right: parent.right
            anchors.rightMargin: tileMargin

            color: videoSelector.textColor
            text: title
            width: parent.width;
            wrapMode: Text.WordWrap;
            font { family: videoSelector.uiFont; pointSize: videoSelector.tileFontSize }
        }
    }
}

