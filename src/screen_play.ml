open Gui_util
module G = Graphics

let num_rows = 5
let num_cols = 10

let draw st ev =
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
  G.set_font "-*-fixed-medium-r-semicondensed--50-*-*-*-*-*-iso8859-1"

let tick st = st
