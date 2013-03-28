var positions = [{x:1300, y:-500, angle:-45, color: "blue", scale: .8},
        {x:-200, y:200, angle:0, color: "grey", scale: 1.2},
        {x:-1500, y:-1000, angle:170, color: "green", scale: .4},
        {x:-1000, y:1000, angle:289, color: "red", scale: .3},
        {x: 1700, y: 100, angle:257, color: "lime", scale: 1},
        {x:50, y:-1500, angle:-45, color: "black", scale: .5}
        ]

var objects = []

function initSlides(){
    positions.forEach(function(pos){
        createNew(pos.x,pos.y,pos.angle, pos.color, pos.scale)
    })
}

function createNew(x,y,angle,color,scale){
    var component = Qt.createComponent("Slide.qml")
    if (component.status === Component.Ready)
    var object=component.createObject(canvas)
    object.x = x-object.width/2
    object.y = y-object.height/2
    object.rotation = angle
    object.color = color
    object.scale = scale
    object.uid = objects.length+1 //TODO make unique
                                  //in future objects will also
                                  //get destroyed and re-created
    objects.push(object)
}

function selectTarget(uid){

    var idx;

    if (uid){
        for (idx=0; idx < objects.length; idx++){
            if (objects[idx].uid === uid){
                return {"x": positions[idx].x, "y":  positions[idx].y, "angle": positions[idx].angle, "scale": positions[idx].scale}
            }
        }
    }

    //randomly select new target for now
    idx = Math.floor(Math.random()*positions.length)
    return {"x": positions[idx].x, "y":  positions[idx].y, "angle": positions[idx].angle, "scale": positions[idx].scale}
}
