module Interpreter = struct
  include Token
  include Parser
  include Functions

  (*Called when a node is a call expression and we need the list of arguments*)
  let rec exec_node node = 
    match node with 
      | Parser.Nil -> Parser.Argument (Parser.Nul ())
      | Parser.Node(Parser.CallExpression name, list_of_arguments) -> let new_list = List.map exec_node list_of_arguments in (Functions.recognize_function name (List.rev new_list))
      | Parser.Node(Parser.Argument a, _) -> Parser.Argument a




end