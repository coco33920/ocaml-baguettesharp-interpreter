module Condition = struct
    include Token
    include Parser

    let equality list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception "not enough args"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.I(i')) -> Parser.Argument(Parser.Bool(i = i'))
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.D(d)) -> Parser.Argument(Parser.Bool(float_of_int i = d))
          | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.I(i)) -> Parser.Argument(Parser.Bool(d = float_of_int i))
          | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.D(d')) -> Parser.Argument(Parser.Bool(d = d'))
          | Parser.Argument (Parser.Str(s)),Parser.Argument (Parser.Str(s')) -> Parser.Argument(Parser.Bool(String.equal s s'))
          | Parser.Argument (Parser.Bool(f)),Parser.Argument (Parser.Bool(f')) -> Parser.Argument(Parser.Bool(f = f'))
          | _ -> Parser.Exception "arguments are not comparable"

    let inferior_large list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception "not enough args"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.I(i')) -> Parser.Argument(Parser.Bool(i <= i'))
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.D(d)) -> Parser.Argument(Parser.Bool(float_of_int i <= d))
          | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.I(i)) -> Parser.Argument(Parser.Bool(d <= float_of_int i))
          | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.D(d')) -> Parser.Argument(Parser.Bool(d <= d'))
          | Parser.Argument (Parser.Str(s)),Parser.Argument (Parser.Str(s')) -> Parser.Argument(Parser.Bool(s <= s'))
          | _ -> Parser.Exception "Arguments are not comparable";;

    
    let inferior_strict list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.I(i')) -> Parser.Argument(Parser.Bool(i < i'))
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.D(d)) -> Parser.Argument(Parser.Bool(float_of_int i < d))
          | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.I(i)) -> Parser.Argument(Parser.Bool(d < float_of_int i))
          | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.D(d')) -> Parser.Argument(Parser.Bool(d < d'))
          | Parser.Argument (Parser.Str(s)),Parser.Argument (Parser.Str(s')) -> Parser.Argument(Parser.Bool(s < s'))
          | _ -> Parser.Exception "Arguments are not comparable";;

      
    let superior_large list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.I(i')) -> Parser.Argument(Parser.Bool(i >= i'))
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.D(d)) -> Parser.Argument(Parser.Bool(float_of_int i >= d))
          | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.I(i)) -> Parser.Argument(Parser.Bool(d >= float_of_int i))
          | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.D(d')) -> Parser.Argument(Parser.Bool(d >= d'))
          | Parser.Argument (Parser.Str(s)),Parser.Argument (Parser.Str(s')) -> Parser.Argument(Parser.Bool(s >= s'))
          | _ -> Parser.Exception "Arguments are not comparable";;

    
    let superior_strict list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.I(i')) -> Parser.Argument(Parser.Bool(i > i'))
          | Parser.Argument (Parser.I(i)),Parser.Argument (Parser.D(d)) -> Parser.Argument(Parser.Bool(float_of_int i > d))
          | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.I(i)) -> Parser.Argument(Parser.Bool(d > float_of_int i))
          | Parser.Argument (Parser.D(d)),Parser.Argument (Parser.D(d')) -> Parser.Argument(Parser.Bool(d > d'))
          | Parser.Argument (Parser.Str(s)),Parser.Argument (Parser.Str(s')) -> Parser.Argument(Parser.Bool(s > s'))
          | _ -> Parser.Exception "Arguments are not comparable";;



    let binary_or list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.Bool(b)),Parser.Argument (Parser.Bool(b')) -> Parser.Argument(Parser.Bool(b || b'))
          | _ -> Parser.Exception "Arguments must be booleans";;

    let binary_and list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.Bool(b)),Parser.Argument (Parser.Bool(b')) -> Parser.Argument(Parser.Bool(b && b'))
          | _ -> Parser.Exception "Arguments must be booleans";;

    let binary_xor list_of_arguments = 
      if List.length list_of_arguments < 2 then Parser.Exception "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in 
        match head,head2 with 
          | Parser.Argument (Parser.Bool(b)),Parser.Argument (Parser.Bool(b')) -> Parser.Argument(Parser.Bool(b <> b'))
          | _ -> Parser.Exception "Arguments must be booleans";;


    let binary_not list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception "not enough arguments"
      else let head = List.hd list_of_arguments in
        match head with 
          | Parser.Argument (Parser.Bool(b)) -> Parser.Argument(Parser.Bool(not b))
          | _ -> Parser.Exception "Argument must be boolean";;

    let if_funct list_of_arguments = 
      if List.length list_of_arguments < 3 then Parser.Exception "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2,tl2 = List.hd tail,List.tl tail in let head3 = List.hd tl2 in 
        match head,head2,head3 with 
          | Parser.Argument (Parser.Bool(b)),Parser.Argument (Parser.I(i)),Parser.Argument (Parser.I(i')) -> if b then Parser.GOTO i else Parser.GOTO i'
          | _ -> Parser.Exception "if structure is IF BOOL INT INT"


end