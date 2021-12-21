firstPlayerStart = 4
secondPlayerStart = 7

# PART 1
recalculatedP1 = firstPlayerStart - 1
recalculatedP2 = secondPlayerStart - 1
roll = -1
p1Points = 0
p2Points = 0
turnNumber = 0

loop
  turnNumber++
  roll = (roll+3) % 10
  move = (3*roll) % 10
  if turnNumber % 2 == 1
    recalculatedP1 = (recalculatedP1 + move) % 10
    p1Points += (recalculatedP1 + 1)
    if(p1Points >= 1000)
      console.log "Part 1: #{3*turnNumber*p2Points}"
      break
  if turnNumber % 2 == 0
    recalculatedP2 = (recalculatedP2 + move) % 10
    p2Points += (recalculatedP2 + 1)
    if(p2Points >= 1000)
      console.log "Part 1: #{3*turnNumber*p1Points}"
      break

# PART 2
numberOfUniversesPerStep = [0, 0, 0, 1, 3, 6, 7, 6, 3, 1]
p1Wins = 0
p2Wins = 0

playTurn = (p1Turn, p1Score, p2Score, p1Field, p2Field, paths) -> 
  if p1Score >= 21
    p1Wins += paths
  else if p2Score >= 21
    p2Wins += paths
  else
    for m in [3..9]
      if p1Turn
        n = (p1Field+m) % 10
        newField = if n == 0 then 10 else n
        playTurn(false, p1Score + newField, p2Score, newField, p2Field, paths * numberOfUniversesPerStep[m])
      else
        n = (p2Field+m) % 10
        newField = if n == 0 then 10 else n
        playTurn(true, p1Score, p2Score + newField, p1Field, newField, paths * numberOfUniversesPerStep[m])

playTurn(true, 0, 0, firstPlayerStart, secondPlayerStart, 1)
console.log "Part 2: #{Math.max(p1Wins, p2Wins)}"
