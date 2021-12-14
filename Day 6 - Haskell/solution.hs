import System.IO

inputFile = "./input.txt"
maxDay = 8
newCycleDay = 6
lastDayPart1 = 80
lastDayPart2 = 256

wordsWhen :: (Char -> Bool) -> String -> [String]
wordsWhen p s = case dropWhile p s of
    "" -> []
    s' -> w : wordsWhen p s''
        where (w, s'') = break p s'

stringToIntList :: String -> [Int]
stringToIntList = map (read::String->Int) . wordsWhen (== ',')

countOccursInList :: [Int] -> Int -> Int
countOccursInList xs x = (length . filter (== x)) xs

countElemsInList :: [Int] -> [Int] -> [Int]
countElemsInList base vals = map (countOccursInList vals) base

countIntsInString :: [Int] -> String -> [Int]
countIntsInString base s = countElemsInList base $ stringToIntList s

leftRotate :: Int -> [Int] -> [Int]
leftRotate _ [] = []
leftRotate n xs = zipWith const (drop n (cycle xs)) xs

addNumberToListAtElem :: Int -> Int -> [Int] -> [Int]
addNumberToListAtElem val index list = zipWith (\x i -> if i == index then x + val else x) list [0..]

performCycle :: [Int] -> [Int]
performCycle xs = addNumberToListAtElem (head xs) newCycleDay $ leftRotate 1 xs

performInfiniteCycles :: [Int] -> [[Int]]
performInfiniteCycles = iterate performCycle

main = do
    handle <- openFile inputFile ReadMode
    contents <- hGetContents handle
    let simulation = map sum $ performInfiniteCycles $ countIntsInString [0..maxDay] contents
    putStrLn "Part 1: "
    print $ last $ take (lastDayPart1 + 1) simulation
    putStrLn "Part 2: "
    print $ last $ take (lastDayPart2 + 1) simulation
    hClose handle