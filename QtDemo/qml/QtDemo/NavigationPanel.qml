import QtQuick 2.0

Column{
    Button {
        label: "<"
        color: "#aaaaaa"
        onClicked: {
            canvas.angle+=10
        }
    }

    Button {
        label: ">"
        color: "#aaaaaa"
        onClicked: {
            canvas.angle-=10
        }
    }

    Button {
        label: "+"
        color: "#aaaaaa"
        onClicked: {
            canvas.scalingFactor+=.1
        }
    }

    Button {
        label: "-"
        color: "#aaaaaa"
        onClicked: {
            if (canvas.scalingFactor > .1) canvas.scalingFactor-=.1
        }
    }
}
