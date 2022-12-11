(** Represents the state of the game. *)

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
(** [gui_images] is the type that represents all the images that are used in the
    game. *)

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
}
(** [t] is the type that represents the current state of the game. *)

val init : unit -> t
(** [init] initializes the state of the game. *)

val change_screen : Screen.t -> t -> t
(** [change_screen s t] changes the state [t] to display screen [s]. *)

val get_cell : int -> int -> t -> Board.cell
(** get_cell [r c t] returns the cell given row [r], column [c], and state [t]. *)
