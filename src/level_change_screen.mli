(** Represents the level change screen in the game. *)

val draw : State.t -> Events.t -> unit
(** [draw st ev] draws the level_change screen given a state [st] and event
    [ev]. It has a resume button, a quit button, and has text at the top saying
    that the level is completed, and asks if you are ready for the next level. *)

val tick : 'a -> 'a
(** [tick st] does not make any changes to the state [st]. But is present for
    consistency with other modules.*)
