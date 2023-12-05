fun getLines(infile: string) = let
  val ins = TextIO.openIn infile
  fun loop ins =
    case TextIO.inputLine ins of
         SOME line => line :: loop ins
       | NONE      => []
in
  loop ins before TextIO.closeIn ins
end;

val lines = getLines "in.txt";

(* bag = (RED, GREEN, BLUE) *)
datatype bag = CUBES of int * int * int;
datatype game = GAME of int * bag list;

fun unitBag(value, "red") = CUBES (value, 0, 0)
  | unitBag(value, "green") = CUBES (0, value, 0)
  | unitBag(value, "blue") = CUBES (0, 0, value)
  | unitBag(value, _) = CUBES (0, 0, 0);

fun joinBag(CUBES (a0, a1, a2),
            CUBES (b0, b1, b2)) =
            CUBES (a0 + b0, a1 + b1, a2 + b2);

fun max(a, b) = if a < b then b else a;

fun maxBag(CUBES (a0, a1, a2),
           CUBES (b0, b1, b2)) =
           CUBES (max(a0, b0), max(a1, b1), max(a2, b2));


val null_bag = CUBES (0, 0, 0);
val max_bag = CUBES (12, 13, 14);

fun isChar (c:char) (x:char) = c = x;
fun isSpace #" " = true
  | isSpace #"\n" = true
  | isSpace _ = false;
fun trim s = String.tokens isSpace s;

fun split c s = String.tokens (isChar c) s;

fun getValue(s: string) =
  let
    val value::[color] = split #" " s;
    val SOME value = Int.fromString value;
    val color::[] = trim color;
    in
      unitBag(value, color)  
  end;

fun getBag(s: string) =
  let
    val values = split #"," s;
  in
    List.foldl joinBag null_bag (map getValue values)
  end;

fun isValid (CUBES (r, g, b)) =
  let
    val CUBES (rmax, gmax, bmax) = max_bag
  in
    (r <= rmax) andalso (g <= gmax) andalso (b <= bmax)
  end
  

fun gameValue(GAME (value, bags)) =
  let
    val mx = List.foldl maxBag null_bag bags;
  in
    if isValid mx then
      value
    else
      0
  end;

fun getGame(s: string) =
  let 
    val header::[bags] = split #":" s;
    val _::[value] = split #" " header;
    val SOME value = Int.fromString value;
    val bags = split #";" bags;
  in
    GAME (value, map getBag bags)
  end;

val totalValue = map gameValue (map getGame lines);
val totalValue = List.foldl op+ 0 totalValue;
