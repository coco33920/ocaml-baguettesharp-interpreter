open Baguette_sharp
include Token 
include Parser
include Lexer
include Interpreter

let list_of_funct = [
  "PAINAUCHOCOLAT";
  "PAINVIENNOIS";
  "CROISSANT";
  "MADELEINE";
  "ECLAIR";
  "CANELE";
  "STHONORE";
  "KOUGNAMANN";
  "PROFITEROLE";
  "FINANCIER";
  "PAINAURAISIN";
  "CHOCOLATINE";
  "BRETZEL";
  "BAGUETTEVIENNOISE";
  "OPERA";
  "MILLEFEUILLE";
  "FRAISIER";
  "QUATREQUART";
  "TIRAMISU";
  "MERINGUE";
  "MERVEILLE";
  "BRIOCHE";
  "TARTE";
  "FLAN";
  "PAINDEPICE";
  "CREPE";
  "CHAUSSONAUXPOMMES";
  "SABLE";
  "CHOUQUETTE";
  "CLAFOUTIS";
  "PARISBREST";
  "TARTEAUXFRAISES";
  "TARTEAUXFRAMBOISES";
  "TARTEAUXPOMMES";
  "TARTEALARHUBARBE";
  "GLACE";
  "BEIGNET";
  "DOUGHNUT";
  "BUCHE";
  "GAUFFREDELIEGE";
  "GAUFFREDEBRUXELLE";
  "GAUFFRE";
  "PANCAKE";
  "SIROPDERABLE";
  "FROSTING";
  "CARROTCAKE";
  "GALETTEDESROIS";
  "FRANGIPANE";
  "BABAAURHUM";
  "CHARLOTTEAUXFRAISES"
  ]

let hash_table = Hashtbl.create 100;;
let shared_ram = Hashtbl.create 1000;;
let _ = (list_of_funct,[
  "printf <message> [args...]";
  "goto <line:int>";
  "print [messages...]";
  "access_variable <name:str>";
  "read stdin";
  "add <a:number> <b:number> [numbers...]";
  "mult <a:number> <b:number> [numbers...]";
  "exponent <a:number> <b:number> (a^b)";
  "sqrt <a:number>";
  "nth-fibonacci <n:int>";
  "substract <a:number> <b:number> (a-b)";
  "divide <a:number> <b:number> (a/b)";
  "randomint <a:int> <b:int> in [[a,b]]";
  "logb <a:number> <b:number> log of a on base b";
  "opposite <a:number> (-a)";
  "floor <a:number>";
  "ceil <a:number>";
  "save_variable <name:str> <value>";
  "= <a> <b> (a=b)";
  "<= <a> <b> (a<=b)";
  "< <a> <b> (a<b)";
  ">= <a> <b> (a>=b)";
  "> <a> <b> (a>b)";
  "and <a> <b> (a&&b)";
  "or <a> <b> (a||b)";
  "xor <a> <b> (a<>b)";
  "not <a> (not a)";
  "if <cond:bool> <a:int> <b:int> goto a if true else b";
  "(";
  ")";
  "\"";
  "access <n:int> <arr:array> arr.(n)";
  "replace <n:int> <arr:array> <el> arr.(n) <- el";
  "create <n:int> <el> Array.make n el";
  "mcreate <n:int> <p:int> <el> Array.make_matrix n p el";
  "display <arr:array> [|el1...eln|]";
  "populate <arr:array> <el> populate the array arr with el";
  "replace <s1:string> <s2:string> <s3:string> replace all s2 occurence by s3 in s1";
  "create <n:int> <s:string> create a string with n times s";
  "add <s1:string> <s2:string> s1 ^ s2";
  "access <n:int> <s1:string> s1.[n]";
  "split <s1:string> <s2:string> split s1 with s2";
  "toarray <s1:string> convert s1 to an array of chars (string chars)";
  "fromarray <arr:array> convert arr to a string from the chars";
  "tostring <el> convert el to a string";
  "ifs <s:string> convert s to a string";
  "dfs <s:string> convert s to a float";
  "bfs <s:string> convert s to a boolean";
  "[";
  "]"
 ]) |> (fun (a,b) -> List.combine a b) |> (List.iter (fun (a,b) -> Hashtbl.add hash_table a b))
  
let usage_message = "baguette-sharp --input <filename>";;
let input_file = ref "";;
let print_about () = print_endline "Baguette# Version 2.0.3 by Charlotte THOMAS"
let output_file = ref "";;
let verbose = ref false;;
let lexer = ref false;;

let spec = [("--input", Arg.Set_string input_file, "precise where is the file to interpret/compile (compilation is not implemented)");
("--output", Arg.Set_string output_file, "precise where the file should be compiled (NOT IMPLEMENTED YET)");
("--version", Arg.Unit print_about, "print version and about the software");
("--verbose", Arg.Set verbose, "show test version");
("--lexer", Arg.Set lexer, "change the lexer to the char version" )]


let read_file filename = 
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true; do
      let a = input_line chan in if not (String.starts_with ~prefix:"//" a) then lines := a :: !lines
    done; !lines
  with End_of_file ->
    close_in chan;
    List.rev !lines ;;


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
    
let parse_file ?(verbose=false) ?(lexer=false) file =
  if verbose then parse_file_verbosely ~lexer:lexer file 
  else let str = read_file file |> List.map String.trim |> String.concat " " in
  let token_list = if not lexer then Lexer.generate_token str else Lexer.generate_token_with_chars str in
  let a = Lexer.validate_parenthesis_and_quote token_list in 
  match a with 
    | Exception s -> print_endline (s#to_string)
    | _ -> Parser.parse_file token_list |> Interpreter.runtime |> ignore;;

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

let fuse_hash_tbl original new_one = 
  Hashtbl.iter (fun a b -> Hashtbl.add original a b) new_one;;

let display_help () =
  print_endline "\027[1;38;2;195;239;195m### Baguette# Interpreter REPL Command Help ###\027[m";
  print_endline "\027[2;38;2;195;239;195m~ help: show this help";
  print_endline "~ load <file>: load and execute a baguette file";
  print_endline "~ exit: exit the REPL";
  print_endline "~ save <file>: save the history in file";
  print_endline "~ lexer: toggle the char or default version of the lexer";
  print_endline "~ verbose: toggle the verbose (default:false)\027[m";;


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

let load_file ?(verbose=false) ?(lexer=false) lst = 
  if List.length lst < 2 then print_endline "not enough args"
  else (
    let tl = List.tl lst in let file = List.hd tl in 
      try parse_file ~verbose:verbose ~lexer:lexer file with _ -> print_endline ("The file " ^ file ^ " do not exists.")
  );;
let rec new_repl_funct () = 
  let rec user_input prompt cb =
    match LNoise.linenoise prompt with 
      | None -> new_repl_funct ()
      | Some v -> cb v; user_input prompt cb
  in LNoise.history_set ~max_length:100 |> ignore;
  print_endline "\027[38;2;195;239;195m### Welcome to Baguette# REPL; type help for help ###\027[m"; print_newline ();
    
  LNoise.set_hints_callback (fun line ->
    let a =  String.trim @@ List.hd @@ List.rev @@ (String.split_on_char ' ') @@ line in 
    try let v = Hashtbl.find hash_table a in Some (" >> "^v,LNoise.Green,false) with _ -> None
  );

  LNoise.set_completion_callback (fun line_so_far in_completion ->
    let line = line_so_far |> String.split_on_char ' ' |> Array.of_list |> (fun arr -> arr.(Array.length arr - 1) <- ""; arr) |> Array.to_list |> String.concat " " in
    let current_word = List.hd @@ List.rev @@ String.split_on_char ' ' @@ line_so_far in
    if line_so_far <> "" && not (String.starts_with ~prefix:"load" line_so_far) && not (String.starts_with ~prefix:"exit" line_so_far) && not (String.starts_with ~prefix:"save" line_so_far) && not (String.starts_with ~prefix:"help" line_so_far)
      then list_of_funct |> List.filter (String.starts_with ~prefix:current_word) |> List.map (String.cat line) |> List.iter (LNoise.add_completion in_completion);
    if current_word <> "" && (String.starts_with ~prefix:"load" line_so_far)
      then
      possible_completion_file current_word
      |> List.map (String.cat "load ")
      |> List.iter (LNoise.add_completion in_completion);
    if line_so_far = "" then (["help";"load";"verbose";"exit";"save";"lexer"] |> List.iter (LNoise.add_completion in_completion))
  );
  (
    fun from_user ->
      let lst = String.split_on_char ' ' from_user in
      match String.trim(List.hd lst) with 
        | "help" -> display_help ()
        | "load" -> load_file ~verbose:!verbose ~lexer:!lexer lst
        | "verbose" -> verbose := not !verbose; print_endline ("\027[2;38;2;195;239;195mVerbose set to " ^ string_of_bool !verbose ^ "\027[0m")
        | "exit" -> exit 0
        | "lexer" -> lexer := not !lexer; print_endline ("\027[2;38;2;195;239;195mLexer (char:true,normal:false) set to " ^ string_of_bool !lexer ^ "\027[0m")
        | "save" -> if List.length lst < 2 then print_endline "not enough args" else let file = List.hd (List.tl lst) in LNoise.history_save ~filename:file |> ignore
        | _ -> let ram = parse_line ~lexer:!lexer ~verbose:!verbose from_user true in (fuse_hash_tbl shared_ram ram); LNoise.history_add from_user |> ignore;
    ) |> user_input "\027[38;2;244;113;116m~>\027[m "
  ;;

let anon_fun (_ : string) = ();;

let () = 
  Arg.parse spec anon_fun usage_message;
  try parse_file ~verbose:!verbose ~lexer:!lexer !input_file with _ ->
    new_repl_funct ()
