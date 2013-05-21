import QtQuick 2.0
import QtMultimedia 5.0

Rectangle {
    id: controlBar
    height: parent.height * 0.2
    color: "#88333333"

    property MediaPlayer mediaPlayer: null
    property bool isMouseAbove: false
    property int margin: parent.width * 0.01
    property double playBackHeight: height*0.48
    property double seekHeight: height*0.48

    signal openURL()

    state: "VISIBLE"

    onMediaPlayerChanged: {
        if (mediaPlayer === null)
            return;
        volumeControl.volume = mediaPlayer.volume;
    }

    function updateStatusText()
    {
        var strText = ""
        switch (mediaPlayer.status) {
            case MediaPlayer.NoMedia: strText = "No Media"; break;
            case MediaPlayer.Loading: strText = "Loading..."; break;
            case MediaPlayer.Buffering: strText = "Buffering..."; break;
            case MediaPlayer.Stalled: strText = "Stalled"; break;
            case MediaPlayer.EndOfMedia: strText = "EndOfMedia"; break;
            case MediaPlayer.InvalidMedia: strText = "InvalidMedia"; break;
            case MediaPlayer.UnknownStatus: strText = "UnknownStatus"; break;
            default: strText = ""; break;
        }

        statusText.text = strText;
    }

    VolumeControl {
        id: volumeControl
        anchors.verticalCenter: playbackControl.verticalCenter
        anchors.left: controlBar.left
        anchors.leftMargin: controlBar.margin
        height: controlBar.playBackHeight
        width: parent.width * 0.3
        onVolumeChanged: {
            if (mediaPlayer !== null)
                mediaPlayer.volume = volume
        }

        Connections {
            target: mediaPlayer
            onVolumeChanged: volumeControl.volume = mediaPlayer.volume
        }
    }

    //Playback Controls
    PlaybackControl {
        id: playbackControl
        anchors.horizontalCenter: controlBar.horizontalCenter
        anchors.top: controlBar.top
        anchors.topMargin: controlBar.margin
        height: controlBar.playBackHeight

        onPlayButtonPressed: {
            if (mediaPlayer === null)
                return;

            if (isPlaying) {
                mediaPlayer.pause();
            } else {
                mediaPlayer.play();
            }
        }

        onReverseButtonPressed: {
            if (mediaPlayer === null)
                return;

            if (mediaPlayer.seekable) {
                //Subtract 10 %
                mediaPlayer.seek(normalizeSeek(Math.round(-mediaPlayer.duration * 0.1)));
            }
        }

        onForwardButtonPressed: {
            if (mediaPlayer === null)
                return;

            if (mediaPlayer.seekable) {
                //Add 10 %
                mediaPlayer.seek(normalizeSeek(Math.round(mediaPlayer.duration * 0.1)));
            }
        }

        onStopButtonPressed: {
            if (mediaPlayer !== null)
                mediaPlayer.stop();

            videoSelector.show();
        }
    }

    Text {
        id: statusText
        anchors.right: parent.right
        anchors.verticalCenter: playbackControl.verticalCenter
        anchors.rightMargin: controlBar.margin
        verticalAlignment: Text.AlignVCenter
        height: controlBar.playBackHeight
        font.pixelSize: playbackControl.height * 0.5
        color: "white"
    }

    //Seek controls
    SeekControl {
        id: seekControl
        anchors.bottom: controlBar.bottom
        anchors.right: controlBar.right
        anchors.left: controlBar.left
        height: controlBar.seekHeight
        anchors.leftMargin: controlBar.margin
        anchors.rightMargin: controlBar.margin

        enabled: playbackControl.isPlaybackEnabled
        duration: mediaPlayer !== null ? mediaPlayer.duration : 0

        onSeekValueChanged: {
            if (mediaPlayer !== null) {
                mediaPlayer.seek(newPosition);
                position = mediaPlayer.position;
            }
        }

        Component.onCompleted: {
            if (mediaPlayer !== null)
                seekable = mediaPlayer.seekable;
        }
    }

    Connections {
        target: mediaPlayer
        onPositionChanged: {
            if (!seekControl.pressed) seekControl.position = mediaPlayer.position;
        }
        onStatusChanged: {
            if ((mediaPlayer.status == MediaPlayer.Loaded) || (mediaPlayer.status == MediaPlayer.Buffered) || mediaPlayer.status === MediaPlayer.Buffering || mediaPlayer.status === MediaPlayer.EndOfMedia)
                playbackControl.isPlaybackEnabled = true;
            else
                playbackControl.isPlaybackEnabled = false;
            updateStatusText();
        }
        onErrorChanged: {
            updateStatusText();
        }

        onPlaybackStateChanged: {
            if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                playbackControl.isPlaying = true;
                applicationWindow.resetTimer();
            } else {
                show();
                playbackControl.isPlaying = false;
            }
        }

        onSeekableChanged: {
            seekControl.seekable = mediaPlayer.seekable;
        }
    }

    //Usage: give the value you wish to modify position,
    //returns a value between 0 and duration
    function normalizeSeek(value) {
        var newPosition = mediaPlayer.position + value;
        if (newPosition < 0)
            newPosition = 0;
        else if (newPosition > mediaPlayer.duration)
            newPosition = mediaPlayer.duration;
        return newPosition;
    }

    function hide() {
        controlBar.state = "HIDDEN";
    }

    function show() {
        controlBar.state = "VISIBLE";
    }

    states: [
        State {
            name: "HIDDEN"
            PropertyChanges {
                target: controlBar
                opacity: 0.0
            }
        },
        State {
            name: "VISIBLE"
            PropertyChanges {
                target: controlBar
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
                target: controlBar
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
                target: controlBar
                properties: "opacity"
                from: 0.95
                to: 0.0
                duration: 200
            }
        }
    ]
}
