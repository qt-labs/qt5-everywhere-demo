/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

var positions = [
            {x:-1100,  y:-1650, gid: 0, url: "demos/rssnews/rssnews.qml", device: 3, name: "Rss Reader"},
            {x:-2100, y:-1550, gid: 0, url: "demos/gridrssnews/main.qml", device: 7, name: "Rss Reader"},

            {x:1300,  y:-1600, gid: 1, url: "demos/canvasclock/canvasClock.qml", device: 4, name: "Canvas\n Clock"},
            {x:2020,  y:-1520, gid: 1, url: "demos/heartmonitor/main.qml", device: 5, name: "  Heart\nMonitor"},

            {x:1000,  y:-300, gid: 2, url: "demos/calqlatr/Calqlatr.qml", device: 0, name: "Calqlatr"},
            {x:-500,  y:-250,  gid: 2, url: "demos/touchgallery/main.qml", device: 2, name: "Widget\nGallery"},
            {x:200,   y:-200, gid: 2, url: "demos/photosurface/photosurface.qml", device: 6, name: " Photo\nSurface"},

            {x:-1800, y:0,   gid: 3, url: "demos/maroon/Maroon.qml", device: 1, name: "Maroon in\n Trouble"},
            {x:-2500, y:100, gid: 3, url: "demos/samegame/samegame.qml", device: 1, name: "SameGame"},

            {x:1200,  y:1200, gid: 5, url: "demos/shaders/main.qml", device: 6, name: "Shaders"},
            {x:2200,  y:1400, gid: 5, url: "demos/particledemo/particledemo.qml", device: 7, name: "Particle\n  Paint"},

            {x:-800,  y:1180, gid: 4, url: "demos/video/main.qml", device: 8, name: "Video"},
            {x:-1600, y:1500, gid: 4, url: "demos/radio/radio.qml", device: 4, name: "Internet\n  Radio"}
        ]

var groupPositions = [
            {x:-2880, y:-2100, width: 2400, height: 1200, textX: 50, textY: 50, name: "Feeds"},
            {x:700, y:-2100, width: 1700, height: 1200, textX: 50, textY: 50, name: "Canvas"},
            {x:-900, y:-800, width: 2650, height: 1300, textX: 50, textY: 50, name: "Applications"},
            {x:-3000, y:-500, width: 1750, height: 1150, textX: 50, textY: 50, name: "Games"},
            {x:-2200, y:850, width: 2050, height: 1150, textX: 50, textY: 150, name: "Multimedia"},
            {x:510, y:600, width: 2450, height: 1500, textX: 50, textY: 50, name: "Particles & Shaders"}
        ]

var imageSources = ["phone1.png","phone2.png", "phone3.png","tablet1.png", "car_device.png", "medical_device.png", "laptop1.png", "laptop2.png", "tv.png"]
var widths = [300, 360, 366, 758, 625, 600, 918, 923, 800]
var heights = [605, 706, 720, 564, 386, 488, 600, 600, 638]
var scales = [0.8, 0.8, 0.6, 0.9, 1.0, 1.0, 0.9, 1.0, 1.0]
var demoWidths = [269, 322, 322, 642, 480, 482, 688, 691, 726]
var demoHeights = [404, 482, 482, 402, 320, 322, 431, 432, 456]
var maskHorizontalOffsets = [1, 1, 1, 1, -52, 1, 1, 1, 1]
var maskVerticalOffsets = [20, 32, 15, 24, 15, 45, 59, 57, 56]
var navigationList = [1,0,2,3,4,6,5,7,8,12,11,9,10]
var groupNavigationList = [0,1,2,3,4,5]
var currentDemoIndex = -1
var currentGroupIndex = -1
var objects = []
var groups = []

function initSlides(){
    positions.forEach(function(pos){
        createSlide(pos.x,pos.y, pos.gid, pos.url, pos.device, pos.name)
    })
}

function createSlide(x,y,gid,url,device,name){
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
        object.uid = objects.length
        object.gid = gid
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

function initGroups(){
    groupPositions.forEach(function(pos){
        createGroup(pos.x, pos.y, pos.width, pos.height, pos.textX, pos.textY, pos.textSource, pos.name)
    })
}

function createGroup(x,y,width,height,textX,textY,textSource,name){
    var component = Qt.createComponent("Group.qml")
    if (component.status === Component.Ready){
        var object=component.createObject(canvas)
        object.uid = groups.length
        object.x = x
        object.y = y
        object.width = width
        object.height = height
        object.textX = textX
        object.textY = textY
        object.name = name

        groups.push(object)
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

function getCurrent()
{
    if (currentDemoIndex < 0 || currentDemoIndex >= objects.length)
        return null;

    return selectTarget(navigationList[currentDemoIndex]);
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
        currentGroupIndex = objects[idx].gid
        return {"x": positions[idx].x,
            "y":  positions[idx].y,
            "targetScale": objects[idx].targetScale,
            "navState": 2}
    }

    return null;
}

function getPosition(idx){
    return {"x": positions[idx].x, "y":  positions[idx].y}
}

function getCurrentGroup()
{
    if (currentGroupIndex < 0 || currentGroupIndex >= groups.length)
        return null;

    return selectGroup(groupNavigationList[currentGroupIndex]);
}

function getNextGroup()
{
    currentGroupIndex++;
    if (currentGroupIndex >= groups.length)
        currentGroupIndex = 0;

    return selectGroup(groupNavigationList[currentGroupIndex]);
}

function getPreviousGroup()
{
    currentGroupIndex--;
    if (currentGroupIndex < 0)
        currentGroupIndex = groups.length-1;

    return selectGroup(groupNavigationList[currentGroupIndex]);
}

function selectGroup(id){

    var idx = -1;

    for (var i=0; i < groups.length; i++){
        if (id >= 0 && groups[i].uid === id){
            idx = i;
            break;
        }
    }

    if (idx !== -1){
        currentGroupIndex = groupNavigationList.indexOf(idx)
        return {"x": groupPositions[idx].x + groupPositions[idx].width/2,
            "y":  groupPositions[idx].y + groupPositions[idx].height/2,
            "targetScale": groups[idx].targetScale,
            "navState": 1}
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

function updateGroupScales(destWidth, destHeight)
{
    for (var i=0; i<groups.length; i++)
        groups[i].targetScale = scaleToBox(destWidth, destHeight, groups[i].width, groups[i].height);
}
