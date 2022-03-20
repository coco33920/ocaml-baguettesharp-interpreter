# REPL
## Table of Contents
- [Main Page](index.md#)
  - [Requirements](index.md#requirements)
  - [History](index.md#history)
  - [Support](index.md#support)
  - [Building](index.md#building)
  - [Install](index.md#install)
  - [Usage](index.md#usage)
  - [Test](index.md#test)
- [REPL](#repl)
  - [Links](#links)
  - [Prerequisite](#prerequisite)
  - [General command line](#general-command-line)
    - [REPL Commands](#repl-commands)
  - [REPL](#repl-1)
    - [Variable](#variable)
    - [Hinting](#hinting)
    - [Auto-completion](#auto-completion)
  - [Command Line](#command-line)
  - [Errors](#errors)
    - [Wrong Type](#wrong-type)
    - [Syntax](#syntax)
    - [List of errors](#list-of-errors)
- [Basic Usage](basic.md#basic-usage)
  - [Links](basic.md/#links)
  - [Support](basic.md#support)
  - [IO](basic.md#io)
  - [Mathematics](basic.md#mathematics)
  - [Boolean algebra](basic.md#boolean-algebra)
    - [Booleans](basic.md#booleans)
    - [Algebra](basic.md#algebra)
  - [Array Manipulations](basic.md#array-manipulations)
  - [String Manipulations](basic.md#string-manipulations)
    - [Conversion from string](basic.md#conversion-from-string)
    - [Conversion to string](basic.md#conversion-to-string)
  - [Variables](basic.md#variables)
- [Random Guessing Game](random.md#random-guessing-game)
  - [Specifications](random.md#specifications)
  - [Initialization of the game](random.md#initialization-of-the-game)
    - [Welcome](random.md#welcome)
    - [Generation of the number to guess](random.md#generation-of-the-number-to-guess)
    - [Declarations](random.md#declarations)
  - [The Game Loop](random.md#the-game-loop)
    - [A Step](random.md#a-step)
    - [The Loop](random.md#the-loop)
-  [Binary Turing Machine](turing.md#binary-turing-machine)
   - [Introduction](turing.md#introduction)
   - [Specification](turing.md#specification)
   - [Initialization](turing.md#initialization)
   - [Program reading](turing.md#program-reading)
   - [One Step](turing.md#one-step)
   - [The Main Loop](turing.md#the-main-loop)
- [Binary Turing Machine Examples](turing.md#examples)
  - [Left Bit Shift](turing.md#left-bit-shift)
  - [Binary Add](turing.md#binary-add)
  - [Infinite loop](turing.md#infinite-loop)

## Links
[Next Page : Basic Usage](basic.md) 
## Prerequisite
The executable of baguette-sharp, either from the precompiled binaries downloadable in the header
or from compiling/installing the project with 
```bash
dune build/install
```
here the executable is assumed to be `baguette_sharp` and in the `$PATH`

## General command line
typing in a terminal
```bash
baguette_sharp --help
```
gives you the help of the command which is

![help](img/help.png)

* `--input` is the location of the input file to interpret
* `--output` is **not** implemented yet
* `--verbose` toggle the verbose on (default is false) which
shows the lexed code and prints the AST before interpreting it
* `--version` prints a nice little 'about me' line
* `--lexer` toggle the char version of the lexer on (default is off)

### REPL Commands
Not specifying an input file launch the REPL for example `baguette_sharp` alone launch the REPL

![repl](img/strpl.png)

The REPL top commands are the following
* `help` shows the displayed help
* `load <file>` loads an external baguette file (note this supports auto-completion)
* `save <file>` saves the history of `Baguette#` commands in the specified file 
* `verbose` toggle the verbose on/off (default is off)
* `lexer` toggle the new lexer on/off (default is off)
* `exit` exit the REPL

N.B the following command are equivalent:
```
baguette_sharp --verbose
```
and 
```
baguette_sharp
```
then toggling `verbose` on. Same with the lexer

## REPL
### Variable
By default the REPL shows the information about an incoming variable.<br/>
The example bellow shows what happens when typing only `Hello` in the prompt

![hello](img/replvar.png)

And the difference between adding and printing the addition:

![diff](img/diff.png)

The same code interpreted through a file only shows the latter 

![file](img/varfile.png)

### Hinting
The REPL shows hint when a function / keyword is typed<br/>
**Function**

![cr](img/crhinting.png)

**Keyword**

![k](img/crochet.png)

### Auto-completion
Lastly the REPL editor uses `Linenoise` to provide auto-completion when using baguette commands

![autocomp](img/autocomp.gif)

## Command Line

The Command Line Version of Baguette# just execute the file
for example
```bash
baguette_sharp --input examples/math.baguette
```
Shows

![math](img/math.png)

## Errors
In the last version (2.0) of Baguette# a real system of errors (without the way of handling them just yet though) has been implemented. Here is some example

### Wrong Type

![typerror](img/typeerror.png)
The error was raised because `MADELEINE` take a string as parameter and `0` is an integer

### Syntax

![syntaxerror](img/syntaxerror.png)
The error was raised because the variable `test` we were trying to access do not exist

### List of errors
there is _ types of error
* `Wrong Type Error` raised when you supply a parameter of a wrong type
* `Syntax Error` for errors relating to runtime and/or syntax
* `Out Of Bound Error` raised when you try to access an element of an array which do not exist (ex element 5 of an array of size 3)
* `Argument Error` when you supply not enough arguments for an instruction
* `Error` for the other types of errors.