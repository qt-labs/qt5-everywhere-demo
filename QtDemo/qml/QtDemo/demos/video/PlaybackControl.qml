
import QtQuick 2.0

Row {
    id: root
    spacing: controlBar.margin

    property bool isPlaybackEnabled: false
    property bool isPlaying: false

    signal playButtonPressed()

    ImageButton {
        id: playButton
        enabled: isPlaybackEnabled
        imageSource: !isPlaying ? "images/PlayButton.png" : "images/PauseButton.png"
        anchors.verticalCenter: root.verticalCenter
        onClicked: {
            playButtonPressed();
        }
    }
}
