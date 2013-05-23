var positions = [
            {x:-500, y:-1180, url: "demos/rssnews/rssnews.qml", device: 3, name: "Rss Reader"},
            {x:-1550, y:-1040, url: "demos/gridrssnews/main.qml", device: 5, name: "Rss Reader"},
            {x:-1050, y:-800, url: "demos/tweetsearch/tweetsearch.qml", device: 2, name: "TweetSearch"},

            {x:1500, y:-1100, url: "demos/heartmonitor/main.qml", device: 4, name: "Heart Monitor"},
            {x:800, y:-1000, url: "demos/canvasclock/canvasClock.qml", device: 4, name: "Canvas Clock"},

            {x:0, y:0, url: "demos/description/main.qml", device: 7, name: "Qt Description"},

            {x:1300, y:-200, url: "demos/photosurface/photosurface.qml", device: 7, name: "Photo Surface"},
            {x:2000, y:600, url: "demos/particledemo/particledemo.qml", device: 6, name: "Particle Paint"},
            {x:900, y:1000, url: "demos/shaders/main.qml", device: 7, name: "Shaders"},

            {x:-1300, y:0, url: "demos/slidepuzzle/slidepuzzle.qml", device: 5, name: "Slide Puzzle"},
            {x:-1900, y:200, url: "demos/radio/radio.qml", device: 4, name: "Internet Radio"},

            {x:-800, y:900, url: "demos/samegame/samegame.qml", device: 1, name: "SameGame"},
            {x:-1500, y:1100, url: "demos/calqlatr/Calqlatr.qml", device: 0, name: "Calqlatr"}
        ]

var imageSources = ["phone1.png","phone2.png", "phone3.png","tablet1.png", "medical_device.png", "laptop1.png", "laptop2.png", "tv.png"]
var widths = [358, 360, 366, 758, 600, 888, 888, 800]
var heights = [722, 706, 720, 564, 488, 512, 512, 638]
var scales = [0.8, 0.8, 0.6, 0.9, 1.0, 0.9, 0.9, 1.0]
var demoWidths = [322, 322, 322, 642, 482, 642, 642, 726]
var demoHeights = [482, 482, 482, 402, 322, 402, 402, 456]
var maskHorizontalOffsets = [1, 1, 1, 1, 1, 1, 1, 1]
var maskVerticalOffsets = [26, 32, 15, 24, 45, 33, 33, 56]
var targetAngles = [0, 0, 0, 0, 0, 0, 0, 0]

var navigationList = [5,1,2,0,4,3,6,7,8,11,12,10,9]
var currentDemoIndex = -1
var objects = []

function initSlides(){
    positions.forEach(function(pos){
        createNew(pos.x,pos.y, pos.url, pos.device, pos.name)
    })
}

function createNew(x,y,url,device,name){
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
        object.uid = objects.length
        object.name = name
        object.startX = x-object.width/2
        object.startY = y-object.height/2
        object.swing = Math.random()*(objects.length/2)+1
        object.createElements();

        if (url){
            object.url = url;
        }
        objects.push(object)
    }
}

function loadCurrentDemo(){

    // Load current demo and release all others possible running demos
    if (currentDemoIndex != -1) {
        for (var i=0; i < objects.length; i++){
            if (currentDemoIndex == i){
                objects[navigationList[currentDemoIndex]].loadDemo();
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
    currentDemoIndex++;
    if (currentDemoIndex >= objects.length)
        currentDemoIndex = 0;

    return selectTarget(navigationList[currentDemoIndex]);
}

function getPrevious()
{
    currentDemoIndex--;
    if (currentDemoIndex < 0)
        currentDemoIndex = objects.length-1;

    return selectTarget(navigationList[currentDemoIndex]);
}

function selectTarget(uid){

    var idx = -1;

    for (var i=0; i < objects.length; i++){
        if (uid >= 0 && objects[i].uid === uid){
            idx = i;
        } else {
            objects[i].releaseDemo();
        }
    }
    if (idx !== -1){
        currentDemoIndex = navigationList.indexOf(idx)
        return {"x": positions[idx].x,
            "y":  positions[idx].y,
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
