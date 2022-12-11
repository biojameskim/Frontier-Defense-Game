type clickable = {
  corners : Gui_util.point * Gui_util.point;
  on_click : State.t -> State.t;
}

type t = {
  mutable clickables : clickable list;
  mouse : Gui_util.point;
}

let make mouse = { clickables = []; mouse }

let handle_click (st : State.t) t =
  List.find_map
    (fun { corners = corner1, corner2; on_click } ->
      if
        Gui_util.is_point_in_box (Gui_util.CornerBox (corner1, corner2)) t.mouse
        (* we feed onclick the old state, and it gives us new state *)
      then Some (on_click st)
      else None)
    t.clickables
  |> Option.value ~default:st

let add_clickable corners on_click t =
  t.clickables <- { corners; on_click } :: t.clickables

let add_clickable_return_hover ((corner1, corner2) as corners) on_click t =
  add_clickable corners on_click t;
  Gui_util.is_point_in_box (Gui_util.CornerBox (corner1, corner2)) t.mouse
