import Data.List

main :: IO ()
main =
    print (filter tester1 generator1)

generator1 :: [(Int, Int, Int, Int)]
generator1 = 
  [(hr, mn, dy, mt) 
  | mt <- [1..12],
    dy <- [1..31],
    hr <- [0..23],
    mn <- [0..59],
    validDate dy mt]
    
validDate :: Int -> Int -> Bool
validDate day month
  | month `elem` [1, 3, 5, 7, 8, 10, 12] = day <= 31  
  | month `elem` [4, 6, 9, 11] = day <= 30            
  | month == 2 = day <= 28                            
  | otherwise = False


segments :: [Int]
segments = [6, 2, 5, 5, 4, 5, 6, 3, 7, 6]  -- 0 to 9

prime :: Int -> Bool
prime
    = not . factorisable 2

factorisable :: Int -> Int -> Bool
factorisable f n
    | f * f <= n = n `mod` f == 0 || factorisable (f+1) n
    | otherwise = False

getDigits :: Int -> [Int]
getDigits num
  | num < 10  = [0, num]
  | otherwise = map (\x -> read [x] :: Int) (show num)

calculateSegments :: [Int] -> Int
calculateSegments = sum . map (segments !!)

nextDate :: (Int, Int, Int, Int) -> (Int, Int, Int, Int)
nextDate (hr, mn, dy, mt) 
  | dy == 31 && mt `elem` [1, 3, 5, 7, 8, 10, 12] = (hr, mn, 1, mt + 1)
  | dy == 30 && mt `elem` [4, 6, 9, 11] = (hr, mn, 1, mt + 1)
  | dy == 28 && mt == 2 = (hr, mn, 1, 3)  
  | otherwise = (hr, mn, dy + 1, mt)

nextMinute :: (Int, Int, Int, Int) -> (Int, Int, Int, Int)
nextMinute (hr, mn, dy, mt)
  | hr == 23 && mn == 59 = (0, 0, dy + 1, mt) 
  | mn == 59 = (hr + 1, 0, dy, mt)
  | otherwise = (hr, mn + 1, dy, mt)

toDigits :: (Int, Int, Int, Int) -> [Int]
toDigits (hr, mn, dy, mt) = concatMap getTwoDigits [hr, mn, dy, mt]
  where
    getTwoDigits num = if num < 10 then [0, num] else getDigits num

noMultiplesOf11 :: (Int, Int, Int, Int) -> Bool
noMultiplesOf11 (hr, mn, dy, mt) = all (\x -> x `mod` 11 /= 0) [hr, mn, dy, mt]

tester1 :: (Int, Int, Int, Int) -> Bool
tester1 dateTime = 
  noMultiplesOf11 dateTime && uniqueDigits && primeSegments && validNextDay && validOneMinAfter
  where
    allDigits = toDigits dateTime
    uniqueDigits = length allDigits == length (nub allDigits)
    totalSegments = calculateSegments allDigits
    primeSegments = prime totalSegments

    -- check conditions for the next day
    nextDay = nextDate dateTime
    nextDayDigits = toDigits nextDay
    nextDaySegs = calculateSegments nextDayDigits
    validNextDay = prime nextDaySegs

    -- check conditions for one minute after
    oneMinAfter = nextMinute nextDay
    oneMinAfterDigits = toDigits oneMinAfter
    oneMinAfterSegs = calculateSegments oneMinAfterDigits
    validOneMinAfter = (oneMinAfterSegs * 2) == (totalSegments + nextDaySegs)
