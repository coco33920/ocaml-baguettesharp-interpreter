
    let two_argument_func list_of_arguments func = 
      if List.length list_of_arguments < 2 then Parser.Exception (new Parser.arg 
        ("This function requires two arguments and you supplied " ^ string_of_int 
      (List.length list_of_arguments) ^ "arguments"))
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
      if List.length list_of_arguments < 1 then Parser.Exception (new Parser.arg 
        ("This function requires one arguments and you supplied none"))
      else let head = List.hd list_of_arguments in Parser.apply_unary_operator (not) head
