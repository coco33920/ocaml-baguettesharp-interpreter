open Monkey
include Lexer
include Token

let print_token_list list =
  let rec str acc list = 
    match list with
      | [] -> acc
      | t::q -> str (acc ^ (Token.token_to_string t) ^ " ") q
  in let s = str "[" list in print_string (s ^ "]");;

let token_list = Lexer.generate_token "CHOUQUETTE PARISBREST lol 3 PARISBREST CLAFOUTIS"

let () = print_token_list (token_list)
let () = print_newline ();;

let () = if Lexer.validate_parenthesis token_list then print_string "yay" else failwith "parenthesage invalide"
