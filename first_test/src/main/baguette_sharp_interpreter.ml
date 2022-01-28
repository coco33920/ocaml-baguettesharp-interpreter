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
  "CHAUSSONAUPOMME";
  "SABLE";
  "CHOUQUETTE";
  "CLAFOUTIS";
  "PARISBREST";]


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
 ]) |> (fun (a,b) -> List.combine a b) |> (List.iter (fun (a,b) -> Hashtbl.add hash_table a b))
  
let usage_message = "baguette-sharp -input <filename>";;
let input_file = ref "";;
let repl = ref false;;

let spec = [("-repl", Arg.Set repl, "lance le repl"); ("-input", Arg.Set_string input_file, "precise le fichier à lancer")]

let anon_fun (_ : string) = ()

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
  let lines = read_file file in 
  let str = String.concat " " lines in
  let token_list = Lexer.generate_token str in
  if (not (Lexer.validate_parenthesis_and_quote token_list)) then failwith "parenthésage invalide"
  else (
    let ast = Parser.parse_file token_list in 
    let _ = Interpreter.runtime ast in () 
  );;

let parse_line line = 
  let str = line in
  let token_list = Lexer.generate_token str in 
  if (not (Lexer.validate_parenthesis_and_quote token_list)) then (print_string "parenthésage invalide"; Hashtbl.create 1)
  else (
    let ast = Parser.parse_file token_list in
    let ram = Interpreter.runtime ast in ram
  );;

let fuse_hash_tbl original new_one = 
  Hashtbl.iter (fun a b -> Hashtbl.add original a b) new_one;;

let display_help () =
  print_string "### Baguette# Interpreter REPL Command Help ###";
  print_newline ();
  print_string "~ help: show this help"; print_newline();
  print_string "~ load <file>: load and execute a baguette file"; print_newline ();
  print_string "~ exit: exit the REPL"; print_newline ();
  print_string "~ save <file>: save the history in file"; print_newline ();;

let load_file lst = 
  if List.length lst < 2 then print_string "not enough args"
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
        | "save" -> if List.length lst < 2 then print_string "not enough args" else let file = List.hd (List.tl lst) in LNoise.history_save ~filename:file |> ignore
        | _ -> let ram = parse_line from_user in (fuse_hash_tbl shared_ram ram); LNoise.history_add from_user |> ignore;
    ) |> user_input "> "
  ;;



let () = 
  Arg.parse spec anon_fun usage_message;
  if !repl then new_repl_funct () else parse_file !input_file;;