module Compiler = struct
  open Baguette_base
  include Lexer
  include Token
  include Parser


  let write_file lst filename =
    let rec aux chan list = 
      match list with 
        | [] -> close_out chan; ();
        | t::q -> output_string chan t; output_string chan "\n"; flush chan; aux chan q;
    in aux (open_out filename) lst;;    

end