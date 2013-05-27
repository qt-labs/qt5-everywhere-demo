import QtQuick 2.0

Grid {
    id: root

    function checkOrientation() {
        root.spacing = (app.height + app.width) * 0.02

        if (app.width >= app.height) {
            root.columns = 1
            root.anchors.bottom = undefined
            root.anchors.horizontalCenter = undefined
            root.anchors.right = app.right
            root.anchors.verticalCenter = app.verticalCenter
            root.anchors.rightMargin = app.width * 0.02
            root.anchors.bottomMargin = 0
        }
        else {
            root.columns = 3
            root.anchors.right = undefined
            root.anchors.verticalCenter = undefined
            root.anchors.bottom = app.bottom
            root.anchors.horizontalCenter = app.horizontalCenter
            root.anchors.rightMargin = 0
            root.anchors.bottomMargin = app.width * 0.02
        }
    }

    Button {
        id: nextButton
        imageSource: "images/btn_next.png"
        onClicked: canvas.goNext()
    }

    Button {
        id: prevButton
        imageSource: "images/btn_previous.png"
        onClicked: canvas.goPrevious()
    }

    Button {
        id: homeButton
        imageSource: "images/btn_home.png"
        onClicked: canvas.goHome()
    }
}
