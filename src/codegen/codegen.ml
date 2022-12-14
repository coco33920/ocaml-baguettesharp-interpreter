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

let std () = 
  let f = define_function "CANELE" (function_type int_type [|int_type;int_type|]) the_module
  in let bb = append_block context "entry" f in
  position_at_end bb builder;
  let ret_val = build_add  (const_int int_type 7) "addtmp" builder in 
  let _ = build_ret ret_val builder in 
  f

let rec codegen_args = function
  | Parser.Argument (I i) -> const_int int_type i
  | Parser.Argument (D d) -> const_float float_type d
  | Parser.Argument (Str s) -> construct_string s
  | Parser.Argument (Bool b) -> const_int bool_type (if b then 1 else 0)
  | Parser.Argument (Nul ()) -> const_int int_type 0
  | _ -> const_null nul

let rec codegen_call name param = 
  let c = lookup_function name the_module in
  let c = match c with 
    Some s -> s
    | None -> raise (Error ("function "^name^" unknown")) in
  let args = List.map codegen_ast param in
  let args = Array.of_list args in
  
  build_call c args "calltmp" builder

  and codegen_ast = function
  | Parser.Node (Parser.Argument a, _) -> codegen_args (Parser.Argument a)
  | Parser.Node (Parser.Exception e, _) -> failwith ("error "^e#to_string)
  | Parser.Node (Parser.CallExpression s, d) -> codegen_call s d
  | _ -> failwith "not implemented yet";;

let () = let x = std () in dump_value x;;
let () = print_endline "Ligne de code : ";;

let b = read_line () in
let a = parse_line b in
print_endline (Parser.print_pretty_node a);
dump_value (codegen_ast a)
