package main

import (
  "fmt"
  "bufio"
  "os"
  "strings"
)

const fileName = "./input.txt"
const firstPartSteps = 10
const secondPartSteps = 40

func printPairsDict(dict *map[string]int) {
  for key, value := range *dict {
    fmt.Println(key, ":", value)
  }
}

type productionResult struct {
  elemOne string
  elemTwo string
}

func makeProductionResult(left string, right string) productionResult {
  return productionResult{left[0:1] + right, right + left[1:2]}
}

func printProductionsDict(dict *map[string]productionResult) {
  for key, value := range *dict {
    fmt.Println("Production:", key, "->", value.elemOne, value.elemTwo)
  }
}

func getDictForFirstInputLine(line string) map[string]int {
  line = strings.TrimSpace(line)

  dict := make(map[string]int)
  for i := 1; i < len(line); i++ {
    dict[line[i-1:i+1]] += 1
  }
  return dict
}

func appendProductionFromLine(line string, dict *map[string]productionResult) {
  left := line[0:2]
  right := line[6:7]
  (*dict)[left] = makeProductionResult(left, right)
}

func countLetters(pairs *map[string]int, firstLetter string, lastLetter string) map[string]int {
  counts := make(map[string]int)

  for key, value := range *pairs {
    counts[key[0:1]] += value
    counts[key[1:2]] += value
  }

  counts[firstLetter] += 1
  counts[lastLetter] += 1

  for key := range counts {
    counts[key] /= 2
  }

  return counts
}

func printLettersCount(dict *map[string]int) {
  for key, value := range *dict {
    fmt.Println(key, ":", value)
  }
}

func performOneStep(pairs *map[string]int, productions *map[string]productionResult) map[string]int {
  dict := make(map[string]int)
  
  for key, value := range *pairs {
    production := (*productions)[key]
    dict[production.elemOne] += value
    dict[production.elemTwo] += value
  }

  return dict
}

func minMax(array []int) (int, int) {
    var max int = array[0]
    var min int = array[0]
    for _, value := range array {
        if max < value {
            max = value
        }
        if min > value {
            min = value
        }
    }
    return min, max
}

func getAnswer(letterCounts *map[string]int) int {
  values := make([]int, 0, len(*letterCounts))
  for _, v := range *letterCounts {
    values = append(values, v)
  }

  min, max := minMax(values)
  return max - min
}

func main() {
  file, _ := os.Open(fileName)
  scanner := bufio.NewScanner(file)

  var pairs map[string]int
  var firstLetter string
  var lastLetter string


  productions := make(map[string]productionResult)
  inputLine := 0

  for scanner.Scan() {
    line := scanner.Text()
    if inputLine == 0 {
      pairs = getDictForFirstInputLine(line)
      firstLetter = line[0:1]
      lastLetter = line[len(line)-1:]
    } else if inputLine > 1 {
      appendProductionFromLine(line, &productions)
    }
    inputLine++
  }

  /*
  fmt.Println(firstLetter, lastLetter)
  printPairsDict(&pairs)
  printProductionsDict(&productions)
  */

  for i := 0; i < firstPartSteps; i++ {
    pairs = performOneStep(&pairs, &productions)
  }
  
  letterCounts := countLetters(&pairs, firstLetter, lastLetter)
  //printLettersCount(&letterCounts)
  result := getAnswer(&letterCounts)
  fmt.Println("Part 1:", result)

  //----

  for i := firstPartSteps; i < secondPartSteps; i++ {
    pairs = performOneStep(&pairs, &productions)
  }

  letterCounts = countLetters(&pairs, firstLetter, lastLetter)
  //printLettersCount(&letterCounts)
  result = getAnswer(&letterCounts)
  fmt.Println("Part 2:", result)
}
