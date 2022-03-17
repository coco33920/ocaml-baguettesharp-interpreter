open Baguette_sharp
let src = "CROISSANT CHOUQUETTE PARISBREST Hello, World ! PARISBREST CLAFOUTIS BAGUETTE";;
Lexer.generate_token src |> Parser.parse_file |> Interpreter.runtime
