-- FORD-FULKERSON
-- Lukas Dobis
-- xdobis01
-- FLP 2021

module FFparseInput (getFileArg, validateArgs, initFlowNet)  where

import Data.List (nub)
import Data.List.Split (splitOn)
import Data.Maybe (fromJust)
import Text.Read (readMaybe)

import FFdata (Node, Capacity, Flow, Path, Edge(..), FlowNet(..))

-- ======================================================================
-- Validate args and parse input       
-- ======================================================================

-- Return file argument
getFileArg :: [String] -> String
getFileArg args = if null fileArg then [] else head fileArg
           where 
              fileArg = (filter (\arg -> notElem '-' arg) args)
            
-- Arguments format validation
validateArgs :: [String] -> Bool
validateArgs args = oneToThreeFlags && noDuplicitFlags && validFlags && oneOrLessFileArg
            where
                flags = filter (\arg -> elem '-' arg) args
                oneToThreeFlags = (length flags /= 0) && (length flags <=3)
                noDuplicitFlags = length (nub flags) == length flags
                validFlags = all (\flag -> elem flag ["-i","-v","-f"]) flags
                oneOrLessFileArg = length (filter (\arg -> notElem '-' arg) args) <= 1
        
-- Initialize not computed flow network graph structure from dicam format
initFlowNet :: String -> FlowNet
initFlowNet dimacsString = FlowNet { source = mainNodes !! 0, target = mainNodes !! 1, maxFlow = 0, edges = edges}
            where
                parsedText = lines dimacsString 
                mainNodesText = filter (\str -> str !! 0 == 'n') parsedText
                mainNodes = parseMainNodes mainNodesText
                edgesText = filter (\str -> str !! 0 == 'a') parsedText
                edges = parseEdges edgesText
                
-- Parses source and target node from text               
parseMainNodes :: [String] -> [Node]
parseMainNodes mainNodesText = map (\nodeTxt -> head (map (fromJust) 
                                                          (filter (Nothing /=) 
                                                                  (map (\string -> readMaybe string :: Maybe Int) 
                                                                       (splitOn " " nodeTxt)
                                                                  )
                                                          )
                                                     )
                                   ) mainNodesText

-- Parses edges from text               
parseEdges :: [String] -> [Edge]
parseEdges edgesText = map (\edgeTxt -> createEdge (map (fromJust) 
                                                        (filter (Nothing /=) 
                                                                (map (\string -> readMaybe string :: Maybe Int) 
                                                                     (splitOn " " edgeTxt)
                                                                )
                                                        )
                                                   )
                           ) edgesText
                           
-- Create edge from Int list
createEdge :: [Int] -> Edge
createEdge (x:y:z:xs) = Edge {
                           start = x :: Node,
                           end = y :: Node,
                           cap = z :: Capacity,
                           flow = 0 
                          }
