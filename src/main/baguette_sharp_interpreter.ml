open Baguette_sharp
(**The REPL of B#*)

open Utils

(**List of all functions*)

let hash_table = Hashtbl.create 100
let shared_ram = Hashtbl.create 1000

let _ =
  ( list_of_funct,
    [
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
      "replace <s1:string> <s2:string> <s3:string> replace all s2 occurence by \
       s3 in s1";
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
      "]";
      ";";
    ] )
  |> (fun (a, b) -> List.combine a b)
  |> List.iter (fun (a, b) -> Hashtbl.add hash_table a b)

let usage_message = "baguette-sharp --input <filename>"
let input_file = ref ""
let print_about () = print_endline "Baguette# Version 2.0.4 by Charlotte THOMAS"
let output_file = ref ""
let verbose = ref false
let lexer = ref false

let spec =
  [
    ( "--input",
      Arg.Set_string input_file,
      "precise where is the file to interpret/compile" );
    ( "--output",
      Arg.Set_string output_file,
      "precise where the file should be compiled" );
    ("--version", Arg.Unit print_about, "print version and about the software");
    ("--verbose", Arg.Set verbose, "show test version");
    ("--lexer", Arg.Set lexer, "change the lexer to the char version");
  ]

(**Take a filename and returns a list of the lines of the file*)

(**Main REPL Function using Linenoise*)
let rec new_repl_funct () =
  let rec user_input prompt cb =
    match LNoise.linenoise prompt with
    | None -> new_repl_funct ()
    | Some v ->
        cb v;
        user_input prompt cb
  in
  LNoise.history_set ~max_length:100 |> ignore;
  print_endline
    "\027[38;2;195;239;195m### Welcome to Baguette# REPL; type help for help \
     ###\027[m";
  print_newline ();

  LNoise.set_hints_callback (fun line ->
      let a =
        String.trim @@ List.hd @@ List.rev @@ String.split_on_char ' ' @@ line
      in
      try
        let v = Hashtbl.find hash_table a in
        Some (" >> " ^ v, LNoise.Green, false)
      with _ -> None);

  LNoise.set_completion_callback (fun line_so_far in_completion ->
      let line =
        line_so_far |> String.split_on_char ' ' |> Array.of_list
        |> (fun arr ->
             arr.(Array.length arr - 1) <- "";
             arr)
        |> Array.to_list |> String.concat " "
      in
      let current_word =
        List.hd @@ List.rev @@ String.split_on_char ' ' @@ line_so_far
      in
      if
        line_so_far <> ""
        && (not (String.starts_with ~prefix:"load" line_so_far))
        && (not (String.starts_with ~prefix:"exit" line_so_far))
        && (not (String.starts_with ~prefix:"save" line_so_far))
        && not (String.starts_with ~prefix:"help" line_so_far)
      then
        list_of_funct
        |> List.filter (String.starts_with ~prefix:current_word)
        |> List.map (String.cat line)
        |> List.iter (LNoise.add_completion in_completion);
      if current_word <> "" && String.starts_with ~prefix:"load" line_so_far
      then
        possible_completion_file current_word
        |> List.map (String.cat "load ")
        |> List.iter (LNoise.add_completion in_completion);
      if line_so_far = "" then
        [ "help"; "load"; "verbose"; "exit"; "save"; "lexer" ]
        |> List.iter (LNoise.add_completion in_completion));
  (fun from_user ->
    let lst = String.split_on_char ' ' from_user in
    match String.trim (List.hd lst) with
    | "help" -> display_help ()
    | "load" -> load_file ~verbose:!verbose ~lexer:!lexer lst
    | "verbose" ->
        verbose := not !verbose;
        print_endline
          ("\027[2;38;2;195;239;195mVerbose set to " ^ string_of_bool !verbose
         ^ "\027[0m")
    | "exit" -> exit 0
    | "lexer" ->
        lexer := not !lexer;
        print_endline
          ("\027[2;38;2;195;239;195mLexer (char:true,normal:false) set to "
         ^ string_of_bool !lexer ^ "\027[0m")
    | "save" ->
        if List.length lst < 2 then print_endline "not enough args"
        else
          let file = List.hd (List.tl lst) in
          LNoise.history_save ~filename:file |> ignore
    | _ ->
        let ram = parse_line ~lexer:!lexer ~verbose:!verbose from_user true in
        fuse_hash_tbl shared_ram ram;
        LNoise.history_add from_user |> ignore)
  |> user_input "\027[38;2;244;113;116m~>\027[m "

let anon_fun (_ : string) = ()

let () =
  Arg.parse spec anon_fun usage_message;
  if !output_file != "" 
    then 
      begin
      print_endline ("Compiling file " ^ !input_file ^ " at output " ^ !output_file ^ " with ocamlopt");
      Transpiler.compile !input_file !output_file |> ignore
      end
  else try parse_file ~verbose:!verbose ~lexer:!lexer !input_file with _ ->
    new_repl_funct ()
