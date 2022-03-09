open Baguette_base
open Baguette_sharp
include Lexer
include Token
include Parser
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

let lex_normal_file_verbously file =
  let src = read_file file |> List.map String.trim |> String.concat " " in
  print_endline "Input code : ";
  print_endline src;
  print_newline ();
  let token_list = Lexer.generate_token src in
  print_endline "Lexed code : ";
  print_newline ();
  Token.print_token_list token_list;
  token_list;;


let lex_char_file_verbously file =
  let src = read_file file |> List.map String.trim |> String.concat " " in 
  let token_list = Lexer.generate_token_with_chars src in
  print_newline ();
  print_endline "Lexed code with chars : ";
  print_newline ();
  Token.print_token_list token_list;
  token_list;;


let () = 
  print_endline "Please enter the file name to test";
  let filename = read_line() in
  let t = Sys.time() in
  let normaltokenlist = lex_normal_file_verbously filename in
  let total_time_1 = (Sys.time() -. t) in
  let t2 = Sys.time() in
  let chartokenlist = lex_char_file_verbously filename in
  let total_time_2 = (Sys.time() -. t2) in
  let t3 = Sys.time() in
  let normalast = Parser.parse_file normaltokenlist in
  let total_time_3 = (Sys.time() -. t3) in
  print_newline ();
  print_endline "Normal AST";
  List.iter (fun c -> print_endline(Parser.print_pretty_node c)) normalast;
  print_newline ();
  let t4 = Sys.time() in
  let newast = Parser.parse_file chartokenlist in
  let total_time_4 = (Sys.time() -. t4) in
  print_endline "New AST";
  List.iter (fun c -> print_endline(Parser.print_pretty_node c)) newast;
  print_newline ();
  print_newline ();
  print_endline "Normal AST Runtime";
  Interpreter.runtime normalast |> ignore;
  print_newline ();
  print_newline ();
  print_endline "New AST Running";
  Interpreter.runtime newast |> ignore;
  print_newline ();
  print_newline ();
  print_endline "\027[1;38;2;244;0;0m #### Rapport ####\027[m";
  print_newline ();
  Printf.printf "Normal lexer took \027[38;2;114;113;0m%fms\027[m\n" (1000. *. total_time_1);
  Printf.printf "Char lexer took \027[38;2;114;113;0m%fms\027[m\n" (1000. *. total_time_2);
  Printf.printf "Normal lexer is \027[1;38;2;244;0;0m%f times faster\027[m\n" (total_time_2 /. total_time_1);
  Printf.printf "Normal Parsing took \027[38;2;114;113;0m%fms\027[m\n" (1000. *. total_time_3);
  Printf.printf "Char parsing took \027[38;2;114;113;0m%fms\027[m\n" (1000. *. total_time_4);
  Printf.printf "Char parsing is \027[1;38;2;244;0;0m%f times faster\027[m\n" (total_time_3 /. total_time_4);
  Printf.printf "Normal total time is \027[38;2;114;113;0m%fms\027[m\n" (1000. *. (total_time_1 +. total_time_3));
  Printf.printf "Char total time is \027[38;2;114;113;0m%fms\027[m\n" (1000. *. (total_time_4 +. total_time_2));
  Printf.printf "Normal is \027[1;38;2;244;0;0m%f times faster\027[m\n" 
                ((total_time_2 +. total_time_4) /. (total_time_1 +. total_time_3));






