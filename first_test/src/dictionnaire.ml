module Dictionnaire = struct

  (*liste de clef valeur*)
  let create () = [];;


  let exists key (dico) = 
    let rec aux acc lst = 
      match acc,lst with
        | _,[] -> acc
        | true,_ -> true
        | _,(k,_)::q when k=key -> aux true q
        | _,q -> aux false q
    in aux false dico;;

  let rec search key dico = 
    match dico with 
      | [] -> raise Not_found
      | (k,value)::_ when k=key -> value
      | _::q -> search key q;;

  let insert (key,value) dico = if (exists key dico) then dico else (key,value)::dico;;

  let delete key dico = if not (exists key dico) then dico else 
    let rec aux acc lst = 
      match lst with 
        | [] -> List.rev acc
        | (k,_)::q when k=key -> aux acc q
        | c::q -> aux (c::acc) q
    in aux [] dico;;
  
end