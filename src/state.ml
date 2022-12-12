open Image_graphics

(* Load all images in initial state to optimize cost *)
type gui_images = {
  horse : Graphics.image;
  horse_tutorial : Graphics.image;
  rifle_soldier_light : Graphics.image;
  rocket_launcher_soldier_light : Graphics.image;
  shield_soldier_light : Graphics.image;
  rifle_soldier_dark : Graphics.image;
  rocket_launcher_soldier_dark : Graphics.image;
  shield_soldier_dark : Graphics.image;
  rifle_soldier_tutorial : Graphics.image;
  rocket_launcher_soldier_tutorial : Graphics.image;
  shield_soldier_tutorial : Graphics.image;
  base_light : Graphics.image;
  base_dark : Graphics.image;
  base_tutorial : Graphics.image;
  regular_enemy : Graphics.image;
  buff_enemy : Graphics.image;
  shield_enemy_1 : Graphics.image;
  shield_enemy_2 : Graphics.image;
  regular_enemy_tutorial : Graphics.image;
  buff_enemy_tutorial : Graphics.image;
  shield_enemy_1_tutorial : Graphics.image;
  shield_enemy_2_tutorial : Graphics.image;
  regular_bullet : Graphics.image;
  regular_bullet_tutorial : Graphics.image;
  rocket_bullet : Graphics.image;
  rocket_bullet_tutorial : Graphics.image;
  rifle_soldier_shop : Graphics.image;
  rocket_launcher_soldier_shop : Graphics.image;
  shield_soldier_shop : Graphics.image;
  base_shop : Graphics.image;
  shovel : Graphics.image;
}

type t = {
  board : Board.t;
  mutable screen : Screen.t;
  was_mouse_pressed : bool;
  mutable timer : int;
  mutable shop_selection : Characters.plant_type option;
  mutable is_shovel_selected : bool;
  mutable coins : int;
  mutable level : int;
  mutable zombies_killed : int;
  mutable zombies_on_board : int;
  mutable message : string option;
  mutable message_length : int option;
  images : gui_images;
  mutable raw_last_tick_time : float;
}

let init () =
  {
    board = Board.init ();
    screen = HomeScreen;
    was_mouse_pressed = false;
    timer = 0;
    shop_selection = None;
    is_shovel_selected = false;
    coins = 0;
    level = 1;
    zombies_killed = 0;
    zombies_on_board = 0;
    message = None;
    message_length = None;
    raw_last_tick_time = Unix.gettimeofday ();
    images =
      (* background color *)
      {
        horse =
          Image_graphics.to_image (Png.load "assets/horse.png" []) 92 199 70;
        horse_tutorial =
          Image_graphics.to_image (Png.load "assets/horse.png" []) 255 255 255;
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
        rifle_soldier_tutorial =
          Image_graphics.to_image
            (Png.load "assets/soldiers/rifle_soldier.png" [])
            255 255 255;
        rocket_launcher_soldier_tutorial =
          Image_graphics.to_image
            (Png.load "assets/soldiers/rocket_launcher_soldier.png" [])
            255 255 255;
        shield_soldier_tutorial =
          Image_graphics.to_image
            (Png.load "assets/soldiers/shield_soldier.png" [])
            255 255 255;
        base_light =
          Image_graphics.to_image
            (Png.load "assets/soldiers/base.png" [])
            92 199 70;
        base_dark =
          Image_graphics.to_image
            (Png.load "assets/soldiers/base.png" [])
            82 172 59;
        base_tutorial =
          Image_graphics.to_image
            (Png.load "assets/soldiers/base.png" [])
            255 255 255;
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
        regular_enemy_tutorial =
          Image_graphics.to_image
            (Png.load "assets/enemies/regular_enemy.png" [])
            255 255 255;
        buff_enemy_tutorial =
          Image_graphics.to_image
            (Png.load "assets/enemies/buff_enemy.png" [])
            255 255 255;
        shield_enemy_1_tutorial =
          Image_graphics.to_image
            (Png.load "assets/enemies/shield_enemy_1.png" [])
            255 255 255;
        shield_enemy_2_tutorial =
          Image_graphics.to_image
            (Png.load "assets/enemies/shield_enemy_2.png" [])
            255 255 255;
        regular_bullet =
          Image_graphics.to_image
            (Png.load "assets/bullets/regular_bullet.png" [])
            92 199 70;
        regular_bullet_tutorial =
          Image_graphics.to_image
            (Png.load "assets/bullets/regular_bullet.png" [])
            255 255 255;
        rocket_bullet =
          Image_graphics.to_image
            (Png.load "assets/bullets/rocket_bullet.png" [])
            92 199 70;
        shovel =
          Image_graphics.to_image (Png.load "assets/shovel.png" []) 82 172 59;
        rocket_bullet_tutorial =
          Image_graphics.to_image
            (Png.load "assets/bullets/rocket_bullet.png" [])
            255 255 255;
        rifle_soldier_shop =
          Image_graphics.to_image
            (Png.load "assets/soldiers/rifle_soldier.png" [])
            196 164 132;
        rocket_launcher_soldier_shop =
          Image_graphics.to_image
            (Png.load "assets/soldiers/rocket_launcher_soldier.png" [])
            196 164 132;
        shield_soldier_shop =
          Image_graphics.to_image
            (Png.load "assets/soldiers/shield_soldier.png" [])
            196 164 132;
        base_shop =
          Image_graphics.to_image
            (Png.load "assets/soldiers/base.png" [])
            196 164 132;
      };
  }

let change_screen s t = { t with screen = s }
let get_cell row col t = List.nth (List.nth t.board.rows row).cells col
