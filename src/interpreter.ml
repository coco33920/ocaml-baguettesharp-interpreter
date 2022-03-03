module Interpreter = struct
  open Baguette_base
  open Baguette_functions
  include Token
  include Parser
  include Functions

  let labels = Hashtbl.create 100;;


  let creating_stack_trace line name except  =
    ["\027[1;38;02;244;113;116mError:\027[m at line";string_of_int line;"while evaluating\027[38;2;50;175;255m";name;"\027[m=>";except#to_string] |> String.concat " ";;


  (*Called when a node is a call expression and we need the list of arguments*)
  let rec exec_node ?(line = -1) node  = 
    match node with 
      | Parser.Nil -> Parser.Argument (Parser.Nul ())
      | Parser.Node(Parser.CallExpression name, list_of_arguments) ->
         let new_list = List.map exec_node list_of_arguments in
         let a = Functions.recognize_function name new_list in
         (match a with
          | Parser.Exception s -> print_endline (creating_stack_trace line name s); Parser.Argument (Parser.Nul ())
          | s -> s)
      | Parser.Node(Parser.Array, list_of_arguments) -> let new_list = List.map exec_node list_of_arguments in Parser.TBL (Array.of_list new_list)
      | Parser.Node(Parser.GOTO s, _) -> Parser.GOTO s
      | Parser.Node(Parser.IF, (Parser.Node(Parser.COND, args))::q) -> let arg = List.hd args in let b = exec_node arg in
        (match b with (Parser.Argument(Parser.Bool b)) -> let i' = string_of_int((Random.int 230)*(Random.int 70)) in Hashtbl.add labels ("if_in_use_"^i') q; if b then Parser.GOTO ("if_in_use_"^i') else Parser.GOTO "else" | _ -> Parser.Exception 
          (new Parser.syntax_error "wrong if"))
      | Parser.Node(Parser.Label s, list_of_arguments) -> Hashtbl.add labels s list_of_arguments; Parser.Argument (Parser.Nul())
      | Parser.Node(Parser.Argument a, _) -> Parser.Argument a
      | _ -> Parser.Argument (Parser.Nul ())

  let rec runtime ?(repl = false) list_of_node = 
    let array_of_node = Array.of_list list_of_node in 
    let n = Array.length array_of_node in
    let i = ref 0 in
    while !i <= (n-1) do
      let exec = exec_node ~line:!i array_of_node.(!i) in match exec with 
        | Parser.Exception s -> print_endline (creating_stack_trace !i "" s); i := n+1;
        | Parser.GOTO s -> i := !i+1; if not (String.equal s "else") then
          (try let a = Hashtbl.find labels s in runtime a |> ignore with _ -> print_string "label do not exist")
        | Parser.TBL c -> if repl then (print_endline (Parser.print_parameter (Parser.TBL(c)))); i := n+1;
        | Parser.Argument a -> (match a with
            | Nul () -> ()
            | _ -> if repl then print_endline ("val: " ^ Parser.print_argument_for_repl a)); i := !i + 1;
        | _ -> i := !i + 1
    done;
    Functions.main_ram;;


end