module Math = struct
open Baguette_base
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
          | [] -> acc
          | arg::q -> aux (Parser.add_numbers arg acc) q
      in aux (Parser.create_int_argument 0) list_of_arguments
    
    
    let mult list_of_arguments = 
      let rec aux acc list = 
        match list with 
          | [] -> acc
          | arg::q -> aux (Parser.mult_numbers arg acc) q
      in aux (Parser.create_int_argument 1) list_of_arguments

    let fibonacci list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception (new Parser.arg ("This function requires one arguments and you supplied none"))
      else let a = List.hd list_of_arguments in match a with (Parser.Argument(Parser.I(i))) -> Parser.create_int_argument (fibo i) | _ -> Parser.Exception (new Parser.type_error "argument must be an integer");;

    let power list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception (new Parser.arg "This function requires an argument and you supplied none")
      else let a,b = List.hd list_of_arguments, List.tl list_of_arguments in let c = List.hd b in Parser.expn a c;;

    
    let sqrt list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception (new Parser.arg ("This function requires one arguments and you supplied none"))
      else let a = List.hd list_of_arguments in
        match a with 
          | Parser.Argument(Parser.I(i)) -> Parser.Argument (Parser.D (sqrt (float_of_int i)))
          | Parser.Argument(Parser.D(d)) -> Parser.Argument (Parser.D (sqrt (d)))
          | _ -> Parser.Exception (new Parser.type_error "argument must be a number");;


    let substract list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception (new Parser.arg ("This function requires two arguments and you supplied " ^ string_of_int (List.length list_of_arguments) ^ "arguments"))
      else let head,tail = List.hd list_of_arguments,List.tl list_of_arguments in 
      let head2 = List.hd tail in Parser.substract_numbers head head2;;


    let divide list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception (new Parser.arg ("This function requires two arguments and you supplied " ^ string_of_int (List.length list_of_arguments) ^ "arguments"))
      else let head,tail = List.hd list_of_arguments,List.tl list_of_arguments in 
      let head2 = List.hd tail in Parser.divide_numbers head head2;;


    let randint list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception (new Parser.arg ("This function requires two arguments and you supplied " ^ string_of_int (List.length list_of_arguments) ^ "arguments"))
      else let head,tail = List.hd list_of_arguments,List.tl list_of_arguments in 
      let head2 = List.hd tail in let a,b = (arguments_to_float head head2) in Random.self_init (); Parser.Argument (Parser.I((Random.int (int_of_float (b-.a))) + int_of_float a));;

    let logb list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception (new Parser.arg ("This function requires two arguments and you supplied " ^ string_of_int (List.length list_of_arguments) ^ "arguments"))
      else let head,tail = List.hd list_of_arguments,List.tl list_of_arguments in 
      let head2 = List.hd tail in let a,b = (arguments_to_float head head2) in Parser.Argument (Parser.D ((log a) /. (log b)));;
  
    
    let opposite list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception (new Parser.arg ("This function requires two arguments and you supplied " ^ string_of_int (List.length list_of_arguments) ^ "arguments"))
      else let head = List.hd list_of_arguments in Parser.mult_numbers (Parser.create_int_argument (-1)) head;;
  
    let floor list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception (new Parser.arg ("This function requires two arguments and you supplied " ^ string_of_int (List.length list_of_arguments) ^ "arguments"))
      else let head = List.hd list_of_arguments in let a = argument_to_float head in Parser.Argument (Parser.I (int_of_float (floor a)));;
  
    let ceil list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception (new Parser.arg ("This function requires two arguments and you supplied " ^ string_of_int (List.length list_of_arguments) ^ "arguments"))
      else let head = List.hd list_of_arguments in let a = argument_to_float head in Parser.Argument (Parser.I (int_of_float (ceil a)));;

  end

