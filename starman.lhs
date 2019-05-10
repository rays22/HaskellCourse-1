#!/usr/bin/env runhaskell

-- starman
-- Guessing Game
-- https://www.futurelearn.com/courses/functional-programming-haskell/5/steps/505463
------------------------------------------------------------------------------------
 Guessing Game

Now let’s put together everything we have learned this week. We are going to write a moderately long Haskell program, consisting of multiple functions and I/O actions.
Guessing Game

The program is going to be a guessing game, called Starman. In this single-player, text-based game, there is a word which the player needs to guess. For each turn of the game, the player guesses a single letter. If that letter is correct, then the guessed letters are displayed in the correct places in the word. If that letter is incorrect, then the user loses a star. Once the user has no stars left, they have lost the game. However if the user guesses all the letters in the word, they have won the game.

Because this game is quite long, we should use a texteditor (like Notepad++ on Windows, TextEdit on Mac or Gedit on Linux). Well, I actually use emacs … if you’ve heard of it. Start by creating an empty text file called starman.hs — the hs extension is to indicate that this file contains Haskell source code.
Key Functions

The heart of the game involves checking the player’s guess. We want to know whether the guess was right. This outcome is a Bool value, either True or False. We need to update the displayed word, if the guess was right, by replacing appropriate dashes in the displayed word with the correctly guessed character. Therefore the result type of the function is a pair (Bool, String). The first element of the pair is the guess outcome. The second element is the String to display to the user for the next round.

Now, the checking function needs to know:

    The secret word, a String
    The current display, also a String
    The character guessed by the player

These are the inputs to the checking function. So now we can state the type of the function:

check :: String -> String -> Char -> (Bool,String)

Here is a great programming tip. It’s always helpful to work out the type of a function first. This focuses your attention on what the function is supposed to compute, and what data it needs to do it. Good software engineers do specification before implementation.

What will the check function body look like? The player’s guess is correct if and only if the guessed character c is in the target word. So the guess is correct if

c `elem` word

The new displayed word will be:

[(if x==c then c else y) | (x,y) <- zip word display]

This is a list comprehension, where we select each letter from either the actual word or the old display. The word is plaintext, whereas the display starts with all dashed characters.

> check :: String -> String -> Char -> (Bool, String)
> check word display c
>   = (c `elem` word, [if x==c
>           then c
>           else y | (x,y) <- zip word display])

The next function we will define is the turn function. This is the function that will be called each time it is the player’s turn to enter a guess. First we need to check how many guesses the player has left:

if n == 0

If there are any guesses left, then we need to see whether the player is correct or not:

if word == display

So we will have two if checks, each followed by putStrLn status messages and the end of the function calling sequence (since it is the end of the game). However if neither of the if conditions is true, then the player can take a turn, so we call another function to get another character from the user input.

> turn :: String -> String -> Int -> IO ()
> turn word display n =
>   do if n==0
>        then putStrLn "You lose"
>        else if word==display
>               then putStrLn "You win!"
>               else mkguess word display n

Note that there is a neater way to write the turn function, using Haskell guards, but we won’t learn about guards until next week.

mkguess :: String -> String -> Int -> IO () -- define data types

> mkguess word display n =
>   do putStrLn (display ++ "  " ++ take n (repeat '*'))
>      putStr "  Enter your guess: "
>      q <- getLine
>      let (correct, display') = check word display (q!!0)
>      let n' = if correct then n else n-1
>      turn word display' n'

What is the type of mkguess? Can you work it out and add it before the function definition? We grab a line of user input, but only use the first character for the guess. This will fail if the user just hits ENTER without typing any characters, since q will be an empty string.

OK, so now we just need a top-level function. Let’s call this starman:

> starman :: String -> Int -> IO ()
> starman word n = turn word ['-' | x <- word] n

This function takes two arguments, the first is the word to be guessed, and the second is the number of incorrect guesses the player is allowed.
