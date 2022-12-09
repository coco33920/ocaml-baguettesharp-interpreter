(**The Array Manipulation Module of the B# STD*)

(**A generic function to extract two parameters from the list and apply a function*)
let two_argument_func func list_of_arguments =
  if List.length list_of_arguments < 2 then
    Parser.Exception
      (new Parser.arg
         ("This function requires two arguments and you supplied "
         ^ string_of_int (List.length list_of_arguments)
         ^ "arguments"))
  else
    let head, tail = (List.hd list_of_arguments, List.tl list_of_arguments) in
    let head2 = List.hd tail in
    func head head2

(**Creates a list containing n times the element default*)
let rec create_list n default lst =
  match n with 0 -> lst | i -> create_list (i - 1) default (default :: lst)

(**Takes an array and an integer and returns tbl.(n)*)
let proto_access n tbl =
  match (n, tbl) with
  | Parser.Argument (Parser.I n), Parser.TBL arr ->
      if n >= Array.length arr then
        Parser.Exception
          (new Parser.outofbound
             ("The array is of length" ^ string_of_int (Array.length arr)))
      else arr.(n)
  | _ -> Parser.Exception (new Parser.type_error "argument must an array")

(**Takes an array, an integer and an element and performs tbl.(n) <- rp*)
let proto_replace n tbl rp =
  match (n, tbl) with
  | Parser.Argument (Parser.I n), Parser.TBL arr ->
      if n >= Array.length arr then
        Parser.Exception
          (new Parser.outofbound
             ("The array is of length" ^ string_of_int (Array.length arr)))
      else
        let () = arr.(n) <- rp in
        Parser.Argument (Parser.Nul ())
  | _ -> Parser.Exception (new Parser.type_error "argument must be an array")

(**Populate the tbl with times default*)
let proto_populate n default tbl =
  match (n, tbl) with
  | Parser.Argument (Parser.I n), Parser.TBL arr ->
      for i = 1 to n do
        arr.(i) <- default
      done;
      Parser.TBL arr
  | _ -> Parser.Exception (new Parser.type_error "argument must be an array")

(**Create an array of size n populated by default*)
let proto_create_array n default =
  match n with
  | Parser.Argument (Parser.I n) -> Parser.TBL (Array.make n default)
  | _ -> Parser.Exception (new Parser.type_error "argument must be an integer")

(**Create a matrix of size n p populated by default*)
let proto_create_matrix n p default =
  match (n, p) with
  | Parser.Argument (Parser.I n), Parser.Argument (Parser.I p) ->
      let mat = Array.make_matrix n p default in
      let nmap = Array.map (fun ss -> Parser.TBL ss) mat in
      Parser.TBL nmap
  | _ -> Parser.Exception (new Parser.type_error "argument must be an integer")

(**Creates the access function*)
let access = two_argument_func proto_access

(**Creates the create function*)
let create_array = two_argument_func proto_create_array

(**Creates the replace function*)
let replace list_of_arguments =
  if List.length list_of_arguments < 3 then
    Parser.Exception
      (new Parser.arg
         ("This function requires three arguments and you supplied "
         ^ string_of_int (List.length list_of_arguments)
         ^ "arguments"))
  else
    let head, tail = (List.hd list_of_arguments, List.tl list_of_arguments) in
    let head2, tail2 = (List.hd tail, List.tl tail) in
    let head3 = List.hd tail2 in
    proto_replace head head2 head3

(**Creates the populate function*)
let populate list_of_arguments =
  if List.length list_of_arguments < 3 then
    Parser.Exception
      (new Parser.arg
         ("This function requires three arguments and you supplied "
         ^ string_of_int (List.length list_of_arguments)
         ^ "arguments"))
  else
    let head, tail = (List.hd list_of_arguments, List.tl list_of_arguments) in
    let head2, tail2 = (List.hd tail, List.tl tail) in
    let head3 = List.hd tail2 in
    proto_populate head head2 head3

(**Create the create_matrix function*)
let create_matrix list_of_arguments =
  if List.length list_of_arguments < 3 then
    Parser.Exception
      (new Parser.arg
         ("This function requires three arguments and you supplied "
         ^ string_of_int (List.length list_of_arguments)
         ^ "arguments"))
  else
    let head, tail = (List.hd list_of_arguments, List.tl list_of_arguments) in
    let head2, tail2 = (List.hd tail, List.tl tail) in
    let head3 = List.hd tail2 in
    proto_create_matrix head head2 head3

(**Transform an array into a string*)
let display_array list_of_arguments =
  match list_of_arguments with
  | [] ->
      Parser.Exception
        (new Parser.arg
           "This function requires one arguments and you supplied none")
  | hd :: _ -> Parser.Argument (Parser.Str (Parser.print_parameter hd))
