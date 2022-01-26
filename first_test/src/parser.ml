module Parser = struct
  include Token

  type arguments = Str of string | I of int | Nul of unit | D of float;;
  type parameters = CallExpression of string | Argument of arguments;;
  type 'a ast = Nil | Node of 'a * ('a ast) list;;

  let parse_string_rec lst = 
    let rec parse acc lsts = 
      match lsts with 
        | [] -> ( acc,[])
        | Token.QUOTE::q -> (acc,q)
        | token::q -> parse (acc ^ (Token.token_to_litteral_string token)) q
    in parse "" lst;;
    
    let parse_line lst = 
      let rec aux last_token acc lst = 
        match lst with 
          | [] -> List.rev acc
          | Token.LEFT_PARENTHESIS::q -> (match last_token with 
            | Token.STRING_TOKEN s -> [Node(CallExpression s, aux Token.LEFT_PARENTHESIS [] q)]
            | _ -> aux Token.LEFT_PARENTHESIS acc q)
          | Token.RIGHT_PARENTHESIS::_ -> List.rev acc
          | Token.QUOTE::q -> let str,q2 = parse_string_rec q in aux Token.QUOTE (Node(Argument (Str str), [Nil])::acc) q2
          | Token.SEMI_COLON::_ -> List.rev acc
          | (Token.STRING_TOKEN s)::q -> aux (Token.STRING_TOKEN s) (Node(Argument (Str s), [Nil])::acc) q
          | (Token.INT_TOKEN i)::q  -> aux (Token.INT_TOKEN i) (Node(Argument (I i), [Nil])::acc) q 
          | (Token.FLOAT_TOKEN d)::q -> aux (Token.FLOAT_TOKEN d) (Node(Argument (D d), [Nil])::acc) q
          | _ -> List.rev acc 
      in aux Token.NULL_TOKEN [] lst;;

      let print_argument arg = 
        match arg with 
          | Str s -> s
          | I i -> string_of_int i
          | D d -> string_of_float d
          | Nul () -> "Nil";;


      

      let print_parameter param = 
        match param with 
          | CallExpression s -> "Fonction: " ^ s
          | Argument s -> "Argument: " ^ print_argument s

      let print_pretty_arguments param = 
        String.concat " " (List.map print_parameter param);;

      let rec print_pretty_node node =
          match node with 
            | Nil -> ""
            | Node (parameter, arguments) -> "(" ^ print_parameter parameter ^ ") [" ^ (String.concat " " (List.map print_pretty_node arguments)) ^ "]"

    

end