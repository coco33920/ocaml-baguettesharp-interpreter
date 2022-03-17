(**The REPL of B#*)
open Baguette_sharp
open Llvm

(**List of all functions*)
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
];;

let hash_table = Hashtbl.create 100;;
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
  ]) |> (fun (a,b) -> List.combine a b) |> (List.iter (fun (a,b) -> Hashtbl.add hash_table a b));;

let usage_message = "baguette-sharp --input <filename>";;
let input_file = ref "";;
let print_about () = print_endline "Baguette# Version 2.0.4 by Charlotte THOMAS"
let output_file = ref "";;
let verbose = ref false;;
let lexer = ref false;;

let spec = [("--input", Arg.Set_string input_file, "precise where is the file to interpret/compile (compilation is not implemented)");
            ("--output", Arg.Set_string output_file, "precise where the file should be compiled (NOT IMPLEMENTED YET)");
            ("--version", Arg.Unit print_about, "print version and about the software");
            ("--verbose", Arg.Set verbose, "show test version");
            ("--lexer", Arg.Set lexer, "change the lexer to the char version" )];;

(**Take a filename and returns a list of the lines of the file*)
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

let compile_file ?(lexer=false) file =
  let str = read_file file |> List.map String.trim |> String.concat " " in
    let token_list = if not lexer then Lexer.generate_token str else Lexer.generate_token_with_chars str in
    let a = Lexer.validate_parenthesis_and_quote token_list in 
    match a with 
    | Exception s -> print_endline (s#to_string)
    | _ ->  Parser.parse_file token_list |>
            List.map (fun c -> dump_value (Codegen.codegen_expr c)) |> ignore;;


let anon_fun (_ : string) = ();;

let () = 
  Arg.parse spec anon_fun usage_message;
  compile_file ~lexer:!lexer !input_file;
  dump_module Codegen.the_module;;
