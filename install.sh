#!/bin/bash
dune build
cp _build/default/src/main/baguette_sharp_interpreter.exe baguette_sharp
cp baguette_sharp bin/linux/baguette#.linux64