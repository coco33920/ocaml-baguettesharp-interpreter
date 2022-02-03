module Functions = struct 
open Baguette_base
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
    | [] -> Parser.Argument(Parser.Nul(print_newline ()))
    | Parser.CallExpression _::_ -> Parser.Exception "callexpressions are illegal"
    | Parser.GOTO _::_ -> Parser.Exception "goto are illegals"
    | Parser.Argument Parser.Str s::q -> print_string (s^" "); print q
    | Parser.Argument Parser.I i::q -> print_string((string_of_int i) ^ " "); print q
    | Parser.Argument Parser.D d::q -> print_string((string_of_float d) ^ " "); print q
    | Parser.Argument Parser.Bool f::q -> print_string((string_of_bool f) ^ " "); print q
    | Parser.Argument Parser.Nul ()::q -> print q
    | _ -> Parser.Exception "error";;


(*printf, replace % with arguments*)
let printf list_of_arguments = 
  let regexp_d = Str.regexp "%d" in
  if List.length list_of_arguments < 1 then Parser.Exception "not enough arguments"
  else let hd,tl = List.hd list_of_arguments,List.tl list_of_arguments in 
  match hd with Parser.Argument(Parser.Str s) -> print_string (boucle regexp_d s tl); Parser.Argument(Parser.Nul(print_newline ())) | _ -> Parser.Exception "first argument must be int"
  
let verify_goto list_of_arguments =
  let a = List.hd list_of_arguments in 
  match a with Parser.Argument(Parser.I i) -> Parser.GOTO i | _ -> Parser.Exception "argument must be an integer";; 
  
let add_variable list_of_arguments = 
  if List.length list_of_arguments < 2 then Parser.Exception "not enough arguments"
  else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
  in let head2 = List.hd tail in match head with | Parser.Argument (Parser.Str (s)) -> Hashtbl.add main_ram s head2; Parser.Argument(Parser.Nul ()) | _ -> Parser.Exception "first argument must be a string"

let read_variable list_of_arguments = 
  if List.length list_of_arguments < 1 then Parser.Exception "not enough arguments"
  else let head = List.hd list_of_arguments in 
  match head with | Parser.Argument (Parser.Str s) -> (try (Hashtbl.find main_ram s) with Not_found -> Parser.Exception "This variable does not exists")
    | _ -> Parser.Exception "first argument must be a string"

 let read_entry () = 
  let a = read_line () in
  try Parser.create_float_argument (float_of_string (String.trim a)) with Failure _ -> (try (Parser.create_float_argument (float_of_string (String.trim a)) ) with Failure _ -> Parser.create_string_argument a)

let recognize_function name list_of_args =
match (String.trim name) with
  | "PAINAUCHOCOLAT" -> printf list_of_args (*IO + GOTO*)
  | "PAINVIENNOIS" -> verify_goto list_of_args
  | "CROISSANT" -> print list_of_args
  | "MADELEINE" -> read_variable list_of_args
  | "ECLAIR" -> read_entry ()
  
  | "CANELE" -> Math.add list_of_args (*MATH*)
  | "STHONORE" -> Math.mult list_of_args
  | "KOUGNAMANN" -> Math.power list_of_args
  | "PROFITEROLE" -> Math.sqrt list_of_args
  | "FINANCIER" -> Math.fibonacci list_of_args
  | "PAINAURAISIN" -> Math.substract list_of_args
  | "CHOCOLATINE" -> Math.divide list_of_args
  | "BRETZEL" -> Math.randint list_of_args
  | "BAGUETTEVIENNOISE" -> Math.logb list_of_args
  | "OPERA" -> Math.opposite list_of_args
  | "MILLEFEUILLE" -> Math.floor list_of_args
  | "FRAISIER" -> Math.ceil list_of_args
  | "QUATREQUART" -> add_variable list_of_args

  | "TIRAMISU" -> Condition.equality list_of_args (*operateur de conditions & binaire*)
  | "MERINGUE" -> Condition.inferior_large list_of_args
  | "MERVEILLE" -> Condition.inferior_strict list_of_args
  | "BRIOCHE" -> Condition.superior_large list_of_args
  | "TARTE" -> Condition.superior_strict list_of_args
  | "FLAN" -> Condition.binary_and list_of_args
  | "PAINDEPICE" -> Condition.binary_or list_of_args
  | "CREPE" -> Condition.binary_xor list_of_args
  | "CHAUSSONAUXPOMMES" -> Condition.binary_not list_of_args
  | "SABLE" -> Condition.if_funct list_of_args

  | _ -> Exception "unknown function";;



end