module Math = struct
include Token
include Parser


let add list_of_arguments = 
  let rec aux acc list =
    match list with 
      | [] -> acc 
      | (Parser.CallExpression _)::_ -> failwith "callexpressions are illegal"
      | (Parser.Argument (Parser.I(i)))::q -> aux (acc +. float_of_int i) q
      | (Parser.Argument (Parser.D(d)))::q -> aux (acc +. d) q
      | (Parser.Argument (Parser.Str(_)))::_ -> failwith "Error add cannot take string arguments"
      | (Parser.Argument (Parser.Nul(())))::q -> aux acc q
  in aux 0. list_of_arguments;;


let mult list_of_arguments = 
  let rec aux acc list =
    match list with
      | [] -> acc 
      | (Parser.CallExpression _)::_ -> failwith "callexpression are illegal"
      | (Parser.Argument (Parser.I(i)))::q -> aux (acc *. (float_of_int i)) q
      | (Parser.Argument (Parser.D(d)))::q -> aux (acc *. d) q
      | (Parser.Argument (Parser.Str(_)))::_ -> failwith "Error mult cannot take string arguments"
      | (Parser.Argument (Parser.Nul(())))::q -> aux acc q
  in aux 1. list_of_arguments;;


end