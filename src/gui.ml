open Gui_util
module G = Graphics

let rec handle_event (st : State.t) =
  (* wait *)
  let e = G.wait_next_event [ G.Poll ] in
  (* initialize event handlers *)
  let ev = Events.make () in
  (* initialize draw *)
  G.clear_graph ();
  G.moveto 0 0;
  G.set_color Palette.failure;
  G.set_line_width 1;
  G.set_text_size 18;
  (* draw *)
  (match st.screen with
  | Screen.HomeScreen -> Screen_home.draw st ev
  | Screen.PlayScreen -> Screen_play.draw st ev
  | Screen.PauseScreen -> assert false);
  G.synchronize ();
  (* tick *)
  let st =
    match st.screen with
    | Screen.HomeScreen -> Screen_home.tick st
    | Screen.PlayScreen -> Screen_play.tick st
    | Screen.PauseScreen -> assert false
  in
  (* handle events *)
  if e.keypressed && e.key == 'q' then exit 0;
  let st =
    if e.button && not st.was_mouse_pressed then
      Events.handle_click (e.mouse_x, e.mouse_y) st ev
    else st
  in
  let st = { st with was_mouse_pressed = e.button } in
  handle_event st

let launch (st : State.t) =
  (* Do not use [G.open_graph "800x600"]; it will crash on Linux *)
  G.open_graph "";
  G.set_window_title "Plants vs. Zombies";
  G.resize_window 1280 720;
  G.auto_synchronize false;
  handle_event st
