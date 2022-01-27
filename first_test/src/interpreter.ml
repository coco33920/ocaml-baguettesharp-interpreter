module Interpreter = struct
  include Token
  include Parser
  include Functions

  (*Called when a node is a call expression and we need the list of arguments*)
  let rec exec_node node = 
    match node with 
      | Parser.Nil -> Parser.Argument (Parser.Nul ())
      | Parser.Node(Parser.CallExpression name, list_of_arguments) -> let new_list = List.map exec_node list_of_arguments in (Functions.recognize_function name (new_list))
      | Parser.Node(Parser.Argument a, _) -> Parser.Argument a
      | _ -> Parser.Argument (Parser.Nul ())

  let runtime list_of_node = 
    let array_of_node = Array.of_list list_of_node in 
    let n = Array.length array_of_node in
    let i = ref 0 in
    while !i <= (n-1) do
      let exec = exec_node array_of_node.(!i) in match exec with 
        | Parser.GOTO w -> i := w; print_string ("goto"^(string_of_int w))
        | _ -> i := !i + 1
    done;
    ();;


end