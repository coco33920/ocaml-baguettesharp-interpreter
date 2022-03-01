open Baguette_sharp
open Baguette_base
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
let fill = (list_of_funct,[
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
let print_about () = print_string "Baguette# Version 1.0 by Charlotte THOMAS"
let output_file = ref "";;

let spec = [("--input", Arg.Set_string input_file, "precise where is the file to interpret/compile (compilation is not implemented)");
("--output", Arg.Set_string output_file, "precise where the file should be compiled (NOT IMPLEMENTED YET)");
("--version", Arg.Unit print_about, "print version and about the software")]


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

let parse_file file = 
  let str = read_file file |> List.map String.trim |> String.concat " " in
  let token_list = Lexer.generate_token str in
  let a = Lexer.validate_parenthesis_and_quote token_list in 
  match a with 
    | Exception s -> print_string s
    | _ -> Parser.parse_file token_list |> Interpreter.runtime |> ignore;;

let parse_line line repl = 
  let str = String.trim line in
  let token_list = Lexer.generate_token str in
  let a = Lexer.validate_parenthesis_and_quote token_list in 
  match a with 
    | Exception s -> print_string s; Hashtbl.create 1
    | _ -> Parser.parse_file token_list |> Interpreter.runtime ~repl:repl;;

let fuse_hash_tbl original new_one = 
  Hashtbl.iter (fun a b -> Hashtbl.add original a b) new_one;;

let display_help () =
  print_endline "### Baguette# Interpreter REPL Command Help ###";
  print_endline "~ help: show this help";
  print_endline "~ load <file>: load and execute a baguette file";
  print_endline "~ exit: exit the REPL";
  print_endline "~ save <file>: save the history in file";;

let load_file lst = 
  if List.length lst < 2 then print_endline "not enough args"
  else (
    let tl = List.tl lst in let file = List.hd tl in parse_file file
  );;
let rec new_repl_funct () = 
  let rec user_input prompt cb =
    match LNoise.linenoise prompt with 
      | None -> new_repl_funct ()
      | Some v -> cb v; user_input prompt cb
  in LNoise.history_set ~max_length:100 |> ignore;
  print_endline "### Welcome to Baguette# REPL; type help for help ###"; print_newline ();
    
  LNoise.set_hints_callback (fun line ->
    let a =  String.trim @@ List.hd @@ List.rev @@ (String.split_on_char ' ') @@ line in 
    try let v = Hashtbl.find hash_table a in Some (" >> "^v,LNoise.Green,false) with _ -> None
  );

  LNoise.set_completion_callback (fun line_so_far in_completion ->
    let line = line_so_far |> String.split_on_char ' ' |> Array.of_list |> (fun arr -> arr.(Array.length arr - 1) <- ""; arr) |> Array.to_list |> String.concat " " in
    let current_word = List.hd @@ List.rev @@ String.split_on_char ' ' @@ line_so_far in
    if line_so_far <> ""
      then list_of_funct |> List.filter (String.starts_with ~prefix:current_word) |> List.map (String.cat line) |> List.iter (LNoise.add_completion in_completion)
  );

  (
    fun from_user ->
      let lst = String.split_on_char ' ' from_user in
      match String.trim(List.hd lst) with 
        | "help" -> display_help ()
        | "load" -> load_file lst
        | "exit" -> exit 0
        | "save" -> if List.length lst < 2 then print_endline "not enough args" else let file = List.hd (List.tl lst) in LNoise.history_save ~filename:file |> ignore
        | _ -> let ram = parse_line from_user true in (fuse_hash_tbl shared_ram ram); LNoise.history_add from_user |> ignore;
    ) |> user_input "> "
  ;;


let anon_fun (_ : string) = ();;

let () = 
  if Array.length (Sys.argv) = 1 then new_repl_funct () else
  Arg.parse spec anon_fun usage_message;
  try parse_file !input_file with _ -> ();;
