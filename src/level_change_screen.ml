open Gui_util

let draw (st : State.t) ev =
  let on_resume _ =
    st.screen <- Screen.PlayScreen;
    st.level <- st.level + 1;
    st.message <- Some ("Level " ^ string_of_int st.level);
    st.message_length <- Some 120;
    st
  in
  let on_quit _ = exit 0 in
  let level_completed_string =
    "Wave " ^ string_of_int st.level ^ " Conquered"
  in
  let level_ready_string =
    "Ready for Wave " ^ string_of_int (st.level + 1) ^ " ?"
  in
  draw_string_p
    (CenterPlace (1280 / 2, 500))
    ~size:GiantText level_completed_string;
  draw_string_p (CenterPlace (1280 / 2, 400)) ~size:BigText level_ready_string;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 195)) 130 50) "Next")
    on_resume ev;
  Events.add_clickable
    (draw_button (placed_box (CenterPlace (1280 / 2, 135)) 130 50) "Quit")
    on_quit ev

let tick st = st
