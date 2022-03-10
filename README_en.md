<h1 align="center">The Baguette# OCaml Interpreter</h1>
<div align="center">
<p>
  <a href="https://github.com/coco33920/ocaml-baguettesharp-interpreter" title="Go to GitHub repo"><img src="https://img.shields.io/static/v1?label=coco33920&message=ocaml-baguettesharp-interpreter&color=55cdfc&logo=github&style=for-the-badge" alt="coco33920 - ocaml-baguettesharp-interpreter"></a>
  <a href="https://github.com/coco33920/ocaml-baguettesharp-interpreter/releases/"><img src="https://img.shields.io/github/release/coco33920/ocaml-baguettesharp-interpreter?include_prereleases=&sort=semver&color=55cdfc&style=for-the-badge" alt="GitHub release"></a>
<a href="#license"><img src="https://img.shields.io/badge/License-MIT-55cdfc?style=for-the-badge" alt="License"></a>
  <div align="center">
  <a href="README.md">
    <img alt="FR" src="https://flagicons.lipis.dev/flags/4x3/fr.svg" width="30px" title="french-readme">
  </a>
  </div>
</p>

<h1 align="center">
    <br>
    <img src="https://i.imgur.com/iBSb0Fh.png" alt="Baguette#" width="540">
    <br>
    Baguette#
    <br>
</h1>

<a href="mailto:contact@baguettesharp.fr"><img src="https://img.shields.io/badge/Contact-Mail-f7a8d8?style=for-the-badge&logo=thunderbird&logoColor=55cdfc" alt="Contact - Mail"></a>

<a href="https://github.com/coco33920/ocaml-baguettesharp-interpreter/wiki">
<img src="https://img.shields.io/badge/view-Documentation-f7a8d8?style=for-the-badge">
</a>
<a href="https://www.baguettesharp.fr">
    <img alt="b#" src="https://img.shields.io/badge/Website-Baguette%23-f7a8d8?style=for-the-badge">
  </a>
</div>
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