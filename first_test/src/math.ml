module Math = struct
include Token
include Parser


let fibo n = 
  let a = ref [|0;1|] and i = ref 2 in
  while !i <= n do 
    !a.(!i mod 2) <- !a.(0) + !a.(1);
    i := !i + 1
  done;
!a.((n+1) mod 2);;

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

let fibonacci list_of_arguments = 
  if List.length list_of_arguments < 1 then failwith "not enough args"
  else let a = List.hd list_of_arguments in match a with (Parser.Argument(Parser.I(i))) -> fibo i | _ -> failwith "argument must be an integer"

let power list_of_arguments = 
  if List.length list_of_arguments < 2 then failwith "not enough args"
  else let a,b = List.hd list_of_arguments, List.tl list_of_arguments in let c = List.hd b in 
  match a,c with 
    | Parser.Argument(Parser.I(i)),Parser.Argument(Parser.I(j)) -> float_of_int i ** float_of_int j
    | Parser.Argument(Parser.I(i)),Parser.Argument(Parser.D(d)) -> float_of_int i ** d
    | Parser.Argument(Parser.D(d)),Parser.Argument(Parser.I(i)) -> d ** float_of_int i
    | Parser.Argument(Parser.D(d)),Parser.Argument(Parser.D(d2)) -> d ** d2
    | _ -> failwith "arguments must be numbers"

 let sqrt list_of_arguments = 
  if List.length list_of_arguments < 1 then failwith "not enough args"
  else let a = List.hd list_of_arguments in
    match a with 
      | Parser.Argument(Parser.I(i)) -> sqrt (float_of_int i)
      | Parser.Argument(Parser.D(d)) -> sqrt (d)
      | _ -> failwith "argument must be a number"

end

