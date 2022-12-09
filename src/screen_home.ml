open Gui_util
open Image_graphics
open Png
open Images

let draw st ev =
  draw_rect_b (CornerBox ((100, 100), (1280 - 100, 720 - 100)));
  let on_play st = st |> State.change_screen Screen.PlayScreen in
  let on_quit _ = exit 0 in
  draw_string_p
    (CenterPlace (1280 / 2, 500))
    ~size:GiantText "Plants vs. Zombies";
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 195)) 100 50) "Play")
    on_play ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 135)) 100 50) "Quit")
    on_quit ev

let tick st = st
