open Baguette_sharp
include Lexer
include Token
include Parser
include Interpreter

let str = "PAINAUCHOCOLAT CHOUQUETTE PARISBREST %dHello %d! PARISBREST 1 PARISBREST World PARISBREST CLAFOUTIS BAGUETTE"
let () = print_string "Affichage de la ligne de code"; print_newline (); print_string str; print_newline (); print_newline ()

let print_token_list list =
  let rec str acc list = 
    match list with
      | [] -> acc
      | t::q -> str (acc ^ (Token.token_to_string t) ^ " ") q
  in let s = str "[" list in print_string (s ^ "]");;

let token_list = Lexer.generate_token str

let () = print_string "Affichage de la liste de token après le tokenizer"; print_newline (); print_token_list (token_list); print_newline (); print_newline ()

let () = print_string "Vérification du parenthésage et des quote"; print_newline ()
let () = if Lexer.validate_parenthesis_and_quote token_list then print_string "Parenthesage valide" else failwith "parenthesage invalide"; print_newline (); print_newline ()
let array = Array.of_list token_list

let ast = Parser.parse_line token_list

let () = print_string "Vérification du parsing"; print_newline()

let () = print_string (Parser.print_pretty_node (Array.of_list ast).(0)); print_newline (); print_newline ()

let () = print_string "Test de l'interpréteur"; print_newline ()

let _ = Interpreter.exec_node (List.hd ast)

