{- Assignment 2 - Finite Automata (due November 11, noon)

Notes:
- You may import Data.List; you may not import any other modules

***Write the names and CDF accounts for each of your group members below.***
Devon Welch, c1welchd
<Name>, <CDF>
-}
module Dfa (State, Symbol, Transition, Automaton(..),
            allStrings, tableToDelta, extend, possibleOutcomes,
            accept, language,
            removeUseless, isFiniteLanguage, language',
            epsilonClosure) where

import Data.List

-- Basic data types
type State = Integer
type Symbol = Char
type Transition = (State, Symbol, State)

-- Automaton Data Type
-- Automaton states alphabet transitions initial final
data Automaton = Automaton [State] [Symbol] [Transition] State [State]
-- Some helper functions for you to access the different automaton components
states :: Automaton -> [State]
states (Automaton s _ _ _ _) = s
alphabet :: Automaton -> [Symbol]
alphabet (Automaton _ a _ _ _) = a
transitions :: Automaton -> [Transition]
transitions (Automaton _ _ ts _ _) = ts
initial :: Automaton -> State
initial (Automaton _ _ _ i _) = i
final :: Automaton -> [State]
final (Automaton _ _ _ _ f) = f
getStart :: Transition -> State
getStart (start, x, end) = start
getX :: Transition -> Char
getX (start, x, end) = x
getEnd :: Transition -> State
getEnd (start, x, end) = end


-- Questions 1-4: transitions
tableToDelta :: [Transition] -> State -> Symbol -> [State]
tableToDelta [] _ _ = []
tableToDelta t st sy = if (getStart (head t) == st && getX (head t) == sy) then (getEnd (head t)):(tableToDelta (tail t) st sy) else tableToDelta (tail t) st sy

extend :: (State -> Symbol -> [State]) -> (State -> String -> [State])
extend = undefined

allStrings :: [Symbol] -> [[String]]
allStrings = undefined

possibleOutcomes :: Automaton -> State -> [[(String, [State])]]
possibleOutcomes = undefined


-- Questions 5-6: acceptance
accept :: Automaton -> String -> Bool
accept = undefined

language :: Automaton -> [String]
language = undefined


-- Questions 7-9: finiteness
removeUseless :: Automaton -> Automaton
removeUseless = undefined

isFiniteLanguage :: Automaton -> Bool
isFiniteLanguage = undefined

language' :: Automaton -> [String]
language' = undefined


-- Question 10: epsilon transitions
epsilonClosure :: Automaton -> [State] -> [State]
epsilonClosure = undefined
