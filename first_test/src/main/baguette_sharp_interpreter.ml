open Baguette_sharp
include Token 
include Parser
include Lexer
include Interpreter

let usage_message = "baguette-sharp -input <filename>";;
let input_file = ref "";;
let repl = ref false;;

let spec = [("-repl", Arg.Set repl, "lance le repl"); ("-input", Arg.Set_string input_file, "precise le fichier à lancer")]

let anon_fun (_ : string) = ()

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
  let lines = read_file file in 
  let str = String.concat " " lines in
  let token_list = Lexer.generate_token str in
  if (not (Lexer.validate_parenthesis_and_quote token_list)) then failwith "parenthésage invalide"
  else (
    let ast = Parser.parse_file token_list in 
    let _ = Interpreter.runtime ast in ()
  );;

let parse_line line = 
  let str = line in
  let token_list = Lexer.generate_token str in 
  if (not (Lexer.validate_parenthesis_and_quote token_list)) then print_string "parenthésage invalide"
  else (
    let ast = Parser.parse_file token_list in
    let _ = Interpreter.runtime ast in ()
  );;



let display_help () =
  print_string "### Baguette# Interpreter REPL Command Help ###";
  print_newline ();
  print_string "~ help: show this help"; print_newline();
  print_string "~ load <file>: load and execute a baguette file"; print_newline ();
  print_string "~ exit: exit the REPL"; print_newline ();
  print_string "~ save <file>: save all commands in file"; print_newline ();;

let load_file lst = 
  if List.length lst < 2 then print_string "not enough args"
  else (
    let tl = List.tl lst in let file = List.hd tl in parse_file file
  );;
let write_commands lst lines = 
  if List.length lst < 2 then print_string "not enough args"
  else (
    let tl = List.tl lst in let file = List.hd tl in let chan_out = open_out file in
    let rec aux lst = 
      match lst with 
        | [] -> ()
        | t::q -> Printf.fprintf chan_out "%s\n" t; flush chan_out; aux q
    in aux lines
  );;
  

 let repl_func () = 
  print_string "### Welcome to Baguette# REPL; type help for help ###"; print_newline ();
  let cmd = ref [] in
  while true do 
    let () = Printf.printf "> %!" in
    let a = read_line () in let lst = String.split_on_char ' ' a in
    match String.trim(List.hd lst) with 
      | "help" -> display_help ()
      | "load" -> load_file lst
      | "exit" -> failwith "fin du programme"
      | "save" -> write_commands lst !cmd
      | _ -> cmd := a::!cmd; parse_line a
  done;
  ();;

let () = 
  Arg.parse spec anon_fun usage_message;
  if !repl then repl_func () else parse_file !input_file;;