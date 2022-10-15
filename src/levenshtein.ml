let list_of_funct =
  [
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
    "CHARLOTTEAUXFRAISES";
    "BAGUETTE";
  ]

let minA s = String.sub s 1 (String.length s - 1)

(**Regular Slow AF levenshtein*)
let rec leven a b =
  let n, m = (String.length a, String.length b) in
  if min n m = 0 then max n m
  else if a.[0] = b.[0] then leven (minA a) (minA b)
  else
    1
    + min (min (leven (minA a) b) (leven a (minA b))) (leven (minA a) (minA b))

(**Fast DP Levenshtein algorithm Wagner/Fischer *)
let rapideLeven a b =
  let n, m = (String.length a, String.length b) in
  let d = Array.make_matrix (n + 1) (m + 1) 0 in
  let temp = ref 0 in
  for i = 0 to n do
    d.(i).(0) <- i
  done;
  for j = 0 to m do
    d.(0).(j) <- j
  done;
  for i = 1 to n do
    for j = 1 to m do
      if a.[i - 1] = b.[j - 1] then temp := 0 else temp := 1;
      d.(i).(j) <-
        min
          (min (d.(i - 1).(j) + 1) (d.(i).(j - 1) + 1))
          (d.(i - 1).(j - 1) + !temp)
    done
  done;
  d.(n).(m)

let select_minimal_distance_word word =
  let f s = (rapideLeven s word, s) in
  let l = list_of_funct in
  let l = List.map f l in
  let l = List.sort Stdlib.compare l in
  let _, w = List.hd l in
  w
