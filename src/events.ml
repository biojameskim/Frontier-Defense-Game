type clickable = {
  corners : Gui_util.point * Gui_util.point;
  on_click : State.t -> State.t;
}
(** Represents a clickable object on the screen. Stores its bounding box and a
    function to run on click. *)

type t = { clickables : clickable Queue.t }
(** Represents information for event-handling that the screen drawing logic
    should return. *)

let make () = { clickables = Queue.create () }

(** Handle a user's mouse click. *)
let handle_click (mouse_x, mouse_y) (st : State.t) t =
  let st_ref = ref st in
  Queue.iter
    (fun { corners = corner1, corner2; on_click } ->
      if
        Gui_util.is_point_in_box
          (Gui_util.CornerBox (corner1, corner2))
          (mouse_x, mouse_y)
      then st_ref := on_click !st_ref)
    t.clickables;
  !st_ref

let add_clickable corners on_click t =
  Queue.add { corners; on_click } t.clickables
