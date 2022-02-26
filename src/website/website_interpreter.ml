open Baguette_sharp
open Baguette_base
open Js_of_ocaml
include Token 
include Parser
include Lexer
include Interpreter

let read_file filename = 
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true; do
      let a = input_line chan in if not (String.starts_with ~prefix:"//" a) then lines := a :: !lines
    done; !lines
  with End_of_file ->
    close_in chan;
    List.rev !lines ;;

let parse_file file = 
  let str = read_file file |> List.map String.trim |> String.concat " " in
  let token_list = Lexer.generate_token str in
  let a = Lexer.validate_parenthesis_and_quote token_list in 
  match a with 
    | Exception s -> print_string s
    | _ -> Parser.parse_file token_list |> Interpreter.runtime |> ignore;;

let parse_line line = 
  let str = String.trim line in
  let token_list = Lexer.generate_token str in
  let a = Lexer.validate_parenthesis_and_quote token_list in 
  match a with 
    | Exception s -> print_string s; Hashtbl.create 1
    | _ -> Parser.parse_file token_list |> Interpreter.runtime;;

let fuse_hash_tbl original new_one = 
  Hashtbl.iter (fun a b -> Hashtbl.add original a b) new_one;;

let load_file lst = 
  if List.length lst < 2 then print_endline "not enough args"
  else (
    let tl = List.tl lst in let file = List.hd tl in parse_file file
  );;

let execute_line str = 
  let str = String.trim str in 
  let token_list = Lexer.generate_token str in 
  let a = Lexer.validate_parenthesis_and_quote token_list in 
  match a with 
    | Exception s -> print_endline s
    | _ -> Parser.parse_file token_list |> Interpreter.runtime |> ignore;;
let interpret_file filename = 
  print_endline "hello world from interpreter";
  parse_file filename;;

let _ =
  print_endline "test";
  Js.export_all
    (object%js
      method add x y = x +. y
      method helloworld s = print_endline (Js.to_string s)
      method interpret fn = fn |> Js.to_string |> interpret_file |> ignore
      method call_line str = str |> Js.to_string |> execute_line;
      
  end);;