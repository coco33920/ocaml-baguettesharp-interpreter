module Functions = struct 
include Token
include Parser
include Math

let rec boucle regex str list = 
  match list with 
    | [] -> str
    | Parser.Argument(Parser.Str(s))::q -> let nstr = Str.replace_first regex s str in boucle regex nstr q
    | Parser.Argument(Parser.I(i))::q -> let nstr = Str.replace_first regex (string_of_int i) str in boucle regex nstr q
    | Parser.Argument(Parser.D(d))::q -> let nstr = Str.replace_first regex (string_of_float d) str in boucle regex nstr q
    | _::q -> boucle regex str q;;


let rec print list_of_arguments =
  match list_of_arguments with 
    | [] -> print_newline ()
    | (Parser.CallExpression _)::_ -> failwith "callexpressions are illegal"
    | (Parser.GOTO _)::_ -> failwith "goto are illegals"
    | (Parser.Argument (Parser.Str(s)))::q -> print_string (s^" "); print q
    | (Parser.Argument (Parser.I(i)))::q -> print_string((string_of_int i) ^ " "); print q
    | (Parser.Argument (Parser.D(d)))::q -> print_string((string_of_float d) ^ " "); print q
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
  

let recognize_function name list_of_args =
match (String.trim name) with 
  | "CROISSANT" -> Parser.Argument (Parser.Nul(print list_of_args))
  | "CANELÉ" -> Parser.Argument (Parser.D(Math.add list_of_args))
  | "STHONORÉ" -> Parser.Argument (Parser.D(Math.mult list_of_args))
  | "KOUGNAMANN" -> Parser.Argument (Parser.D(Math.power list_of_args))
  | "PROFITEROLES" -> Parser.Argument (Parser.D(Math.sqrt list_of_args))
  | "FINANCIER" -> Parser.Argument (Parser.I(Math.fibonacci list_of_args))
  | "PAINAUCHOCOLAT" -> Parser.Argument (Parser.Nul(printf list_of_args))
  | "PAINVIENNOIS" -> Parser.GOTO (verify_goto list_of_args)
  | _ -> Parser.Argument (Parser.Nul(print [Parser.Argument (Parser.Str(""))]));;

end