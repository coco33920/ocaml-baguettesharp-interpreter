open Monkey
include Lexer
include Token
include Parser

let print_token_list list =
  let rec str acc list = 
    match list with
      | [] -> acc
      | t::q -> str (acc ^ (Token.token_to_string t) ^ " ") q
  in let s = str "[" list in print_string (s ^ "]");;

let token_list = Lexer.generate_token "CHOUQUETTE PARISBREST lol 3 pdpkdqopdq 45 () () () ) CHOUQUETTE PARISBREST CLAFOUTIS"

let () = print_token_list (token_list)
let () = print_newline ();;

let () = print_string "Vérification du parenthésage et des quote"; print_newline ()
let () = if Lexer.validate_parenthesis_and_quote token_list then print_string "yay" else failwith "parenthesage invalide"; print_newline ()
let array = Array.of_list token_list

let () = print_string "Vérification du parsing d'un string entre \""; print_newline ()
let a,b = Parser.parse_string 1 array;;
let () = print_string a; print_newline ();  print_int b