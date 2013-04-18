var positions = [{x:700, y:-400, angle: 0, borderColor: "blue", url: "demos/samegame/samegame.qml", device: 0},
        {x:1200, y:-200, angle:5, borderColor: "grey", url: "demos/tweetsearch/tweetsearch.qml", device: 0},
        {x:-700, y:-300, angle: 2, borderColor: "green", url: "demos/calqlatr/Calqlatr.qml", device: 0},
        {x:-1300, y:400, angle: -2, borderColor: "red", url: "demos/particledemo/particledemo.qml", device: 1},
        {x: 900, y: 200, angle: 0, borderColor: "lime", url: "demos/tweetsearch/tweetsearch.qml", device: 0},
        {x:-300, y:-900, angle: 8, borderColor: "black", url: "demos/calqlatr/Calqlatr.qml", device: 0},
        {x: 300, y:-1000, angle: 0, borderColor: "orange", url: "demos/particledemo/particledemo.qml", device: 2},
        {x: 200, y:1100, angle: -8, borderColor: "orange", url: "demos/particledemo/particledemo.qml", device: 3},

        {x: -1300, y:1100, angle: 3, borderColor: "orange", url: "demos/boot/BootScreen.qml", device: 2},
        {x: 1500, y:800, angle: -3, borderColor: "orange", url: "demos/boot/BootScreen.qml", device: 2},
        {x: 1500, y:-1100, angle: -3, borderColor: "red", url: "demos/particledemo/particledemo.qml", device: 1},
        {x: 2000, y: 0, angle: 5, borderColor: "red", url: "demos/photosurface/photosurface.qml", device: 1},
        {x: -1700, y: -900, angle: 3, borderColor: "orange", url: "demos/particledemo/particledemo.qml", device: 3},

        {x:-2200, y:200, angle: -5, borderColor: "blue", url: "demos/samegame/samegame.qml", device: 0}
        ]

var order = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
var currentOrderIndex = 0

var currentDemoId = -1
var objects = []

function initSlides(){
    positions.forEach(function(pos){
        createNew(pos.x,pos.y,pos.angle, pos.borderColor, pos.url, pos.device)
    })
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
    object.rotation = angle
    object.uid = objects.length+1
    object.borderColor = borderColor
    object.x = x-object.width/2
    object.y = y-object.height/2


    if (url){
        object.url = url;
        //object.loadDemo() //loads demo app to slide
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
        return {"x": positions[idx].x, "y":  positions[idx].y, "angle": positions[idx].angle, "targetScale": objects[idx].targetScale}
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
    var xscale = destWidth / sourceWidth;
    var yscale = destHeight / sourceHeight;

    var scale = Math.max(xscale, yscale);
    if (sourceWidth > destWidth || sourceHeight > destHeight)
        scale = Math.min(xscale,yscale);

    return scale;
}

function updateObjectScales(destWidth, destHeight)
{
    for (var i=0; i<objects.length; i++)
        objects[i].targetScale = scaleToBox(destWidth, destHeight, objects[i].width*objects[i].scale, objects[i].height*objects[i].scale);
}
