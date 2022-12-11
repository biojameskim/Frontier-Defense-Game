type clickable = {
  corners : Gui_util.point * Gui_util.point;
  on_click : State.t -> State.t;
}

type t = {
  clickables : clickable Queue.t;
  mouse : Gui_util.point;
}

let make mouse = { clickables = Queue.create (); mouse }

let handle_click (st : State.t) t =
  let st_ref = ref st in
  Queue.iter
    (fun { corners = corner1, corner2; on_click } ->
      if
        Gui_util.is_point_in_box (Gui_util.CornerBox (corner1, corner2)) t.mouse
        (* we feed onclick the old state, and it gives us new state *)
      then st_ref := on_click !st_ref)
    t.clickables;
  !st_ref

let add_clickable corners on_click t =
  Queue.add { corners; on_click } t.clickables

let add_clickable_return_hover ((corner1, corner2) as corners) on_click t =
  add_clickable corners on_click t;
  Gui_util.is_point_in_box (Gui_util.CornerBox (corner1, corner2)) t.mouse
