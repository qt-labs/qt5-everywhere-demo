import QtQuick 2.0
import QtQuick.XmlListModel 2.0

Rectangle {
    id: mainWindow
    anchors.fill: parent
    color: appBackground

    property int tileHeight: parseInt(grid.height / 3)
    property int tileFontSize: tileHeight * 0.05
    property int horizontalMargin: height * 0.08
    property int topBarsize: height * 0.2
    property int bottomBarSize: height * 0.08
    property int tileMargin: height * 0.01
    property int appHeaderFontSize: topBarsize * 0.4
    property string appBackground: "#262626"
    property string tileBackground: "#86bc24"
    property string textColor: "white"
    property string uiFont: "Segoe UI"

    XmlListModel {
        id: feedModel
        //source: "http://blog.qt.digia.com/feed/"
        source: "http://news.yahoo.com/rss/tech"
        //query: "/rss/channel/item"
        // Filter out items that don't have images
        query: "/rss/channel/item[exists(child::media:content)]"
        namespaceDeclarations: "declare namespace media=\"http://search.yahoo.com/mrss/\";"
        XmlRole  { name: "url"; query: "media:content/@url/string()" }
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "pubDate"; query: "pubDate/string()" }
        XmlRole { name: "link"; query: "link/string()" }

        onStatusChanged: {
            if (status == XmlListModel.Ready) {
                playbanner.start();
            }
        }
    }

    // Top bar
    Rectangle {
        id: topBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: horizontalMargin
        opacity: 0
        height: topBarsize
        color: "transparent"
        Text {
            id: title
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            text: qsTr("Yahoo Technology")
            font.family: uiFont;
            font.pixelSize: appHeaderFontSize;
            color: textColor
            smooth: true
        }
    }

    // Grid view
    GridView {
        id: grid
        anchors.fill: parent
        anchors.topMargin: topBarsize
        anchors.bottomMargin: bottomBarSize
        anchors.leftMargin: horizontalMargin
        anchors.rightMargin: horizontalMargin
        opacity: 0
        flow: GridView.TopToBottom
        cellHeight: tileHeight
        cellWidth: parseInt(tileHeight * 1.5)
        cacheBuffer: cellWidth
        clip: false
        focus: true
        model: feedModel
        delegate: RssDelegate {}

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
        orientation: Qt.Horizontal
        position: grid.visibleArea.xPosition
        pageSize: grid.visibleArea.widthRatio
    }

    SequentialAnimation {
         id: playbanner
         running: false
         NumberAnimation { target: topBar; property: "opacity"; to: 1.0; duration: 300}
         NumberAnimation { target: grid; property: "opacity"; to: 1.0; duration: 300}
    }

}

