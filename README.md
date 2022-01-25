<h1 align="center">Welcome to Baguette# (in OCaml) 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-0.1-blue.svg?cacheSeconds=2592000" />
  <a href="#" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
</p>

> Baguette# is back! Now in OCaml, using https://dev.to/nt591/writing-an-interpreter-in-ocaml-45hm and https://ruslanspivak.com/lsbasi-part1/ and friends support and help :heart:

## Histoire 
J'ai repris ce projet début 2022, il sert de TIPE ENS et Tétraconcours ( je suis en prépa ) pour illustrer la théorie des langages formels de manière plus ludique, pour sa manière ludique de jouer avec... des pâtisseries! Je fais la base du langage : le lexer (l'algorithme qui transforme le texte brute en liste de token plus facile à travailler) est prêt.

En ce moment je travaille le parser, il sert à transformer la liste de token en un arbre de syntaxe abstraite ( AST en anglais ) qui va permettre d'interpréter le langage après, l'algorithme s'occupe de transformer une liste en un arbre avec les fonctions/opérateurs et leurs arguments ( qui peuvent aussi être des fonctions )

Suivra l'interpréteur !

## Install

```sh
dune build .
```

## Usage

```sh
dune exec 
```

## Run tests

```sh
dune runtest
```

## Author

👤 **Charlotte Thomas**

* Github: [@coco33920](https://github.com/coco33920)

## Show your support

Give a ⭐️ if this project helped you!

***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_