module Parser = struct
  include Token

  type arguments = Str of string | I of int;;
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
          | [] -> acc
          | Token.LEFT_PARENTHESIS::q -> (match last_token with 
            | Token.STRING_TOKEN s -> [Node(CallExpression s, aux Token.LEFT_PARENTHESIS [] q)]
            | _ -> aux Token.LEFT_PARENTHESIS acc q)
          | Token.RIGHT_PARENTHESIS::_ -> acc
          | Token.QUOTE::q -> let str,q2 = parse_string_rec q in aux Token.QUOTE (Node(Argument (Str str), [Nil])::acc) q2
          | Token.SEMI_COLON::q -> acc
          | (Token.STRING_TOKEN s)::q -> aux (Token.STRING_TOKEN s) (Node(Argument (Str s), [Nil])::acc) q
          | (Token.INT_TOKEN i)::q  -> aux (Token.INT_TOKEN i) (Node(Argument (I i), [Nil])::acc) q 
          | _ -> acc 
      in aux Token.NULL_TOKEN [] lst;;

      let print_argument arg = 
        match arg with 
          | Str s -> s
          | I i -> string_of_int i;;

      

      let print_parameter param = 
        match param with 
          | CallExpression s -> "Fonction: " ^ s
          | Argument s -> "Argument: " ^ print_argument s
      let rec print_pretty_node node =
          match node with 
            | Nil -> ""
            | Node (parameter, arguments) -> "(" ^ print_parameter parameter ^ ") [" ^ (String.concat " " (List.map print_pretty_node arguments)) ^ "]"

      

end