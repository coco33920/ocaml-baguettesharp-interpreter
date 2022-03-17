opam install -y linenoise fmt
git clone https://github.com/coco33920/ocaml-baguettesharp-interpreter
cd ocaml-baguettesharp-interpreter
dune build @install 
dune install
