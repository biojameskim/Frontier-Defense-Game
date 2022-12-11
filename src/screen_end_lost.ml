open Gui_util

let draw st ev =
  let on_quit _ = exit 0 in
  draw_string_p
    (CenterPlace (1280 / 2, 520))
    ~size:GiantText "Your frontier has been invaded";
  draw_string_p
    (CenterPlace (1280 / 2, 420))
    ~size:BigText "Better luck next time!";
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 195)) 130 50) "Restart")
    (fun (st : State.t) -> State.init ())
    ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 135)) 130 50) "Quit")
    on_quit ev

let tick st = st
