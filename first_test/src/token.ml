module Token = struct
  type token_type = 
    | LEFT_PARENTHESIS
    | RIGHT_PARENTHESIS
    | QUOTE
    | SEMI_COLON
    | Int of int
    | String of string


  let token_to_string = function
    | LEFT_PARENTHESIS -> "("
    | RIGHT_PARENTHESIS -> ")"
    | QUOTE -> "\""
    | SEMI_COLON -> ";"
    | Int(i) -> "Int " ^ string_of_int i
    | String(s) -> "String " ^ s

    let pretty_print ppf tok = Fmt.pf ppf "Token %s" (token_to_string tok)


  end