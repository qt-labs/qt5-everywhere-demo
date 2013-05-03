var positions = [{x:-800, y:-800, angle: 0, borderColor: "green", url: "demos/calqlatr/Calqlatr.qml", device: 0},
                 {x:700, y:-900, angle: 0, borderColor: "blue", url: "demos/samegame/samegame.qml", device: 1},
                 {x:1400, y:-500, angle:5, borderColor: "grey", url: "demos/tweetsearch/tweetsearch.qml", device: 2},
                 {x:-1800, y:-100, angle: -4, borderColor: "orange", url: "demos/rssnews/rssnews.qml", device: 3},
                 {x:1700, y:200, angle: -3, borderColor: "orange", url: "demos/boot/BootScreen.qml", device: 4},
                 {x:-1700, y: 800, angle: 5, borderColor: "red", url: "demos/photosurface/photosurface.qml", device: 5},
                 {x:1600, y:1100, angle: -4, borderColor: "red", url: "demos/particledemo/particledemo.qml", device: 6},
                 {x:-200, y:1600, angle: 3, borderColor: "orange", url: "demos/slidepuzzle/slidepuzzle.qml", device: 7}]

var imageSources = ["phone1","phone2", "phone3","tablet1", "medical_device", "laptop1", "laptop2", "tv"]
var widths = [358, 361, 366, 758, 600, 888, 888, 708]
var heights = [723, 707, 721, 565, 489, 513, 513, 565]
var scales = [0.6, 0.6, 0.6, 0.8, 1.4, 1.4, 1.5, 2]
var demoWidths = [324, 324, 324, 644, 484, 644, 644, 644]
var demoHeights = [484, 484, 484, 404, 324, 404, 404, 404]
var maskHorizontalOffsets = [1, 1, 1, 1, 1, 1, 1, 1]
var maskVerticalOffsets = [27, 33, 16, 25, 46, 34, 34, 50]
var targetAngles = [-90, -90, -90, 0, 0, 0, 0, 0]

var currentDemoId = -1
var objects = []

function initSlides(){
    positions.forEach(function(pos){
        createNew(pos.x,pos.y,pos.angle, pos.borderColor, pos.url, pos.device)
    })
}

function createNew(x,y,angle,borderColor,url,device){
    var component = Qt.createComponent("Slide.qml")
    if (component.status === Component.Ready){
        var object=component.createObject(canvas)
        object.device = device
        object.imageSource = "images/" + imageSources[device] + ".svg"
        object.width = widths[device]
        object.height = heights[device]
        object.scale = scales[device]
        object.demoWidth = demoWidths[device]
        object.demoHeight = demoHeights[device]
        object.maskVerticalOffset = maskVerticalOffsets[device]
        object.maskHorizontalOffset = maskHorizontalOffsets[device]
        object.rotation = angle
        object.uid = objects.length
        object.borderColor = borderColor
        object.x = x-object.width/2
        object.y = y-object.height/2
        object.createElements();

        if (url){
            object.url = url;
        }
        print ("object.url: "+object.url)
        objects.push(object)
    }
}

function loadCurrentDemo(){

    // Load current demo and release all others possible running demos
    if (currentDemoId != -1) {
        for (var i=0; i < objects.length; i++){
            if (currentDemoId == i){
                objects[currentDemoId].loadDemo();
            }
        }
    }
}

function releaseDemos()
{
    for (var i=0; i < objects.length; i++)
        objects[i].releaseDemo();
}

function getNext()
{
    currentDemoId++;
    if (currentDemoId >= objects.length)
        currentDemoId = 0;

    return selectTarget(currentDemoId);
}

function getPrevious()
{
    currentDemoId--;
    if (currentDemoId < 0)
        currentDemoId = objects.length-1;

    return selectTarget(currentDemoId);
}

function selectTarget(uid){

    var idx = -1;

    for (var i=0; i < objects.length; i++){
        if (uid >= 0 && objects[i].uid === uid){
            idx = i
        } else {
            objects[i].releaseDemo();
        }
    }
    if (idx !== -1){
        currentDemoId = idx
        return {"x": positions[idx].x,
            "y":  positions[idx].y,
            "angle": positions[idx].angle,
            "targetScale": objects[idx].targetScale,
            "targetAngle": objects[idx].targetAngle}
    }

    return null;
}

function boundingBox(){
    var minX = 0, maxX = 0, minY = 0, maxY = 0;

    for (var i=0; i<objects.length; i++){
        var scale = objects[i].scale;
        var w2 = objects[i].width/2;
        var h2 = objects[i].height/2;
        var left = (objects[i].x - w2)*scale;
        var right = (objects[i].x + w2)*scale;
        var top = (objects[i].y - h2)*scale;
        var bottom = (objects[i].y + h2)*scale;

        if (left < minX)
            minX = left;
        else if (right > maxX)
            maxX = right;

        if (top < minY)
            minY = top;
        else if (bottom > maxY)
            maxY = bottom;
    }

    return {"x": minX, "y": minY, "width": maxX-minX, "height": maxY-minY, "centerX": (minX+maxX)/2, "centerY": (minY+maxY)/2};
}

function scaleToBox(destWidth, destHeight, sourceWidth, sourceHeight)
{
    return Math.min(destWidth / sourceWidth, destHeight / sourceHeight);
}

function updateObjectScales(destWidth, destHeight)
{
    for (var i=0; i<objects.length; i++)
        objects[i].targetScale = scaleToBox(destWidth, destHeight, objects[i].targetWidth(), objects[i].targetHeight());
}
