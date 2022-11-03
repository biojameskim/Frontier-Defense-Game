type t = {
  board : Board.t;
  screen : Screen.t;
}

let init () = { board = Board.init (); screen = HomeScreen }
let change_screen s t = { board = t.board; screen = s }
