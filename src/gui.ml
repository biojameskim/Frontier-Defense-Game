open Gui_util
module G = Graphics

module Screen_draw = struct
  let num_rows = 5
  let num_cols = 10

  let draw_home_screen () =
    G.set_color (G.rgb 92 199 70);
    G.fill_rect 0 0 (G.size_x ()) (G.size_y ());
    (* Color grid alternate *)
    G.moveto 0 0;
    color_grid_alternate (G.size_x ()) (G.size_y ()) num_cols 0;

    G.set_color Palette.black;

    (* Initialize grid layout *)
    G.moveto 0 0;
    draw_col_lines (G.size_x ()) (G.size_y ()) 0 num_cols;
    draw_row_lines (G.size_x ()) (G.size_y ()) 0 num_rows;

    (* Initialize lawnmower layout *)
    init_lawnmowers (G.size_x ()) (G.size_y ()) num_rows num_cols
      (G.size_y () / (num_rows * 2));

    (* Initialize zombie and plant positions *)
    draw_plants_or_zombies (G.size_x ()) (G.size_y ()) 0 num_rows num_cols true;
    draw_plants_or_zombies (G.size_x ()) (G.size_y ()) 0 num_rows num_cols false;
    G.set_font "-*-fixed-medium-r-semicondensed--50-*-*-*-*-*-iso8859-1";

    G.set_color Palette.border;
    draw_string_from_placement ScreenCenterPlace
      ((() |> G.size_x |> string_of_int)
      ^ "x"
      ^ (() |> G.size_y |> string_of_int));
    let box1 =
      draw_button (TopCenterPlace (G.size_x () / 2, 50)) 150 50 "Play"
    in
    let box2 =
      draw_button (TopCenterPlace (G.size_x () / 2, 100)) 150 50 "Quit"
    in
    ()

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
