import QtQuick 2.0

Column{

    Button {
        imageSource: "images/btn_previous.svg"
        onClicked: canvas.goPrevious()
    }

    Button {
        imageSource: "images/btn_next.svg"
        onClicked: canvas.goNext()
    }

    Button {
        imageSource: "images/btn_home.svg"
        onClicked: canvas.goHome()
    }

}
