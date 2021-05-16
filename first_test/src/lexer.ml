module Lexer = struct
  include Token

  type lexer = {
    input : string;
    position : int;
    read_position : int;
    ch : char;
  }

  let null_byte = '\x00'

  let new_lexer input_string = 
    {
      input = input_string;
      position = 0;
      read_position = 0;
      ch = null_byte;
    }

end