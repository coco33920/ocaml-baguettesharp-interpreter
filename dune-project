(lang dune 2.0)

(name baguette-sharp)
(version 2.0.2)
(generate_opam_files true)

(source
 (github coco33920/ocaml-baguettesharp-interpreter))

(authors "Charlotte Thomas")

(maintainers "Charlotte Thomas")

(license MIT)

(documentation https://github.com/coco33920/ocaml-baguettesharp-interpreter/wiki)

(package
 (name baguette-sharp)
 (homepage https://baguettesharp.fr)
 (synopsis "The Baguette# Interpreter Binary")
 (description "The REPL binaries for Baguette#")
 (depends ocaml dune fmt str linenoise baguette_sharp)
 )
