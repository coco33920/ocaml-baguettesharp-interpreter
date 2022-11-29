(lang dune 3.0)
(name baguette_sharp)
(version 2.1)
(generate_opam_files false)

(source
 (github coco33920/ocaml-baguettesharp-interpreter))

(authors "Charlotte Thomas")

(maintainers "Charlotte Thomas")

(license MIT)

(documentation https://github.com/coco33920/ocaml-baguettesharp-interpreter/wiki)
(package
 (name baguette_sharp)
 (allow_empty)
 (homepage https://baguettesharp.fr)
 (synopsis "The Baguette# Interpreter REPL")
 (description "The REPL for Baguette#")
 (depends
 {"ocaml">=4.13.1})
 )
