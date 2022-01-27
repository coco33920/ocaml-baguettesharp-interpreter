module Parser = struct
  include Token

  type arguments = Str of string | I of int | Nul of unit | D of float | Bool of bool;;
  type parameters = CallExpression of string | Argument of arguments | GOTO of int;;
  type 'a ast = Nil | Node of 'a * ('a ast) list;;

  let parse_string_rec lst = 
    let rec parse acc lsts = 
      match lsts with 
        | [] -> ( acc,[])
        | Token.QUOTE::q -> (acc,q)
        | token::q -> parse (acc ^ (Token.token_to_litteral_string token)) q
    in parse "" lst;;
    
    (*Only parse a callexpression and not a line ? => not important right now multiline is more important*)
    let parse_line lst = 
      let rec aux last_token acc lst = 
        match lst with
          | [] -> lst,List.rev acc
          | Token.LEFT_PARENTHESIS::q -> (match last_token with 
            | Token.STRING_TOKEN s -> let rest,accs = aux Token.LEFT_PARENTHESIS [] q in (aux Token.NULL_TOKEN (Node(CallExpression s, accs)::(List.tl acc)) rest)
            | _ -> aux Token.LEFT_PARENTHESIS acc q)
          | Token.RIGHT_PARENTHESIS::q -> q,List.rev acc
          | Token.QUOTE::q -> let str,q2 = parse_string_rec q in aux Token.QUOTE (Node(Argument (Str str), [Nil])::acc) q2
          | Token.SEMI_COLON::_ -> lst,List.rev acc
          | (Token.STRING_TOKEN s)::q -> aux (Token.STRING_TOKEN s) (Node(Argument (Str s), [Nil])::acc) q
          | (Token.INT_TOKEN i)::q  -> aux (Token.INT_TOKEN i) (Node(Argument (I i), [Nil])::acc) q
          | (Token.FLOAT_TOKEN d)::q -> aux (Token.FLOAT_TOKEN d) (Node(Argument (D d), [Nil])::acc) q
          | (Token.BOOL_TOKEN f)::q -> aux (Token.BOOL_TOKEN f) (Node(Argument (Bool f), [Nil])::acc) q
          | _::q -> q,List.rev acc 
      in aux Token.NULL_TOKEN [] lst;;



    let parse_file list_of_tokens = 
      let rec aux acc lst = 
        match lst with
          | [] -> acc
          | Token.SEMI_COLON::[] -> acc
          | Token.SEMI_COLON::q -> let rest,accs = parse_line q in aux (acc @ accs) rest
          | _::q -> aux acc q
      in let rest,accs = parse_line list_of_tokens in aux accs rest;;

      let print_argument arg = 
        match arg with 
          | Str s -> "String: " ^ s
          | I i -> "Int: " ^ string_of_int i
          | D d -> "Float: " ^ string_of_float d
          | Bool b -> "Bool: " ^ string_of_bool b
          | Nul () -> "Nil";;


      

      let print_parameter param = 
        match param with 
          | CallExpression s -> "Fonction: " ^ s
          | Argument s -> "Argument: " ^ print_argument s
          | GOTO i -> "GOTO: " ^ (string_of_int i)

      let print_pretty_arguments param = 
        String.concat " " (List.map print_parameter param);;

      let rec print_pretty_node node =
          match node with 
            | Nil -> ""
            | Node (parameter, arguments) -> "(" ^ print_parameter parameter ^ ") [" ^ (String.concat " " (List.map print_pretty_node arguments)) ^ "]"

    

end