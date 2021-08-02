# Functional and Logic Programming - Functional Project
## FORD-FULKERSON

#### Author: Lukas Dobis <xdobis01@stud.fit.vutbr.cz>

## Used Haskell modules
- `Data.List`
- `Data.List.Split`
- `Data.Maybe`
- `Text.Read`
- `System.Environment`
- `System.Exit`

## Build
Using `make` command the project is compiled using the `ghc` compiler
into `ford-fulkerson` executable. To showcase simple example use `make run`
to print computed flow network. Running command `make tests`, generates
test results described in `doc/test-description.txt` file.
Command `make clean` can be used to clear all build files and test outputs, 
while `make reset` does same, but with additional removal of executable.

## Run

```bash
$ ./ford-fulkerson (-i|-v|-f) [FILE|STDIN]
```
`FILE` is a file containing maximum flow problem in DIMACS format, if it is
not provided, program assumes that it will receive contents of such file 
from standar input. Flag `-i`, makes program print problem reconstructed 
back into DIMACS format. Flag `-v`, makes program print computed maximum flow.
Flag `-f`, makes program print computed flow network in form of DIMACS solution.
Order of arguments is arbitrary, but they must follow four conditions:
1) One to three unique and selectable flags 2) One or none file argument
3) Allowed flag format is: -v -f, this is not: -vf. 4) File input is expected to 
be in valid DICAM format.

## Description
The program computes maximum flow with corresponding flow network, for flow network 
problem encoded in DIMACS format (http://lpsolve.sourceforge.net/5.5/DIMACS_maxf.htm). 
After computation program prints output on standard output based on flags set by user.

- `src/FFmain.hs` - The main program performing IO operations and only module to
                    import from other project modules, with exception of FFdata module.
- `src/FFdata.hs` - Module defining data structures Edge and FlowNet for representing
                    flow network. Also contains some type synonyms for better overview
                    of code. (Instead of general term of graph theory vertex, in this 
                    project is for purpose of shorter function names, used term node. And
                    as sink is used synonym, which is more often used target)
- `src/FFparseInput.hs` - Arguments validation and input parsing of DIMACS file contents 
                          to create inner flow network representation FlowNet.
- `src/FFedmondsKapr.hs` - Edmonds-Karp algorithm implementation of Ford-Fulkerson method
                           which uses Breath-First-Search to find augmenting path, to 
                           iteratively compute flow network.
- `src/FFcreateOutput.hs` - Module for creating output for standard output from computed
                            flow network, based on set flags.
