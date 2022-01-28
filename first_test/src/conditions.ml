module Condition = struct
    include Token
    include Parser

    let two_argument_func list_of_arguments func = 
      if List.length list_of_arguments < 2 then Parser.Exception "not enough args"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2 = List.hd tail in func head head2;;

    let equality list_of_arguments = two_argument_func list_of_arguments Parser.equality

    let inferior_large list_of_arguments = two_argument_func list_of_arguments Parser.inferior_large

    let inferior_strict list_of_arguments = two_argument_func list_of_arguments Parser.inferior

    let superior_large list_of_arguments = two_argument_func list_of_arguments Parser.superior_large

    let superior_strict list_of_arguments = two_argument_func list_of_arguments Parser.superior

    let binary_or list_of_arguments = two_argument_func list_of_arguments (Parser.apply_binary_operator (||))
    let binary_and list_of_arguments = two_argument_func list_of_arguments (Parser.apply_binary_operator (&&))

    let binary_xor list_of_arguments = two_argument_func list_of_arguments (Parser.apply_binary_operator (<>))


    let binary_not list_of_arguments = 
      if List.length list_of_arguments < 1 then Parser.Exception "not enough arguments"
      else let head = List.hd list_of_arguments in Parser.apply_unary_operator (not) head

    let if_funct list_of_arguments =
      if List.length list_of_arguments < 3 then Parser.Exception "not enough arguments"
      else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
      in let head2,tl2 = List.hd tail,List.tl tail in let head3 = List.hd tl2 in 
        match head,head2,head3 with 
          | Parser.Argument (Parser.Bool(b)),Parser.Argument (Parser.I(i)),Parser.Argument (Parser.I(i')) -> if b then (Parser.GOTO i) else (Parser.GOTO i')
          | _ -> Parser.Exception "if structure is IF BOOL INT INT"


end