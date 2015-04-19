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
            epsilonClosure, getStart, getX, getEnd, makeNiceList,
            removeDups, canExit, getTransitions) where

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

-- Helper functions to get the start state, symbol, and end state of a transition
getStart :: Transition -> State
getStart (start, x, end) = start
getX :: Transition -> Char
getX (start, x, end) = x
getEnd :: Transition -> State
getEnd (start, x, end) = end

-- Helper functions to turn a list into an ordered list with no duplicates
makeNiceList :: Ord a => [a] -> [a]
makeNiceList x = removeDups (sort x)
removeDups :: Eq a => [a] -> [a]
removeDups [] = []
removeDups [a] = [a]
removeDups (x:xs) = if x == head xs then removeDups xs else x:(removeDups xs)

-- Questions 1-4: transitions
tableToDelta :: [Transition] -> State -> Symbol -> [State]
tableToDelta trans st sy = makeNiceList (foldr 
												(\x y -> (getEnd x):y) 
												[] 
												(filter 
													(\x -> (getStart x) == st && (getX x) == sy) 
													trans))

extend :: (State -> Symbol -> [State]) -> (State -> String -> [State])
extend trans sta str = foldl 
							(\x y -> (foldl' 
										(\q z -> q ++ (trans z y)) 
										[] 
										x)) 
							[sta] 
							str

allStrings :: [Symbol] -> [[String]]
allStrings s = [""]:(map 
						(\x -> makeNiceList (foldl' 
										(\p q -> p ++ (map (\y -> (y:q)) s)) 
										[] 
										x))
						(allStrings s))

possibleOutcomes :: Automaton -> State -> [[(String, [State])]]
possibleOutcomes a st = map 
							(\y -> map 
									(\x -> (x, (extend (tableToDelta (transitions a)) st x))) 
									y) 
							(allStrings (alphabet a))


-- Questions 5-6: acceptance
accept :: Automaton -> String -> Bool
accept a str = foldl' 
					(\h z -> h || (((fst z) == str) && (foldl' 
															(\q p -> (elem p (final a)) || q) 
															False 
															(snd z)))) 
					False 
					(possibleOutcomes a (initial a) !! (length str))

language :: Automaton -> [String]
language a = if canExit a [(initial a)] then (if accept a "" then (languageHelper a) else tail (languageHelper a)) else []


-- Helper function for language. Helps avoid calls to language that never finish or return, even initial elements
-- in an infinite list. [State] should be the initial state of the automaton put into a list.
canExit :: Automaton -> [State] -> Bool
canExit a st = if (elem (initial a) (final a)) then True else if (foldl' (\x y -> x || elem y (final a)) False st) then True else 
	let nextIter = (makeNiceList (foldl' (\x y -> x ++ y:(getTransitions a y)) [] st))
	in if (st == nextIter) then False else (canExit a nextIter)

-- Helper function, specifically for language. Gets all states that a given state transitions to (other than itself with "").
getTransitions :: Automaton -> State -> [State]
getTransitions a st = makeNiceList (foldl' (\y x -> if (getStart x == st) then (getEnd x):y else y ++ []) [] (transitions a))

-- Helper function for language that does the majority of the work; language was considering "" to be valid
-- for automata even when it wasn't supposed to (even though accept was showing it should not be accepted)
-- so language removes the first element ("") if it should not be there. This returns an infinite list.
languageHelper :: Automaton -> [String]
languageHelper a = foldr
					(\z x -> z ++ (filter 
										(\y -> if accept a y then True else False) 
										x)) 
					[] 
					(allStrings (alphabet a))


-- Questions 7-9: finiteness
removeUseless :: Automaton -> Automaton
removeUseless a = Automaton 
	(filter (\x -> isUseful a x) (states a)) 
	(alphabet a) 
	(filter (\y -> isUseful a (getStart y) && isUseful a (getEnd y)) (transitions a)) 
	(initial a) 
	(final a)

-- Helper function for removeUseless. Returns to True if the state passed in is determined to be useful,
-- False otherwise.
isUseful :: Automaton -> State -> Bool
isUseful a st = if null (languageUseless a st) then False else True

-- Helper function for removeUseless. Works the same as language, except that a state is passed in so that
-- a starting state may be chosen, rather than be limited to the starting state of the automaton. One 
-- other change is that languageUselessHelper, which this fucntion calls, returns a finite list,
-- rather than an infinite list, like languageHelper.
languageUseless :: Automaton -> State -> [String]
languageUseless a st = if (acceptUseless a "" st) then (languageUselessHelper a st) else tail (languageUselessHelper a st)

-- Helper function for removeUseless. Has the same basic purpose as languageHelper, with one addition - I was 
-- having a problem with it not returning in some situations, so I made it return a finite list rather than
-- an infinite list. 
languageUselessHelper :: Automaton -> State -> [String]
languageUselessHelper a st = foldr 
								(\z x -> z ++ (filter 
													(\y -> if acceptUseless a y st then True else False) 
													x)) 
								[] 
								(take (length (states a)) (allStrings (alphabet a)))

-- Helper function for removeUseless. Has the same basic function as accept, except a starting state is
-- passed in so you can use states other than the starting state of the automaton.
acceptUseless :: Automaton -> String -> State -> Bool
acceptUseless a str sta = foldl' 
							(\h z -> h || (((fst z) == str) && (foldl' 
																	(\q p -> (elem p (final a)) || q) 
																	False 
																	(snd z)))) 
							False 
							(possibleOutcomes a sta !! (length str))

isFiniteLanguage :: Automaton -> Bool
isFiniteLanguage a = if null (language a) || findLargeString (length (states (removeUseless a))) (languageUseless a 0) then False else True

language' :: Automaton -> [String]
language' a = if isFiniteLanguage a then languageUseless a (initial a) else language a

-- Helper function for isFiniteLanguage. This would be implemeneted with a higehr oreder function if [String] was not potentially infinite.
-- Checks if there is a string of at least size i in s; returns True if there is, False if there isn't. 
findLargeString :: Int -> [String] -> Bool
findLargeString i s = if null s then False else if length (head s) > i then True else findLargeString i (tail s)

-- Question 10: epsilon transitions
epsilonClosure :: Automaton -> [State] -> [State]
epsilonClosure a st = if makeNiceList st == epsilonHelper a st then makeNiceList st else epsilonClosure a (epsilonHelper a st)

-- Helper functiion for epsilonClosure. Returns the list of states passed in with any new states that 
-- can be reached in one 'round' of epsilon transitions inserted into the list at the appropriate
-- places.
epsilonHelper :: Automaton -> [State] -> [State]
epsilonHelper a st = makeNiceList (st ++ foldl' (\x y -> x ++ getEpsilonTransitions a y) [] st)

-- Helper function for epsilonClosure. Returns a list of all of the states that a given state can reach
-- in one 'round' of epsilon transitions.
getEpsilonTransitions :: Automaton -> State -> [State]
getEpsilonTransitions a st = foldl' 
						(\y x -> if getStart x == st && getX x == ' ' then (getEnd x):y else y) 
						[] 
						(transitions a)

a1 = Automaton [0,1,2]
                                     ['a','b']
                                     [(0,'a',1),
                                      (1,'a',2),
                                      (0,'b',0),
                                      (1,'b',1),
                                      (2,'b',2),
                                      (1,'a',0)] 0 [2]

a2 = Automaton [0,1] ['a'] [(0,'a',1)] 0 [0]

finite = Automaton [0,1] ['a'] [(0,'a',1)] 0 [1]

a8 = Automaton [0] ['a'] [(0,'a',0)] 0 [0]