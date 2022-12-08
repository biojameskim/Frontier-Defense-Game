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

  (* draw takes a state, and draws the thing on the screen given the state, and
     has an accumator of events *)
  (match st.screen with
  | Screen.HomeScreen -> Screen_home.draw st ev
  | Screen.PlayScreen -> Screen_play.draw st ev
  | Screen.PauseScreen -> Screen_pause.draw st ev
  | Screen.LevelChangeScreen -> Level_change_screen.draw st ev
  | Screen.EndScreenLost -> Screen_end_lost.draw st ev);
  (* makes contents of the screen update *)
  G.synchronize ();
  (* tick - state is being reassigned on the tick, or else the state will never
     change *)
  let st =
    match st.screen with
    | Screen.HomeScreen -> Screen_home.tick st
    | Screen.PlayScreen -> Screen_play.tick st
    | Screen.PauseScreen -> Screen_pause.tick st
    | Screen.LevelChangeScreen -> Level_change_screen.tick st
    | Screen.EndScreenLost -> Screen_end_lost.tick st
  in
  (* handle events like quitting *)
  if e.keypressed && e.key == 'q' then exit 0;
  let st =
    if e.button && not st.was_mouse_pressed then
      Events.handle_click (e.mouse_x, e.mouse_y) st ev
    else st
  in
  (* makes sure the mouse held down is only one click *)
  let st = { st with was_mouse_pressed = e.button } in
  handle_event st

(* launches the game, handle event waits for you to do something, and then it
   happens *)
let launch (st : State.t) =
  (* Do not use [G.open_graph "800x600"]; it will crash on Linux *)
  G.open_graph "";
  G.set_window_title "Plants vs. Zombies";
  G.resize_window 1280 720;
  G.auto_synchronize false;
  handle_event st
