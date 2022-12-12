(** Represents the characters in the game. *)

(** [zombie_type] is the type representing the category of zombies. *)
type zombie_type =
  | RegularZombie
  | TrafficConeHeadZombie
  | BucketHeadZombie

type zombie = {
  mutable hp : int;
  damage : int;
  mutable location : int * int;
  mutable speed : int;
  frame : int;
  zombie_type : zombie_type;
  width : int;
}
(** [zombie] is the type of a zombie. *)

type plant_type =
  | PeaShooterPlant
  | IcePeaShooterPlant
  | WalnutPlant
  | SunflowerPlant
      (** [plant_type] is the type representing the category of plants. *)

type plant = {
  mutable hp : int;
  speed : int;
  mutable timer : int;
  location : int * int;
  plant_type : plant_type;
  cost : int;
  width : int;
}
(** [plant] is the type of a plant. *)

(** [pea_type] is the type representing the category of peas. *)
type pea_type =
  | RegularPea
  | RocketPea

type pea = {
  pea_type : pea_type;
  damage : int;
  mutable location : int * int;
  speed : int;
  width : int;
}
(** [pea] is the type of a pea. *)

type lawnmower = {
  damage : int;
  mutable speed : int;
  location : int * int;
  row : int;
  width : int;
}
(** [lawnmower] is the type of a lawnmower *)

type sun = {
  location : int * int;
  row : int;
}
(** [sun] is the type of *)

val zombie_walk : zombie -> unit
(** [zombie_walk zombie] mutates the zombie to update the location. *)

val lawnmower_walk : lawnmower option -> lawnmower option
(** [lawnmower_walk lawnmower] returns a new lawnmower with updated location.
    This can be used to update the lawnmowers on the screen, making it appear as
    if they are moving across the screen. *)

val spawn_pea : plant -> pea
(** [spawn_pea plant] returns a pea based on the type of the plant *)

val pea_walk : pea -> unit
(** [pea_walk pea] updates the location of a pea. This can be used to update the
    peas on the screen, making it appear as if they are moving across the
    screen. *)

val spawn_zombie : Gui_util.point -> zombie_type -> zombie
(** [spawn_zombie location zombie_type] returns a zombie at the given location
    and with the given type. *)

val get_plant_cost : plant_type -> int
(** [get_plant_cost plant] gets the cost of the specific plant *)

val get_plant_hp : plant_type -> int
(** [get_plant_hp plant] gets the hp of the specific plant *)

val get_plant_speed : plant_type -> int
(** [get_plant_speed plant_type] gets the speed of the plant *)

val get_plant_width : plant_type -> int
(** [get_plant_width plant_type] gets the width of the plant *)

val spawn_plant : Gui_util.box -> plant_type -> plant
(** [spawn_plant box plant_type] spawns a plant of a certain type given its box. *)
