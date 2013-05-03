import QtQuick 2.0

Column{

    function rotateButtons(angle)
    {
        prevButton.rotation = angle
        nextButton.rotation = angle
        homeButton.rotation = angle
    }

    Button {
        id: nextButton
        imageSource: "images/btn_next.svg"
        onClicked: canvas.goNext()
    }

    Button {
        id: prevButton
        imageSource: "images/btn_previous.svg"
        onClicked: canvas.goPrevious()
    }

    Button {
        id: homeButton
        imageSource: "images/btn_home.svg"
        onClicked: canvas.goHome()
    }

}
