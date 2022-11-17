(* *)
type clickable = {
  corners : Gui_util.point * Gui_util.point;
  on_click : State.t -> State.t;
}
(** Represents a clickable object on the screen. Stores its bounding box and a
    function to run on click. *)

type t = { clickables : clickable Queue.t }
(** Represents information for event-handling that the screen drawing logic
    should return. *)
(* an events.t is a queue of clickables, the queue is iterated through 
   when something is clicked. on_click is called when something you have to click
   happens *)
let make () = { clickables = Queue.create () }

(** Handle a user's mouse click. *)
(* on_click should primarily change the state.t, so it takes in a state 
   and outputs the new state *)
let handle_click (mouse_x, mouse_y) (st : State.t) t =
  let st_ref = ref st in
  Queue.iter
    (fun { corners = corner1, corner2; on_click } ->
      if
        Gui_util.is_point_in_box
          (Gui_util.CornerBox (corner1, corner2))
          (mouse_x, mouse_y)
          (* we feed onclick the old state, and it gives us new state *)
      then st_ref := on_click !st_ref)
    t.clickables;
  !st_ref
(* add_clickable names the region on the screen that is clickable 
   and onclick is the function that should be run when you click on it. 
   t is the events.t*)
let add_clickable corners on_click t =
  Queue.add { corners; on_click } t.clickables
