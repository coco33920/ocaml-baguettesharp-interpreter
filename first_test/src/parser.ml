module Parser = struct
  include Token

  type arguments = Str of string | I of int;;
  type parameters = CallExpression of string | Argument of arguments;;
  type 'a ast = Nil | Node of 'a * 'a list ast;;

  let parse_string index_start token_lst = 
    let s = ref "" and n = Array.length token_lst and i_a = ref (index_start+1) in 
    while !i_a < (n-1) && (match token_lst.(!i_a) with Token.QUOTE -> false | _ -> true) do
      s := !s ^ (Token.token_to_litteral_string (token_lst.(!i_a)));
      i_a := !i_a + 1
    done;
    (!s,!i_a)
end