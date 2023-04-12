(**The Function Module : Handles called function and dispatch commands*)

(**The main Hashtbl for variable storage*)
let main_ram = Hashtbl.create 1000

let result = Stack.create ()

(**Replaces all occurence of a string by another*)
let rec boucle regex str list =
  match list with
  | [] -> str
  | Parser.Argument (Parser.Str s) :: q ->
      let nstr = Str.replace_first regex s str in
      boucle regex nstr q
  | Parser.Argument (Parser.I i) :: q ->
      let nstr = Str.replace_first regex (string_of_int i) str in
      boucle regex nstr q
  | Parser.Argument (Parser.D d) :: q ->
      let nstr = Str.replace_first regex (string_of_float d) str in
      boucle regex nstr q
  | Parser.Argument (Parser.Bool f) :: q ->
      let nstr = Str.replace_first regex (string_of_bool f) str in
      boucle regex nstr q
  | _ :: q -> boucle regex str q

(**Recursively prints the list of argument*)
let rec print list_of_arguments =
  match list_of_arguments with
  | [] -> Parser.Argument (Parser.Nul (print_newline ()))
  | Parser.CallExpression _ :: _ ->
      Parser.Exception
        (new Parser.syntax_error "callexpressions are illegal while printing")
  | Parser.GOTO _ :: _ ->
      Parser.Exception
        (new Parser.syntax_error "goto are illegal while printing")
  | Parser.Argument (Parser.Str s) :: q ->
      print_string (s ^ " ");
      print q
  | Parser.Argument (Parser.I i) :: q ->
      print_string (string_of_int i ^ " ");
      print q
  | Parser.Argument (Parser.D d) :: q ->
      print_string (string_of_float d ^ " ");
      print q
  | Parser.Argument (Parser.Bool f) :: q ->
      print_string (string_of_bool f ^ " ");
      print q
  | Parser.Argument (Parser.Nul ()) :: q -> print q
  | _ ->
      Parser.Exception
        (new Parser.type_error "the supplied type is not printable")

(**Printf the input*)
let printf list_of_arguments =
  let regexp_d = Str.regexp "%d" in
  if List.length list_of_arguments < 1 then
    Parser.Exception
      (new Parser.arg
         "This function requires one arguments and you supplied none")
  else
    let hd, tl = (List.hd list_of_arguments, List.tl list_of_arguments) in
    match hd with
    | Parser.Argument (Parser.Str s) ->
        print_string (boucle regexp_d s tl);
        Parser.Argument (Parser.Nul (print_newline ()))
    | _ ->
        Parser.Exception
          (new Parser.type_error "first argument must be an integer")

(**Creates a new variable into the ram*)
let add_variable list_of_arguments =
  if List.length list_of_arguments < 2 then
    Parser.Exception
      (new Parser.arg
         "This function requires one arguments and you supplied none")
  else
    let head, tail = (List.hd list_of_arguments, List.tl list_of_arguments) in
    let head2 = List.hd tail in
    match head with
    | Parser.Argument (Parser.Str s) ->
        Hashtbl.add main_ram s head2;
        Parser.Argument (Parser.Nul ())
    | _ ->
        Parser.Exception
          (new Parser.type_error "first argument must be an integer")

(**Access to a variable stored in the ram*)
let read_variable list_of_arguments =
  if List.length list_of_arguments < 1 then
    Parser.Exception
      (new Parser.arg
         "This function requires one arguments and you supplied none")
  else
    let head = List.hd list_of_arguments in
    match head with
    | Parser.Argument (Parser.Str s) -> (
        try Hashtbl.find main_ram s
        with Not_found ->
          Parser.Exception
            (new Parser.syntax_error "the variable do not exists"))
    | _ ->
        Parser.Exception
          (new Parser.type_error "first argument must be a string")

(**Reads the standard input*)
let read_entry list_of_args =
  match list_of_args with
  | [] -> (
      let a = read_line () in
      try Parser.create_float_argument (float_of_string (String.trim a))
      with Failure _ -> (
        try Parser.create_int_argument (int_of_string (String.trim a))
        with Failure _ -> Parser.create_string_argument a))
  | _ ->
      let a = read_line () in
      Parser.create_string_argument a

let return list_of_args =
  match list_of_args with
  | [] -> Parser.Argument (Parser.Nul ())
  | t :: _ ->
      Stack.push t result;
      Parser.Argument (Parser.Nul ())

(**Takes a string and a list of argument and dispatch the called instruction*)
let recognize_function name list_of_args =
  match String.trim name with
  | "PAINAUCHOCOLAT" -> printf list_of_args (*IO + GOTO*)
  | "CROISSANT" -> print list_of_args
  | "MADELEINE" -> read_variable list_of_args
  | "ECLAIR" -> read_entry list_of_args
  | "CANELE" -> Math.add list_of_args (*MATH*)
  | "STHONORE" -> Math.mult list_of_args
  | "KOUIGNAMANN" -> Math.power list_of_args
  | "PROFITEROLE" -> Math.sqrt list_of_args
  | "FINANCIER" -> Math.fibonacci list_of_args
  | "PAINAURAISIN" -> Math.substract list_of_args
  | "CHOCOLATINE" -> Math.divide list_of_args
  | "BRETZEL" -> Math.randint list_of_args
  | "JOCONDE" -> Math.logb list_of_args
  | "OPERA" -> Math.opposite list_of_args
  | "MILLEFEUILLE" -> Math.floor list_of_args
  | "FRAISIER" -> Math.ceil list_of_args
  | "QUATREQUART" -> add_variable list_of_args

  | "TIRAMISU" ->
      Conditions.equality list_of_args (*operateur de conditions & binaire*)
  | "MERINGUE" -> Conditions.inferior_large list_of_args
  | "MERVEILLE" -> Conditions.inferior_strict list_of_args
  | "BRIOCHE" -> Conditions.superior_large list_of_args
  | "TARTE" -> Conditions.superior_strict list_of_args
  | "FLAN" -> Conditions.binary_and list_of_args
  | "PAINDEPICE" -> Conditions.binary_or list_of_args
  | "CREPE" -> Conditions.binary_xor list_of_args
  | "CHAUSSONAUXPOMMES" -> Conditions.binary_not list_of_args
  | "TARTEAUXFRAISES" -> Array_manipulation.access list_of_args (*ACCESS*)
  | "TARTEAUXFRAMBOISES" -> Array_manipulation.replace list_of_args (*REPLACE*)
  | "TARTEAUXPOMMES" -> Array_manipulation.create_array list_of_args (*CREATE*)
  | "TARTEALARHUBARBE" ->
      Array_manipulation.create_matrix list_of_args (*MCREATE*)
  | "GLACE" -> Array_manipulation.display_array list_of_args (*DISPLAY*)
  | "BEIGNET" -> Array_manipulation.populate list_of_args (*POPULATE*)
  | "DOUGHNUT" -> String_manipulation.replace list_of_args (*SREPLACE*)
  | "BUCHE" -> String_manipulation.create list_of_args (*SCREATE*)
  | "GAUFFREDELIEGE" -> String_manipulation.concat list_of_args (*SADD*)
  | "GAUFFREDEBRUXELLES" -> String_manipulation.access list_of_args (*SACCESS*)
  | "GAUFFRE" -> String_manipulation.split list_of_args (*SPLIT*)
  | "PANCAKE" -> String_manipulation.transform_to_array list_of_args (*TOARR*)
  | "SIROPDERABLE" ->
      String_manipulation.transform_from_array list_of_args (*FROMARR*)
  | "FROSTING" ->
      String_manipulation.convert_to_string list_of_args (*TOSTRING*)
  | "CARROTCAKE" -> String_manipulation.int_from_string list_of_args (*IFS*)
  | "GALETTEDESROIS" ->
      String_manipulation.double_from_string list_of_args (*DFS*)
  | "FRANGIPANE" -> String_manipulation.bool_from_string list_of_args (*BFS*)
  | "APFELSTRUDEL" -> return list_of_args
  
  | "🍞🍫" -> printf list_of_args
  | "🥐" -> print list_of_args
  | "🧈" -> read_variable list_of_args
  | "⛈️🍫" -> read_entry list_of_args
  | "🌰" -> add_variable list_of_args

  | "🧁🍷" -> Math.add list_of_args
  | "🍒" -> Math.mult list_of_args
  | "🎂🧈" -> Math.power list_of_args
  | "🧁🍫" -> Math.sqrt list_of_args
  | "🧁💰" -> Math.fibonacci list_of_args
  | "🍞🍇" -> Math.substract list_of_args
  | "🥐🍫" -> Math.divide list_of_args
  | "🥨" -> Math.randint list_of_args
  | "🥮🖼️" -> Math.logb list_of_args
  | "🎂🎵" -> Math.opposite list_of_args
  | "🥮🧈" -> Math.floor list_of_args
  | "🎂🍓" -> Math.ceil list_of_args

  | "🥮🍵🍫" -> Conditions.equality list_of_args
  | "🥚" -> Conditions.inferior_large list_of_args
  | "🎂🍋" -> Conditions.inferior_strict list_of_args
  | "🍞🥐" -> Conditions.superior_large list_of_args
  | "🥧" -> Conditions.superior_strict list_of_args
  | "🎂🥚" -> Conditions.binary_and list_of_args
  | "🍞🌶️" -> Conditions.binary_or list_of_args
  | "🍞🥚" -> Conditions.binary_xor list_of_args
  | "🍞🍎" -> Conditions.binary_not list_of_args


  | _ ->
      let word = Levenshtein.select_minimal_distance_word name in
      Parser.Exception
        (new Parser.bag_exception
           ("The " ^ name ^ " function does not exists do you mean " ^ word
          ^ " ?"))
