import QtQuick 2.0

Rectangle {
    id: game
    anchors.fill: parent
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#222222" }
        GradientStop { position: 0.3; color: "#666666" }
        GradientStop { position: 0.8; color: "#444444" }
    }
    property int freeX: 2;
    property int freeY: 2;
    property int time: 0;
    property int clicks: 0;
    property bool gameRunning: false;

    Toolbar { id: toolbar }

    // Game table
    Rectangle {
        id: gameTable
        color: "transparent"
        smooth: true
        anchors.fill: parent
        anchors.centerIn: parent
        anchors.leftMargin: 0.3*parent.width;

        Image {
            id: backgroundImage
            anchors.fill: parent
            source: "images/QtLogo_background.png"
            smooth: true
            opacity: 0.2

            MouseArea {
                anchors.fill: parent
                onPressed: backgroundImage.opacity = 0.5
                onReleased: backgroundImage.opacity = 0.2
            }
        }

        ButtonList { id: buttons; }
        Button {
            index: 8
            posX:2
            posY:2
            visible: !game.gameRunning
            opacity: 1.0
        }
    }

    // Click clock timer
    Timer {
        id: clockTimer
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            toolbar.setElapsedSeconds(++time);
        }
    }

    // Start timer
    Timer {
        id: startTimer
        interval: 10
        running: false
        repeat: false
        onTriggered: game.startGame()
    }

    // Move button to the x,y and set free position
    function moveButton(button, x, y)
    {
        var tempX = button.posX;
        var tempY = button.posY;
        button.posX = x;
        button.posY = y;
        freeX = tempX;
        freeY = tempY;
    }

    function move(button)
    {
        // Move button to the free place
        if (((freeX == button.posX-1 || freeX == button.posX+1) && freeY === button.posY) ||
                ((freeY == button.posY-1 || freeY == button.posY+1) && freeX === button.posX))
        {
            if (game.gameRunning)
                toolbar.setClicks(++clicks);
            moveButton(button, freeX, freeY);
        }
    }

    function buttonWidth() {
        return 0.33*gameTable.width;
    }
    function buttonHeight() {
        return 0.33*gameTable.height;
    }

    // Check if our game is over
    function checkGameOver()
    {
        if (game.gameRunning)
        {
            var startX = buttonWidth()/2;
            var startY = buttonHeight()/2;
            var stepX = buttonWidth();
            var stepY = buttonHeight();
            var index = 0;
            var ready = true;

            // Check if we are ready. Set the ready-flag in the buttons
            // from the start to the first wrong button
            for (var y=0; y<3; y++)
            {
                for (var x=0; x<3; x++)
                {
                    var xx = startX + x*stepX;
                    var yy = startY + y*stepY;
                    var btn = buttons.childAt(xx,yy);
                    if (btn !== null)
                    {
                        ready = ready & index === btn.index;
                        btn.ready = ready;
                    }
                    else if (y != 2 || x != 2)
                    {
                        ready = false;
                    }

                    index++;
                }
            }

            if (ready)
            {
                game.gameRunning = false;
                clockTimer.stop();
                // show particles
            }
        }
    }

    // Here we change buttons position
    function shakeButtons()
    {
        var startX = buttonWidth()/2;
        var startY = buttonHeight()/2;
        var stepX = buttonWidth();
        var stepY = buttonHeight();

        var now = new Date();
        var seed = now.getMilliseconds();

        for (var i=0; i<200; i++)
        {
            seed++;
            var num = (Math.floor(4 * Math.random(seed)));

            var xNew = freeX;
            var yNew = freeY;
            switch (num)
            {
            case 0: xNew = Math.max(0,freeX-1); break; //move left
            case 1: xNew = Math.min(2,freeX+1); break; //move right
            case 2: yNew = Math.max(0,freeY-1); break; //move up
            default: yNew = Math.min(2,freeX+1); break; //move down
            }

            var xx = startX + xNew*stepX;
            var yy = startY + yNew*stepY;
            if (buttons.childAt(xx,yy) !== null)
                game.move(buttons.childAt(xx,yy));
        }

    }

    function startNewGame()
    {
        game.gameRunning = false;
        clockTimer.stop();
        startTimer.start();
    }

    // Start game with shaking buttons
    function startGame()
    {
        // Shake buttons and start new game
        shakeButtons();

        game.gameRunning = true;
        clicks = 0;
        time = 0;
        toolbar.setClicks(0);
        toolbar.setElapsedSeconds(0);
        clockTimer.start();
        checkGameOver();
    }

}
