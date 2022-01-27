open Baguette_sharp
include Lexer
include Token
include Parser
include Interpreter

(**)
let str = "CROISSANT CHOUQUETTE CANELÉ CHOUQUETTE 2 3 12 20 CLAFOUTIS CLAFOUTIS BAGUETTE PAINAUCHOCOLAT CHOUQUETTE PARISBREST %dHello %d! PARISBREST 1 PARISBREST World PARISBREST CLAFOUTIS BAGUETTE CROISSANT CHOUQUETTE CANELÉ CHOUQUETTE 2 3 12 20 CLAFOUTIS CLAFOUTIS BAGUETTE 1 3 4 5"
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

let new_ast = Parser.parse_file token_list

let () = print_string "Vérification du parsing"; print_newline()

let () = print_int (List.length new_ast); print_newline ()
let funct a = print_string (Parser.print_pretty_node a); print_newline (); print_newline ()
let _ = List.map funct new_ast;;

let () = print_string "Test de l'interpréteur"; print_newline ()

(*let _ = Interpreter.exec_node (List.hd new_ast)*)
let _ = Interpreter.runtime new_ast

