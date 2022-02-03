module Token = struct
  type token_type = 
    | LEFT_PARENTHESIS
    | RIGHT_PARENTHESIS
    | QUOTE
    | SEMI_COLON
    | INT_TOKEN of int
    | FLOAT_TOKEN of float
    | NULL_TOKEN
    | STRING_TOKEN of string
    | BOOL_TOKEN of bool

  let string_to_token str = match (String.trim str) with
    | "CHOUQUETTE" -> LEFT_PARENTHESIS
    | "CLAFOUTIS" -> RIGHT_PARENTHESIS
    | "PARISBREST" -> QUOTE
    | "BAGUETTE" -> SEMI_COLON
    | "CUPCAKE" -> BOOL_TOKEN true
    | "POPCAKE" -> BOOL_TOKEN false 
    | str -> try INT_TOKEN(int_of_string str) with Failure _ -> (try FLOAT_TOKEN(float_of_string str) with Failure _-> NULL_TOKEN)
    | _ -> NULL_TOKEN



  let token_to_string = function
    | LEFT_PARENTHESIS -> "{(}"
    | RIGHT_PARENTHESIS -> "{)}"
    | QUOTE -> "{\"}"
    | SEMI_COLON -> "{;}"
    | INT_TOKEN(i) ->  "{Int " ^ string_of_int i ^ "}"
    | FLOAT_TOKEN(i) -> "{Float " ^ string_of_float i ^ "}"
    | STRING_TOKEN (s) -> "{String \"" ^ s ^ "\"}"
    | BOOL_TOKEN f -> "{Bool: " ^ string_of_bool f ^ "}"
    | _ -> ""
  
  let token_to_litteral_string = function
    | LEFT_PARENTHESIS -> "("
    | RIGHT_PARENTHESIS -> ")"
    | SEMI_COLON -> ";"
    | INT_TOKEN(i) -> string_of_int i ^ " "
    | STRING_TOKEN (s) -> s 
    | FLOAT_TOKEN d -> string_of_float d ^ " "
    | BOOL_TOKEN f -> string_of_bool f ^ " "
    | _ -> ""

    
    let pretty_print ppf tok = Fmt.pf ppf "Token %s" (token_to_string tok)


let print_token_list list =
  let rec str acc list = 
    match list with
      | [] -> acc
      | t::q -> str (acc ^ (token_to_string t) ^ " ") q
  in let s = str "[" list in print_string (s ^ "]");;
    

  end