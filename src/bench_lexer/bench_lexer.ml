open Baguette_base
include Lexer
include Token
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
  Token.print_token_list token_list;;


let lex_char_file_verbously file =
  let src = read_file file |> List.map String.trim |> String.concat " " in 
  let token_list = Lexer.generate_token_with_chars src in
  print_endline "Lexed code with chars : ";
  print_newline ();
  Token.print_token_list token_list;;


let () = 
  print_endline "Please enter the file name to test";
  let filename = read_line() in
  let t = Sys.time() in
  lex_normal_file_verbously filename;
  let total_time_1 = (Sys.time() -. t) in
  let t2 = Sys.time() in
  lex_char_file_verbously filename;
  let total_time_2 = (Sys.time() -. t2) in
  print_newline ();
  print_newline ();
  print_endline "\027[1;38;2;244;0;0m #### Rapport ####\027[m";
  print_newline ();
  Printf.printf "Normal lexer took \027[38;2;114;113;0m%fms\027[m\n" total_time_1;
  Printf.printf "Char lexer took \027[38;2;114;113;0m%fms\027[m\n" total_time_2;
  Printf.printf "Normal lexer is \027[1;38;2;244;0;0m%f times faster\027[m" (total_time_2 /. total_time_1);


