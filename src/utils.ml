let read_file filename = 
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true; do
      let a = input_line chan in if not (String.starts_with ~prefix:"//" a) then lines := a :: !lines
    done; !lines
  with End_of_file ->
    close_in chan;
    List.rev !lines;;

(**Parsing a file and outputting all of the different steps*)
let parse_file_verbosely ?(lexer=false) file =
  let src = read_file file |> List.map String.trim |> String.concat " " in
  print_endline "Input code : ";
  print_newline ();
  print_endline src;
  print_newline ();
  let token_list = if not lexer then Lexer.generate_token src else Lexer.generate_token_with_chars src in
  print_newline ();
  print_endline "Lexed code : ";
  print_newline ();
  Token.print_token_list token_list;
  let a = Lexer.validate_parenthesis_and_quote token_list in 
  match a with
  | Exception s -> print_endline (s#to_string)
  | _ -> (
      let ast = Parser.parse_file token_list in
      print_newline ();
      print_endline "Parsed code : ";
      print_newline ();
      (List.iter (fun s -> print_endline (Parser.print_pretty_node s))) ast;
      print_newline ();
      print_endline "Interpreter : ";
      print_newline (); 
      Interpreter.runtime ast |> ignore
    );;

(**Parse a file and execute the runtime*)
let parse_file ?(verbose=false) ?(lexer=false) file =
  if verbose then parse_file_verbosely ~lexer:lexer file 
  else let str = read_file file |> List.map String.trim |> String.concat " " in
    let token_list = if not lexer then Lexer.generate_token str else Lexer.generate_token_with_chars str in
    let a = Lexer.validate_parenthesis_and_quote token_list in 
    match a with 
    | Exception s -> print_endline (s#to_string)
    | _ -> Parser.parse_file token_list |> Interpreter.runtime |> ignore;;

(**Parse a line and execute it through the runtime*)
let parse_line ?(verbose=false) ?(lexer=false) line repl =
  let str = String.trim line in
  if verbose then(
    print_endline "Read code : ";
    print_endline str);
  let token_list = if not lexer then Lexer.generate_token str else Lexer.generate_token_with_chars str in
  if verbose then(
    print_endline "Lexed code : ";
    Token.print_token_list token_list);
  let a = Lexer.validate_parenthesis_and_quote token_list in 
  match a with 
  | Exception s -> print_endline (s#to_string); Hashtbl.create 1
  | _ -> let ast = Parser.parse_file token_list in
    if verbose then
      (print_endline "Parsed code : ";
       List.iter (fun s -> print_endline (Parser.print_pretty_node s)) ast;
       print_endline "Runtime : ";
       print_newline ();
      );
    Interpreter.runtime ~repl:repl ast;;

(**Takes two Hahstbl and fuse them together*)
let fuse_hash_tbl original new_one = 
  Hashtbl.iter (fun a b -> Hashtbl.add original a b) new_one;;

(**Display the REPL Help*)
let display_help () =
  print_endline "\027[1;38;2;195;239;195m### Baguette# Interpreter REPL Command Help ###\027[m";
  print_endline "\027[2;38;2;195;239;195m~ help: show this help";
  print_endline "~ load <file>: load and execute a baguette file";
  print_endline "~ exit: exit the REPL";
  print_endline "~ save <file>: save the history in file";
  print_endline "~ lexer: toggle the char or default version of the lexer";
  print_endline "~ verbose: toggle the verbose (default:false)\027[m";;

(**List all of possible file in directory for autocompletion*)
let possible_completion_file word =
  let word = if word = "" then "./" else word in
  let array = 
    if Sys.file_exists word && Sys.is_directory word then Sys.readdir word
    else Sys.readdir (Filename.dirname word) in
  let file_list = Array.to_list array in 
  let file_list_with_name = 
    if Sys.file_exists word && Sys.is_directory word
    then List.map (String.cat ((Filename.basename word) ^ (Filename.dir_sep))) file_list
    else List.map (String.cat ((Filename.dirname word) ^ Filename.dir_sep)) (List.filter (String.starts_with ~prefix:(Filename.basename word)) file_list) 
  in
  let filtered_list = List.map (fun str -> 
      if String.starts_with ~prefix:"./" str then Str.replace_first (Str.regexp "./") "" str
      else str) file_list_with_name
  in
  let double_filtered_list = List.map (fun str -> 
      if Sys.file_exists str && Sys.is_directory str then (str ^ Filename.dir_sep)
      else str) filtered_list
  in double_filtered_list;;

let load_file_name ?(verbose=false) ?(lexer=false) file = 
  try parse_file ~verbose:verbose ~lexer:lexer file with _ -> print_endline ("The file " ^ file ^ " do not exists.");;
  
(**Load a file*)
let load_file ?(verbose=false) ?(lexer=false) lst = 
  if List.length lst < 2 then print_endline "not enough args"
  else (
    let tl = List.tl lst in let file = List.hd tl in 
    load_file_name ~verbose:verbose ~lexer:lexer file
  );;
