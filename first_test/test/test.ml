open Baguette_sharp
include Lexer
include Token
include Parser
include Interpreter
let str = "CROISSANT CHOUQUETTE CANELÉ CHOUQUETTE 2 3 12 20 CLAFOUTIS CLAFOUTIS BAGUETTE"

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

let () = print_string "Vérification du parsing d'un string entre \" "; print_newline ()

let rec i n lst = match (n,lst) with
  | n,_::q when n<1 -> i (n+1) q 
  | n,_::q when n=1 -> let a,_ = Parser.parse_string_rec q in a
  | _ -> "";;

let a = i 0 token_list;;
let () = print_string ("String calculé: "^ a); print_newline (); print_newline ()

let ast = Parser.parse_line token_list

let () = print_string (Parser.print_pretty_node (Array.of_list ast).(0)); print_newline (); print_newline ()

let () = print_string "Test de l'interpréteur"; print_newline (); print_newline ()

let _ = Interpreter.exec_node (List.hd ast)

