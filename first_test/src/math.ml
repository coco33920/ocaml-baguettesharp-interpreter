module Math = struct
include Token
include Parser


    let argument_to_float a =
      match a with
        | Parser.Argument (Parser.I(i)) -> float_of_int i
        | Parser.Argument (Parser.D(d)) -> d
        | _ -> 0.
    
    let list_of_arguments_to_float list_of_args = 
      List.map argument_to_float list_of_args;;

    let arguments_to_float a b = 
      match a,b with 
        | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.I(i')) -> float_of_int i,float_of_int i'
        | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.D(d)) -> float_of_int i,d
        | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.I(i)) -> d,float_of_int i
        | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.D(d')) -> d,d'
        | _ -> 0.,0.

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
          | [] -> Parser.Argument (Parser.D acc)
          | (Parser.CallExpression _)::_ -> Parser.Exception "callexpressions are illegal"
          | (Parser.Argument (Parser.I(i)))::q -> aux (acc +. float_of_int i) q
          | (Parser.Argument (Parser.D(d)))::q -> aux (acc +. d) q
          | (Parser.Argument (Parser.Str(_)))::_ -> Parser.Exception "add cannot take string arguments"
          | (Parser.Argument (Parser.Nul(())))::q -> aux acc q
          | (Parser.GOTO(_))::_ -> Parser.Exception "goto are illegals"
          | (Parser.Argument (Parser.Bool _))::_ -> Parser.Exception "add cannot take boolean arguments"
          | _ -> Parser.Exception "argument not recognized"
      in aux 0. list_of_arguments;;


    let mult list_of_arguments = 
      let rec aux acc list =
        match list with
          | [] -> Parser.Argument (Parser.D (acc)) 
          | (Parser.CallExpression _)::_ -> Parser.Exception "callexpression are illegal"
          | (Parser.Argument (Parser.I(i)))::q -> aux (acc *. (float_of_int i)) q
          | (Parser.Argument (Parser.D(d)))::q -> aux (acc *. d) q
          | (Parser.Argument (Parser.Str(_)))::_ -> Parser.Exception "mult cannot take string arguments"
          | (Parser.Argument (Parser.Nul(())))::q -> aux acc q
          | Parser.GOTO(_)::_ -> Parser.Exception "goto are illegals"
          | (Parser.Argument (Parser.Bool _))::_ -> Parser.Exception "mult cannot take boolean arguments"
          | _ -> Parser.Exception "argument not recognized"
      in aux 1. list_of_arguments;;

    let fibonacci list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception "not enough args"
      else let a = List.hd list_of_arguments in match a with (Parser.Argument(Parser.I(i))) -> Parser.Argument(Parser.I(fibo i)) | _ -> Parser.Exception "argument must be an integer";;

    let power list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception "not enough args"
      else let a,b = List.hd list_of_arguments, List.tl list_of_arguments in let c = List.hd b in 
        match a,c with 
          | Parser.Argument(Parser.I(i)),Parser.Argument(Parser.I(j)) -> Parser.Argument (Parser.D (float_of_int i ** float_of_int j))
          | Parser.Argument(Parser.I(i)),Parser.Argument(Parser.D(d)) -> Parser.Argument (Parser.D (float_of_int i ** d))
          | Parser.Argument(Parser.D(d)),Parser.Argument(Parser.I(i)) -> Parser.Argument (Parser.D (d ** float_of_int i))
          | Parser.Argument(Parser.D(d)),Parser.Argument(Parser.D(d2)) -> Parser.Argument (Parser.D (d ** d2))
          | _ -> Parser.Exception "arguments must be numbers";;

    let sqrt list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception "not enough args"
      else let a = List.hd list_of_arguments in
        match a with 
          | Parser.Argument(Parser.I(i)) -> Parser.Argument (Parser.D (sqrt (float_of_int i)))
          | Parser.Argument(Parser.D(d)) -> Parser.Argument (Parser.D (sqrt (d)))
          | _ -> Parser.Exception "argument must be a number";;


    let substract list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception "not enough args"
      else let head,tail = List.hd list_of_arguments,List.tl list_of_arguments in 
      let head2 = List.hd tail in let a,b = (arguments_to_float head head2) in Parser.Argument (Parser.D ((a -. b)));;


    let divide list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception "not enough args"
      else let head,tail = List.hd list_of_arguments,List.tl list_of_arguments in 
      let head2 = List.hd tail in let a,b = (arguments_to_float head head2) in Parser.Argument (Parser.D ((a /. b)));;


    let randint list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception "not enough args"
      else let head,tail = List.hd list_of_arguments,List.tl list_of_arguments in 
      let head2 = List.hd tail in let a,b = (arguments_to_float head head2) in Parser.Argument (Parser.I((Random.int (int_of_float (b-.a))) + int_of_float a));;

    let logb list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception "not enough args"
      else let head,tail = List.hd list_of_arguments,List.tl list_of_arguments in 
      let head2 = List.hd tail in let a,b = (arguments_to_float head head2) in Parser.Argument (Parser.D ((log a) /. (log b)));;
  
    
    let opposite list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception "not enough args"
      else let head = List.hd list_of_arguments in let a = argument_to_float head in Parser.Argument (Parser.D (-1. *. a));;
  
    let floor list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception "not enough args"
      else let head = List.hd list_of_arguments in let a = argument_to_float head in Parser.Argument (Parser.I (int_of_float (floor a)));;
  
    let ceil list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception "not enough args"
      else let head = List.hd list_of_arguments in let a = argument_to_float head in Parser.Argument (Parser.I (int_of_float (ceil a)));;
  




  end

