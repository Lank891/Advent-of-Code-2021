import { readFileSync } from 'fs';
import { cloneDeep } from 'lodash';


const file : string = readFileSync('./input.txt', 'utf-8');
const lines : string[] = file.split(/\s+/);

interface regularNumber {
    value: number;
    depth: number;
}

type snailfishNumber = regularNumber[]

function readSnailfishNumber(inputLine: string): snailfishNumber {
    let number: snailfishNumber = [];
    let depth: number = 0;
    for(let i = 0; i < inputLine.length; i++) {
        switch(inputLine[i]) {
            case '[':
                depth++;
                break;
            case ']':
                depth--;
                break;
            case ',':
                break;
            default:
                number.push({depth: depth, value: parseInt(inputLine[i])});
        }
    }
    return number;
}

function snailfishNumberToStringInternal(number: snailfishNumber, depth: number = 0): string {
    let result: string = "";
    if(number.length == 0)
        return result;

    if(number[0].depth == depth) {
        result += number[0].value;
        number.splice(0, 1);
    } else {
        result += "[";
        result += snailfishNumberToStringInternal(number, depth + 1);
        result += " ";
        result += snailfishNumberToStringInternal(number, depth + 1);
        result += "]";
    }
    return result;
}

function snailfishNumberToString(number: snailfishNumber): string {
    return snailfishNumberToStringInternal(cloneDeep(number));
}

function snailfishNumberMagnitudeInternal(number: snailfishNumber, depth: number = 0): number {
    let result: number = 0;
    if(number.length == 0)
        return result;

    if(number[0].depth == depth) {
        result += number[0].value;
        number.splice(0, 1);
    } else {
        result += 3 * snailfishNumberMagnitudeInternal(number, depth + 1);
        result += 2 * snailfishNumberMagnitudeInternal(number, depth + 1);
    }

    return result;
}

function snailfishNumberMagnitude(number: snailfishNumber): number {
    return snailfishNumberMagnitudeInternal(cloneDeep(number));
}

function addSnailfishNumbers(n1: snailfishNumber, n2: snailfishNumber): snailfishNumber {
    return n1.concat(n2).map((v) => {return {value: v.value, depth: v.depth+1}});
}

// False if no explosion was required, true if it was performed
function explodeSnailfishNumber(number: snailfishNumber): boolean {
    let explodeIndex = number.findIndex((v) => v.depth == 5);
    if(explodeIndex == -1)
        return false;

    if(explodeIndex != 0) {
        number[explodeIndex - 1].value += number[explodeIndex].value;
    }
    if(explodeIndex + 2 < number.length) {
        number[explodeIndex + 2].value += number[explodeIndex + 1].value;
    }

    number.splice(explodeIndex, 2);
    number.splice(explodeIndex, 0, {depth: 4, value: 0});
    return true;
}

// Fale if no split was required, true if it was performed
function splitSnailfishNumber(number: snailfishNumber): boolean {
    let splitIndex = number.findIndex((v) => v.value >= 10);
    if(splitIndex == -1)
        return false;
    let lvalue: number = Math.floor(number[splitIndex].value / 2);
    let rvalue: number = Math.ceil(number[splitIndex].value / 2);
    let newDepth: number = number[splitIndex].depth + 1;

    number.splice(splitIndex, 1, {depth: newDepth, value: rvalue});
    number.splice(splitIndex, 0, {depth: newDepth, value: lvalue});

    return true;
}

function reduceSnailfishNumber(number: snailfishNumber) {
    while(true) {
        while(explodeSnailfishNumber(number));
        if(!splitSnailfishNumber(number))
            return;
    }
}

let allNumbers: snailfishNumber[] = lines.map(line => readSnailfishNumber(line));

let n: snailfishNumber = allNumbers[0];
for(let i = 1; i < lines.length; i++) {
    n = addSnailfishNumbers(n, readSnailfishNumber(lines[i]));
    reduceSnailfishNumber(n);
    //console.log(snailfishNumberToString(n));
}

console.log(`Part 1: ${snailfishNumberMagnitude(n)}`);

let crossMagnitudes: number[] = [];
for(let i = 0; i < allNumbers.length; i++) {
    for(let j = 0; j <allNumbers.length; j++) {
        let crossAdded: snailfishNumber = addSnailfishNumbers(allNumbers[i], allNumbers[j]);
        reduceSnailfishNumber(crossAdded);
        crossMagnitudes.push(snailfishNumberMagnitude(crossAdded));
    }
}

console.log(`Part 2: ${Math.max.apply(null, crossMagnitudes)}`);