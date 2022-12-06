open Gui_util

(* [draw st ev] draws the pause screen. It has a resume button, a quit button,
   and has text at the top saying that the game is paused *)
let draw st ev =
  let on_resume st = st |> State.change_screen Screen.PlayScreen in
  let on_quit _ = exit 0 in
  draw_string_p (CenterPlace (1280 / 2, 500)) ~size:GiantText "Paused";
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 195)) 100 50) "Resume")
    on_resume ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 135)) 100 50) "Quit")
    on_quit ev

let tick st = st
