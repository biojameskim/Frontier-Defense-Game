(** Represents the lost game screen in the game. *)

val draw : 'a -> Events.t -> unit
(** [draw st ev] draws the lost game screen given a state [st] and event [ev].
    It has a restart button, a quit button, and has text at the top saying that
    you lost the game. *)

val tick : 'a -> 'a
(** [tick st] does not make any changes to the state [st]. But is present for
    consistency with other modules. *)
