module Condition = struct
    include Token
    include Parser

    let equality list_of_arguments = 
      if List.length list_of_arguments < 2 then failwith "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.I(i')) -> i = i'
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.D(d)) -> float_of_int i = d
          | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.I(i)) -> d = float_of_int i
          | Parser.Argument (Parser.Str(s)),Parser.Argument (Parser.Str(s')) -> String.equal s s'
          | Parser.Argument (Parser.Bool(f)),Parser.Argument (Parser.Bool(f')) -> f = f'
          | _ -> failwith "Arguments are not comparable";;

    let inferior_large list_of_arguments = 
      if List.length list_of_arguments < 2 then failwith "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.I(i')) -> i <= i'
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.D(d)) -> float_of_int i <= d
          | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.I(i)) -> d <= float_of_int i
          | Parser.Argument (Parser.Str(s)),Parser.Argument (Parser.Str(s')) -> s <= s'
          | _ -> failwith "Arguments are not comparable";;

    
    let inferior_strict list_of_arguments = 
      if List.length list_of_arguments < 2 then failwith "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.I(i')) -> i < i'
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.D(d)) -> float_of_int i < d
          | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.I(i)) -> d < float_of_int i
          | Parser.Argument (Parser.Str(s)),Parser.Argument (Parser.Str(s')) -> s < s'
          | _ -> failwith "Arguments are not comparable";;

      
    let superior_large list_of_arguments = 
      if List.length list_of_arguments < 2 then failwith "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.I(i')) -> i >= i'
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.D(d)) -> float_of_int i >= d
          | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.I(i)) -> d >= float_of_int i
          | Parser.Argument (Parser.Str(s)),Parser.Argument (Parser.Str(s')) -> s >= s'
          | _ -> failwith "Arguments are not comparable";;

    
    let superior_strict list_of_arguments = 
      if List.length list_of_arguments < 2 then failwith "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.I(i')) -> i > i'
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.D(d)) -> float_of_int i > d
          | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.I(i)) -> d > float_of_int i
          | Parser.Argument (Parser.Str(s)),Parser.Argument (Parser.Str(s')) -> s > s'
          | _ -> failwith "Arguments are not comparable";;



    let binary_or list_of_arguments = 
      if List.length list_of_arguments < 2 then failwith "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.Bool(b)),Parser.Argument (Parser.Bool(b')) -> b || b'
          | _ -> failwith "Arguments must be booleans";;

    let binary_and list_of_arguments = 
      if List.length list_of_arguments < 2 then failwith "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.Bool(b)),Parser.Argument (Parser.Bool(b')) -> b && b'
          | _ -> failwith "Arguments must be booleans";;

    let binary_xor list_of_arguments = 
      if List.length list_of_arguments < 2 then failwith "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.Bool(b)),Parser.Argument (Parser.Bool(b')) -> b <> b'
          | _ -> failwith "Arguments must be booleans";;


    let binary_not list_of_arguments = 
      if List.length list_of_arguments < 1 then failwith "not enough arguments"
      else let head = List.hd list_of_arguments in
        match head with 
          | Parser.Argument (Parser.Bool(b)) -> not b
          | _ -> failwith "Argument must be boolean";;

end