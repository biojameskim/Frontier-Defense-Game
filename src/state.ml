type t = {
  board : Board.t;
  mutable screen : Screen.t;
  was_mouse_pressed : bool;
  mutable timer : int;
  mutable shop_selection : Characters.plant_type option;
  mutable coins : int;
  mutable level : int;
  mutable zombies_killed : int;
  images : Gui_util.gui_images;
}

let init () =
  {
    board = Board.init ();
    screen = HomeScreen;
    was_mouse_pressed = false;
    timer = 0;
    shop_selection = None;
    coins = 0;
    level = 1;
    zombies_killed = 0;
    images = Gui_util.get_images ();
  }

let change_screen s t = { t with screen = s }
let get_cell row col t = List.nth (List.nth t.board.rows row).cells col
