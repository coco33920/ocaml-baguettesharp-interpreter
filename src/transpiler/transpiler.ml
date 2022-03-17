let _ = 
  print_endline "file:";
  let file = read_line () in 
  let f = Naive.t file 
  in Naive.compile f;; 