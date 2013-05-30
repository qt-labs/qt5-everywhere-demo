import QtQuick 2.0

Item {
    id: delegate
    height: grid.cellHeight
    width: grid.cellWidth
    property int tileMargin: videoSelector.tileMargin

    signal videoSelected(string link)

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
            source: thumbnail
            width: parent.width
            height: parent.height
        }

        Rectangle{
            width: parent.width
            height: titleText.height + tileMargin
            anchors.top: titleText.top
            anchors.bottom: parent.bottom
            color: "Black"
            opacity: 0.5
            visible: iconImage.source

        }

        Text {
            id: titleText
            anchors.left: parent.left
            anchors.leftMargin: tileMargin/3
            anchors.bottom: parent.bottom
            anchors.bottomMargin: tileMargin/3
            anchors.right: parent.right
            anchors.rightMargin: tileMargin/3

            color: videoSelector.textColor
            text: title
            width: parent.width;
            wrapMode: Text.WordWrap;
            smooth: true
            font { family: videoSelector.uiFont; pointSize: videoSelector.tileFontSize }
        }
    }
}

