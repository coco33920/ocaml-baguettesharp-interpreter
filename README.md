<h1 align="center">The Baguette# OCaml Interpreter</h1>
<div align="center">
<p>
  <a href="https://github.com/coco33920/ocaml-baguettesharp-interpreter" title="Go to GitHub repo"><img src="https://img.shields.io/static/v1?label=coco33920&message=ocaml-baguettesharp-interpreter&color=55cdfc&logo=github&style=for-the-badge" alt="coco33920 - ocaml-baguettesharp-interpreter"></a>
  <a href="https://github.com/coco33920/ocaml-baguettesharp-interpreter/releases/"><img src="https://img.shields.io/github/release/coco33920/ocaml-baguettesharp-interpreter?include_prereleases=&sort=semver&color=55cdfc&style=for-the-badge" alt="GitHub release"></a>
<a href="#license"><img src="https://img.shields.io/badge/License-MIT-55cdfc?style=for-the-badge" alt="License"></a>
  <div align="center">
  <a href="README_en.md">
    <img alt="GB" src="https://flagicons.lipis.dev/flags/4x3/gb.svg" width="30px" title="english-readme">
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
<img src="https://img.shields.io/badge/Usage-Wiki-f7a8d8?style=for-the-badge">
</a>
<a href="https://www.baguettesharp.fr">
    <img alt="b#" src="https://img.shields.io/badge/Website-Baguette%23-f7a8d8?style=for-the-badge">
  </a>
<a href="https://doc.baguettesharp.fr">
    <img alt="b#" src="https://img.shields.io/badge/API-Documentation-f7a8d8?style=for-the-badge">
  </a>
</div>
<h4 align="center">Baguette# est de retour..... En OCaml !</h4>

## Pré-requis 
Ocaml version >= 4.13.1,modules fmt,str et linenoise ( pour le REPL )

```sh
opam install fmt str linenoise
```

## Installation

### Binaires pré-compilées
**Téléchargement automatique** des binaire pour linux x86_64 (dernière version).
```bash
curl https://raw.githubusercontent.com/coco33920/ocaml-baguettesharp-interpreter/master/download.sh | sh
```
le script télécharge la dernière version, l'installe sous `~/.local/bin/baguette_sharp` et le rend éxecutable
alternativement vous pouvez faire
```bash
wget https://raw.githubusercontent.com/coco33920/ocaml-baguettesharp-interpreter/master/download.sh
sh download.sh
```
ou encore juste éxecuter le script
```bash
wget https://github.com/coco33920/ocaml-baguettesharp-interpreter/releases/latest/download/baguette.linux64
mv baguette.linux64 ~/.local/bin/baguette_sharp #par exemple pour l'avoir dans $PATH 
chmod +x ~/.local/bin/baguette_sharp #pour être executable
```

### OPAM
Build la dernière version stable depuis OPAM `opam install baguette_sharp` compile et installe la dernière version OPAM
de baguette_sharp sous `baguette_sharp.repl`

### Source
Pour installer depuis les sources il faut installer d'abord les dépendances `opam install fmt linenoise` et avoir OCaml >= 4.13.1
Installation depuis les sources automatiques (avec installations de dépendances) :
```curl
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
dune install
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