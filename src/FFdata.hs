-- FORD-FULKERSON
-- Lukas Dobis
-- xdobis01

module FFdata (Node, Capacity, Flow, Path, Edge(..), FlowNet(..))  where

type Node = Int
type Capacity = Int
type Flow = Int
type Path = [Node]

-- Data structure representing edge 
data Edge = Edge 
            {
            start :: Node,
            end :: Node,
            cap :: Capacity,
            flow :: Flow
            } deriving (Eq, Show)

-- Data structure holding flow network
data FlowNet = FlowNet 
            {
            source :: Node,
            target :: Node,
            maxFlow :: Flow,
            edges :: [Edge]
            } deriving Show
