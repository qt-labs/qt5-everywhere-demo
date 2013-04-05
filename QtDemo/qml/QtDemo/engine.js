var positions = [{x:1300, y:-500, angle: 0, borderColor: "blue", scale: .6, url: "demos/calqlatr/Calqlatr.qml", device: 0},
        {x:-1200, y:200, angle:0, borderColor: "grey", scale: .6, url: "demos/tweetsearch/tweetsearch.qml", device: 0},
        {x:-1600, y:-1300, angle: 0, borderColor: "green", scale: .6, url: "demos/samegame/samegame.qml", device: 0},
        {x:-1300, y:1500, angle: 0, borderColor: "red", scale: 1.4, url: "demos/particledemo/particledemo.qml", device: 1},
        {x: 1700, y: 1100, angle:0, borderColor: "lime", scale: .6, url: "demos/calqlatr/Calqlatr.qml", device: 0},
        {x:50, y:-1500, angle: 0, borderColor: "black", scale: .6, url: "demos/tweetsearch/tweetsearch.qml", device: 0},
        {x: 1200, y:-1600, angle: 0, borderColor: "orange", scale: .8, url: "demos/particledemo/particledemo.qml", device: 2},
        {x: 500, y:1400, angle: 0, borderColor: "orange", scale: 2, url: "demos/particledemo/particledemo.qml", device: 3}
        ]

var objects = []

function initSlides(){
    positions.forEach(function(pos){
        createNew(pos.x,pos.y,pos.angle, pos.borderColor, pos.scale, pos.url, pos.device)
    })
}

function createNew(x,y,angle,borderColor,scale,url,device){
    var component = Qt.createComponent("Slide.qml")
    if (component.status === Component.Ready)
    var object=component.createObject(canvas)
    object.x = x-object.width/2
    object.y = y-object.height/2
    object.rotation = angle
    object.scale = scale
    object.uid = objects.length+1 //TODO make unique
                                  //in future objects will also
                                  //get destroyed and re-created
    object.borderColor = borderColor
    object.device = device


    if (url){
        object.url = url;
        //object.loadDemo() //loads demo app to slide
    }
    objects.push(object)
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
            objects[idx].loadDemo();
            return {"x": positions[idx].x, "y":  positions[idx].y, "angle": positions[idx].angle, "scale": positions[idx].scale}
        }

    //randomly select new target for now
    idx = Math.floor(Math.random()*positions.length)
    objects[idx].loadDemo();
    return {"x": positions[idx].x, "y":  positions[idx].y, "angle": positions[idx].angle, "scale": positions[idx].scale}
}
