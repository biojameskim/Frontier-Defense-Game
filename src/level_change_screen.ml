open Gui_util

(* [draw st ev] draws the pause screen. It has a resume button, a quit button,
   and has text at the top saying that the game is paused *)
let draw (st : State.t) ev =
  let on_resume _ =
    st.screen <- Screen.PlayScreen;
    st.level <- st.level + 1;
    st
  in
  let on_quit _ = exit 0 in
  let level_string =
    "Level " ^ string_of_int st.level ^ "completed. Ready for level "
    ^ string_of_int (st.level + 1)
    ^ "?"
  in
  draw_string_p (CenterPlace (1280 / 2, 500)) ~size:GiantText level_string;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 195)) 100 50) "Resume")
    on_resume ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 135)) 100 50) "Quit")
    on_quit ev

let tick st = st
