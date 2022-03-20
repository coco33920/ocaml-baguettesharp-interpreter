# OCaml Baguette# Interpreter
Welcome to the website of the Interpreter of OCaml.
The content here is for the moment the README.md of the repo.

<div align="center">
<a href="https://github.com/coco33920/ocaml-baguettesharp-interpreter">
<img src="https://img.shields.io/static/v1?label=coco33920&message=ocaml-baguettesharp-interpreter&color=55cdfc&logo=github&style=for-the-badge">
</a>
<a href="https://github.com/coco33920/ocaml-baguettesharp-interpreter/releases">
<img src="https://img.shields.io/github/release/coco33920/ocaml-baguettesharp-interpreter?include_prereleases=&sort=semver&color=55cdfc&style=for-the-badge">
</a>
<a href="https://github.com/coco33920/ocaml-baguettesharp-interpreter/blob/master/LICENCE">
<img src="https://img.shields.io/badge/License-MIT-55cdfc?style=for-the-badge">
</a>
<br>
<a href="https://github.com/coco33920/ocaml-baguettesharp-interpreter/wiki">
<img src="https://img.shields.io/badge/view-Wiki-f7a8d8?style=for-the-badge">
</a>
<a href="https://www.baguettesharp.fr">
    <img alt="b#" src="https://img.shields.io/badge/Website-Baguette%23-f7a8d8?style=for-the-badge">
  </a>
<a href="mailto:contact@baguettesharp.fr"><img src="https://img.shields.io/badge/Contact-Mail-f7a8d8?style=for-the-badge&logo=thunderbird&logoColor=f7a8d8" alt="Contact - Mail"></a>
</div>

## Table of Contents

<details><summary>Main Page</summary>


- [Main Page](#)
  - [Requirements](#requirements)
  - [History](#history)
  - [Support](#support)
  - [Building](#building)
  - [Install](#install)
  - [Usage](#usage)
  - [Test](#test)


</details>


<details><summary>REPL</summary>


- [REPL](repl.md#repl)
  - [Links](repl.md#links)
  - [Prerequisite](repl.md#prerequisite)
  - [General command line](repl.md#general-command-line)
    - [REPL Commands](repl.md#repl-commands)
  - [REPL](repl.md#repl-1)
    - [Variable](repl.md#variable)
    - [Hinting](repl.md#hinting)
    - [Auto-completion](repl.md#auto-completion)
  - [Command Line](repl.md#command-line)
  - [Errors](repl.md#errors)
    - [Wrong Type](repl.md#wrong-type)
    - [Syntax](repl.md#syntax)
    - [List of errors](repl.md#list-of-errors)


</details>


<details><summary>Basic Usage</summary>


- [Basic Usage](basic.md/#basic-usage)
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


</details>
<details><summary>Advanced Usage</summary>


- [Advanced Usage](advanced.md#advanced-usage)
  - [Introduction](advanced.md#introduction)
  - [Labels](advanced.md#labels)
  - [GOTOs](advanced.md#gotos)
    - [Order of execution](advanced.md#order-of-execution)
  - [Errors](advanced.md#errors)
  - [Variables and Labels](advanced.md#variables-and-labels)
  - [IFs](advanced.md#ifs)


</details>
<details><summary>Random Guessing Game</summary>


- [Random Guessing Game](random.md#random-guessing-game)
  - [Specifications](random.md#specifications)
  - [Initialization of the game](random.md#initialization-of-the-game)
    - [Welcome](random.md#welcome)
    - [Generation of the number to guess](random.md#generation-of-the-number-to-guess)
    - [Declarations](random.md#declarations)
  - [The Game Loop](random.md#the-game-loop)
    - [A Step](random.md#a-step)
    - [The Loop](random.md#the-loop)


</details>
<details><summary>Binary Turing Machine</summary>


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


</details>


## Requirements
Ocaml version >= 4.13.1, modules fmt,str and linenoise ( REPL )

```sh
opam install fmt str linenoise
```


## History 

I restarted this project early 2022, to act as a TIPE (a french weird oral exam for the _concours_ of _Écoles d'Ingénieurs_) to frame the formal language theory, and to do that you'll play with our _world famous_ pastries !

The lexer, parser and interpreter are finished, they take a string of language and transform it into an abstract syntax tree (AST) that the interpreter take to execute the language. I now work on the theoritical part of the issue (turing-completeness), and the compiler.

The syntax is really close to a BASIC but with less explicit words and keywords you'll see :)

## Support

The language supports integers, floating point numbers, strings, booleans, predicates, gotos, conditionnals gotos (if/else), 
and implements many of the standard instructions you can find in a language standard library.
Keywords are simple and are the only instances when you don't need parenthesis, go see the WIKI for more accurate informations

## Building

```sh
dune build .
```

## Install
```sh
dune install
baguette_sharp
```

## Usage

```sh
dune exec baguette_sharp_interpreter
```

## Test

```sh
dune runtest
```
