<h1 align="center">The Baguette# OCaml Interpreter</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.2-blue.svg?cacheSeconds=2592000" />
  <a href="#" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
  <a href="README.md">FR</a>
</p>

<h1 align="center">
    <br>
    <img src="https://i.imgur.com/iBSb0Fh.png" alt="Baguette#" width="540">
    <br>
    Baguette#
    <br>
</h1>
<h4 align="center">Baguette# is back!</h4>

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

## Usage

```sh
dune exec baguette_sharp_interpreter
```

## Test

```sh
dune runtest
```