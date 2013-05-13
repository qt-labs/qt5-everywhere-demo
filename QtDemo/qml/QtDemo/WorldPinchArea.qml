import QtQuick 2.0

PinchArea{
    id: worldPinchArea
    anchors.fill: parent
    pinch.target: pinchProxy
    pinch.minimumScale: app.minScaleFactor
    pinch.maximumScale: app.maxScaleFactor
    pinch.maximumRotation: 360
    pinch.minimumRotation: -360
    enabled: !zoomAnimation.running && !navigationAnimation.running

    property bool pinching: false

    onPinchStarted: {
        pinching = true
        pinchProxy.rotation = canvas.angle
        pinchProxy.scale = canvas.scalingFactor

        if (canvas.scalingFactor>1){
            var object = mapToItem(canvas, pinch.center.x, pinch.center.y)

            canvas.rotationOriginX = object.x
            canvas.rotationOriginY = object.y
        }
    }
    onPinchFinished: pinching = false;
}
