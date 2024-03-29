(**The Token Module*)

(**Type of tokens*)
type token_type =
  | LEFT_PARENTHESIS
  | RIGHT_PARENTHESIS
  | KEYWORD of string
  | QUOTE
  | SEMI_COLON
  | INT_TOKEN of int
  | FLOAT_TOKEN of float
  | NULL_TOKEN
  | STRING_TOKEN of string
  | BOOL_TOKEN of bool
  | ARRAY_BEGIN
  | PARAM_BEGIN
  | ARRAY_END
  | PARAM_END
  | COMMENT
  | COMMA

(**Parses a string into a token*)
let string_to_token str =
  match String.trim str with
  | "CHOUQUETTE" -> LEFT_PARENTHESIS
  | "CLAFOUTIS" -> RIGHT_PARENTHESIS
  | "PARISBREST" -> QUOTE
  | "BAGUETTE" -> SEMI_COLON
  | "CUPCAKE" -> BOOL_TOKEN true
  | "POPCAKE" -> BOOL_TOKEN false
  | "MUFFIN" -> KEYWORD "BEGIN"
  | "COOKIES" -> KEYWORD "END"
  | "ICECREAM" -> KEYWORD "LABEL"
  | "PAINVIENNOIS" -> KEYWORD "GOTO"
  | "SABLE" -> KEYWORD "IF"
  | "FRAMBOISIER" -> KEYWORD "THEN"
  | "LAUGEWECKLE" -> KEYWORD "LOAD"
  | "BABAAURHUM" -> ARRAY_BEGIN
  | "CHARLOTTEAUXFRAISES" -> ARRAY_END
  | "SCHNECKENKUCHEN" -> PARAM_END
  | "CRUMBLE" -> PARAM_BEGIN
  | "//" -> COMMENT
  | "," -> COMMA
  | "🧅" -> LEFT_PARENTHESIS
  | "🧄" -> RIGHT_PARENTHESIS
  | "🍉" -> QUOTE
  | "🥖" -> SEMI_COLON
  | "🧁" -> BOOL_TOKEN true
  | "🎂" -> BOOL_TOKEN false
  | "🥮" -> KEYWORD "BEGIN"
  | "🍪" -> KEYWORD "END"
  | "🍨" -> KEYWORD "LABEL"
  | "🍞" -> KEYWORD "GOTO"
  | "🥠" -> KEYWORD "IF"
  | "🍰" -> KEYWORD "THEN"
  | "🍊" -> KEYWORD "LOAD"
  | "🍫" -> ARRAY_BEGIN
  | "🍬" -> ARRAY_END
  | "🍭" -> PARAM_END
  | "🍮" -> PARAM_BEGIN
  | str -> (
      try INT_TOKEN (int_of_string str) with
      | Failure _ -> (
          try FLOAT_TOKEN (float_of_string str) with Failure _ -> NULL_TOKEN)
      | _ -> NULL_TOKEN)

(**A list of token recognized by the lexer*)
let recognized_token =
  [
    ",";
    "CHOUQUETTE";
    "CLAFOUTIS";
    "PARISBREST";
    "BAGUETTE";
    "CUPCAKE";
    "SCHNECKENKUCHEN";
    "CRUMBLE";
    "POPCAKE";
    "MUFFIN";
    "COOKIES";
    "ICECREAM";
    "PAINVIENNOIS";
    "SABLE";
    "FRAMBOISIER";
    "BABAAURHUM";
    "//";
    "LAUGEWECKLE";
  ]

(**Transforms a token into a string*)
let token_to_string = function
  | LEFT_PARENTHESIS -> "{(}"
  | RIGHT_PARENTHESIS -> "{)}"
  | QUOTE -> "{\"}"
  | SEMI_COLON -> "{;}"
  | INT_TOKEN i -> "{Int " ^ string_of_int i ^ "}"
  | FLOAT_TOKEN i -> "{Float " ^ string_of_float i ^ "}"
  | STRING_TOKEN s -> "{String \"" ^ s ^ "\"}"
  | BOOL_TOKEN f -> "{Bool: " ^ string_of_bool f ^ "}"
  | KEYWORD k -> "{KEYWORD: " ^ k ^ "}"
  | ARRAY_BEGIN -> "{[}"
  | ARRAY_END -> "{]}"
  | PARAM_BEGIN -> "{ { }"
  | PARAM_END -> "{ } }"
  | COMMENT -> "{//}"
  | COMMA -> "{,}"
  | NULL_TOKEN -> "NULL"

(**Transforms the value of a token into a string*)
let token_to_litteral_string = function
  | LEFT_PARENTHESIS -> "("
  | RIGHT_PARENTHESIS -> ")"
  | SEMI_COLON -> ";"
  | INT_TOKEN i -> string_of_int i ^ " "
  | STRING_TOKEN s -> s
  | FLOAT_TOKEN d -> string_of_float d ^ " "
  | BOOL_TOKEN f -> string_of_bool f ^ " "
  | KEYWORD k -> k ^ " "
  | ARRAY_BEGIN -> "["
  | ARRAY_END -> "]"
  | PARAM_BEGIN -> "{"
  | PARAM_END -> "}"
  | COMMENT -> "//"
  | COMMA -> ","
  | _ -> ""

(**Pretty print a token*)
let pretty_print ppf tok = Fmt.pf ppf "Token %s" (token_to_string tok)

(**Prints a list of token*)
let print_token_list list =
  let rec str acc list =
    match list with
    | [] -> acc
    | t :: q -> str (acc ^ token_to_string t ^ " ") q
  in
  let s = str "[" list in
  print_string (s ^ "]")
