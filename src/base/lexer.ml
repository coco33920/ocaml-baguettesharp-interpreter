module Lexer = struct
  include Token
  open Parser 
  let read_token word in_quote = 
    match (Token.string_to_token word) with
      | NULL_TOKEN -> (Token.STRING_TOKEN(word),0)
      | QUOTE -> (QUOTE,1)
      | token -> if in_quote then (Token.STRING_TOKEN(word),0) else (token,0);;


  (*
  Algorithm to recognize token with char
  We read a char, store our CURRENT string
  => We add the char to the storage
  => If a token is a suffix of the string => we add the Token and the string token and continue with an empty storage string
  => If not => we continue
  => the end => List.rev acc
  *)
  
  (*check if the incoming string has a token as suffix*)
  let is_a_token_a_keyword input_string =
    List.mapi (fun i s -> try (Str.search_forward (Str.regexp s) input_string 0 |> ignore; i,true)
    with _ -> i,false) Token.recognized_token

    |> (fun l -> 
        let s = 
          try List.find (fun (_,b) -> b=true) l 
          with _ -> (0,false)
      in s);;


  let extract_token input_string i = 
    let aux s =
      try 
        let a = Str.search_forward (Str.regexp s) input_string 0
        in let s1 = String.sub input_string 0 a and s2 = String.sub input_string a (String.length input_string - a)
        in match (s1,s2) with
          | "","" -> (Token.NULL_TOKEN,Token.NULL_TOKEN)
          | s1,"" -> (Token.STRING_TOKEN s1,Token.NULL_TOKEN)
          | "",s2 -> (Token.NULL_TOKEN, Token.string_to_token s2)
          | s1,s2 -> (Token.STRING_TOKEN s1,Token.string_to_token s2)
      with _ ->
        (Token.STRING_TOKEN input_string, Token.NULL_TOKEN)
    in aux (List.nth Token.recognized_token i);;


  let generate_token_with_chars input_string =
    let lst = List.of_seq (String.to_seq input_string)
  in let rec aux acc storage lst = match lst with
    | [] -> List.rev acc
    | t::q when t = ' ' -> aux acc storage q
    | t::q -> let storage = storage ^ (String.make 1 t) in 
      let c,s = is_a_token_a_keyword storage in
      if s=true then 
        let s,token = extract_token storage c in
        match s,token with
          | Token.NULL_TOKEN,Token.NULL_TOKEN -> aux acc storage q
          | s,Token.NULL_TOKEN -> aux (s::acc) "" q
          | Token.NULL_TOKEN,t -> aux (t::acc) "" q
          | s,t -> aux (t::s::acc) "" q
    else aux acc storage q
  in aux [] "" lst;;

  let generate_token input_string = 
    let lst = String.split_on_char ' ' input_string in
    let rec aux acc quotes lst = match lst with
      | [] -> List.rev acc
      | t::q -> let token,add = read_token t ((quotes mod 2) = 1) in aux (token::acc) (quotes+add) q
  in aux [] 0 lst;;

  let validate_parenthesis_and_quote input_token_list = 
    let stack = Stack.create () in
    let rec aux stack acc lst = match lst with 
      | [] -> Parser.create_bool_argument (Stack.is_empty stack && (acc mod 2)=0)
      | Token.LEFT_PARENTHESIS::q -> Stack.push 1 stack; aux stack acc q
      | Token.RIGHT_PARENTHESIS::q  -> if Stack.is_empty stack then Parser.Exception (new Parser.syntax_error "invalid parenthesis") else (let _ = Stack.pop stack in aux stack acc q)
      | Token.QUOTE::q -> aux stack (acc+1) q
      | _::q -> aux stack acc q
  in aux stack 0 input_token_list;;
end