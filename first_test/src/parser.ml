module Parser = struct
  include Token

  type arguments = Str of string | I of int;;
  type parameters = CallExpression of string | Argument of arguments;;
  type 'a ast = Nil | Node of 'a * ('a ast) list;;

  let parse_string_rec lst = 
    let rec parse acc lst = 
      match lst with 
        | [] -> ( acc,[])
        | Token.QUOTE::q -> (acc,q)
        | token::q -> parse (acc ^ (Token.token_to_litteral_string token)) q
    in parse "" lst;;
    

end