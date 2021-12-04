import { readFileSync } from 'fs';

const file : string = readFileSync('./input.txt', 'utf-8');
const board_size : number = 5;

const lines : string[] = file.split('\n');

const guesses : number[] = lines[0].split(',').map(p => Number(p));

class Board {
    values : [number, boolean][][] = []; //Y is first, X is second
    size : number = 0;

    constructor(lines : string[]) {
        lines.forEach(line => {
            let numbers : [number, boolean][] = line.trim().split(/\s+/).map(p => [Number(p), false]);
            this.values.push(numbers);
        })
        this.size = lines.length;
    }

    markNumber(n : number) : void {
        for (let y = 0; y < this.size; y++) {
            let row = this.values[y];
            for(let x = 0; x < row.length; x++) {
                if(row[x][0] === n) {
                    row[x][1] = true
                }
            }
        }
    }

    bingo() : boolean {
        for(let n = 0; n < this.size; n++) {
            let row_bingo : boolean = true;
            let column_bingo : boolean = true;

            for(let i = 0; i < this.size; i++) {
                if(this.values[n][i][1] === false) {
                    row_bingo = false;
                }
                if(this.values[i][n][1] === false) {
                    column_bingo = false;
                }
            }

            if(row_bingo || column_bingo) {
                return true;
            }
        }
        return false;
    }

    getPoints() : number {
        let sum : number = 0
        for (let y = 0; y < this.size; y++) {
            let row = this.values[y];
            for(let x = 0; x < row.length; x++) {
                if(row[x][1] === false) {
                    sum += row[x][0];
                }
            }
        }
        return sum
    }
}

let boards : (Board | undefined)[] = [];
for(let i = 2; i < lines.length; i += (board_size + 1)) {
    let boardLines : string[] = [];
    for(let j = 0; j < board_size; j++) {
        boardLines.push(lines[i + j]);
    }
    boards.push(new Board(boardLines));
}

let boardThatWonFirst : Board | undefined = undefined;
let boardThatWonLast : Board | undefined = undefined;
let lastNumberThatWonFirst : number = -1;
let lastNumberThatWonLast : number = -1;

for(let i = 0; i < guesses.length; i++) {
    let guess : number = guesses[i];

    for(let j = 0; j < boards.length; j++) {
        if(boards[j] == undefined) {
            continue;
        }

        boards[j].markNumber(guess);

        if(boards[j].bingo()) {

            // Part 1
            if(lastNumberThatWonLast == -1) {
                boardThatWonFirst = boards[j];
                lastNumberThatWonFirst = guess;
            }
            
            // Part 2
            boardThatWonLast = boards[j];
            lastNumberThatWonLast = guess;
            boards[j] = undefined;
        }
    }
}

if(boardThatWonFirst == undefined) {
    console.log("No bingo won (?)");
} else {
    let boardScoreFirst : number = boardThatWonFirst.getPoints();
    let boardScoreLast : number = boardThatWonLast.getPoints();

    console.log("[First board] Final score:\n\tBoard points: " + 
        String(boardScoreFirst) + 
        "\n\tGuess: " + 
        String(lastNumberThatWonFirst) + 
        "\n\tScore: " + 
        String(boardScoreFirst * lastNumberThatWonFirst));

    console.log("[Last board] Final score:\n\tBoard points: " + 
        String(boardScoreLast) + 
        "\n\tGuess: " + 
        String(lastNumberThatWonLast) + 
        "\n\tScore: " + 
        String(boardScoreLast * lastNumberThatWonLast));
}