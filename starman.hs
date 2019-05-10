#!/usr/bin/env runhaskell
-- starman
-- Guessing Game
-- https://www.futurelearn.com/courses/functional-programming-haskell/5/steps/505463
------------------------------------------------------------------------------------
---- work out the type of a function first ----
-- The secret word, a String
-- The current display, also a String
-- The character guessed by the player
check :: String -> String -> Char -> (Bool,String)
check word display c
  = (c `elem` word, [if x==c
          then c
          else y | (x,y) <- zip word display])

---- we need to check how many guesses the player has left:
--if n == 0
---- If there are any guesses left, then we need to see whether the player is correct or not:
--if word == display

turn :: String -> String -> Int -> IO ()
turn word display n =
    do if n==0
        then putStrLn "You lose"
        else if word==display
            then putStrLn "You win!"
            else mkguess word display n

mkguess :: String -> String -> Int -> IO () -- my guess was String for IO () -- rs 2019-05-08
------------------------
--mkguess word display n =
--    do putStrLn (display ++ "  " ++ take n (repeat '*'))
--        putStr "  Enter your guess: "
--        q <- getLine
--        let (correct, display') = check word display (q!!0)
--        let n' = if correct then n else n-1
--        turn word display' n'
------------------------
mkguess word display n =
  do putStrLn (display ++ "  " ++ take n (repeat '*'))
     putStr "  Enter your guess: "
     q <- getLine
     let (correct, display') = check word display (q!!0)
     let n' = if correct then n else n-1
     turn word display' n'


-- top-level function
starman :: String -> Int -> IO ()
starman word n = turn word ['-' | x <- word] n


