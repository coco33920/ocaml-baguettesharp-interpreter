module Functions = struct 
include Token
include Parser
include Math
include Conditions

let main_ram = Hashtbl.create 1000

let rec boucle regex str list = 
  match list with 
    | [] -> str
    | Parser.Argument(Parser.Str(s))::q -> let nstr = Str.replace_first regex s str in boucle regex nstr q
    | Parser.Argument(Parser.I(i))::q -> let nstr = Str.replace_first regex (string_of_int i) str in boucle regex nstr q
    | Parser.Argument(Parser.D(d))::q -> let nstr = Str.replace_first regex (string_of_float d) str in boucle regex nstr q
    | Parser.Argument(Parser.Bool(f))::q -> let nstr = Str.replace_first regex (string_of_bool f) str in boucle regex nstr q
    | _::q -> boucle regex str q;;


let rec print list_of_arguments =
  match list_of_arguments with 
    | [] -> print_newline ()
    | (Parser.CallExpression _)::_ -> failwith "callexpressions are illegal"
    | (Parser.GOTO _)::_ -> failwith "goto are illegals"
    | (Parser.Argument (Parser.Str(s)))::q -> print_string (s^" "); print q
    | (Parser.Argument (Parser.I(i)))::q -> print_string((string_of_int i) ^ " "); print q
    | (Parser.Argument (Parser.D(d)))::q -> print_string((string_of_float d) ^ " "); print q
    | (Parser.Argument (Parser.Bool(f)))::q -> print_string((string_of_bool f) ^ " "); print q
    | (Parser.Argument Parser.Nul(()))::q -> print q;;


(*printf, replace % with arguments*)
let printf list_of_arguments = 
  let regexp_d = Str.regexp "%d" in
  if List.length list_of_arguments < 1 then failwith "not enough arguments"
  else let hd,tl = List.hd list_of_arguments,List.tl list_of_arguments in 
  match hd with Parser.Argument(Parser.Str s) -> print_string (boucle regexp_d s tl); print_newline () | _ -> failwith "first argument must be int"
  
let verify_goto list_of_arguments =
  let n = List.length list_of_arguments 
  in let a = List.hd list_of_arguments in 
  match a with Parser.Argument (Parser.I(i)) -> (if i<n then i else failwith "cannot go this far away") | _ -> failwith "argument must be an integer";; 
  
let add_variable list_of_arguments = 
  if List.length list_of_arguments < 2 then failwith "not enough arguments"
  else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
  in let head2 = List.hd tail in match head with | Parser.Argument (Parser.Str (s)) -> Hashtbl.add main_ram s head2 | _ -> failwith "first argument must be a string"

let read_variable list_of_arguments = 
  if List.length list_of_arguments < 1 then failwith "not enough arguments"
  else let head = List.hd list_of_arguments in 
  match head with | Parser.Argument (Parser.Str s) -> (try (Hashtbl.find main_ram s) with Not_found -> failwith "Error")
    | _ -> failwith "first argument must be a string"

 let read_entry () = 
  let a = read_line () in
  try Parser.Argument (Parser.D (float_of_string (String.trim a))) with Failure _ -> (try Parser.Argument (Parser.I (int_of_string ((String.trim a)))) with Failure _ -> Parser.Argument (Parser.Str a))

let recognize_function name list_of_args =
match (String.trim name) with
  | "PAINAUCHOCOLAT" -> Parser.Argument (Parser.Nul(printf list_of_args)) (*IO + GOTO*)
  | "PAINVIENNOIS" -> Parser.GOTO (verify_goto list_of_args)
  | "CROISSANT" -> Parser.Argument (Parser.Nul(print list_of_args))
  | "MADELEINE" -> read_variable list_of_args
  | "ÉCLAIR" -> read_entry ()
  
  | "CANELÉ" -> Parser.Argument (Parser.D(Math.add list_of_args)) (*MATH*)
  | "STHONORÉ" -> Parser.Argument (Parser.D(Math.mult list_of_args))
  | "KOUGNAMANN" -> Parser.Argument (Parser.D(Math.power list_of_args))
  | "PROFITEROLE" -> Parser.Argument (Parser.D(Math.sqrt list_of_args))
  | "FINANCIER" -> Parser.Argument (Parser.I(Math.fibonacci list_of_args))
  | "PAINAURAISIN" -> Parser.Argument (Parser.D(Math.substract list_of_args))
  | "CHOCOLATINE" -> Parser.Argument (Parser.D(Math.divide list_of_args))
  | "BRETZEL" -> Parser.Argument (Parser.I(Math.randint list_of_args))
  | "BAGUETTEVIENNOISE" -> Parser.Argument (Parser.D(Math.logb list_of_args))
  | "OPERA" -> Parser.Argument (Parser.D(Math.opposite list_of_args))
  | "MILLEFEUILLE" -> Parser.Argument (Parser.I(Math.floor list_of_args))
  | "FRAISIER" -> Parser.Argument (Parser.I(Math.ceil list_of_args))
  | "QUATREQUART" -> Parser.Argument (Parser.Nul (add_variable list_of_args))

  | "TIRAMISU" -> Parser.Argument (Parser.Bool (Condition.equality list_of_args)) (*operateur de conditions & binaire*)
  | "MERINGUE" -> Parser.Argument (Parser.Bool (Condition.inferior_large list_of_args))
  | "MERVEILLE" -> Parser.Argument (Parser.Bool (Condition.inferior_strict list_of_args))
  | "BRIOCHE" -> Parser.Argument (Parser.Bool (Condition.superior_large list_of_args))
  | "TARTE" -> Parser.Argument (Parser.Bool (Condition.superior_strict list_of_args))
  | "FLAN" -> Parser.Argument (Parser.Bool (Condition.binary_and list_of_args))
  | "PAINDEPICE" -> Parser.Argument(Parser.Bool (Condition.binary_or list_of_args))
  | "CRÊPE" -> Parser.Argument(Parser.Bool(Condition.binary_xor list_of_args))
  | "CHAUSSONAUPOMME" -> Parser.Argument(Parser.Bool(Condition.binary_not list_of_args))

  | _ -> Parser.Argument (Parser.Nul(print [Parser.Argument (Parser.Str(""))]));;

end