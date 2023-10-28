import Data.List


main :: IO ()
main =
  print (filter tester2 generator2)


generator2 :: [(String, String, String, String, String)]
generator2 = 
  [(n1,n2,n3,n4,n5)
  | n1 <- map show [123..987],
  special n1,
  n3 <- permutations n1,
  n5 <- permutations n1,
  n2 <- selectTwoDigits n1,
  n4 <- selectTwoDigits n1,
  head n1 /= head n2
  ]

special :: String -> Bool
special s
    = not ('0' `elem` s) -- true if no 0 in s
    && nodups s

nodups :: Eq a => [a] -> Bool
nodups s =
    s == nub s -- simplifies duplicates to one

selectTwoDigits :: String -> [String]
selectTwoDigits n1
  = [[a,b] | a <- n1, b <- n1, a /= b]
  
tester2 :: (String, String, String, String, String) -> Bool
tester2 (n1, n2, n3, n4, n5) = 
    n1Minusn2 == n3Int
    && n3Minusn4 == n5Int
    && total < 2000
  where
    n1Int = read n1
    n2Int = read n2
    n3Int = read n3
    n4Int = read n4
    n5Int = read n5

    n1Minusn2 = n1Int - n2Int
    n3Minusn4 = n3Int - n4Int
    total = n1Int + n3Int + n5Int
