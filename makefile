install:
	dune build @install
	cp _build/default/src/main/baguette_sharp_interpreter.exe bin/linux/baguette#.linux64
html-documentation:
	dune build @doc
	cp -R _build/default/_doc/_html/* docs/doc/
	dune clean
