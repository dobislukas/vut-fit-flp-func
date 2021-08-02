-- FORD-FULKERSON
-- Lukas Dobis
-- xdobis01
-- FLP 2021

module Main (main)  where

import System.Environment (getArgs, getProgName)
import System.Exit (die) 

import FFdata (FlowNet)
import FFedmondsKarp (edmonds_karp_algorithm)
import FFparseInput (getFileArg, validateArgs, initFlowNet)
import FFcreateOutput (createOutputString)

-- Main 
main :: IO ()
main = do
     (input, args) <- processArgs =<< getArgs
     processFlowNet (initFlowNet input) args

-- Argument validation and processing
processArgs :: [String] -> IO (String, [String])
processArgs args = do
    input <- if null (getFileArg args) then getContents else readFile (getFileArg args)
    case validateArgs args of
        True  -> return (input, args)
        False -> die ("Incorrect arguments: Expecting [-i|-v|-f] [FILE|STDIN]")

-- Compute flow into flow network, and based on flags create output string to print
processFlowNet :: FlowNet -> [String] -> IO ()
processFlowNet flowNet args = do
                  let computedflowNet = edmonds_karp_algorithm flowNet True
                  progName <- getProgName
                  putStrLn $ createOutputString computedflowNet (progName:args)
