import QtQuick 2.0
import QtQuick.XmlListModel 2.0

Item {
    id: videoSelector

    property int tileHeight: parseInt(grid.height / 2)
    property int tileMargin: tileHeight * 0.1
    property int tileFontSize: tileHeight * 0.08
    property string tileBackground: "#262626"
    property string textColor: "white"
    property string uiFont: "Segoe UI"

    signal selectVideo(string link)

    state: "VISIBLE"

    onOpacityChanged: {
        if (state === "HIDDEN" && opacity <= 0.05)
            visible = false;
    }

    XmlListModel {
        id: videoModel
        source: "qt5_videos.xml"
        query: "/videolist/item"
        XmlRole  { name: "thumbnail"; query: "thumbnail/string()" }
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "link"; query: "link/string()" }
    }

    // Grid view
    GridView {
        id: grid
        anchors.fill: parent
        flow: GridView.TopToBottom
        cellHeight: tileHeight
        cellWidth: parseInt(tileHeight * 1.5)
        cacheBuffer: cellWidth
        clip: false
        focus: true
        model: videoModel
        delegate: VideoDelegate { onVideoSelected: videoSelector.selectVideo(link); }

        // Only show the scrollbars when the view is moving.
        states: State {
            when: grid.movingHorizontally
            PropertyChanges { target: horizontalScrollBar; opacity: 1 }
        }

        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 400 }
        }
    }

    ScrollBar {
        id: horizontalScrollBar
        width: parent.width; height: 6
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        opacity: 0
        position: grid.visibleArea.xPosition
        pageSize: grid.visibleArea.widthRatio
    }

    function hide() {
        videoSelector.state = "HIDDEN";
    }

    function show() {
        videoSelector.visible = true;
        videoSelector.state = "VISIBLE";
    }

    states: [
        State {
            name: "HIDDEN"
            PropertyChanges {
                target: videoSelector
                opacity: 0.0
            }
        },
        State {
            name: "VISIBLE"
            PropertyChanges {
                target: videoSelector
                opacity: 0.95
            }
        }
    ]

    transitions: [
        Transition {
            from: "HIDDEN"
            to: "VISIBLE"
            NumberAnimation {
                id: showAnimation
                target: videoSelector
                properties: "opacity"
                from: 0.0
                to: 1.0
                duration: 200
            }
        },
        Transition {
            from: "VISIBLE"
            to: "HIDDEN"
            NumberAnimation {
                id: hideAnimation
                target: videoSelector
                properties: "opacity"
                from: 0.95
                to: 0.0
                duration: 200
            }
        }
    ]
}
