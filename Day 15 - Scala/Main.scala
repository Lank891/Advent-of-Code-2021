import scala.collection.mutable
import scala.io.Source

object Const {
  val inputFile = "./input.txt"
}

object Util {
  type Row[T] = Array[T]
  type Matrix[T] = Array[Row[T]]

  def printMatrix(matrix: Matrix[Int]): Unit = {
    for(row <- matrix) {
      for(cell <- row) {
        print(f"$cell%4d ")
      }
      println()
    }
  }

  def printMatrix(matrix: Matrix[CellTourInfo]): Unit = {
    for(row <- matrix) {
      for(cell <- row) {
        print(f"${cell.cost}%4d ")
      }
      println()
    }
  }

  def wrapAroundNine(n: Int): Int = {
    var t = n
    while(t > 9)
      t -= 9
    t
  }
}

class CellTourInfo(var x: Int, var y: Int, var cost: Int = Int.MaxValue, var prevX: Int = -1, var prevY: Int = -1) {
  override def toString: String = s"($x, $y): $cost <- ($prevX, $prevY)\n"
}

class Dijkstra(var matrix: Util.Matrix[Int], var xMax: Int, var yMax: Int) {

  def CalculateAllDistances(): Util.Matrix[CellTourInfo] = {
    val costs = Array.ofDim[CellTourInfo](yMax, xMax)
    for(y <- 0 until yMax) {
      for(x <- 0 until xMax) {
        costs(y)(x) = new CellTourInfo(x, y)
      }
    }

    // Note: Priority queue did not work for some reason
    val costQueue = mutable.Queue.empty[CellTourInfo]
    val notCalculated = mutable.HashSet.empty[CellTourInfo]
    for(row <- costs){
      for(cell <- row) {
        costQueue.enqueue(cell)
        notCalculated.add(cell)
      }
    }
    costs(0)(0).cost = 0

    while (costQueue.nonEmpty) {
      costQueue.sortInPlaceWith((c1, c2) => c2.cost > c1.cost)
      val cellInfo = costQueue.dequeue
      notCalculated.remove(cellInfo)

      val neighbours = notCalculated.filter(cell =>
          (cell.x == cellInfo.x-1 && cell.y == cellInfo.y) ||
          (cell.x == cellInfo.x+1 && cell.y == cellInfo.y) ||
          (cell.x == cellInfo.x && cell.y == cellInfo.y-1) ||
          (cell.x == cellInfo.x && cell.y == cellInfo.y+1)
      )

      for(neigh <- neighbours) {
        val alt = cellInfo.cost + matrix(neigh.y)(neigh.x)
        if(alt < costs(neigh.y)(neigh.x).cost){
          costs(neigh.y)(neigh.x).cost = alt
          costs(neigh.y)(neigh.x).prevX = cellInfo.x
          costs(neigh.y)(neigh.x).prevY = cellInfo.y
        }
      }
    }

    costs
  }
}

object Main extends App {
  var t0 = System.nanoTime()

  val fileSource = Source.fromFile(Const.inputFile)
  val lines = fileSource.getLines.toList
  fileSource.close

  val yMax = lines.length
  val xMax = lines.head.length

  val matrix = Array.ofDim[Int](yMax, xMax)


  for(y <- 0 until yMax) {
    val intLine = lines(y).trim.toCharArray.map(c => c - '0')

    for(x <- 0 until xMax) {
      matrix(y)(x) = intLine(x)
    }
  }

  var t1 = System.nanoTime()
  println(s"Parsing: - in ${(t1 - t0)/1000000} ms")

  t0 = System.nanoTime()
  val costs = new Dijkstra(matrix, xMax, yMax).CalculateAllDistances()

  t1 = System.nanoTime()
  println(s"Part 1: ${costs(yMax-1)(xMax-1).cost} in ${(t1 - t0)/1000000} ms")

  t0 = System.nanoTime()
  val yMaxP2 = yMax*5
  val xMaxP2 = xMax*5

  val matrixP2 = Array.ofDim[Int](yMaxP2, xMaxP2)

  for(i <- 0 until 5) {
    for(j <- 0 until 5) {
      for(y <- 0 until yMax) {
        for(x <- 0 until xMax) {
          matrixP2(i*yMax+y)(j*xMax+x) = Util.wrapAroundNine(matrix(y)(x)+i+j)
        }
      }
    }
  }

  t1 = System.nanoTime()
  println(s"Part 2 preparation: - in ${(t1 - t0)/1000000} ms")

  t0 = System.nanoTime()
  val costsP2 = new Dijkstra(matrixP2, xMaxP2, yMaxP2).CalculateAllDistances()

  t1 = System.nanoTime()
  println(s"Part 2: ${costsP2(yMaxP2-1)(yMaxP2-1).cost} in ${(t1 - t0)/1000000} ms")
}
