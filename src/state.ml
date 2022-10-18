type t = {
  board : Board.t;
  screen : Screen.t;
}

let init () = { board = Board.init (); screen = HomeScreen }
