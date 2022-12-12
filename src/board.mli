(** Represents the board grid in the game. *)

open Characters

val num_cols : int
(** [num_cols] is the number of columns in the board grid. *)

val num_rows : int
(** [num_cols] is the number of columns in the board grid. *)

type cell = { mutable plant : plant option }
(** [cell] is the type of a cell in the board grid. *)

type row = {
  cells : cell list;
  mutable zombies : zombie list;
  mutable peas : pea list;
  mutable lawnmower : lawnmower option;
}
(** [row] is the type of a row in the board grid *)

type t = { rows : row list }
(** [t] is the type of the board *)

val init_row : int -> row
(** [init_row] intialitizes a row in the grid with an empty list of zombies,
    plants, and peas, and an initial lawnmower. *)

val init : unit -> t
(** [init] calls the init_row function num_rows times. *)

val spawn_zombie_by_level : int -> zombie_type
(** [spawn_zombie_by_level level] spawns zombies based on level. Random.int i
    chooses a random integer between 0 and (i - 1) inclusive. *)

val spawn_zombie : int -> t -> unit
(** [spawn_zombie level t] spawns a zombie based on level. *)
