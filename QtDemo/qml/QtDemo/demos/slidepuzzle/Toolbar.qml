import QtQuick 2.0

Rectangle {
    id: toolbar
    color: "#232323"
    anchors.fill: parent
    anchors.rightMargin: 0.7*parent.width;
    anchors.leftMargin: -1;
    anchors.topMargin: -1;
    anchors.bottomMargin: -1
    border.color: "#666666"
    function setElapsedSeconds(s)
    {
        timeText.text = qsTr("Time: " + s + " s");
    }
    function setClicks(c)
    {
        clicksText.text = qsTr("Clicks: " + c);
    }

    Text {
        id: timeText
        color: "#ffffff"
        text: qsTr("Time: ")
        styleColor: "#ffffff"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        anchors.topMargin: toolbar.height*0.05
        anchors.leftMargin: toolbar.height*0.02
        anchors.top: toolbar.top
        anchors.right: toolbar.right
        anchors.left: toolbar.left
        font.pixelSize: toolbar.width * 0.14
    }

    Text {
        id: clicksText
        color: "#ffffff"
        text: qsTr("Clicks: ")
        styleColor: "#ffffff"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        anchors.topMargin: toolbar.height*0.05
        anchors.leftMargin: toolbar.height*0.02
        anchors.top: timeText.bottom
        anchors.right: toolbar.right
        anchors.left: toolbar.left
        font.pixelSize: toolbar.width * 0.14
    }

    Rectangle
    {
        id: startButton
        anchors.bottom: toolbar.bottom
        anchors.right: toolbar.right
        anchors.left: toolbar.left
        anchors.margins: toolbar.height*0.05
        anchors.bottomMargin: toolbar.height*0.02
        height: toolbar.height * 0.1
        color: "transparent"
        radius: 6
        Text {
            id: startText
            anchors.fill: parent
            color: "#987621"
            text: qsTr("Start")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: toolbar.width * 0.14
        }
        MouseArea {
            anchors.fill: parent
            onPressed: startButton.color = "#778899"
            onReleased: startButton.color = "transparent"
            onClicked: game.startNewGame()
        }
    }
}
