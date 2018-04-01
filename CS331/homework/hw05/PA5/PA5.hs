-- PA5.hs
-- Thatcher Lane
-- CS 331

module PA5 where

-- collatzCounts
-- Returns a list of Integers. Item K of returned list is how many
--  iterations of the Collatz function are required
--  to take the number K+1 to 1.
collatzCounts :: [Integer]
collatzCounts = map collatzCount [0..]
collatzCount n = fromIntegral $ length(collatzList $ n+1) - 1 where
    collatzList n
        | n < 1       = error "no negative number"
        | n == 1    = [n]
        | otherwise = n:collatzList (collatzNext n) where
            collatzNext n
                | n `mod` 2 == 1 = 3*n+1
                | otherwise           = div n 2

-- findList
-- Takes two lists of same type.
-- Returns the earliest index in the second list at which a
--  copy of the first list is found or Nothing if not found.
findList :: Eq a => [a] -> [a] -> Maybe Int
findList [] _ = Just 0
findList _ [] = Nothing
findList (x:xs) (y:ys) = findList' (x:xs) (y:ys) n where
    n = length(y:ys)
    findList' [] _ _ = Just 0
    findList' _ [] _= Nothing
    findList' (x:xs) (y:ys) n =
        if x:xs == take (length $ x:xs) (y:ys)
            then Just (n - length(y:ys))
            else findList' (x:xs) ys n


-- op ##
-- Takes two lists of same type.
-- Returns as integer the number of indices at which the two
--  lists contain equal values.
(##) :: Eq a => [a] -> [a] -> Int
[] ## _ = 0
_ ## [] = 0
(x:xs) ## (y:ys) =
    if (x == y)
        then (xs ## ys +1)
        else (xs ## ys)


-- filterAB
-- Recieves boolean function and two lists
-- It returns a list of all items in the second list for which the
--  corresponding item in the first list makes the boolean function true.
filterAB :: (a -> Bool) -> [a] -> [b] -> [b]
filterAB _ [] _ = []
filterAB _ _ [] = []
filterAB p (x:xs) (y:ys) =
    if (p x)
        then y:(filterAB p xs ys)
        else filterAB p xs ys

-- NOT REQUIRED: helper function
-- retrieve the first or second of the Tuple
getTuple1 (first,_) = first
getTuple2 (_,second) = second

-- NOT REQUIRED: helper function
-- tupleList
-- generates a list from a tuple
tupleList [] = ([], [])
tupleList [x] = ([x],[])
tupleList (x:y:xs) = (x:xp, y:yp ) where (xp, yp) = tupleList xs

-- sumEvenOdd
-- It returns a tuple of two numbers: the sum of the even-index items in the
--  given list, and the sum of the odd-index items in the given list.
--  Indices are zero-based.
sumEvenOdd :: Num a => [a] -> (a, a)
sumEvenOdd list = tuple where
    tuplePieces = tupleList list
    evens = foldr (+) 0 (getTuple1 tuplePieces)
    odds = foldr (+) 0 (getTuple2 tuplePieces)
    tuple = (evens, odds)
