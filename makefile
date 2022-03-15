html-documentation:
	dune build @doc
	cp -R _build/default/_doc/_html/* docs/doc/
	dune clean