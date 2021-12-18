fs = require('fs');

const file = fs.readFileSync('./input.txt', 'utf-8');
const minSimX = 0
const maxSimX = 5000
const minSimY = -5000
const maxSimY = 5000

const inputInformationRegex = /^.*x=(-?\d+)\.\.(-?\d+).*y=(-?\d+)\.\.(-?\d+)\s*$/i
const inputVals = file.match(inputInformationRegex)
const minX = parseInt(inputVals[1])
const maxX = parseInt(inputVals[2])
const minY = parseInt(inputVals[3])
const maxY = parseInt(inputVals[4])

function simulateForStart(sX, sY) {
    let actualMaxY = 0
    let wasHit = false

    let x = 0
    let y = 0
    //console.log(sX, sY)
    while(!(wasHit || (sY < 0 && y < minY))) {
        x += sX
        y += sY
        //console.log(x, y)
        //console.log(sX, sY)
        if(y > actualMaxY) {
            actualMaxY = y
        }
        sY -= 1
        sX -= Math.sign(sX)
        //console.log(x, minX, maxX, y, minY, maxY)
        if(x >= minX && x <= maxX && y >= minY && y <= maxY) {
            //console.log(x, y)
            wasHit = true
        }
    }
    //console.log(wasHit)
    return {maxY: actualMaxY, hit: wasHit}
}

let foundYs = []

for(let sY = minSimY; sY <= maxSimY; sY++) {
    for(let sX = minSimX; sX <= maxSimX; sX++) {
        const res = simulateForStart(sX, sY)
        if(res.hit) {
            foundYs.push(res.maxY)
        }
    }
}

console.log("Part 1:", Math.max(...foundYs))
console.log("Part 2:", foundYs.length)