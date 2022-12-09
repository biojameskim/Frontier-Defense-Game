open Image_graphics

(* Load all images in initial state to optimize cost *)
type gui_images = {
  horse : Graphics.image;
  rifle_soldier : Graphics.image;
  rocket_launcher_soldier : Graphics.image;
  shield_soldier : Graphics.image;
  base : Graphics.image;
  regular_enemy : Graphics.image;
  buff_enemy : Graphics.image;
  shield_enemy_1 : Graphics.image;
  shield_enemy_2 : Graphics.image;
  regular_bullet : Graphics.image;
  rocket_bullet : Graphics.image;
}

type t = {
  board : Board.t;
  mutable screen : Screen.t;
  was_mouse_pressed : bool;
  mutable timer : int;
  mutable shop_selection : Characters.plant_type option;
  mutable coins : int;
  mutable level : int;
  mutable zombies_killed : int;
  images : gui_images;
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
    images =
      {
        horse = Image_graphics.to_image (Png.load "assets/horse.png" []);
        rifle_soldier =
          Image_graphics.to_image
            (Png.load "assets/soldiers/rifle_soldier.png" []);
        rocket_launcher_soldier =
          Image_graphics.to_image
            (Png.load "assets/soldiers/rocket_launcher_soldier.png" []);
        shield_soldier =
          Image_graphics.to_image
            (Png.load "assets/soldiers/shield_soldier.png" []);
        base = Image_graphics.to_image (Png.load "assets/soldiers/base.png" []);
        regular_enemy =
          Image_graphics.to_image
            (Png.load "assets/enemies/regular_enemy.png" []);
        buff_enemy =
          Image_graphics.to_image (Png.load "assets/enemies/buff_enemy.png" []);
        shield_enemy_1 =
          Image_graphics.to_image
            (Png.load "assets/enemies/shield_enemy_1.png" []);
        shield_enemy_2 =
          Image_graphics.to_image
            (Png.load "assets/enemies/shield_enemy_2.png" []);
        regular_bullet =
          Image_graphics.to_image
            (Png.load "assets/bullets/regular_bullet.png" []);
        rocket_bullet =
          Image_graphics.to_image
            (Png.load "assets/bullets/rocket_bullet.png" []);
      };
  }

let change_screen s t = { t with screen = s }
let get_cell row col t = List.nth (List.nth t.board.rows row).cells col
