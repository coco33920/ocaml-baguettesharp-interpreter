(**The Interpreter Module of B#*)

(**The Hashtbl storing the labels AST*)
let labels = Hashtbl.create 100;;
let functions = Hashtbl.create 100;;

(**A function to generate a stack trace from an error object*)
let creating_stack_trace line name except  =
  ["\027[1;38;02;244;113;116mError:\027[m at line";string_of_int line;"while evaluating\027[38;2;50;175;255m";name;"\027[m=>";except#to_string] |> String.concat " ";;

(**Interpretation of a single Node*)
(*Called when a node is a call expression and we need the list of arguments*)
let rec exec_node ?(line = -1) node  = 
  match node with 
  | Parser.Nil -> Parser.Argument (Parser.Nul ())
  | Parser.Node(Parser.CallExpression name, list_of_arguments) ->
    let new_list = List.map exec_node list_of_arguments in
    let a = Functions.recognize_function name new_list in
    (match a with
     | Parser.Exception _ -> 
      let p = try_injection name new_list in
      (match p with
      | Parser.Exception e ->  print_endline (creating_stack_trace line name e); Parser.Argument (Parser.Nul ())
      | e -> e)
     | s -> s)
  | Parser.Node(Parser.Array, list_of_arguments) -> let new_list = List.map exec_node list_of_arguments in Parser.TBL (Array.of_list new_list)
  | Parser.Node(Parser.GOTO s, _) -> Parser.GOTO s
  | Parser.Node(Parser.IF, (Parser.Node(Parser.COND, args))::q) -> let arg = List.hd args in let b = exec_node arg in
    (match b with (Parser.Argument(Parser.Bool b)) -> let i' = string_of_int((Random.int 230)*(Random.int 70)) in Hashtbl.add labels ("if_in_use_"^i') q; if b then Parser.GOTO ("if_in_use_"^i') else Parser.GOTO "else" | _ -> Parser.Exception 
                                                                                                                                                                                                                                   (new Parser.syntax_error "wrong if"))
  | Parser.Node(Parser.Label s, list_of_arguments) -> Hashtbl.add labels s list_of_arguments; Parser.Argument (Parser.Nul())
  | Parser.Node(Parser.Argument a, _) -> Parser.Argument a
  | Parser.Node(Parser.Function (name,args),list_of_arguments)
    -> Hashtbl.add functions name (args,list_of_arguments); Parser.Argument (Parser.Nul ())
  | _ -> Parser.Argument (Parser.Nul ())
and try_injection name list_of_arguments = 
  let inject_arguments args list_of_arguments l =
    let arr1,arr2 = Array.of_list args,Array.of_list list_of_arguments
    in if Array.length arr1 > Array.length arr2 then
      Parser.Exception (new Parser.bag_exception "not enough errors") 
    else
      (for i=0 to (Array.length arr1 -1) do 
        let a1,a2 = arr1.(i),arr2.(i)
        in Hashtbl.add (Functions.main_ram) a1 a2
      done;
      (*arguments are injected => execution*)
      runtime l |> ignore; 
      let p = Stack.pop_opt (Functions.result)
      in match p with
      | None -> Parser.Argument (Parser.Nul ())
      | Some v -> v
      )

  in let a = Hashtbl.find_opt functions name in 
  match a with
    | Some (s,l) -> inject_arguments s list_of_arguments l
    | None -> Parser.Exception (new Parser.bag_exception "unknown function")
and runtime ?(repl = false) list_of_node = 
  let array_of_node = Array.of_list list_of_node in 
  let n = Array.length array_of_node in
  let i = ref 0 in
  while !i <= (n-1) do
    let exec = exec_node ~line:!i array_of_node.(!i) in match exec with 
    | Parser.Exception s -> print_endline (creating_stack_trace !i "" s); i := n+1;
    | Parser.GOTO s -> i := !i+1; if not (String.equal s "else") then
        (try let a = Hashtbl.find labels s in runtime a |> ignore; with _ -> print_string "label do not exist")
    | Parser.TBL c -> if repl then (print_endline (Parser.print_parameter (Parser.TBL(c)))); i := n+1;
    | Parser.Argument a -> (match a with
        | Nul () -> ()
        | _ -> if repl then print_endline ("val: " ^ Parser.print_argument_for_repl a)); i := !i + 1;
    | _ -> i := !i + 1
  done;
  Functions.main_ram;;

(*
Interpretation of a function 
=> Definition : adding the function name and parameters with the value
=> Call:
  => Injecting arguments
  => runtime the node
*)