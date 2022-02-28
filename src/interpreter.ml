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
      | Parser.Node(Parser.IF, (Parser.Node(Parser.COND, args))::q) -> let arg = List.hd args in let b = exec_node arg in
        (match b with (Parser.Argument(Parser.Bool b)) -> let i' = string_of_int((Random.int 230)*(Random.int 70)) in Hashtbl.add labels ("if_in_use_"^i') q; if b then Parser.GOTO ("if_in_use_"^i') else Parser.GOTO "else" | _ -> Parser.Exception "error if")
      | Parser.Node(Parser.Label s, list_of_arguments) -> Hashtbl.add labels s list_of_arguments; Parser.Argument (Parser.Nul())
      | Parser.Node(Parser.Argument a, _) -> Parser.Argument a
      | _ -> Parser.Argument (Parser.Nul ())

  let rec runtime ?(repl = false) list_of_node = 
    let array_of_node = Array.of_list list_of_node in 
    let n = Array.length array_of_node in
    let i = ref 0 in
    while !i <= (n-1) do
      let exec = exec_node array_of_node.(!i) in match exec with 
        | Parser.Exception s -> print_string ("Error: " ^ s); print_newline (); i := n+1;
        | Parser.GOTO s -> i := !i+1; if not (String.equal s "else") then
          (try let a = Hashtbl.find labels s in runtime a |> ignore with _ -> print_string "label do not exist")
        | Parser.Argument a -> (match a with
            | Nul () -> ()
            | _ -> if repl then print_endline ("val: " ^ Parser.print_argument_for_repl a)); i := !i + 1;
        | _ -> i := !i + 1
    done;
    Functions.main_ram;;


end