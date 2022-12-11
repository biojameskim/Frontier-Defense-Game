(** Represents the main gui functionality. *)

val handle_event : State.t -> 'a
(** [handle_event st] handles all events given a state [st]. Represents the main
    event loop as the function is recursive. *)

val launch : (unit -> State.t) -> 'a
(** [launch f] begins the game given a thunk [f] to calculate the initial state. *)
