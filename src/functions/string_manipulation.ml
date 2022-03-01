module StringManipulation = struct
open Baguette_base
include Parser



  let two_argument_func func list_of_arguments = 
    if List.length list_of_arguments < 2 then Parser.Exception "not enough args"
    else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
    in let head2 = List.hd tail in func head head2;;

  let three_argument_func func list_of_arguments = 
    if List.length list_of_arguments < 3 then Parser.Exception "not enough args"
    else let head,tail = List.hd list_of_arguments, List.tl list_of_arguments
    in let head2,tail2 = List.hd tail,List.tl tail
    in let head3 = List.hd tail2 in func head head2 head3;;

  let proto_create n s = match n,s with
      | Parser.Argument(Parser.I(n)),Parser.Argument(Parser.Str(s)) -> Parser.Argument(Parser.Str(Array.make n s |> Array.to_list |> String.concat ""))
      | _ -> Parser.Exception "wrong arguments"

  let proto_replace s1 s2 s3 = 
    match (s1,s2,s3) with 
      | Parser.Argument(Parser.Str(s1)),Parser.Argument(Parser.Str(s2)),Parser.Argument(Parser.Str(s3)) -> let regex = Str.regexp s2 in let s = Str.global_replace regex s3 s1 in Parser.Argument(Parser.Str(s))
      | _ -> Parser.Exception "arguments must be string"

  let explode s = List.init (String.length s) (fun (i) -> String.get s i |> Char.escaped)
  let transform_to_array list_of_arguments =
    let aux s1 = (
    match s1 with
      | Parser.Argument(Parser.Str(s1)) -> explode s1 |> List.map Parser.create_string_argument |> Array.of_list |> (fun (a) -> Parser.TBL a)
      | _ -> Parser.Exception "argument must be a string")
  in match list_of_arguments with 
    | [] -> Parser.Exception "not enough args"
    | t::_ -> aux t;;

  let extract_string_from_arg param = 
    match param with 
      | Parser.Argument (Parser.Str s) -> s
      | Parser.Argument (Parser.I i) -> string_of_int i
      | Parser.Argument (Parser.D d) -> string_of_float d
      | Parser.Argument (Parser.Bool b) -> string_of_bool b
      | _ -> ""

  let transform_from_array list_of_arguments =
    let aux arr = 
    (match arr with
      | Parser.TBL arr -> Parser.Argument(Parser.Str(Array.map extract_string_from_arg arr |> Array.to_list |> String.concat ""))
      | _ -> Parser.Exception "argument must be an array")
    in match list_of_arguments with
      | [] -> Parser.Exception "not enough args"
      | t::_ -> aux t;;
  
  let proto_concat s1 s2 = 
    match (s1,s2) with
      | Parser.Argument(Parser.Str(s1)),Parser.Argument(Parser.Str(s2)) -> Parser.Argument(Parser.Str(s1 ^ s2))
      | _ -> Parser.Exception "arguments must be string"

  let proto_access n s = match n,s with
      | Parser.Argument(Parser.I(n)),Parser.Argument(Parser.Str(s)) -> if n >= String.length s then Parser.Exception "out of bound" else Parser.Argument(Parser.Str(String.make 1 s.[n]))
      | _ -> Parser.Exception "wrong arguments"
  
  let proto_split s1 s2 = 
    match (s1,s2) with
      | Parser.Argument(Parser.Str(s1)),Parser.Argument(Parser.Str(s2)) -> let regex = Str.regexp s2 in let arr = Str.split regex s1 in let al = List.map (Parser.create_string_argument) arr in Parser.TBL (Array.of_list al)
      | _ -> Parser.Exception "arguments must be string"


  let replace = three_argument_func proto_replace;;
  let concat = two_argument_func proto_concat;;
  let create = two_argument_func proto_create;;
  let access = two_argument_func proto_access;;

  let split = two_argument_func proto_split;;

  let convert_to_string list_of_arguments = 
    match list_of_arguments with 
      | [] -> Parser.Exception "not enough args"
      | (Parser.Argument (Parser.I(i)))::_ -> Parser.create_string_argument(string_of_int i)
      | (Parser.Argument (Parser.D(d)))::_ -> Parser.create_string_argument(string_of_float d)
      | (Parser.Argument (Parser.Bool(b)))::_ -> Parser.create_string_argument(string_of_bool b)
      | _ -> Parser.Exception "wrong type"

  let int_from_string list_of_arguments =
    match list_of_arguments with 
    | [] -> Parser.Exception "not enough args"
    | (Parser.Argument (Parser.Str(s)))::_ -> (try Parser.create_int_argument(int_of_string s) with Failure _ -> Parser.Exception "error while converting")
    | _ -> Parser.Exception "wrong type";;

  let double_from_string list_of_arguments =
    match list_of_arguments with 
    | [] -> Parser.Exception "not enough args"
    | (Parser.Argument (Parser.Str(s)))::_ -> (try Parser.create_float_argument(float_of_string s) with Failure _ -> Parser.Exception "error while converting")
    | _ -> Parser.Exception "wrong type";;

  let bool_from_string list_of_arguments =
    match list_of_arguments with 
    | [] -> Parser.Exception "not enough args"
    | (Parser.Argument (Parser.Str(s)))::_ -> (try Parser.create_bool_argument(bool_of_string s) with Failure _ -> Parser.Exception "error while converting")
    | _ -> Parser.Exception "wrong type";;



end