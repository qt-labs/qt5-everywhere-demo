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
            if (item) {
                if (item.objectName === 'slide')
                    target = app.selectTarget(item.uid)
                else if (item.objectName === 'group')
                    target = app.selectGroup(item.uid)
            }

            // If we found target, go to the target
            if (target) {
                canvas.goTo(target, false, item.objectName === 'slide' ? 2 : 1)
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
            app.navigationState = 3 //dirty
        }
    }
    onWheel: {
        var newScalingFactor = canvas.scalingFactor
        if (wheel.angleDelta.y > 0){
            newScalingFactor+=canvas.scalingFactor*.05
        }else{
            newScalingFactor-=canvas.scalingFactor*.05
        }
        if (newScalingFactor < app.minScaleFactor) newScalingFactor = app.minScaleFactor
        if (newScalingFactor > app.maxScaleFactor) newScalingFactor = app.maxScaleFactor
        canvas.scalingFactor = newScalingFactor
    }
}
