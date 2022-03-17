#!/usr/bin/sh
wget https://github.com/coco33920/ocaml-baguettesharp-interpreter/releases/latest/download/baguette.linux64
mv baguette.linux64 ~/.local/bin/baguette_sharp #par exemple pour l'avoir dans $PATH 
chmod +x ~/.local/bin/baguette_sharp #pour être executable
baguette_sharp #lance le REPL
