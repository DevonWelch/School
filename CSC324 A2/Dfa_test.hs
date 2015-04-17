{- Sample tests for Assignment 2 -}
import Test.HUnit
import Dfa (State, Symbol, Transition, Automaton(..),
            allStrings, tableToDelta, extend, possibleOutcomes,
            accept, language,
            removeUseless, isFiniteLanguage, language', epsilonClosure,
            getStart, getX, getEnd, makeNiceList, removeDups, canExit,
            getTransitions)

t1 = (1, 'a', 2)

getStartTests = TestList [
    1 ~=? getStart t1
    ]

getXTests = TestList [
    'a' ~=? getX t1
    ]

getEndTests = TestList [
    2 ~=? getEnd t1
    ]

makeNiceListTests = TestList [
    [1,2,3] ~=? makeNiceList [1,3,2,3,1,2]
    ]

removeDupsTests = TestList [
    [1,2,3] ~=? removeDups [1,1,2,2,2,2,3]
    ]

canExitTests = TestList [
    False ~=? canExit a6 [1],
    True ~=? canExit a2 [0]
    ]

getTransitionsTests = TestList [
    [1,2] ~=? getTransitions a7 0
    ]

tableToDeltaTests = TestList [
    [2] ~=? tableToDelta [(1, 'f', 2)] 1 'f',
    -- Note: a symbol could be passed in that doesn't appear in any transition
    [] ~=? tableToDelta [(1, 'f', 2)] 1 'b',
    -- tests that non-deterministic calls are correct
    [1, 2] ~=? tableToDelta [(1, 'f', 2), (1, 'f', 1)] 1 'f',
    -- tests that transitions with the same symbol but not the same start won't be kept track of
    [2] ~=? tableToDelta [(1, 'f', 2), (2, 'f', 1)] 1 'f'
    ]

extendTests = TestList [
    [2] ~=? extend (tableToDelta [(1, 'f', 2), (2, 'f', 2)]) 1 "ff",
    -- tests that non-deterministic calls are correct
    [2, 3] ~=? extend (tableToDelta [(1, 'f', 2), (2, 'f', 2), (2, 'f', 3)]) 1 "ff",
    -- tests that the string is being read in the correct order
    [3] ~=? extend (tableToDelta [(1, 'f', 2), (2, 'f', 2), (2, 'g', 3)]) 1 "fg",
    -- tests that a symbol not part of the automaton's alphabet will return an empty
    -- list, and not cause an error
    [] ~=? extend (tableToDelta [(1, 'f', 2), (2, 'f', 2), (2, 'g', 3)]) 1 "fzg"
    ]

allStringsTests = TestList [
    ["aa", "ab", "ba", "bb"] ~=? allStrings "ab" !! 2,
    -- tests that the first element of the output is just the empty string
    [""] ~=? allStrings "ab" !! 0,
    -- tests that inputitng a string with the same characters doesn't cause duplicate
    -- strings in the output 
    ["aa", "ab", "ba", "bb"] ~=? allStrings "aab" !! 2
    ]

possibleOutcomesTests = TestList [
    [("aa",[1]), ("ab",[0,2]), ("ba",[0,2]), ("bb",[1])] ~=?
        (possibleOutcomes (Automaton [0,1,2]
                                     ['a','b']
                                     [(0,'a',1),
                                      (1,'a',2),
                                      (0,'b',0),
                                      (1,'b',1),
                                      (2,'b',2),
                                      (1,'a',0)] 0 [2]) 1) !! 2
    ]

a1 = Automaton [0,1] ['a'] [(0,'a',1),(1,'a',0)] 0 [0]

a5 = Automaton [0,1] ['a'] [(0,'a',1),(1,'a',0)] 1 [0]

acceptTests = TestList [
    True ~=? accept a1 "aa",
    -- tests that an empty string starting from the final state is accepted
    True ~=? accept a1 "",
    -- tests that a series of tarnsitions that should not be accepted is not
    False ~=? accept a1 "a",
    -- tests that an incorrect string is nto accepted
    False ~=? accept a1 "b",
    -- tests that an automaton that does not start in a final state does not
    -- accept ""
    False ~=? accept a5 ""
    ]

languageTests = TestList [
    ["","aa"] ~=? take 2 (language a1),
    ["a","aaa"] ~=? take 2 (language a5)
    ]

a2 = Automaton [0,1] ['a'] [(0,'a',1)] 0 [0]

a8 = Automaton [0] ['a'] [(0,'a',0)] 0 [0]

a6 = Automaton [0,1] ['a'] [(0,'a',1)] 1 [0]

a7 = Automaton [0,1,2] ['a','b'] [(0,'a',1),(1,'a',0), (0, 'b', 2)] 1 [0]

eq :: Automaton -> Automaton -> Bool
eq (Automaton s1 a1 ts1 i1 f1) (Automaton s2 a2 ts2 i2 f2) =
    s1 == s2 &&
    a1 == a2 &&
    ts1 == ts2 &&
    i1 == i2 &&
    f1 == f2

removeUselessTests = let a3 = removeUseless a2
    in
    TestList [
        True ~=? eq a3 (Automaton [0] ['a'] [] 0 [0]),
        -- tests that removeUseless does not do anything unwanted to a proper automaton
        True ~=? eq a3 (removeUseless a3)
        ]

isFiniteLanguageTests = TestList [
    True ~=? isFiniteLanguage a2,
    False ~=? isFiniteLanguage a6,
    False ~=? isFiniteLanguage a8
    ]


language'Tests = TestList [
    [""] ~=? language' a2,
    -- tests that an automaton with a finite language does not return an infinite list
    ["a"] ~=? language' a5
    ]

a3 = Automaton [0,1,2] ['a','b'] [(0,' ',2),(0,'a',1),(2,'b',0)] 0 [1]

a4 = Automaton [0,1,2] ['a','b'] [(0,' ',2),(0,'a',1),(2,'b',0),(2,' ', 1)] 0 [1]


epsilonClosureTests = TestList [
    [0,2] ~=? epsilonClosure a3 [0],
    -- tests that multiple passed in states works
    [0, 1, 2] ~=? epsilonClosure a4 [0, 2]
    ]

main :: IO ()
main = do
    -- Put each call to "runTestTT" on a separate line
    runTestTT getStartTests
    runTestTT getXTests
    runTestTT getEndTests
    runTestTT makeNiceListTests
    runTestTT removeDupsTests
    runTestTT canExitTests
    runTestTT getTransitionsTests
    runTestTT tableToDeltaTests
    runTestTT extendTests
    runTestTT allStringsTests
    runTestTT possibleOutcomesTests
    runTestTT acceptTests
    runTestTT languageTests
    runTestTT removeUselessTests
    runTestTT isFiniteLanguageTests
    runTestTT language'Tests
    runTestTT epsilonClosureTests
    return ()
