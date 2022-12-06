open Gui_util

(* [draw st ev] draws the end_lost screen. It has a restart button, a quit
   button, and has text at the top saying that they lost the game *)
let draw st ev =
  draw_rect_b (CornerBox ((100, 100), (1280 - 100, 720 - 100)));
  let on_quit _ = exit 0 in
  draw_string_p
    (CenterPlace (1280 / 2, 500))
    ~size:GiantText "You lost, better luck next time!";
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 195)) 100 50) "Restart")
    (fun (st : State.t) -> State.init ())
    ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 135)) 100 50) "Quit")
    on_quit ev

let tick st = st
