open Gui_util
module G = Graphics

(* let debug_tick_value : float option ref = ref None *)

let handle_event_init (st : State.t) =
  (* wait *)
  let e = G.wait_next_event [ G.Poll ] in
  (* initialize draw *)
  G.clear_graph ();
  G.moveto 0 0;
  G.set_color Palette.failure;
  G.set_line_width 100;
  (* helps discover failure to explicitly set line width *)
  G.set_text_size 18;
  e

let handle_event_draw (st : State.t) ev =
  match st.screen with
  | Screen.HomeScreen -> Screen_home.draw st ev
  | Screen.TutorialScreen1 -> Screen_tutorial1.draw st ev
  | Screen.TutorialScreen2 -> Screen_tutorial2.draw st ev
  | Screen.PlayScreen -> Screen_play.draw st ev
  | Screen.PauseScreen -> Screen_pause.draw st ev
  | Screen.LevelChangeScreen -> Screen_level_change.draw st ev
  | Screen.EndScreenLost -> Screen_end_lost.draw st ev
  | Screen.EndScreenWin -> Screen_end_win.draw st ev

let handle_event_tick (st : State.t) =
  match st.screen with
  | Screen.HomeScreen -> Screen_home.tick st
  | Screen.TutorialScreen1 -> Screen_tutorial1.tick st
  | Screen.TutorialScreen2 -> Screen_tutorial2.tick st
  | Screen.PlayScreen -> Screen_play.tick st
  | Screen.PauseScreen -> Screen_pause.tick st
  | Screen.LevelChangeScreen -> Screen_level_change.tick st
  | Screen.EndScreenLost -> Screen_end_lost.tick st
  | Screen.EndScreenWin -> Screen_end_win.tick st

let rec handle_event (st : State.t) =
  let e = handle_event_init st in
  (* initialize event handlers *)
  let ev = Events.make (G.mouse_pos ()) in
  handle_event_draw st ev;
  (* makes contents of the screen update *)
  G.synchronize ();
  (* tick - state is being reassigned on the tick, or else the state will never
     change *)
  let raw_time = Unix.gettimeofday () in
  let should_tick = raw_time -. st.raw_last_tick_time > 1. /. 30. in
  let st = if should_tick then handle_event_tick st else st in
  (* if e.keypressed && e.key == 'q' then exit 0; *)
  let st =
    if e.button && not st.was_mouse_pressed then Events.handle_click st ev
    else st
  in
  (* makes sure the mouse held down is only one click *)
  let st = { st with was_mouse_pressed = e.button } in
  if should_tick then st.raw_last_tick_time <- raw_time;
  (* (if should_tick then *)
  (*  match !debug_tick_value with *)
  (*  | None -> debug_tick_value := Some (Unix.gettimeofday ()) *)
  (*  | Some t -> *)
  (*      let t2 = Unix.gettimeofday () in *)
  (*      debug_tick_value := Some t2; *)
  (*      1. /. (t2 -. t) |> string_of_float |> print_endline); *)
  handle_event st

(* launches the game, handle event waits for you to do something, and then it
   happens *)
let launch (st : unit -> State.t) =
  (* Do not use [G.open_graph "800x600"]; it will crash on Linux *)
  G.open_graph "";
  G.set_window_title "Frontier Defense";
  G.resize_window 1280 720;
  G.auto_synchronize false;
  handle_event (st ())
