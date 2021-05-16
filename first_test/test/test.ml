open Monkey
include Lexer
include Token

let print_token_list list =
  let rec str acc list = 
    match list with
      | [] -> acc
      | t::q -> str (acc ^ (Token.token_to_string t) ^ " ") q
  in let s = str "[" list in print_string (s ^ "]");;

let () = print_token_list (Lexer.generate_token "CHOUQUETTE CLAFOUTIS PARISBREST lol 3 PARISBREST CLAFOUTIS")