open Monkey
include Lexer
include Token

let token_testable = Alcotest.testable Token.pretty_print (=)

let test_lexer_delimiters () =
  Alcotest.(check (list token_testable))
    "same token types" [
        Token.PLUS
      ; Token.RIGHT_PARENTHESIS
      ; Token.LEFT_PARENTHESIS
      ; Token.SEMI_COLON
      ; Token.QUOTE
      ]
      (Lexer.generate_tokens "=+(){},;")

let () =
  Alcotest.run "Lexer"
    [
      ( "list-delimiters",
        [ Alcotest.test_case "first case" `Slow test_lexer_delimiters ] );
    ]
