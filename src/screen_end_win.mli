(** Represents the win screen. *)

val draw : State.t -> Events.t -> unit
(** Draw the contents of this screen. *)

val tick : State.t -> State.t
(** Run the tick function associated with this screen. *)
