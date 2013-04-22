var positions = [{x:700, y:-400, angle: 0, borderColor: "blue", url: "demos/samegame/samegame.qml", device: 0},
                 {x:1200, y:-200, angle:5, borderColor: "grey", url: "demos/tweetsearch/tweetsearch.qml", device: 0},
                 {x:-700, y:-300, angle: 2, borderColor: "green", url: "demos/calqlatr/Calqlatr.qml", device: 0},
                 {x:-1300, y:400, angle: -2, borderColor: "red", url: "demos/particledemo/particledemo.qml", device: 1},
                 {x: 900, y: 200, angle: 0, borderColor: "lime", url: "demos/tweetsearch/tweetsearch.qml", device: 0},
                 {x:-300, y:-900, angle: 8, borderColor: "black", url: "demos/calqlatr/Calqlatr.qml", device: 0},
                 {x: 300, y:-1000, angle: 0, borderColor: "orange", url: "demos/particledemo/particledemo.qml", device: 2},
                 {x: 200, y:1100, angle: -8, borderColor: "orange", url: "demos/slidepuzzle/slidepuzzle.qml", device: 3},

                 {x: -1300, y:1100, angle: 3, borderColor: "orange", url: "demos/boot/BootScreen.qml", device: 2},
                 {x: 1500, y:800, angle: -3, borderColor: "orange", url: "demos/boot/BootScreen.qml", device: 2},
                 {x: 1500, y:-1100, angle: -3, borderColor: "red", url: "demos/particledemo/particledemo.qml", device: 1},
                 {x: 2000, y: 0, angle: 5, borderColor: "red", url: "demos/photosurface/photosurface.qml", device: 1},
                 {x: -1700, y: -900, angle: 3, borderColor: "orange", url: "demos/particledemo/particledemo.qml", device: 3},

                 {x:-2200, y:200, angle: -5, borderColor: "blue", url: "demos/samegame/samegame.qml", device: 0}
        ]
var widths = [375, 838, 840, 867]
var heights = [835, 589, 763, 520]
var scales = [0.6, 1.4, 0.8, 2]
var maskWidths = [375, 900, 840, 867]
var maskHeights = [835, 661, 763, 520]
var demoWidths = [321, 735, 688, 603]
var demoHeights = [481, 460, 462, 378]
var maskVerticalOffsets = [44, 37, 91, 51]
var maskHorizontalOffsets = [-2, -5, 0, 1]
var targetAngles = [-90, 0, 0, 0]

var currentDemoId = -1
var objects = []

function initSlides(){
    positions.forEach(function(pos){
        createNew(pos.x,pos.y,pos.angle, pos.borderColor, pos.url, pos.device)
    })
}

function slideCount()
{
    return positions.length;
}

function showBootScreen(scale){
    print ("Show BootScreen")
    var component = Qt.createComponent("demos/boot/BootScreen.qml")
    print ("component on: "+component)

    if (component.status === Component.Ready){
        print ("ready!!!")
        component.createObject(app)
    }
}

function createNew(x,y,angle,borderColor,url,device){
    var component = Qt.createComponent("Slide.qml")
    if (component.status === Component.Ready){
        var object=component.createObject(canvas)
        object.device = device
        object.width = widths[device]
        object.height = heights[device]
        object.scale = scales[device]
        object.maskWidth = maskWidths[device]
        object.maskHeight = maskHeights[device]
        object.demoWidth = demoWidths[device]
        object.demoHeight = demoHeights[device]
        object.maskVerticalOffset = maskVerticalOffsets[device]
        object.maskHorizontalOffset = maskHorizontalOffsets[device]
        object.rotation = angle
        object.uid = objects.length+1
        object.borderColor = borderColor
        object.x = x-object.width/2
        object.y = y-object.height/2

        if (url){
            object.url = url;
        }
        print ("object.url: "+object.url)
        objects.push(object)
    }
}

function lookForSlides(x,y,angle){
    //find next slide to fly into from the given position and direction

    for (var idx=0; idx < positions.length; idx++){

        //TODO: improve heurestics by adding also distance here

        var a=positions[idx].y-y
        var b=positions[idx].x-x

        var distance = Math.sqrt(a*a+b*b)

        var angleBetween = Math.atan2(a,b)*57.2957795
        var diff = Math.abs(angle-angleBetween)

        if (distance > 100 && diff < 20) {
            return selectTarget(positions[idx].uid);
        }
    }
    return selectTarget(null) //random
}

function loadCurrentDemo(){

    // Load current demo and release all others possible running demos
    if (currentDemoId != -1) {
        for (var i=0; i < objects.length; i++){
            if (currentDemoId == i){
                objects[currentDemoId].loadDemo();
            }
            else {
                objects[i].releaseDemo();
            }
        }
    }
}

function releaseDemos()
{
    for (var i=0; i < objects.length; i++)
        objects[i].releaseDemo();
}

function selectTarget(uid){

    var idx = -1;

    for (var i=0; i < objects.length; i++){
        if (uid && objects[i].uid === uid){
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
        var w2 = objects[i].width/2*scale;
        var h2 = objects[i].height/2*scale;
        var left = objects[i].x - w2;
        var right = objects[i].x - w2;
        var top = objects[i].y - h2;
        var bottom = objects[i].y + h2;

        if (left < minX)
            minX = left;
        else if (right > maxX)
            maxX = right;

        if (top < minY)
            minY = top;
        else if (bottom > maxY)
            maxY = bottom;
    }

    return {"x": minX, "y": minY, "width": maxX-minX, "height": maxY-minY};
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
