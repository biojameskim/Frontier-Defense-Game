(** Represents the state of the game. *)

type warning = BuyBasesWarning

(** Represents various warning messages that may be shown to the user. *)

type message = string * int
(** Represents a GUI pop-up message. *)

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
  mutable messages : message list;
  images : gui_images;
  mutable raw_last_tick_time : float;
  mutable warnings_given : warning list;
  mutable bases_giving_message : Characters.plant list;
}
(** [t] is the type that represents the current state of the game. *)

val init : unit -> t
(** [init] initializes the state of the game. *)

val change_screen : Screen.t -> t -> t
(** [change_screen s t] changes the state [t] to display screen [s] and returns
    the state [t]. *)

val get_cell : int -> int -> t -> Board.cell
(** get_cell [r c t] returns the cell given row [r], column [c], and state [t]. *)

val add_message : string -> int -> ?allow_duplication:bool -> t -> unit
(** [add_message msg duration t] adds a new message to [t]. *)

val remove_message : string -> t -> unit
(** [remove_message msg t] removes the message [msg] from [t]. *)

val reduce_message_durations : t -> unit
(** [reduce_message_durations t] subtracts 1 from every message duration and
    removes messages with non-positive duration. *)

val trigger_warning : warning -> string -> int -> t -> unit
(** [trigger_warning warning msg duration t] is like add_message but ensures
    that each variant of warning is only shown to the user one time. *)

val update_shovel : bool -> t -> t
(** [update_shovel is_shovel_selected] changes whether the shovel is selected
    and adds/removes the corresponding methods. *)
