var heartData = [0,0,0,0,0]

function fillHeartData(length) {
    if (length !== heartData.length) {
        heartData = new Array(length);
        for (var i=0; i<length; i++) {
            heartData[i] = 0;
        }
    }
}
