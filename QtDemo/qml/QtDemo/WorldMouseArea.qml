import QtQuick 2.0

MouseArea{
    id: worldMouseArea
    anchors.fill: parent

    property int oldX: 0
    property int oldY: 0
    property int startMouseX: 0
    property int startMouseY: 0
    property bool panning: false

    onReleased: {
        var dx = mouse.x - startMouseX;
        var dy = mouse.y - startMouseY;

        // Check the point only if we didn't move the mouse too much
        if (!mouse.wasHeld && Math.abs(dx) <= app.tapLimitX && Math.abs(dy) <= app.tapLimitY)
        {
            panning = false
            var target = null;
            var object = mapToItem(canvas, mouse.x, mouse.y)
            var item = canvas.childAt(object.x,object.y)
            if (item && item.objectName === 'slide') {
                target = app.selectTarget(item.uid)
            }

            // If we found target, go to the target
            if (target) {
                canvas.goTo(target)
                zoomAnimation.restart()
            }
            else // If not target under mouse -> go home
                canvas.goHome()
        }
    }

    onPressed: {
        // Save mouse state
        oldX = mouse.x
        oldY = mouse.y
        startMouseX = mouse.x
        startMouseY = mouse.y
    }

    onPositionChanged: {
        var dx = mouse.x - oldX;
        var dy = mouse.y - oldY;

        oldX = mouse.x;
        oldY = mouse.y;

        if (!zoomAnimation.running && !navigationAnimation.running)
        {
            panning = true;
            canvas.xOffset += dx;
            canvas.yOffset += dy;
        }
    }

}
