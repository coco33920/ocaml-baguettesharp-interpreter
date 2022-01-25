module Lexer = struct
  include Token

  type lexer = {
    input : string;
    position : int;
    read_position : int;
    ch : char;
  };;

  let null_byte = '\x00'

 

  let read_char lexer =
    let str_end = lexer.read_position >= String.length (lexer.input) in
    let new_ch = if str_end then null_byte else String.get (lexer.input) (lexer.read_position) in
    {lexer with position=lexer.read_position; read_position=lexer.read_position+1; ch=new_ch};;
 let new_lexer input_string = 
      let lexer = {
        input = input_string;
        position = 0;
        read_position = 0;
        ch = null_byte;
      }
    in read_char lexer;;

  let read_token word in_quote = 
    match (Token.string_to_token word) with
      | NULL_TOKEN -> (Token.STRING_TOKEN(word ^ " "),0)
      | QUOTE -> (QUOTE,1)
      | token -> if in_quote then (Token.STRING_TOKEN(word ^ " "),0) else (token,0);;

  let generate_token input_string = 
    let lst = String.split_on_char ' ' input_string in
    let rec aux acc quotes lst = match lst with
      | [] -> List.rev acc
      | t::q -> let token,add = read_token t ((quotes mod 2) = 1) in aux (token::acc) (quotes+add) q
  in aux [] 0 lst;;

  let validate_parenthesis_and_quote input_token_list = 
    let stack = Stack.create () in
    let rec aux stack acc lst = match lst with 
      | [] -> Stack.is_empty stack && (acc mod 2)=0
      | Token.LEFT_PARENTHESIS::q -> Stack.push 1 stack; aux stack acc q
      | Token.RIGHT_PARENTHESIS::q  -> if Stack.is_empty stack then failwith "parenthésage invalide" else (let _ = Stack.pop stack in aux stack acc q)
      | Token.QUOTE::q -> aux stack (acc+1) q
      | _::q -> aux stack acc q
  in aux stack 0 input_token_list;;
end