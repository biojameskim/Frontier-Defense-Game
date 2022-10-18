open Gui_util
module G = Graphics

module Screen_draw = struct
  let draw_home_screen () =
    G.set_color Palette.border;
    draw_rect_from_points 100 100 1180 620;
    G.moveto 300 300;
    G.draw_string "Plants vs. Zombies"

  let draw screen =
    match screen with
    | Screen.HomeScreen -> draw_home_screen ()
    | Screen.PlayScreen -> assert false
    | Screen.PauseScreen -> assert false
end

let rec handle_event (st : State.t) =
  G.clear_graph ();
  draw_reset_state ();
  Screen_draw.draw st.screen;
  let e = G.wait_next_event [ G.Key_pressed ] in
  if e.keypressed && e.key == 'q' then exit 0 else handle_event st

let launch (st : State.t) =
  (* Do not use [G.open_graph "800x600"]; it will crash on Linux *)
  G.open_graph "";
  G.set_window_title "Plants vs. Zombies";
  G.resize_window 1280 720;
  handle_event st
