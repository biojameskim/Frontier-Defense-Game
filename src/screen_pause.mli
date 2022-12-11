(** Represents the pause screen in the game. *)

val draw : State.t -> Events.t -> unit
(** [draw st ev] draws the pause screen given a state [st] and event [ev]. It
    has a resume button, a quit button, and has text at the top saying that the
    game is paused. *)

val tick : 'a -> 'a
(** [tick st] does not make any changes to the state [st]. But is present for
    consistency with other modules. *)
