(**The Math Module of the B# STD*)


    (**Transforms a parameter into a float*)
    let argument_to_float a =
      match a with
        | Parser.Argument (Parser.I(i)) -> float_of_int i
        | Parser.Argument (Parser.D(d)) -> d
        | _ -> 0.
  
    (**Transforms a list of parameters into a list of floats*)
    let list_of_arguments_to_float list_of_args = 
      List.map argument_to_float list_of_args;;

    (**Transforms a couple of arguments into a couple of floats*)
    let arguments_to_float a b = 
      match a,b with 
        | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.I(i')) -> float_of_int i,float_of_int i'
        | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.D(d)) -> float_of_int i,d
        | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.I(i)) -> d,float_of_int i
        | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.D(d')) -> d,d'
        | _ -> 0.,0.

    (**A O(n) in time and O(1) in space iterative fibbonacci function*)
    let fibo n = 
      let a = ref [|0;1|] and i = ref 2 in
      while !i <= n do 
        !a.(!i mod 2) <- !a.(0) + !a.(1);
        i := !i + 1
      done;
      !a.((n+1) mod 2);;

    (**Computes the sum of the list*)
    let add list_of_arguments = 
      let rec aux acc list = 
        match list with 
          | [] -> acc
          | arg::q -> aux (Parser.add_numbers arg acc) q
      in aux (Parser.create_int_argument 0) list_of_arguments
    
    (**Computes the multiplication of the list*)
    let mult list_of_arguments = 
      let rec aux acc list = 
        match list with 
          | [] -> acc
          | arg::q -> aux (Parser.mult_numbers arg acc) q
      in aux (Parser.create_int_argument 1) list_of_arguments

    (**Gives the nth element of the fibbonacci sequence*)
    let fibonacci list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception (new Parser.arg ("This function requires one arguments and you supplied none"))
      else let a = List.hd list_of_arguments in match a with (Parser.Argument(Parser.I(i))) -> Parser.create_int_argument (fibo i) | _ -> Parser.Exception (new Parser.type_error "argument must be an integer");;
    
    (**Exponentiate a^b*)
    let power list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception (new Parser.arg "This function requires an argument and you supplied none")
      else let a,b = List.hd list_of_arguments, List.tl list_of_arguments in let c = List.hd b in Parser.expn a c;;

    (**Computes the square root of the input*)
    let sqrt list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception (new Parser.arg ("This function requires one arguments and you supplied none"))
      else let a = List.hd list_of_arguments in
        match a with 
          | Parser.Argument(Parser.I(i)) -> Parser.Argument (Parser.D (sqrt (float_of_int i)))
          | Parser.Argument(Parser.D(d)) -> Parser.Argument (Parser.D (sqrt (d)))
          | _ -> Parser.Exception (new Parser.type_error "argument must be a number");;

    (**Computes the substraction (a-b) of the first two numbers of the input list*)
    let substract list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception (new Parser.arg ("This function requires two arguments and you supplied " ^ string_of_int (List.length list_of_arguments) ^ "arguments"))
      else let head,tail = List.hd list_of_arguments,List.tl list_of_arguments in 
      let head2 = List.hd tail in Parser.substract_numbers head head2;;

    (**Computes the division (a/b) with the first two elements of the list*)
    let divide list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception (new Parser.arg ("This function requires two arguments and you supplied " ^ string_of_int (List.length list_of_arguments) ^ "arguments"))
      else let head,tail = List.hd list_of_arguments,List.tl list_of_arguments in 
      let head2 = List.hd tail in Parser.divide_numbers head head2;;

    (**Returns a random integer in [a,b]*)
    let randint list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception (new Parser.arg ("This function requires two arguments and you supplied " ^ string_of_int (List.length list_of_arguments) ^ "arguments"))
      else let head,tail = List.hd list_of_arguments,List.tl list_of_arguments in 
      let head2 = List.hd tail in let a,b = (arguments_to_float head head2) in Random.self_init (); Parser.Argument (Parser.I((Random.int (int_of_float (b-.a))) + int_of_float a));;

    (**Computes the logarithm of a in base b*)
    let logb list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception (new Parser.arg ("This function requires two arguments and you supplied " ^ string_of_int (List.length list_of_arguments) ^ "arguments"))
      else let head,tail = List.hd list_of_arguments,List.tl list_of_arguments in 
      let head2 = List.hd tail in let a,b = (arguments_to_float head head2) in Parser.Argument (Parser.D ((log a) /. (log b)));;
  
    (**Returns the opposite of the input*)
    let opposite list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception (new Parser.arg ("This function requires two arguments and you supplied " ^ string_of_int (List.length list_of_arguments) ^ "arguments"))
      else let head = List.hd list_of_arguments in Parser.mult_numbers (Parser.create_int_argument (-1)) head;;
  
    (**Returns the floor of the input*)
    let floor list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception (new Parser.arg ("This function requires two arguments and you supplied " ^ string_of_int (List.length list_of_arguments) ^ "arguments"))
      else let head = List.hd list_of_arguments in let a = argument_to_float head in Parser.Argument (Parser.I (int_of_float (floor a)));;
  
    (**Returns the ceil of the input*)
    let ceil list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception (new Parser.arg ("This function requires two arguments and you supplied " ^ string_of_int (List.length list_of_arguments) ^ "arguments"))
      else let head = List.hd list_of_arguments in let a = argument_to_float head in Parser.Argument (Parser.I (int_of_float (ceil a)));;
