type t = {
  board : Board.t;
  screen : Screen.t;
  was_mouse_pressed : bool
}

let init () = { board = Board.init (); screen = HomeScreen; was_mouse_pressed = false }
let change_screen s t = { t with screen = s }
let get_cell row col t = List.nth (List.nth t.board.rows row).cells col
