import QtQuick 2.0

Rectangle {
    id: root
    width: 40
    height: 40
    border {color: "#333333"; width: 1}
    radius: 20
    smooth: true
    gradient: Gradient{
        GradientStop {position: .0; color: buttonMouseArea.pressed ? "#dddddd" : "#aaaaaa"}
        GradientStop {position: 1.0; color: "#666666"}
    }

    property string label: ""
    signal clicked()

    Text{
        text: root.label
        anchors.centerIn: root
        color: "white"
        font { pixelSize: 26; weight: Font.Bold }
    }

    MouseArea {
        id: buttonMouseArea
        anchors.fill: root
        onClicked: {
            root.clicked()
        }
    }
}
