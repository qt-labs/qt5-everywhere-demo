var positions = [{x:1300, y:-500, angle:-45, borderColor: "blue", scale: .7, url: "demos/calqlatr/Calqlatr.qml"},
        {x:-200, y:200, angle:0, borderColor: "grey", scale: .7, url: "demos/tweetsearch/tweetsearch.qml"},
        {x:-1600, y:-1300, angle:170, borderColor: "green", scale: .8, url: "demos/calqlatr/Calqlatr.qml"},
        {x:-1000, y:1500, angle:289, borderColor: "red", scale: .7, url: "demos/tweetsearch/tweetsearch.qml"},
        {x: 1700, y: 1100, angle:270, borderColor: "lime", scale: .8, url: "demos/calqlatr/Calqlatr.qml"},
        {x:50, y:-1500, angle:-45, borderColor: "black", scale: .7, url: "demos/tweetsearch/tweetsearch.qml"}
        ]

var objects = []

function initSlides(){
    positions.forEach(function(pos){
        createNew(pos.x,pos.y,pos.angle, pos.borderColor, pos.scale, pos.url)
    })
}

function createNew(x,y,angle,borderColor,scale,url){
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
    return null; //no match
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
