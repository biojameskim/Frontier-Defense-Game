(** Represents the main GUI functionality. The main GUI loop is implemented in
    [handle_event]. This method maintains a current state of type [State.t].
    Every iteration of the GUI loop, [draw] is called, which renders the
    graphics in the window, registers event handlers, and should not mutate the
    state. Next, [tick] is called, which may mutate the state. Finally, event
    handlers are called, which may also mutate the state. *)

val handle_event_init : State.t -> Graphics.status
(** Perform initialization operations in the main event loop. Returns the
    Graphics status object. *)

val handle_event_draw : State.t -> Events.t -> unit
(** Call [draw] on the current screen. *)

val handle_event_tick : State.t -> State.t
(** Call [tick] on the current screen, returning the new state. *)

val handle_event : State.t -> 'a
(** [handle_event st] handles all events given a state [st]. Represents the main
    event loop as the function is recursive. *)

val launch : (unit -> State.t) -> 'a
(** [launch f] begins the game given a thunk [f] to calculate the initial state. *)
