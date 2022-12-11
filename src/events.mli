(** Represents clickable events in the game. *)

type clickable = {
  corners : Gui_util.point * Gui_util.point;
  on_click : State.t -> State.t;
}
(** [clickable] represents the type of a clickable object on the screen. Stores
    its bounding box and a function to run on click. *)

type t = { clickables : clickable Queue.t }
(** [t] is the type representing clickables *)

val make : unit -> t
(** [make] initializes a queue of clickables. *)

val handle_click : int * int -> State.t -> t -> State.t
(** [handle_click] handles a user's mouse click. *)

val add_clickable :
  Gui_util.point * Gui_util.point -> (State.t -> State.t) -> t -> unit
(** [add_clickable] adds a clickable to the queue in type t. *)
