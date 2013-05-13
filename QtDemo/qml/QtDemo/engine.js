var positions = [{x:-100, y:-850, angle: 0, url: "demos/calqlatr/Calqlatr.qml", device: 0, name: "Calqlatr"},
                 {x:700, y:-900, angle: 0, url: "demos/samegame/samegame.qml", device: 1, name: "SameGame"},
                 {x:1400, y:-500, angle:0, url: "demos/tweetsearch/tweetsearch.qml", device: 2, name: "TweetSearch"},
                 {x:-1200, y:-600, angle: 0, url: "demos/canvasclock/canvasClock.qml", device: 4, name: "Canvas clock"},
                 {x:-1900, y:0, angle: 0, url: "demos/rssnews/rssnews.qml", device: 3, name: "Rss Reader"},
                 {x:1700, y:200, angle: 0, url: "demos/boot/BootScreen.qml", device: 4, name: "Particles"},
                 {x:-2000, y:800, angle: 0, url: "demos/slidepuzzle/slidepuzzle.qml", device: 5, name: "Slide puzzle"},
                 {x:1600, y:1100, angle: 0, url: "demos/particledemo/particledemo.qml", device: 6, name: "Multitouch"},
                 {x:1100, y:2000, angle: 0, url: "demos/photosurface/photosurface.qml", device: 7, name: "Photo surface"},
                 {x:-1100, y:1700, angle: 0, url: "demos/shaders/main.qml", device: 7, name: "Shaders"}]

var imageSources = ["phone1.svg","phone2.svg", "phone3.svg","tablet1.svg", "medical_device.svg", "laptop1.svg", "laptop2.svg", "tv.svg"]
var widths = [358, 361, 366, 758, 600, 888, 888, 708]
var heights = [723, 707, 721, 565, 489, 513, 513, 565]
var scales = [0.6, 0.6, 0.6, 1.0, 1.2, 1.2, 1.2, 1.5]
var demoWidths = [322, 322, 322, 642, 482, 642, 642, 642]
var demoHeights = [482, 482, 482, 402, 322, 402, 402, 402]
var maskHorizontalOffsets = [1, 1, 1, 1, 1, 1, 1, 1]
var maskVerticalOffsets = [26, 32, 15, 24, 45, 33, 33, 49]
var targetAngles = [-90, -90, 0, 0, 0, 0, 0, 0]

var currentDemoId = -1
var objects = []

function initSlides(){
    positions.forEach(function(pos){
        createNew(pos.x,pos.y,pos.angle, pos.url, pos.device, pos.name)
    })
}

function createNew(x,y,angle,url,device,name){
    var component = Qt.createComponent("Slide.qml")
    if (component.status === Component.Ready){
        var object=component.createObject(canvas)
        object.device = device
        object.imageSource = "images/" + imageSources[device]
        object.width = widths[device]
        object.height = heights[device]
        object.scale = scales[device]
        object.demoWidth = demoWidths[device]
        object.demoHeight = demoHeights[device]
        object.maskVerticalOffset = maskVerticalOffsets[device]
        object.maskHorizontalOffset = maskHorizontalOffsets[device]
        object.targetAngle = targetAngles[device]
        object.rotation = angle
        object.uid = objects.length
        object.name = name
        object.x = x-object.width/2
        object.y = y-object.height/2
        object.createElements();

        if (url){
            object.url = url;
        }
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
