open Image_graphics

(* Load all images in initial state to optimize cost *)
type gui_images = {
  horse : Graphics.image;
  rifle_soldier_light : Graphics.image;
  rocket_launcher_soldier_light : Graphics.image;
  shield_soldier_light : Graphics.image;
  rifle_soldier_dark : Graphics.image;
  rocket_launcher_soldier_dark : Graphics.image;
  shield_soldier_dark : Graphics.image;
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
      (* background color *)
      {
        horse =
          Image_graphics.to_image (Png.load "assets/horse.png" []) 92 199 70;
        rifle_soldier_light =
          Image_graphics.to_image
            (Png.load "assets/soldiers/rifle_soldier.png" [])
            92 199 70;
        rocket_launcher_soldier_light =
          Image_graphics.to_image
            (Png.load "assets/soldiers/rocket_launcher_soldier.png" [])
            92 199 70;
        shield_soldier_light =
          Image_graphics.to_image
            (Png.load "assets/soldiers/shield_soldier.png" [])
            92 199 70;
        rifle_soldier_dark =
          Image_graphics.to_image
            (Png.load "assets/soldiers/rifle_soldier.png" [])
            82 172 59;
        rocket_launcher_soldier_dark =
          Image_graphics.to_image
            (Png.load "assets/soldiers/rocket_launcher_soldier.png" [])
            82 172 59;
        shield_soldier_dark =
          Image_graphics.to_image
            (Png.load "assets/soldiers/shield_soldier.png" [])
            82 172 59;
        base =
          Image_graphics.to_image
            (Png.load "assets/soldiers/base.png" [])
            92 199 70;
        regular_enemy =
          Image_graphics.to_image
            (Png.load "assets/enemies/regular_enemy.png" [])
            82 172 59;
        buff_enemy =
          Image_graphics.to_image
            (Png.load "assets/enemies/buff_enemy.png" [])
            82 172 59;
        shield_enemy_1 =
          Image_graphics.to_image
            (Png.load "assets/enemies/shield_enemy_1.png" [])
            82 172 59;
        shield_enemy_2 =
          Image_graphics.to_image
            (Png.load "assets/enemies/shield_enemy_2.png" [])
            82 172 59;
        regular_bullet =
          Image_graphics.to_image
            (Png.load "assets/bullets/regular_bullet.png" [])
            92 199 70;
        rocket_bullet =
          Image_graphics.to_image
            (Png.load "assets/bullets/rocket_bullet.png" [])
            92 199 70;
      };
  }

let change_screen s t = { t with screen = s }
let get_cell row col t = List.nth (List.nth t.board.rows row).cells col
