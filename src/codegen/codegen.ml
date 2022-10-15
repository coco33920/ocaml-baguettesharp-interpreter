print_endline "test"

open Llvm
open! Baguette_sharp

exception Error of string

let read_file filename =
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true do
      let a = input_line chan in
      if not (String.starts_with ~prefix:"//" a) then lines := a :: !lines
    done;
    !lines
  with End_of_file ->
    close_in chan;
    List.rev !lines

let parse_line file =
  let str = [ file ] |> List.map String.trim |> String.concat " " in
  let token_list = Lexer.generate_token str in
  let a = Lexer.validate_parenthesis_and_quote token_list in
  match a with
  | Exception s -> failwith ("error" ^ s#to_string)
  | _ -> List.hd (Parser.parse_file token_list)

let context = global_context ()
let the_module = create_module context "testcompiler"
let builder = builder context
let int_type = i32_type context
let float_type = double_type context
let bool_type = i1_type context
let nul = void_type context
let construct_string str = const_string context str
let named_values : (string, llvalue) Hashtbl.t = Hashtbl.create 10
let variables = Functions.main_ram
let labels = Hashtbl.create 100
let functions = Hashtbl.create 100

let rec codegen_expr = function
  | Parser.Argument (I i) -> const_int int_type i
  | Parser.Argument (D d) -> const_float float_type d
  | Parser.Argument (Str s) -> construct_string s
  | _ -> const_null nul

let codegen_ast = function
  | Parser.Node (Parser.Argument a, _) -> codegen_expr (Parser.Argument a)
  | _ -> failwith "not implemented yet"

let () = print_endline "Ligne de code : ";;

let b = read_line () in
let a = parse_line b in
print_endline (Parser.print_pretty_node a);
dump_value (codegen_ast a)
