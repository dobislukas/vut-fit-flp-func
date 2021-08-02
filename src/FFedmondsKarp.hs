-- FORD-FULKERSON
-- Lukas Dobis
-- xdobis01
-- FLP 2021

module FFedmondsKarp (edmonds_karp_algorithm)  where

import FFdata (Node, Capacity, Flow, Path, Edge(..), FlowNet(..))
import FFparseInput (initFlowNet)

-- ======================================================================
-- Edmonds-Karp algorithm (Ford-Fulkerson method implementation)                
-- ======================================================================

-- Compute flow for flow network, by iteratively updating flow of edges by minimum of augmenting path (source to target)
edmonds_karp_algorithm :: FlowNet -> Bool -> FlowNet
edmonds_karp_algorithm flowNet False = flowNet
edmonds_karp_algorithm flowNet True = edmonds_karp_algorithm updatedflowNet (addedFlow /= 0)
                            where
                                 initGrayBlackNodes = [source flowNet]                              
                                 initGrayNodes = [source flowNet]
                                 initPathList = [[source flowNet]]
                                 path = computePath flowNet initPathList initGrayNodes initGrayBlackNodes
                                 (updatedEdges, addedFlow) = updateEdges (edges flowNet) path
                                 updatedflowNet = FlowNet {
                                                            source = source flowNet,
                                                            target = target flowNet,
                                                            edges = updatedEdges,
                                                            maxFlow = (maxFlow flowNet + addedFlow)
                                                          }

-- ======================================================================
-- Compute path for flow network update               
-- ======================================================================

-- Compute list of paths until augmenting path from source to target is found or all vertices are black
-- Uses Breath-First-Search to find all paths from source to target
computePath :: FlowNet -> [Path] -> [Node] -> [Node] -> Path
computePath flowNet path_list [] _ = if all null augmentingPathList then [] else head augmentingPathList
       where 
           augmentingPathList = (filter (\path -> last path == target flowNet) path_list)
computePath flowNet path_list (head_node:gray_nodes) grayBlack = computePath flowNet path_list' gray' grayBlack'
       where 
             es = edges flowNet
             s = source flowNet
             t = target flowNet
             -- Find neighbooring white nodes to head node of gray node queue
             headEdges = getNodeEdges es s head_node
             headNeighboors = getNodesFromEdges headEdges
             filteredNeighbors = filterOutGrayBlack grayBlack headNeighboors
             -- Find path ending with head node, extend them with found neighboors 
             pathWithHeadNode = findNodePath path_list head_node
             extendedPaths = extendPath pathWithHeadNode filteredNeighbors
             -- Erase old path, and add extended paths to new path list
             path_list' = (filterOldPath path_list pathWithHeadNode) ++ extendedPaths
             -- Update gray and grayblack nodes, if path is found empty gray nodes to end recursion  
             pathIsFound = hasTarget path_list' t
             gray' = if pathIsFound then [] else (gray_nodes ++ filteredNeighbors)
             grayBlack' = grayBlack ++ filteredNeighbors

-- Get edges neighbooring head node, that satisfy criteria
getNodeEdges :: [Edge] -> Node -> Node -> [Edge]
getNodeEdges es source headNode = headEdges
                            where
                                  headEdges = filter (\edge -> start edge == headNode && 
                                                                             end edge /= source &&
                                                                             cap edge > flow edge 
                                                     ) es
-- Get nodes from edges
getNodesFromEdges :: [Edge] -> [Node]
getNodesFromEdges nodeEdges = map (\edge -> end edge) nodeEdges

-- Filter out gray and black nodes from neighboor candidates
filterOutGrayBlack :: [Node] -> [Node] -> [Node]
filterOutGrayBlack grayBlack neighboors = filter (\node -> notElem node grayBlack) neighboors

-- Find path with head node
findNodePath :: [Path] -> Node -> Path
findNodePath path_list node = if all null pathWithNode then [] else head pathWithNode
                    where 
                       pathWithNode = filter (\path -> last path == node) path_list

-- Create new paths by extending path with neighboors
extendPath :: Path -> [Node] -> [Path]
extendPath path neighboors = map (\neighboor -> path ++ [neighboor]) neighboors

-- Filter old path out of path list
filterOldPath :: [Path] -> Path -> [Path]
filterOldPath pathList oldPath = filter (\path -> path /= oldPath) pathList

-- Tells if there is path to target node, in list of paths
hasTarget :: [Path] -> Node -> Bool
hasTarget pathList target = not( null pathWithTarget)
                    where 
                        pathWithTarget = filter (\path -> last path == target) pathList

-- ======================================================================
-- Compute flow update from found augmenting path, and update edges                 
-- ======================================================================

-- Return updated edges with added flow difference
updateEdges :: [Edge] -> Path -> ([Edge], Flow)
updateEdges es [] = (es, 0)
updateEdges es path = (updatedEdges, difference)
                     where
                        pathEdges = getPathEdges es path
                        difference = minFlowDifference pathEdges
                        updatedPathEdges = getNewEdges pathEdges difference
                        notPathEdges = filter (\edge -> notElem edge pathEdges) es
                        updatedEdges = notPathEdges ++ updatedPathEdges

-- Get edges from found augmenting path
getPathEdges :: [Edge] -> Path -> [Edge]
getPathEdges es [x] = []
getPathEdges es (x:y:xs) = pathEdge ++ getPathEdges es (y:xs)
                    where 
                        pathEdge = filter (\edge -> start edge == x && end edge == y) es
                              
                               
-- Compute minimum of all differences between capacity and flow in path edges  
minFlowDifference :: [Edge] -> Flow
minFlowDifference [edge] = cap edge - flow edge
minFlowDifference (edge:es) = min (cap edge - flow edge) (minFlowDifference es)   

-- Create new path edges, with their flow updated by difference
getNewEdges :: [Edge] -> Flow -> [Edge]
getNewEdges pathEdges difference = map (\edge -> Edge {
                                                       start = start edge,
                                                       end = end edge,
                                                       cap = cap edge,
                                                       flow = difference + flow edge 
                                                      }
                                       ) pathEdges
