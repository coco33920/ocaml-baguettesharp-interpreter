module Functions = struct 
open Baguette_base
include Token
include Parser
include Math
include Array_manipulation
include Conditions
include String_manipulation

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
    | [] -> Parser.Argument(Parser.Nul((print_newline ())))
    | Parser.CallExpression _::_ -> Parser.Exception (new Parser.syntax_error "callexpressions are illegal while printing")
    | Parser.GOTO _::_ -> Parser.Exception (new Parser.syntax_error "goto are illegal while printing")
    | Parser.Argument Parser.Str s::q -> print_string (s^" "); print q
    | Parser.Argument Parser.I i::q -> print_string((string_of_int i) ^ " "); print q
    | Parser.Argument Parser.D d::q -> print_string((string_of_float d) ^ " "); print q
    | Parser.Argument Parser.Bool f::q -> print_string((string_of_bool f) ^ " "); print q
    | Parser.Argument Parser.Nul ()::q -> print q
    | _ -> Parser.Exception (new Parser.type_error "the supplied type is not printable");;


(*printf, replace % with arguments*)
let printf list_of_arguments = 
  let regexp_d = Str.regexp "%d" in
  if List.length list_of_arguments < 1 then Parser.Exception (new Parser.arg ("This function requires one arguments and you supplied none"))
  else let hd,tl = List.hd list_of_arguments,List.tl list_of_arguments in 
  match hd with Parser.Argument(Parser.Str s) -> print_string (boucle regexp_d s tl); Parser.Argument(Parser.Nul(print_newline ())) | _ -> Parser.Exception (new Parser.type_error "first argument must be an integer")
    
let add_variable list_of_arguments = 
  if List.length list_of_arguments < 2 then Parser.Exception (new Parser.arg ("This function requires one arguments and you supplied none"))
  else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
  in let head2 = List.hd tail in match head with | Parser.Argument (Parser.Str (s)) -> Hashtbl.add main_ram s head2; Parser.Argument(Parser.Nul ()) | _ -> Parser.Exception (new Parser.type_error "first argument must be an integer")

let read_variable list_of_arguments = 
  if List.length list_of_arguments < 1 then Parser.Exception (new Parser.arg ("This function requires one arguments and you supplied none"))
  else let head = List.hd list_of_arguments in 
  match head with | Parser.Argument (Parser.Str s) -> (try (Hashtbl.find main_ram s) with Not_found -> Parser.Exception (new Parser.syntax_error "the variable do not exists"))
    | _ -> Parser.Exception ((new Parser.type_error "first argument must be a string"))

 let read_entry list_of_args =
  match list_of_args with 
  | [] -> (let a = read_line () in
  try Parser.create_float_argument (float_of_string (String.trim a)) with Failure _ -> (try (Parser.create_int_argument (int_of_string (String.trim a)) ) with Failure _ -> Parser.create_string_argument a))
  | _ -> let a = read_line () in Parser.create_string_argument a

let recognize_function name list_of_args =
match (String.trim name) with
  | "PAINAUCHOCOLAT" -> printf list_of_args (*IO + GOTO*)
  | "CROISSANT" -> print list_of_args
  | "MADELEINE" -> read_variable list_of_args
  | "ECLAIR" -> read_entry list_of_args
  
  | "CANELE" -> Math.add list_of_args (*MATH*)
  | "STHONORE" -> Math.mult list_of_args
  | "KOUIGNAMANN" -> Math.power list_of_args
  | "PROFITEROLE" -> Math.sqrt list_of_args
  | "FINANCIER" -> Math.fibonacci list_of_args
  | "PAINAURAISIN" -> Math.substract list_of_args
  | "CHOCOLATINE" -> Math.divide list_of_args
  | "BRETZEL" -> Math.randint list_of_args
  | "JOCONDE" -> Math.logb list_of_args
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

  | "TARTEAUXFRAISES" -> ArrayManipulation.access list_of_args (*ACCESS*)
  | "TARTEAUXFRAMBOISES" -> ArrayManipulation.replace list_of_args (*REPLACE*)
  | "TARTEAUXPOMMES" -> ArrayManipulation.create_array list_of_args (*CREATE*)
  | "TARTEALARHUBARBE" -> ArrayManipulation.create_matrix list_of_args (*MCREATE*)
  | "GLACE" -> ArrayManipulation.display_array list_of_args (*DISPLAY*)
  | "BEIGNET" -> ArrayManipulation.populate list_of_args (*POPULATE*)

  | "DOUGHNUT" -> StringManipulation.replace list_of_args (*SREPLACE*)
  | "BUCHE" -> StringManipulation.create list_of_args (*SCREATE*)
  | "GAUFFREDELIEGE" -> StringManipulation.concat list_of_args (*SADD*)
  | "GAUFFREDEBRUXELLES" -> StringManipulation.access list_of_args (*SACCESS*)
  | "GAUFFRE" -> StringManipulation.split list_of_args (*SPLIT*)
  | "PANCAKE" -> StringManipulation.transform_to_array list_of_args (*TOARR*)
  | "SIROPDERABLE" -> StringManipulation.transform_from_array list_of_args (*FROMARR*)

  | "FROSTING" -> StringManipulation.convert_to_string list_of_args (*TOSTRING*)
  | "CARROTCAKE" -> StringManipulation.int_from_string list_of_args (*IFS*)
  | "GALETTEDESROIS" -> StringManipulation.double_from_string list_of_args (*DFS*)
  | "FRANGIPANE" -> StringManipulation.bool_from_string list_of_args (*BFS*)

  | _ -> Exception (new Parser.bag_exception "unknown function");;



end