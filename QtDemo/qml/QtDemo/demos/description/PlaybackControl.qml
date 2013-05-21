
import QtQuick 2.0

Row {
    id: root
    spacing: controlBar.margin

    property bool isPlaybackEnabled: false
    property bool isPlaying: false

    signal forwardButtonPressed()
    signal reverseButtonPressed()
    signal playButtonPressed()
    signal stopButtonPressed()

    //Playback Controls
    ImageButton {
        id: rateReverseButton
        enabled: isPlaybackEnabled
        imageSource: "images/RateButtonReverse.png"
        anchors.verticalCenter: root.verticalCenter

        onClicked: {
            reverseButtonPressed();
        }
    }
    ImageButton {
        id: stopButton
        enabled: isPlaybackEnabled
        imageSource: "images/StopButton.png"
        anchors.verticalCenter: root.verticalCenter
        onClicked: {
            stopButtonPressed();
        }
    }
    ImageButton {
        id: playButton
        enabled: isPlaybackEnabled
        imageSource: !isPlaying ? "images/PlayButton.png" : "images/PauseButton.png"
        anchors.verticalCenter: root.verticalCenter
        onClicked: {
            playButtonPressed();
        }
    }

    ImageButton {
        id: rateForwardButton
        enabled: isPlaybackEnabled
        imageSource: "images/RateButtonForward.png"
        anchors.verticalCenter: root.verticalCenter
        onClicked: {
            forwardButtonPressed();
        }
    }
}
