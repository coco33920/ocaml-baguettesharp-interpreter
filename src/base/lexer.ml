(**
   General lexer module : generate lexers char by char or word by word (default)
*)

(**Take a word and if the lexer is between quotes and returns the corresponding token with Token#string_to_token*)
let read_token word in_quote =
  match Token.string_to_token word with
  | NULL_TOKEN -> (Token.STRING_TOKEN word, 0)
  | QUOTE -> (QUOTE, 1)
  | token -> if in_quote then (Token.STRING_TOKEN word, 0) else (token, 0)

let recognized_token = Token.recognized_token

(**Returns the maximum of a list*)
let rec max_lst acc lst =
  match lst with
  | [] -> acc
  | i :: q when i >= acc -> max_lst i q
  | _ :: q -> max_lst acc q

(**Take a string and returns the biggest token matching the keyword*)
let is_a_token_a_keyword input_string =
  let a =
    List.map
      (fun s ->
        try
          let v = Str.search_forward (Str.regexp s) input_string 0 in
          v
        with _ -> -1)
      recognized_token
  in
  max_lst (-1) a

(**Runs the type inference algorithm*)
let type_inference_algorithm input_string =
  try
    let a = int_of_string input_string in
    Token.INT_TOKEN a
  with Failure _ -> (
    try
      let a = float_of_string input_string in
      Token.FLOAT_TOKEN a
    with Failure _ -> Token.STRING_TOKEN input_string)

(**Take a string with a token in it and returns a couple of Tokens*)
let extract_token input_string index =
  let aux =
    try
      let a = index in
      let s1 = String.sub input_string 0 a
      and s2 = String.sub input_string a (String.length input_string - a) in
      match (String.trim s1, String.trim s2) with
      | "", "" -> (Token.NULL_TOKEN, Token.NULL_TOKEN)
      | s1, "" -> (type_inference_algorithm s1, Token.NULL_TOKEN)
      | "", s2 -> (Token.NULL_TOKEN, Token.string_to_token s2)
      | s1, s2 -> (type_inference_algorithm s1, Token.string_to_token s2)
    with _ -> (type_inference_algorithm input_string, Token.NULL_TOKEN)
  in
  aux

(**The char by char lexer*)
let generate_token_with_chars input_string =
  let lst = List.of_seq (String.to_seq input_string) in
  let rec aux acc storage lst quote_count =
    match lst with
    | [] -> List.rev acc
    | t :: q when t = ' ' -> aux acc (storage ^ " ") q quote_count
    | t :: q ->
        let storage = storage ^ String.make 1 t in
        let i = is_a_token_a_keyword storage in
        let s = i >= 0 in
        if s = true && quote_count mod 2 = 0 then
          let s, token = extract_token storage i in
          match (s, token) with
          | Token.NULL_TOKEN, Token.NULL_TOKEN -> aux acc storage q quote_count
          | Token.NULL_TOKEN, Token.QUOTE ->
              aux (Token.QUOTE :: acc) "" q (quote_count + 1)
          | Token.NULL_TOKEN, t -> aux (t :: acc) "" q quote_count
          | s, Token.NULL_TOKEN -> aux (s :: acc) "" q quote_count
          | s, Token.QUOTE ->
              aux (Token.QUOTE :: s :: acc) "" q (quote_count + 1)
          | s, t -> aux (t :: s :: acc) "" q quote_count
        else if s = true && quote_count mod 2 = 1 then
          let s, token = extract_token storage i in
          match (s, token) with
          | Token.NULL_TOKEN, Token.QUOTE ->
              aux (Token.QUOTE :: acc) "" q (quote_count + 1)
          | s, Token.QUOTE ->
              aux (Token.QUOTE :: s :: acc) "" q (quote_count + 1)
          | _, _ -> aux acc storage q quote_count
        else aux acc storage q quote_count
  in
  aux [] "" lst 0

(**The word by word lexers*)
let generate_token input_string =
  let lst = String.split_on_char ' ' input_string in
  let rec aux acc quotes lst =
    match lst with
    | [] -> List.rev acc
    | t :: q ->
        let token, add = read_token t (quotes mod 2 = 1) in
        aux (token :: acc) (quotes + add) q
  in
  aux [] 0 lst

(**A function to count the parenthesis and validate if every parenthesis are closed and every quotes are doubled*)
let validate_parenthesis_and_quote input_token_list =
  let stack = Stack.create () in
  let rec aux stack acc lst =
    match lst with
    | [] -> Parser.create_bool_argument (Stack.is_empty stack && acc mod 2 = 0)
    | Token.LEFT_PARENTHESIS :: q ->
        Stack.push 1 stack;
        aux stack acc q
    | Token.RIGHT_PARENTHESIS :: q ->
        if Stack.is_empty stack then
          Parser.Exception (new Parser.syntax_error "invalid parenthesis")
        else
          let _ = Stack.pop stack in
          aux stack acc q
    | Token.QUOTE :: q -> aux stack (acc + 1) q
    | _ :: q -> aux stack acc q
  in
  aux stack 0 input_token_list

(**Algorithm
  if a parenthesis is closed without having been opened then the token is eliminated
  at the end close parenthesis are added in case of too much opened parenthesis*)
let automatic_correction_of_parenthesis input_token_list =
  let stack = Stack.create () in
  let rec aux stack acc lst =
    match lst with
    | [] ->
        let r = ref acc in
        let n = Stack.length stack in
        for _ = 0 to n - 1 do
          r := Token.RIGHT_PARENTHESIS :: !r
        done;
        List.rev !r
    | Token.LEFT_PARENTHESIS :: q ->
        Stack.push 1 stack;
        aux stack (Token.LEFT_PARENTHESIS :: acc) q
    | Token.RIGHT_PARENTHESIS :: q ->
        if Stack.is_empty stack then aux stack acc q
        else
          let _ = Stack.pop stack in
          aux stack (Token.RIGHT_PARENTHESIS :: acc) q
    | t :: q -> aux stack (t :: acc) q
  in
  aux stack [] input_token_list
