open Core
exception Error of string
let context = Llvm.global_context ()
let the_module = Llvm.create_module context "testcompiler"
let builder = Llvm.builder context
let int_type = Llvm.i32_type context
let float_type = Llvm.double_type context
let bool_type = Llvm.i1_type context
let nul = Llvm.void_type context
let construct_string str = 
  Llvm.const_string context str;;

let argument_to_value arg = 
  match arg with 
  |Parser.I i -> Llvm.const_int int_type i
  |Parser.D d -> Llvm.const_float float_type d
  |Parser.Str s -> construct_string s
  |Parser.Bool b -> if b then Llvm.const_int bool_type 1 else Llvm.const_int bool_type 0
  |_ -> Llvm.const_null nul
  


let node_of_param param = Parser.Node(param,[]);;
let codegen_expr ast = match ast with
  | Parser.Nil -> Llvm.const_null nul 
  | Parser.Node(Parser.Argument a,_) -> argument_to_value a
  | Parser.Node(Parser.CallExpression name,list_of_args) 
    -> let l = List.map ~f:(Interpreter.exec_node) list_of_args in
       let a = Functions.recognize_function name l
        in 
        let b = (match a with 
          | Parser.Argument a -> argument_to_value a
          | Parser.Exception e -> failwith (e#to_string)
          | _ -> Llvm.const_null nul)
        in b
  | Parser.Node(Parser.Exception e,_) -> failwith e#to_string
  | Parser.Node(Parser.GOTO f,_) -> construct_string f
  | Parser.Node(Parser.Label f,_) -> construct_string f
  | Parser.Node(IF,_) -> construct_string "IF"
  | Parser.Node(COND,_) -> construct_string "COND"
  | Parser.Node(Array,_) -> construct_string "ARRAY"
  | Parser.Node(TBL _,_) -> construct_string "TBL"

