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

  let string_to_token str = match (String.trim str) with
    | "CHOUQUETTE" -> LEFT_PARENTHESIS
    | "CLAFOUTIS" -> RIGHT_PARENTHESIS
    | "PARISBREST" -> QUOTE
    | "BAGUETTE" -> SEMI_COLON
    | str -> try INT_TOKEN(int_of_string str) with Failure _ -> (try FLOAT_TOKEN(float_of_string str) with Failure _-> NULL_TOKEN)
    | _ -> NULL_TOKEN



  let token_to_string = function
    | LEFT_PARENTHESIS -> "{(}"
    | RIGHT_PARENTHESIS -> "{)}"
    | QUOTE -> "{\"}"
    | SEMI_COLON -> "{;}"
    | INT_TOKEN(i) ->  "{Int " ^ string_of_int i ^ "}"
    | STRING_TOKEN (s) -> "{String \"" ^ s ^ "\"}"
    | _ -> ""
  
  let token_to_litteral_string = function
    | LEFT_PARENTHESIS -> "("
    | RIGHT_PARENTHESIS -> ")"
    | SEMI_COLON -> ";"
    | INT_TOKEN(i) -> string_of_int i ^ " "
    | STRING_TOKEN (s) -> s 
    | _ -> ""

    
    let pretty_print ppf tok = Fmt.pf ppf "Token %s" (token_to_string tok)
    

  end