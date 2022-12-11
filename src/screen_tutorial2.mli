(** Represents the second screen of the tutorial in the game. *)

val draw : State.t -> Events.t -> unit
(** [draw st ev] draws the second tutorial screen given a state [st] and event
    [ev]. *)

val tick : 'a -> 'a
(** [tick st] does not make any changes to the state [st]. But is present for
    consistency with other modules. *)
