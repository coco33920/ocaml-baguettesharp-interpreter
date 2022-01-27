open Baguette_sharp
include Token 
include Parser
include Lexer
include Interpreter

let usage_message = "baguette-sharp <filename>";;
let input_file = ref "";;

let anon_fun filename = input_file := filename;;

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

let () = 
  Arg.parse [] anon_fun usage_message;
  let lines = read_file !input_file in 
  let str = String.concat " " lines in
  let token_list = Lexer.generate_token str in
  if (not (Lexer.validate_parenthesis_and_quote token_list)) then failwith "parenthésage invalide"
  else (
    let ast = Parser.parse_file token_list in 
    let _ = Interpreter.runtime ast in ()
  );;