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

  (*let read_token lexer =
    let rec aux acc lexer =
      print_string acc;
      print_newline ();
      match (Token.string_to_token acc) with
        | NULL_TOKEN -> let lex = read_char lexer in aux (acc ^ (String.make 1 lex.ch)) lex
        | token -> (, token)
    in aux (String.make 1 lexer.ch) lexer;;*)

  let read_token word = 
    match (Token.string_to_token word) with
      | NULL_TOKEN -> Token.STRING_TOKEN(word ^ " ")
      | token -> token
  
  let generate_token input_string = 
    let lst = String.split_on_char ' ' input_string in
    let rec aux acc lst = match lst with
      | [] -> List.rev acc
      | t::q -> aux ((read_token t)::acc) q
  in aux [] lst;;
end