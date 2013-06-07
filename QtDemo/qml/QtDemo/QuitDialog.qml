import QtQuick 2.0

Rectangle {
    id: root
    anchors.fill: parent
    color: Qt.rgba(0.0, 0.0, 0.0, 0.7)

    signal yes()
    signal no()

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        id: dialog
        anchors.centerIn: parent
        width: dialogText.paintedWidth * 1.1
        height: parent.height * 0.3
        property double dialogMargin: height * 0.05

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#222222" }
            GradientStop { position: 0.3; color: "#000000" }
            GradientStop { position: 1.0; color: "#111111" }
        }
        radius: 10
        border { color: "#999999"; width: 1 }

        Item {
            id: content
            anchors { left: parent.left; right: parent.right; top: parent.top }
            height: dialog.height * 0.6

            Text {
                id: dialogText
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Are you sure you want to quit?")
                color: "#ffffff"
                font.pixelSize: 0.2 *content.height
            }
        }

        Rectangle {
            id: line
            anchors { left: parent.left; right: parent.right; top: content.bottom }
            anchors.leftMargin: dialog.dialogMargin
            anchors.rightMargin: dialog.dialogMargin
            height: 1
            color: "#777777"
        }

        DialogButton {
            anchors { bottom: dialog.bottom; left:dialog.left; bottomMargin: dialog.dialogMargin; leftMargin: dialog.dialogMargin }
            buttonText: "Yes"
            onClicked: root.yes()
        }
        DialogButton {
            anchors { bottom: dialog.bottom; right:dialog.right; bottomMargin: dialog.dialogMargin; rightMargin: dialog.dialogMargin }
            buttonText: "No"
            onClicked: root.no()
        }

    }

}
