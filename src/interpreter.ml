module Interpreter = struct
  open Baguette_base
  open Baguette_functions
  include Token
  include Parser
  include Functions

  let labels = Hashtbl.create 100;;


  (*Called when a node is a call expression and we need the list of arguments*)
  let rec exec_node node = 
    match node with 
      | Parser.Nil -> Parser.Argument (Parser.Nul ())
      | Parser.Node(Parser.CallExpression name, list_of_arguments) -> let new_list = List.map exec_node list_of_arguments in (Functions.recognize_function name (new_list))
      | Parser.Node(Parser.GOTO s, _) -> Parser.GOTO s
      | Parser.Node(Parser.Label s, list_of_arguments) -> Hashtbl.add labels s list_of_arguments; Parser.Argument (Parser.Nul())
      | Parser.Node(Parser.Argument a, _) -> Parser.Argument a
      | _ -> Parser.Argument (Parser.Nul ())

  let runtime list_of_node = 
    let array_of_node = Array.of_list list_of_node in 
    let n = Array.length array_of_node in
    let i = ref 0 in
    while !i <= (n-1) do
      let exec = exec_node array_of_node.(!i) in match exec with 
        | Parser.Exception s -> print_string ("Error: " ^ s); print_newline (); i := n+1;
        | Parser.GOTO s -> (try let a = Hashtbl.find labels s in List.map exec_node a |> ignore with _ -> print_string "label do not exist"); i := !i+1;
        | _ -> i := !i + 1
    done;
    Functions.main_ram;;


end