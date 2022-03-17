let read_file filename = 
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true; do
      let a = input_line chan in if not (String.starts_with ~prefix:"//" a) then lines := a :: !lines
    done; !lines
  with End_of_file ->
    close_in chan;
    List.rev !lines;;

let t file = 
  let src = read_file file |> List.map String.trim |> String.concat " " in
  let temp_file = Filename.temp_file "baguette" "sharp.ml" in 
  let chan = open_out temp_file in
    output_string chan ("open Baguette_sharp\n");
    output_string chan (Printf.sprintf "let src = \"%s\";;\n" src);
    output_string chan (Printf.sprintf "Lexer.generate_token src |> Parser.parse_file |> Interpreter.runtime |> ignore;;");
    flush chan;
    temp_file;;  
    
let compile file =
  Sys.command (Printf.sprintf "ocamlfind ocamlopt -package baguette_sharp -linkpkg %s -o out" file)