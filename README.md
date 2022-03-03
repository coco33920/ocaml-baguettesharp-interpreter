<h1 align="center">The Baguette# OCaml Interpreter</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-2.0-blue.svg?cacheSeconds=2592000" />
  <img alt="s" src="https://wakatime.com/badge/github/coco33920/ocaml-baguettesharp-interpreter.svg" />
  <a href="#" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
  <a href="README_en.md">
    <img alt="GB" src="https://flagicons.lipis.dev/flags/4x3/gb.svg" width="30px">
  </a>
</p>

<h1 align="center">
    <br>
    <img src="https://i.imgur.com/iBSb0Fh.png" alt="Baguette#" width="540">
    <br>
    Baguette#
    <br>
</h1>
<h4 align="center">Baguette# est de retour..... En OCaml !</h4>

## Pré-requis 
Ocaml version >= 4.13.1,modules fmt,str et linenoise ( pour le REPL )

```sh
opam install fmt str linenoise
```


## Histoire 

J'ai repris ce projet début 2022, il sert de TIPE ENS et Tétraconcours ( je suis en prépa ) pour illustrer la théorie des langages formels de manière plus ludique, pour sa manière ludique de jouer avec... des pâtisseries!

Le parser est fini, il sert à transformer la liste de token en un arbre de syntaxe abstraite ( AST en anglais ) qui va permettre d'interpréter le langage après, l'algorithme s'occupe de transformer une liste en un arbre avec les fonctions/opérateurs et leurs arguments ( qui peuvent aussi être des fonctions ) ainsi que l'interpréteur qui prend l'AST et interprète le langage, le travail porte maintenant sur la partie théorique (turing-completeness) et la partie compilateur.

La syntaxe est proche du BASIC mais sans les boucles explicite ( on peut les faire... mais il faut vous débrouiller ;) )

## Support

Actuellement l'interpréteur supporte les entier, les flottant, les chaînes de caractères, les booleans, les conditions simple, le retour à une ligne antérieure/postérieure et les if/else et implémente les fonctions
standard précédemment implémentées dans la version en GO
La grammaire est identique, chaque mot/symbole est séparé d'un espace et chaque symbole et fonction ont un nom de pâtisserie/viennoiserie/sucrerie française ou non.

Les keywords sont simple (voir le WIKI) et ne sont pas suivi de parenthèse ( comme le LABEL par exemple )

## Installation

```sh
dune build .
```

## Utilisation

```sh
dune exec baguette_sharp_interpreter
```

## Test

```sh
dune runtest
```

Voir le WIKI ( en anglais ) pour des informations plus détaillées