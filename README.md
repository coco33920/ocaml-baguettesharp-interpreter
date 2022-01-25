<h1 align="center">The Baguette# OCaml Interpreter</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-0.1-blue.svg?cacheSeconds=2592000" />
  <a href="#" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
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
## Histoire 
J'ai repris ce projet début 2022, il sert de TIPE ENS et Tétraconcours ( je suis en prépa ) pour illustrer la théorie des langages formels de manière plus ludique, pour sa manière ludique de jouer avec... des pâtisseries! Je fais la base du langage : le lexer (l'algorithme qui transforme le texte brute en liste de token plus facile à travailler) est prêt.

En ce moment je travaille le parser, il sert à transformer la liste de token en un arbre de syntaxe abstraite ( AST en anglais ) qui va permettre d'interpréter le langage après, l'algorithme s'occupe de transformer une liste en un arbre avec les fonctions/opérateurs et leurs arguments ( qui peuvent aussi être des fonctions )

Suivra l'interpréteur !

## Installation

```sh
dune build .
```

## Utilisation

```sh
dune exec 
```

## Test

```sh
dune runtest
```

À venir..... la documentation!