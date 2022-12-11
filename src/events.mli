(** Encapsulates the state and logic involved in processing GUI mouse events.
    Every tick, the [Gui] module creates a new [Events.t] and sends it as the
    second argument to [draw] in a screen module. The screen module calls
    [add_clickable] for each box (rectangular region on the screen) which is
    "clickable," providing a function of type [State.t -> State.t] to transform
    the state when clicked. It is also possible to check if the mouse is
    hovering over the box, which is useful for animations and GUI effects. **)

type clickable = {
  corners : Gui_util.point * Gui_util.point;
  on_click : State.t -> State.t;
}
(** [clickable] represents the type of a clickable object on the screen. Stores
    its bounding box and a function to run on click. *)

type t = {
  clickables : clickable Queue.t;
  mouse : Gui_util.point;
}
(** A value of type [t] contains a container of clickables and the coordinate of
    the mouse. *)

val make : Gui_util.point -> t
(** [make p] creates a value of type [t] given coordinates of mouse [p]. **)

val handle_click : State.t -> t -> State.t
(** [handle_click st t] runs click handlers for each clickable that the user's
    mouse is inside. *)

val add_clickable :
  Gui_util.point * Gui_util.point -> (State.t -> State.t) -> t -> unit
(** [add_clickable ((x1, y1), (x2, y2)) f t] adds a clickable to [t] given
    lower-left coordinates [(x1, y1)], upper-left coordinates [(x2, y2)], and a
    callback [f] which is called on click. [f st] should return a transformed
    state given prior state [st]. *)

val add_clickable_return_hover :
  Gui_util.point * Gui_util.point -> (State.t -> State.t) -> t -> bool
(** Same as [add_clickable] but returns whether the mouse is hovering over the
    clickable. *)
