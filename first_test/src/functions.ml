module Functions = struct 
include Token
include Parser



let rec print list_of_arguments =
  match list_of_arguments with 
    | [] -> ()
    | (Parser.CallExpression _)::_ -> failwith "callexpressions are illegal"
    | (Parser.Argument (Parser.Str(s)))::q -> print_string (s^" "); print q
    | (Parser.Argument (Parser.I(i)))::q -> print_string((string_of_int i) ^ " "); print q
    | (Parser.Argument Parser.Nul(()))::q -> print q;;

let add list_of_arguments = 
  let rec aux acc list =
    match list with 
      | [] -> acc 
      | (Parser.CallExpression _)::_ -> failwith "callexpressions are illegal"
      | (Parser.Argument (Parser.I(i)))::q -> aux (acc+i) q
      | (Parser.Argument (Parser.Str(_)))::_ -> failwith "Error add cannot take string arguments"
      | (Parser.Argument (Parser.Nul(())))::q -> aux acc q
  in aux 0 list_of_arguments;;



let recognize_function name list_of_args =
match (String.trim name) with 
  | "CROISSANT" -> Parser.Argument (Parser.Nul(print list_of_args))
  | "CANELÉ" -> Parser.Argument (Parser.I(add list_of_args))
  | _ -> Parser.Argument (Parser.Nul(print [Parser.Argument (Parser.Str(""))]));;

end