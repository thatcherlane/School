-- median.hs
-- Thatcher Lane
-- CS 331
-- Assignment 5

module Main where

import Data.List (sort)
import Data.Maybe (isJust, fromMaybe)

-- main
-- Prompts user for list of numbers,
--   prints median or empty list message, and
--   repeats as decided by user.
main = do
    putStrLn ""
    putStrLn "Enter a list of integers, one on each line."
    putStrLn "We will then compute the median of your integers"
    putStrLn ""

    list <- getList
    let med = calcMedian $ sort list
    if isJust(med)
        then putStrLn $ "Median: " ++ (show $ fromMaybe 0 med)
        else putStrLn "Empty List - no median"

    putStr "Compute another median? [y/n] "
    c <- getLine
    if c == "y"
        then main
        else do
            putStrLn "Bye!"
            return ()


-- getList
-- Return an I/O wrapped number list input by user.
--  Numbers are input one line at a time, and limited to type Int
getList :: IO [Int]
getList = do

    line <- getLine
    if null line
        then do
            return []
        else do
            numList <- getList
            return ((read line :: Int):numList)


-- calcMedian
-- Takes list of numbers.
-- Returns the median of list as Just Num, or Nothing if the list is empty.
--  If there are two possible medians, the lower value is returned.
calcMedian :: Num a => [a] -> Maybe a
calcMedian [] = Nothing
calcMedian xs = m xs xs where
    m (x1:_) [_] = Just x1
    m (x1:x2:_) [_,_] = Just x1
    m (_:xs) (_:_:ys) = m xs ys
