module Functions = struct 
include Token
include Parser
include Math


let rec print list_of_arguments =
  match list_of_arguments with 
    | [] -> ()
    | (Parser.CallExpression _)::_ -> failwith "callexpressions are illegal"
    | (Parser.Argument (Parser.Str(s)))::q -> print_string (s^" "); print q
    | (Parser.Argument (Parser.I(i)))::q -> print_string((string_of_int i) ^ " "); print q
    | (Parser.Argument (Parser.D(d)))::q -> print_string((string_of_float d) ^ " "); print q
    | (Parser.Argument Parser.Nul(()))::q -> print q;;


let recognize_function name list_of_args =
match (String.trim name) with 
  | "CROISSANT" -> Parser.Argument (Parser.Nul(print list_of_args))
  | "CANELÉ" -> Parser.Argument (Parser.D(Math.add list_of_args))
  | "STHONORÉ" -> Parser.Argument (Parser.D(Math.mult list_of_args))
  | _ -> Parser.Argument (Parser.Nul(print [Parser.Argument (Parser.Str(""))]));;

end