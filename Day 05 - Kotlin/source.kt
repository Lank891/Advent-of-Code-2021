import java.io.File
import kotlin.math.sign

const val boardSize: Int = 1000;

typealias XY = Pair<Int, Int>;
typealias VentPath = Pair<XY, XY>;
typealias Board = Array<Array<Int>>

fun ventPathToString(path: VentPath): String {
    return "Path (${path.first.first}, ${path.first.second}) -> (${path.second.first}, ${path.second.second})"
}

fun printBoard(board: Board) {
    for(y in 0 until boardSize){
        for(x in 0 until boardSize) {
            print("${if (board[x][y] == 0) '.' else board[x][y]} ");
        }
        println();
    }
}

fun isVentPathOblique(path: VentPath): Boolean {
    return path.first.first != path.second.first && path.first.second != path.second.second;
}

fun commaSeparatedNumbersToXY(numbers: String): XY {
    val split: List<Int> = numbers.split(",").map{ str: String -> str.toInt()}
    return Pair(split[0], split[1]);
}

fun inputLineToVentPath(line: String): VentPath {
    val splits: List<String>     = line.split("->").map{ str: String -> str.trim()};
    return Pair(commaSeparatedNumbersToXY(splits[0]), commaSeparatedNumbersToXY(splits[1]));
}

fun addNotObliqueVent(board: Board, path: VentPath) {
    fun getXRange(path: VentPath): IntProgression {
        return if(path.first.first < path.second.first){
            (path.second.first downTo path.first.first)
        } else {
            (path.first.first downTo path.second.first)
        }
    }

    fun getYRange(path: VentPath): IntProgression {
        return if(path.first.second < path.second.second){
            (path.second.second downTo path.first.second)
        } else {
            (path.first.second downTo path.second.second)
        }
    }

    for(x in getXRange(path)) {
        for(y in getYRange(path)) {
            board[x][y]++;
        }
    }
}

fun addObliqueVent(board: Board, path: VentPath) {
    val (left: XY, right: XY) = if (path.first.first < path.second.first) Pair(path.first, path.second) else Pair(path.second, path.first);

    var yVal: Int = left.second;
    val yDiff: Int = -sign((left.second - right.second).toDouble()).toInt();

    for(x in left.first..right.first) {
        board[x][yVal] += 1;
        yVal += yDiff;
    }
}

fun getOverlappedCells(board: Board): Int {
    var sum: Int = 0;
    for(column in board) {
        for(cell in column) {
            if(cell > 1) {
                sum++;
            }
        }
    }
    return sum;
}

fun main(args: Array<String>) {
    val vents: List<VentPath> = File("./input.txt").readLines().map{ str: String -> inputLineToVentPath(str)};
    val (obliqueVents: List<VentPath>, notObliqueVents: List<VentPath>) = vents.partition { vent: VentPath -> isVentPathOblique(vent) };

    /*
    println("---   OBLIQUE VENTS   ---")
    obliqueVents.forEach { vent: VentPath -> println(ventPathToString(vent))};

    println("--- NOT OBLIQUE VENTS ---")
    notObliqueVents.forEach { vent: VentPath -> println(ventPathToString(vent))};
    */

    val board: Board = Array(boardSize) { _ -> Array(boardSize) { _ -> 0 } };

    // Part 1
    notObliqueVents.forEach { vent: VentPath -> addNotObliqueVent(board, vent) };
    println("Part 1 overlapped cells: ${getOverlappedCells(board)}");

    //printBoard(board);

    // Part 2
    obliqueVents.forEach { vent: VentPath -> addObliqueVent(board, vent) };
    println("Part 2 overlapped cells: ${getOverlappedCells(board)}");

    //printBoard(board);
}